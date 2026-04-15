# Quarto 伪代码扩展

![Release](https://img.shields.io/github/release/leovan/quarto-pseudocode.svg)
![License](https://img.shields.io/github/license/leovan/quarto-pseudocode.svg)
![Issues](https://img.shields.io/github/issues/leovan/quarto-pseudocode.svg)

---

🇺🇸 [README](README.md) | 🇨🇳 [中文说明](README.zh.md)

一个用于在 HTML 和 PDF 文档中渲染伪代码的 Quarto 扩展。HTML 文档基于 [pseudocode.js](https://github.com/SaswatPadhi/pseudocode.js) 实现，PDF 文档基于 `algorithm` 和 `algpseudocodex` 包实现。

## 安装

```bash
quarto add leovan/quarto-pseudocode
```

这将在 `_extensions` 子目录中安装本插件。如果使用版本控制，请检入到此目录。

## 使用

### 添加扩展

将如下内容添加到文档的头部或 `_quarto.yml` 文件中：

```yml
filters:
  - pseudocode
```

### 伪代码块

将伪代码添加到标记为 `pseudocode` 的代码块中：

````
```pseudocode
#| html-indent-size: "1.2em"
#| html-comment-delimiter: "//"
#| html-line-number: true
#| html-line-number-punc: ":"
#| html-no-end: false
#| pdf-placement: "htb!"
#| pdf-line-number: true
#| pdf-comment-delimiter: "//"

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

> [!IMPORTANT]
> 使用大驼峰式关键词，而非全大写关键词。

### 参数配置

全局参数如下：

| 参数               | 默认值      | 格式 | 注释                     |
| ------------------ | ----------- | ---- | ------------------------ |
| `caption-prefix`   | "Algorithm" | 全部 | 伪代码标题的前缀。       |
| `reference-prefix` | "Algorithm" | 全部 | 代码交叉引用文本的前缀。 |
| `caption-number`   | true        | 全部 | 在伪代码标题中显示编号。 |
| `caption-align`    | "left"      | 全部 | 伪代码标题的对齐方式。   |

将参数添加到文档的头部或 `_metadata.yml` 文件中，例如：

```yml
pseudocode:
  caption-prefix: "算法"
  reference-prefix: "算法"
  caption-number: true
  caption-align: "left"
```

伪代码参数格式类似 R 和 Python 代码，如下：

| 参数                     | 默认值  | 格式 | 注释                               |
| ------------------------ | ------- | ---- | ---------------------------------- |
| `label`                  |         | 全部 | 交叉引用标签，通常以 `alg-` 开头。 |
| `html-indent-size`       | "1.2em" | HTML | HTML 格式缩进大小。                |
| `html-comment-delimiter` | "//"    | HTML | HTML 格式注释分隔符。              |
| `html-line-number`       | true    | HTML | HTML 格式显示行号。                |
| `html-line-number-punc`  | ":"     | HTML | HTML 格式中行号后使用的标点符号。  |
| `html-no-end`            | false   | HTML | HTML 格式隐藏结束语句。            |
| `html-indent-lines`      | false   | PDF  | HTML 格式显示缩进参考线。          |
| `pdf-placement`          | "H"     | PDF  | PDF 格式中放置伪代码块的放置方式。 |
| `pdf-line-number`        | true    | PDF  | PDF 格式显示行号。                 |
| `pdf-comment-delimiter`  | "//"    | PDF  | PDF 格式注释分隔符。               |
| `pdf-no-end`             | false   | PDF  | PDF 格式隐藏结束语句。             |
| `pdf-indent-lines`       | false   | PDF  | PDF 格式显示缩进参考线。           |
| `pdf-italic-comment`     | false   | PDF  | PDF 格式斜体注释。                 |
| `pdf-right-comment`      | false   | PDF  | PDF 格式右对齐的注释。             |
| `pdf-comment-color`      | "black" | PDF  | PDF 格式注释颜色。                 |

> [!NOTE]
>
> 1. 如果在伪代码块中直接指定方式方式，例如 `\begin{algorithm}[htb!]`，则 `pdf-placement` 参数将被忽略。
> 2. 如果在伪代码块中直接指定是否显示行号，例如 `\begin{algorithmic}[1]`，则 `pdf-line-number` 参数将被忽略。
> 3. 所有这些改变不会影响 HTML 文档，建议使用参数选项而非直接修改伪代码。

对于 HTML 文档，[pseudocode.js](https://github.com/SaswatPadhi/pseudocode.js) 使用 [KaTeX](https://katex.org/) 或 [MathJax](https://www.mathjax.org/) 渲染数学公式。本扩展在 html body 之后添加 [pseudocode.js](https://github.com/SaswatPadhi/pseudocode.js)，因此你需要在 html body 之前或 html header 中初始化 [KaTeX](https://katex.org/) 或 [MathJax](https://www.mathjax.org/)。将相关内容添加到文档的头部或 `_quarto.yml` 文件中：

#### MathJax 3

```yml
format:
  html:
    include-in-header:
      text: |
        <script>
        MathJax = {
          loader: {
            load: ["[tex]/boldsymbol"],
          },
          tex: {
            tags: "all",
            inlineMath: [["$", "$"], ["\\(", "\\)"]],
            displayMath: [["$$", "$$"], ["\\[", "\\]"]],
            processEscapes: true,
            processEnvironments: true,
            packages: {
              "[+]": ["boldsymbol"],
            },
          },
        };
        </script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml-full.js"></script>
```

#### MathJax 4

```yml
format:
  html:
    include-in-header:
      text: |
        <script>
        MathJax = {
          loader: {
            load: ["[tex]/boldsymbol"],
          },
          tex: {
            tags: "all",
            inlineMath: [["$", "$"], ["\\(", "\\)"]],
            displayMath: [["$$", "$$"], ["\\[", "\\]"]],
            processEscapes: true,
            processEnvironments: true,
            packages: {
              "[+]": ["boldsymbol"],
            },
          },
        };
        </script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/mathjax@4/tex-chtml.js"></script>
```

#### KaTeX

```yml
format:
  html:
    include-in-header:
      text: |
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@latest/dist/katex.min.css" />
      <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/katex@latest/dist/katex.min.js"></script>
```

对于 PDF 文档，在 `book` 类型项目中将第 `x` 章中伪代码标题序号将由 `Algorithm n` 变为 `Algorithm x.n`。将 `\algrenewcommand{\algorithmiccomment}[1]{<your value> #1}` 添加到文档的头部或 `_quarto.yml` 文件中可以改变注释的显示方式：

```yml
format:
  pdf:
    include-before-body:
      text: |
        \algrenewcommand{\algorithmiccomment}[1]{\hskip3em$\rightarrow$ #1}
```

### 交叉引用

#### 内置交叉引用

在伪代码块中设置 `label`，并且需要以 `algo-` 开头：

> [!WARNING]
> 从 Quarto 1.8 开始，`alg` 已经成为交叉引用的保留前缀。

````
```pseudocode
#| label: algo-quicksort
...

\begin{algorithm}
\caption{Quicksort}
\begin{algorithmic}
...
\end{algorithmic}
\end{algorithm}
```
````

在正文中使用 `@<label>` 进行交叉引用：

```
Quicksort algorithm is shown as @algo-quicksort.
```

> [!IMPORTANT]
> 必须设置 `label` 和 `\caption{}` 以确保内置交叉引用正常。

> [!WARNING]
> 对于 `book` 类型项目，跨文件引用仅在 PDF 文档中可用。

#### Quarto 自定义交叉引用

在文档的头部或 `_quarto.yml` 文件中定义用于伪代码的自定义交叉引用：

```yaml
crossref:
  custom:
    - kind: float
      key: alg
      reference-prefix: "Algorithm"
      caption-prefix: "Algorithm"
      latex-env: alg
      latex-list-of-description: Algorithm
```

使用 [Quarto 自定义交叉引用](https://quarto.org/docs/authoring/cross-references-custom.html) 包围伪代码块：

````
::: {#alg-quicksort}

```pseudocode
...

\begin{algorithm}
\caption{Quicksort}
\begin{algorithmic}
...
\end{algorithmic}
\end{algorithm}
```

Quicksort

:::
````

> [!IMPORTANT]
>
> 1. 请勿设置 `label`，以避免与内置引用冲突。
> 2. 请将全局设置 `caption-number` 置为 `false`，以避免在伪代码内置标题和 Quarto 自定义交叉引用标题中显式不一致的数字。
> 3. 在伪代码块和 Quarto 自定义交叉引用中同时设置标题以取得最佳效果。

在正文中使用 `@<label>` 进行交叉引用：

```
Quicksort algorithm is shown as @alg-quicksort.
```

### 区别

1. Quarto 自定义交叉引用会额外添加一个类似图片的标题，并且其中的数字和伪代码内置标题中的数字可能不一致。
2. 对于 `book` 类型项目，内置交叉引用跨文件引用仅在 PDF 文档中可用。Quarto 自定义交叉引用则在 HTML 和 PDF 文档中均可用。

目前，除了在 `book` 类型项目 HTML 文档中有跨文件引用需求外，仍建议使用内置交叉引用以取得最佳效果。

> [!CAUTION]
> 请勿在同一个项目中使用不同类型的交叉引用。

## 示例

伪代码在 HTML 和 PDF 文档中的渲染结果如下所示。


|            HTML 文档            |            PDF 文档            |
| :----------------------------------: | :---------------------------------: |
| ![](screenshots/html-document.png) | ![](screenshots/pdf-document.png) |

更详细的示例请参见：

1. 单文档（HTML 和 PDF）：[examples/simple](examples/simple)。
2. 书籍文档（HTML 和 PDF）：[examples/book](examples/book)。
3. Beamer 文档（PDF）：[examples/beamer](examples/beamer)。
4. 交叉引用示例（HTML 和 PDF）：[examples/cross-reference](examples/cross-reference)。

## 版权

The MIT License (MIT)

Copyright (c) 2023-2026 [范叶亮 | Leo Van](https://leovan.me)
