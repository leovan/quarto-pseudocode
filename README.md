# Quarto Pseudocode Extension

![License](https://img.shields.io/github/license/leovan/quarto-pseudocode.svg)
![Issues](https://img.shields.io/github/issues/leovan/quarto-pseudocode.svg)

---

🇺🇸 [README](README.md) | 🇨🇳 [中文说明](README.zh.md)

A Quarto extension to render pseudocode for `html` and `pdf` format output. It's based on [pseudocode.js](https://github.com/SaswatPadhi/pseudocode.js) for `html` format, `algorithm` and `algpseudocode` package for `pdf` format.

> **Warning**  
> Mathjax 3 is used for `html` format, it may conflict to your document using Mathjax 2.

## Installing

```bash
quarto add leovan/quarto-pseudocode
```

This will install the extension under the `_extensions` subdirectory. If you're using version control, you will want to check in this directory.

## Using

Put this in the header of your document, or in the `_quarto.yml` file.

```
filters:
  - pseudocode
```

Then you can put the pseudocode in a code block marked with `pseudocode`.

````
```pseudocode
#| label: alg-quicksort
#| html-indent-size: "1.2em"
#| html-comment-delimiter: "//"
#| html-line-number: true
#| html-line-number-punc: ":"
#| html-no-end: false

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
> Use upper camel case format keyword rather than all uppercase format keyword.

Use `@<alg-label>` to do cross reference.

```
Quicksort algorithm is shown as @alg-quicksort.
```

> **Note**  
> For `book` type project, cross reference in different files is only available with `pdf` format.

Pseudocode and cross reference rendered in `html` and `pdf` format are shown as below.

| `html` format                    | `pdf` format                    |
| :------------------------------: | :-----------------------------: |
| ![](screenshots/html-format.png) | ![](screenshots/pdf-format.png) |

Options for pseudocode share the same format like R or Python code.

| option                   | default  | format | comment                                                  |
| :----------------------- | :------- | :----- | :------------------------------------------------------- |
| `label`                  |          | all    | label for cross reference, must start with `alg-` if has |
| `html-indent-size`       | "1.2 em" | `html` | `indentSize` in pseudocode.js                            |
| `html-comment-delimiter` | "//"     | `html` | `commentDelimiter` in pseudocode.js                      |
| `html-line-number`       | true     | `html` | `lineNumber` in pseudocode.js                            |
| `html-line-number-punc`  | ":"      | `html` | `lineNumberPunc`in pseudocode.js                         |
| `html-no-end`            | false    | `html` | `noEnd` in pseudocode.js                                 |

You can change the `Algorithm` word to native language, such as `算法` in Chinese, by putting this in the header of your document, or in the `_metadata.yml` file.

```
pseudocode:
  alg-title: "算法"
  alg-prefix: "算法"
```

`alg-title` is used for pseudocode caption and `alg-prefix` is used for cross reference.

For `book` type project, pseudocode caption count will be like `x.n` in chapter `x`, by putting this in the header of your document, or in the `_quarto.yml` file.

```
format:
  pdf:
    include-before-body:
      text: |
        \numberwithin{algorithm}{chapter}
```

## Examples

1. A minimal example for single document: [example.qmd](example.qmd).
2. A minimal example for `book` type project: [_quarto.yml](_quarto.yml).

## License

The MIT License (MIT)

Copyright (c) 2023 [范叶亮 | Leo Van](https://leovan.me)
