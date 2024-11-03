local function ensure_html_deps()
  quarto.doc.add_html_dependency({
    name = "pseudocode",
    version = "2.4.1",
    scripts = { "pseudocode.min.js" },
    stylesheets = { "pseudocode.min.css" }
  })
  quarto.doc.include_text("after-body", [[
    <script type="text/javascript">
    (function(d) {
      d.querySelectorAll(".pseudocode-container").forEach(function(el) {
        let pseudocodeOptions = {
          indentSize: el.dataset.indentSize || "1.2em",
          commentDelimiter: el.dataset.commentDelimiter || "//",
          lineNumber: el.dataset.lineNumber === "true" ? true : false,
          lineNumberPunc: el.dataset.lineNumberPunc || ":",
          noEnd: el.dataset.noEnd === "true" ? true : false,
          titlePrefix: el.dataset.captionPrefix || "Algorithm"
        };
        pseudocode.renderElement(el.querySelector(".pseudocode"), pseudocodeOptions);
      });
    })(document);
    (function(d) {
      d.querySelectorAll(".pseudocode-container").forEach(function(el) {
        let captionSpan = el.querySelector(".ps-root > .ps-algorithm > .ps-line > .ps-keyword")
        if (captionSpan !== null) {
          let captionPrefix = el.dataset.captionPrefix + " ";
          let captionNumber = "";
          if (el.dataset.pseudocodeNumber) {
            captionNumber = el.dataset.pseudocodeNumber + " ";
            if (el.dataset.chapterLevel) {
              captionNumber = el.dataset.chapterLevel + "." + captionNumber;
            }
          }
          captionSpan.innerHTML = captionPrefix + captionNumber;
        }
      });
    })(document);
    </script>
  ]])
end

local function ensure_latex_deps()
  quarto.doc.use_latex_package("algorithm")
  quarto.doc.use_latex_package("algpseudocode")
  quarto.doc.use_latex_package("caption")
end

local function extract_source_code_options(source_code, render_type)
  local options = {}
  local source_codes = {}
  local found_source_code = false

  for str in string.gmatch(source_code, "([^\n]*)\n?") do
    if (string.match(str, "^%s*#|.*") or string.gsub(str, "%s", "") == "") and not found_source_code then
      if string.match(str, "^%s*#|%s+[" .. render_type .. "|label].*") then
        str = string.gsub(str, "^%s*#|%s+", "")
        local idx_start, idx_end = string.find(str, ":%s*")

        if idx_start and idx_end and idx_end + 1 < #str then
          k = string.sub(str, 1, idx_start - 1)
          v = string.sub(str, idx_end + 1)
          v = string.gsub(v, "^\"%s*", "")
          v = string.gsub(v, "%s*\"$", "")

          options[k] = v
        else
          quarto.log.warning("Invalid pseducode option: " .. str)
        end
      end
    else
      found_source_code = true
      table.insert(source_codes, str)
    end
  end

  return options, table.concat(source_codes, "\n")
end

local function render_pseudocode_block_html(global_options)
  ensure_html_deps()

  local filter = {
    CodeBlock = function(el)
      if not el.attr.classes:includes("pseudocode") then
        return el
      end

      local options, source_code = extract_source_code_options(el.text, "html")

      source_code = string.gsub(source_code, "%s*\\begin{algorithm}[^\n]+", "\\begin{algorithm}")
      source_code = string.gsub(source_code, "%s*\\begin{algorithmic}[^\n]+", "\\begin{algorithmic}")

      local alg_id = options["label"]
      options["label"] = nil
      options["html-caption-prefix"] = global_options.caption_prefix

      if global_options.number_with_in_chapter and global_options.html_chapter_level then
        options["html-chapter-level"] = global_options.html_chapter_level
      end

      if global_options.caption_number then
        options["html-pseudocode-number"] = global_options.html_current_number
      end

      local data_options = {}
      for k, v in pairs(options) do
        if string.match(k, "^html-") then
          data_k = string.gsub(k, "^html", "data")
          data_options[data_k] = v
        end
      end

      local inner_el = pandoc.Div(source_code)
      inner_el.attr.classes = pandoc.List()
      inner_el.attr.classes:insert("pseudocode")

      local outer_el = pandoc.Div(inner_el)
      outer_el.attr.classes = pandoc.List()
      outer_el.attr.classes:insert("pseudocode-container")
      outer_el.attr.classes:insert("quarto-float")
      outer_el.attr.attributes = data_options

      if alg_id then
        outer_el.attr.identifier = alg_id
        global_options.html_identifier_number_mapping[alg_id] = global_options.html_current_number
        global_options.html_current_number = global_options.html_current_number + 1
      end

      return outer_el
    end
  }

  return filter
end

local function render_pseudocode_block_latex(global_options)
  ensure_latex_deps()

  if global_options.caption_number then
    quarto.doc.include_text("before-body", "\\floatname{algorithm}{" .. global_options.caption_prefix .. "}")
  else
    quarto.doc.include_text("in-header", "\\DeclareCaptionLabelFormat{algnonumber}{" .. global_options.caption_prefix .. "}")
    quarto.doc.include_text("before-body", "\\captionsetup[algorithm]{labelformat=algnonumber}")
  end

  if global_options.number_with_in_chapter then
    quarto.doc.include_text("before-body", "\\numberwithin{algorithm}{chapter}")
  end

  local filter = {
    CodeBlock = function(el)
      if not el.attr.classes:includes("pseudocode") then
        return el
      end

      local options, source_code = extract_source_code_options(el.text, "pdf")

      local pdf_placement = "H"
      if options["pdf-placement"] then
        pdf_placement = options["pdf-placement"]
      end
      source_code = string.gsub(source_code, "\\begin{algorithm}%s*\n", "\\begin{algorithm}[" .. pdf_placement .. "]\n")

      if not options["pdf-line-number"] or options["pdf-line-number"] == "true" then
        source_code = string.gsub(source_code, "\\begin{algorithmic}%s*\n", "\\begin{algorithmic}[1]\n")
      end

      if options["label"] then
        source_code = string.gsub(source_code, "\\begin{algorithmic}", "\\label{" .. options["label"] .. "}\n\\begin{algorithmic}")
      end

      return pandoc.RawInline("latex", source_code)
    end
  }

  return filter
end

local function render_pseudocode_block(global_options)
  local filter = {
    CodeBlock = function(el)
      return el
    end
  }

  if quarto.doc.is_format("html") then
    filter = render_pseudocode_block_html(global_options)
  elseif quarto.doc.is_format("latex") then
    filter = render_pseudocode_block_latex(global_options)
  end

  return filter
end

local function render_pseudocode_ref_html(global_options)
  local filter = {
    Cite = function(el)
      local cite_text = pandoc.utils.stringify(el.content)

      for k, v in pairs(global_options.html_identifier_number_mapping) do
        if cite_text == "@" .. k then
          local link_src = "#" .. k
          local alg_id = v

          if global_options.html_chapter_level then
            alg_id = global_options.html_chapter_level .. "." .. alg_id
          end

          local link_text = global_options.reference_prefix .. " " .. alg_id
          local link = pandoc.Link(link_text, link_src)
          link.attr.classes = pandoc.List()
          link.attr.classes:insert("quarto-xref")

          return link
        end
      end
    end
  }

  return filter
end

local function render_pseudocode_ref_latex(global_options)
  local filter = {
    Cite = function(el)
      local cite_text = pandoc.utils.stringify(el.content)

      if string.match(cite_text, "^@alg-") then
        return pandoc.RawInline("latex", global_options.reference_prefix .. "~\\ref{" .. string.gsub(cite_text, "^@", "") .. "}" )
      end
    end
  }

  return filter
end

local function render_pseudocode_ref(global_options)
  local filter = {
    Cite = function(el)
      return el
    end
  }

  if quarto.doc.is_format("html") then
    filter = render_pseudocode_ref_html(global_options)
  elseif quarto.doc.is_format("latex") then
    filter = render_pseudocode_ref_latex(global_options)
  end

  return filter
end

function Pandoc(doc)
  local global_options = {
    caption_prefix = "Algorithm",
    reference_prefix = "Algorithm",
    caption_number = true,
    number_with_in_chapter = false,
    html_chapter_level = nil,
    html_current_number = 1,
    html_identifier_number_mapping = {}
  }

  if doc.meta["pseudocode"] then
    global_options.caption_prefix = pandoc.utils.stringify(doc.meta["pseudocode"]["caption-prefix"]) or global_options.caption_prefix
    global_options.reference_prefix = pandoc.utils.stringify(doc.meta["pseudocode"]["reference-prefix"]) or global_options.reference_prefix
    global_options.caption_number = doc.meta["pseudocode"]["caption-number"] or global_options.caption_number
  end

  if doc.meta["book"] then
    global_options.number_with_in_chapter = true

    if quarto.doc.is_format("html") then
      local _, input_qmd_filename = string.match(quarto.doc["input_file"], "^(.-)([^\\/]-%.([^\\/%.]-))$")
      local renders = doc.meta["book"]["render"]

      for _, render in pairs(renders) do
        if render["file"] and render["number"] and pandoc.utils.stringify(render["file"]) == input_qmd_filename then
          global_options.html_chapter_level = pandoc.utils.stringify(render["number"])
        end
      end
    end
  end

  doc = doc:walk(render_pseudocode_block(global_options))

  return doc:walk(render_pseudocode_ref(global_options))
end
