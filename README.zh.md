# Quarto 伪代码扩展

![Release](https://img.shields.io/github/release/leovan/quarto-pseudocode.svg)
![License](https://img.shields.io/github/license/leovan/quarto-pseudocode.svg)
![Issues](https://img.shields.io/github/issues/leovan/quarto-pseudocode.svg)

---

🇺🇸 [README](README.md) | 🇨🇳 [中文说明](README.zh.md)

一个用于在 `html` 和 `pdf` 格式输出中渲染伪代码的 Quarto 扩展。`html` 格式基于 [pseudocode.js](https://github.com/SaswatPadhi/pseudocode.js) 实现，`pdf` 格式基于 `algorithm` 和 `algpseudocode` 包实现。

## 安装

```bash
quarto add leovan/quarto-pseudocode
```

这将在 `_extensions` 子目录中安装本插件。如果使用版本控制，请检入到此目录。

## 使用

将如下内容添加到文档的头部或 `_quarto.yml` 文件中：

```yml
filters:
  - pseudocode
```

之后将伪代码添加到标记为 `pseudocode` 的代码块中。

````
```pseudocode
#| label: alg-quicksort
#| html-indent-size: "1.2em"
#| html-comment-delimiter: "//"
#| html-line-number: true
#| html-line-number-punc: ":"
#| html-no-end: false
#| pdf-placement: "htb!"
#| pdf-line-number: true

\begin{algorithm}
\caption{Quicksort}
\begin{algorithmic}
\Procedure{Quicksort}{$A, p, r$}
  \If{$p < r$}
    \State $q = $ \Call{Partition}{$A, p, r$}
    \State \Call{Quicksort}{$A, p, q - 1$}
    \State \Call{Quicksort}{$A, q + 1, r$}
  \EndIf
\EndProcedure
\Procedure{Partition}{$A, p, r$}
  \State $x = A[r]$
  \State $i = p - 1$
  \For{$j = p$ \To $r - 1$}
    \If{$A[j] < x$}
      \State $i = i + 1$
      \State exchange
      $A[i]$ with     $A[j]$
    \EndIf
    \State exchange $A[i]$ with $A[r]$
  \EndFor
\EndProcedure
\end{algorithmic}
\end{algorithm}
```
````

> **Note**  
> 使用大驼峰式关键词，而非全大写关键词。

使用 `@<alg-label>` 进行引用。

```
Quicksort algorithm is shown as @alg-quicksort.
```

> **Note**  
> 对于 `book` 类型项目，跨文件引用仅在 `pdf` 格式中可用。

伪代码和应用以 `html` 和 `pdf` 格式的渲染结果如下所示。

| `html` 格式                      | `pdf` 格式                      |
| :------------------------------: | :-----------------------------: |
| ![](screenshots/html-format.png) | ![](screenshots/pdf-format.png) |

伪代码使用的参数格式类似 R 和 Python 代码。

| 参数                     | 默认值   | 格式   | 注释                                     |
| :----------------------- | :------- | :----- | :--------------------------------------- |
| `label`                  |          | all    | 用于引用的标签，如果有必须以 `alg-` 开头 |
| `html-indent-size`       | "1.2 em" | `html` | pseudocode.js 中的 `indentSize`          |
| `html-comment-delimiter` | "//"     | `html` | pseudocode.js 中的 `commentDelimiter`    |
| `html-line-number`       | true     | `html` | pseudocode.js 中的 `lineNumber`          |
| `html-line-number-punc`  | ":"      | `html` | pseudocode.js 中的 `lineNumberPunc`      |
| `html-no-end`            | false    | `html` | pseudocode.js 中的 `noEnd`               |
| `pdf-placement`          |          | `pdf`  | 伪代码在文本中的放置方式                 |
| `pdf-line-number`        | true     | `pdf`  | 是否显示行号                             |

> **Note**  
> 如果在伪代码直接指定方式方式，例如 `\begin{algorithm}[htb!]`，则 `pdf-placement` 参数将被忽略。  
> 如果在伪代码直接指定是否显示行号，例如 `\begin{algorithmic}[1]`，则 `pdf-line-number` 参数将被忽略。  
> 所有这些改变不会影响 `html` 格式输出，建议使用参数选项而非直接修改伪代码。

对于 `html` 格式：

[pseudocode.js](https://github.com/SaswatPadhi/pseudocode.js) 使用 [KaTeX](https://katex.org/) 或 [MathJax](https://www.mathjax.org/) 渲染数学公式。本扩展在 html body 之后添加 [pseudocode.js](https://github.com/SaswatPadhi/pseudocode.js)，因此你需要在 html body 之前或 html header 中初始化 [KaTeX](https://katex.org/) 或 [MathJax](https://www.mathjax.org/)。

例如，可以将如下内容添加到文档的头部或 `_quarto.yml` 文件中。

```yml
format:
  html:
    include-in-header:
      text: |
        <script>
        MathJax = {
          loader: {
            load: ['[tex]/boldsymbol']
          },
          tex: {
            tags: "all",
            inlineMath: [['$','$'], ['\\(','\\)']],
            displayMath: [['$$','$$'], ['\\[','\\]']],
            processEscapes: true,
            processEnvironments: true,
            packages: {
              '[+]': ['boldsymbol']
            }
          }
        };
        </script>
        <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml-full.js" type="text/javascript"></script>
```

对于 `pdf` 格式：

1. `\numberwithin{algorithm}{chapter}` 可以在 `book` 类型项目中将第 `x` 章中伪代码标题序号改变为 `x.n`。
2. `\algrenewcommand{\algorithmiccomment}[1]{<your value> #1}` 可以改变注释的显示方式。

将这些内容添加到文档的头部或 `_quarto.yml` 文件中。

```yml
format:
  pdf:
    include-before-body:
      text: |
        \numberwithin{algorithm}{chapter}
        \algrenewcommand{\algorithmiccomment}[1]{\hskip3em$\rightarrow$ #1}
```

将如下内容添加到文档的头部或 `_metadata.yml` 文件中，可以将 `Algorithm` 转换为本地语言，例如中文的 `算法`。

```yml
pseudocode:
  alg-title: "算法"
  alg-prefix: "算法"
```

`alg-title` 用于伪代码的标题，`alg-prefix` 用于引用。

## 示例

1. 单文档（HTML 和 PDF 格式）：[examples/simple/simple.qmd](examples/simple/simple.qmd)。
2. 书籍文档（HTML 和 PDF 格式）：[examples/book/_quarto.yml](examples/book/_quarto.yml)。
3. Beamer 文档（PDF 格式）：[examples/beamer/beamer.qmd](examples/beamer/beamer.qmd)。

## 版权

The MIT License (MIT)

Copyright (c) 2023-2024 [范叶亮 | Leo Van](https://leovan.me)
