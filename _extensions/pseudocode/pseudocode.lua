local function ensure_html_deps()
  quarto.doc.include_file("in-header", "in_header.html")
  quarto.doc.include_file("after-body", "after_body.html")
end

local function ensure_latex_deps()
  quarto.doc.use_latex_package("algorithm")
  quarto.doc.use_latex_package("algpseudocode")
end

local function extract_source_code_options(source_code, option_type)
  local options = {}
  local source_codes = {}
  local found_source_code = false

  for str in string.gmatch(source_code, "([^\n]*)\n?") do
    if (string.match(str, "^#|.*") or string.gsub(str, "%s", "") == "") and not found_source_code then
      if string.match(str, "^#|%s+[" .. option_type .. "|label].*") then
        str = string.gsub(str, "^#|%s+", "")
        local idx_start, idx_end = string.find(str, ":%s*")

        if idx_start and idx_end then
          k = string.sub(str, 1, idx_start - 1)
          v = string.sub(str, idx_end + 1)

          k = string.gsub(k, option_type, "data")
          v = string.gsub(v, "^\"%s*", "")
          v = string.gsub(v, "%s*\"$", "")

          options[k] = v
        end
      end
    else
      found_source_code = true
      table.insert(source_codes, str)
    end
  end

  return options, table.concat(source_codes, "\n")
end

local function render_pseudocode_block_html(el, alg_title, chapter_level, pseudocode_index)
  ensure_html_deps()

  local options, source_code = extract_source_code_options(el.text, "html")

  local alg_id = options["label"]
  options["label"] = nil
  options["data-alg-title"] = alg_title
  options["data-pseudocode-index"] = pseudocode_index

  if chapter_level then
    options["data-chapter-level"] = chapter_level
  end

  local inner_el = pandoc.Div(source_code)
  inner_el.attr.classes = pandoc.List()
  inner_el.attr.classes:insert("pseudocode")

  local outer_el = pandoc.Div(inner_el)
  outer_el.attr.classes = pandoc.List()
  outer_el.attr.classes:insert("pseudocode-container")
  outer_el.attr.attributes = options

  if alg_id then
    outer_el.attr.identifier = alg_id
  end

  return outer_el
end

local function render_pseudocode_block_latex(el, alg_title)
  ensure_latex_deps()
  quarto.doc.include_text("before-body", "\\floatname{algorithm}{" .. alg_title .. "}")

  local options, source_code = extract_source_code_options(el.text, "pdf")

  if options["label"] then
    source_code = string.gsub(source_code, "\\begin{algorithmic}", "\\label{" .. options["label"] .. "}\n\\begin{algorithmic}[1]")
  end

  el = pandoc.RawInline("latex", source_code)

  return el
end

local function render_pseudocode_block(el, alg_title, chapter_level, pseudocode_index)
  if quarto.doc.is_format("html") then
    el = render_pseudocode_block_html(el, alg_title, chapter_level, pseudocode_index)
  elseif quarto.doc.is_format("latex") then
    el = render_pseudocode_block_latex(el, alg_title)
  end

  return el
end

local function render_pseudocode_ref_html(doc, alg_prefix, chapater_level)
  local pseudocodes = {}

  for _, el in pairs(doc.blocks) do
    if el.t == "Div" and el.attr and el.attr.classes:includes("pseudocode-container") then
      pseudocodes[el.identifier] = {
        alg_prefix = el.attr.attributes["data-alg-prefix"] or alg_prefix,
        chapater_level = chapater_level,
        pseudocode_index = el.attr.attributes["data-pseudocode-index"]
      }
    end
  end

  local filter = {
    Cite = function(el)
      local cite_text = pandoc.utils.stringify(el.content)
      for k, v in pairs(pseudocodes) do
        if cite_text == "@" .. k then
          local link_src = "#" .. k
          local alg_id = v["pseudocode_index"]

          if v["chapater_level"] then
            alg_id = v["chapater_level"] .. "." .. alg_id
          end

          local link_text = v["alg_prefix"] .. " " .. alg_id
          return pandoc.Link(link_text, link_src)
        end
      end
    end
  }

  return filter
end

local function render_pseudocode_ref_latex(alg_prefix)
  local filter = {
    Cite = function(el)
      local cite_text = pandoc.utils.stringify(el.content)

      if string.match(cite_text, "^@alg-") then
        return pandoc.RawInline("latex", " " .. alg_prefix .. "~\\ref{" .. string.gsub(cite_text, "^@", "") .. "} " )
      end
    end
  }

  return filter
end

local function render_pseudocode_ref(doc, alg_prefix, chapater_level)
  local filter = {
    Cite = function(el)
      return el
    end
  }

  if quarto.doc.is_format("html") then
    filter = render_pseudocode_ref_html(doc, alg_prefix, chapater_level)
  elseif quarto.doc.is_format("latex") then
    filter = render_pseudocode_ref_latex(alg_prefix)
  end

  return filter
end

function Pandoc(doc)
  local alg_title = "Algorithm"
  local alg_prefix = "Algorithm"
  local pseudocode_index = 1
  local chapater_level = nil

  if doc.meta["pseudocode"] then
    alg_title = pandoc.utils.stringify(doc.meta["pseudocode"]["alg-title"]) or "Algorithm"
    alg_prefix = pandoc.utils.stringify(doc.meta["pseudocode"]["alg-prefix"]) or "Algorithm"
  end

  -- get current chapter level
  if doc.meta["book"] then
    local _, input_qmd_filename = string.match(quarto.doc["input_file"], "^(.-)([^\\/]-%.([^\\/%.]-))$")
    local renders = doc.meta["book"]["render"]

    for _, render in pairs(renders) do
      if pandoc.utils.stringify(render["file"]) == input_qmd_filename and render["number"] then
        chapater_level = pandoc.utils.stringify(render["number"])
      end
    end
  end

  -- render pseudocode blocks
  for idx, el in pairs(doc.blocks) do
    if el.t == "CodeBlock" and el.attr and el.attr.classes:includes("pseudocode") then
      doc.blocks[idx] = render_pseudocode_block(el, alg_title, chapater_level, pseudocode_index)
      pseudocode_index = pseudocode_index + 1
    end
  end

  -- render pseudocode references
  return doc:walk(render_pseudocode_ref(doc, alg_prefix, chapater_level))
end
