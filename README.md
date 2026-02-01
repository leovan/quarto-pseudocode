# Quarto Pseudocode Extension

![Release](https://img.shields.io/github/release/leovan/quarto-pseudocode.svg)
![License](https://img.shields.io/github/license/leovan/quarto-pseudocode.svg)
![Issues](https://img.shields.io/github/issues/leovan/quarto-pseudocode.svg)

---

🇺🇸 [README](README.md) | 🇨🇳 [中文说明](README.zh.md)

A Quarto extension to render pseudocode for `html` and `pdf` document. It's based on [pseudocode.js](https://github.com/SaswatPadhi/pseudocode.js) for `html` document, `algorithm` and `algpseudocode` package for `pdf` document.

## Installing

```bash
quarto add leovan/quarto-pseudocode
```

This will install the extension under the `_extensions` subdirectory. If you're using version control, you will want to check in this directory.

## Using

### Adding Extension

Add this in the header of your document, or in the `_quarto.yml` file:

```yml
filters:
  - pseudocode
```

### Pseudocode Block

Add the pseudocode in a code block marked with `pseudocode`:

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
> Use upper camel case format keyword rather than all uppercase format keyword.

### Parameters

Global parameters are show as below:

| Parameter          | Default     | Format | Description                                             |
| ------------------ | ----------- | ------ | ------------------------------------------------------- |
| `caption-prefix`   | "Algorithm" | all    | prefix for caption                                      |
| `reference-prefix` | "Algorithm" | all    | prefix for reference                                    |
| `caption-number`   | true        | all    | show number in build-in caption                         |
| `caption-align`    | "left"      | all    | Build-in caption alignment, "left", "center" or "right" |

Add global parameters in the header of your document, or in the `_quarto.yml` file:

```yml
pseudocode:
  caption-prefix: "Algorithm"
  reference-prefix: "Algorithm"
  caption-number: true
  caption-align: "left"
```

Parameters for pseudocode share the same format like R or Python code:

| Parameter                | Default | Format | Description                                              |
| ------------------------ | ------- | ------ | -------------------------------------------------------- |
| `label`                  |         | all    | label for cross reference, must start with `alg-` if has |
| `html-indent-size`       | "1.2em" | `html` | `indentSize` in pseudocode.js                            |
| `html-comment-delimiter` | "//"    | `html` | `commentDelimiter` in pseudocode.js                      |
| `html-line-number`       | true    | `html` | `lineNumber` in pseudocode.js                            |
| `html-line-number-punc`  | ":"     | `html` | `lineNumberPunc`in pseudocode.js                         |
| `html-no-end`            | false   | `html` | `noEnd` in pseudocode.js                                 |
| `pdf-placement`          | "H"     | `pdf`  | placement of the pseudocode in text                      |
| `pdf-line-number`        | true    | `pdf`  | show line number                                         |
| `pdf-comment-delimiter`  | "//"    | `pdf`  | comment delimiter                                        |

> [!NOTE]
>
> 1. If set the placement in pseudocode, such as `\begin{algorithm}[htb!]`, then `pdf-placement` option will be ignored.
> 2. If set show line number or not in pseudocode, such as `\begin{algorithmic}[1]`, then `pdf-line-number` option will be ignored.
> 3. All these changes won't affect the output of `html` document. We recommend you set the parameters rather than modify pseudocode directly.

For `html` document, [pseudocode.js](https://github.com/SaswatPadhi/pseudocode.js) render math formulas using either [KaTeX](https://katex.org/) or [MathJax](https://www.mathjax.org/). We add [pseudocode.js](https://github.com/SaswatPadhi/pseudocode.js) after html body, thus you need initialize [KaTeX](https://katex.org/) or [MathJax](https://www.mathjax.org/) before html body or in html header. Add this in the header of your document, or in the `_quarto.yml` file.

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

For `pdf` document, pseudocode caption in `book` type project will be changed from `Algorithm n` to `Algorithm x.n` in chapter `x`. Add `\algrenewcommand{\algorithmiccomment}[1]{<your value> #1}` in the header of your document, or in the `_quarto.yml` file will change the form in which comments are displayed:

```yml
format:
  pdf:
    include-before-body:
      text: |
        \algrenewcommand{\algorithmiccomment}[1]{\hskip3em$\rightarrow$ #1}
```

### Cross Reference

#### Build-in Cross Reference

Set the `label` in pseudocode, and it must start with `algo-`:

> [!WARNING]
> From Quarto 1.8, `alg` has become a reserved cross reference prefix keyword.

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

Use `@<label>` to do cross reference:

```
Quicksort algorithm is shown as @algo-quicksort.
```

> [!IMPORTANT]
> Must set `label` and `\caption{}` to make build-in cross reference works.

> [!WARNING]
> For `book` type project, build-in cross reference in different files works only with `pdf` format.

#### Quarto Custom Cross Reference

Add custom cross reference for pseudocode in the header of your document, or in the `_quarto.yml` file:

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

Use [Quarto custom cross reference](https://quarto.org/docs/authoring/cross-references-custom.html) to surround the pseudocode:

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
> 1. Do not set `label` to avoid conflict with build-in cross reference.
> 2. Set the global parameter `caption-number` to `false` to avoid show different numbers in pseudocode build-in caption and Quarto cross reference caption.
> 3. Set both captions in pseudocode and Quarto custom cross reference to achieve best effect.

Use `@<label>` to do cross reference.

```
Quicksort algorithm is shown as @alg-quicksort.
```

#### Difference

1. Quarto custom cross reference will add an extra caption like figure, in which number may not be same as pseudocode build-in caption.
2. Build-in cross reference in different files is only available with `pdf` document for `book` type project. Quarto custom cross reference works in both `html` and `pdf` document.

Now, expect cross reference in different files with `pdf` document for `book` type project, we strongly recommend use build-in cross reference to achieve best effect.

> [!CAUTION]
> Do not use different type of cross reference in the same project.

## Examples

Pseudocode and cross reference rendered in `html` and `pdf` document are shown as below.

| `html` document                    | `pdf` document                    |
| :--------------------------------: | :-------------------------------: |
| ![](screenshots/html-document.png) | ![](screenshots/pdf-document.png) |

More examples please refer:

1. Single document (`html` and `pdf`): [examples/simple](examples/simple).
2. Book document (`html` and `pdf`): [examples/book](examples/book).
3. Beamer document (`pdf`): [examples/beamer](examples/beamer).
4. Cross reference example (`html` and `pdf`): [examples/cross-reference](examples/cross-reference).

## License

The MIT License (MIT)

Copyright (c) 2023-2026 [范叶亮 | Leo Van](https://leovan.me)
