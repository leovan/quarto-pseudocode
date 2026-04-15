# Changelog

## [1.5.0](https://github.com/leovan/quarto-pseudocode/compare/v1.4.0...v1.5.0) (2026-04-15)

### Features

- Add `html-indent-lines` option for HTML document. [#16](https://github.com/leovan/quarto-pseudocode/pull/16) ([imartayan](https://github.com/imartayan))

## [1.4.0](https://github.com/leovan/quarto-pseudocode/compare/v1.3.0...v1.4.0) (2026-03-28)

### Features

- Add Quarto Wizard schema and snippets. [#13](https://github.com/leovan/quarto-pseudocode/pull/13) ([mcanouil](https://github.com/mcanouil))
- Change `algpseudocode` to `algpseudocodex` to support more features. [#15](https://github.com/leovan/quarto-pseudocode/pull/15) ([imartayan](https://github.com/imartayan))

## [1.3.0](https://github.com/leovan/quarto-pseudocode/compare/v1.2.0...v1.3.0) (2026-02-01)

### Features

- Add MathJax 4 support.
- Add parameter `pdf-comment-delimiter` for PDF document.

### Bug Fixes

- Add space around comment delimiter.

## [1.2.0](https://github.com/leovan/quarto-pseudocode/compare/v1.1.3...v1.2.0) (2025-10-01)

### Bug Fixes

- Make filter compatible with Quarto 1.8. [#11](https://github.com/leovan/quarto-pseudocode/issues/11)

> [!WARNING]
>
> 1. Change the prefix from `alg-` to `algo-` when using build-in cross reference to make it compatible with Quarto 1.8.
> 1. Change the prefix from `algo-` to `alg-` when using Quarto custom cross reference to make it compatible with Quarto 1.8.

### Features

- Optimize style when there is no caption.
- Add parameter `caption-align` to control caption alignment.

## [1.1.3](https://github.com/leovan/quarto-pseudocode/compare/v1.1.2...v1.1.3) (2025-09-03)

### Bug Fixes

- Fix wrong comment delimiter. [#10](https://github.com/leovan/quarto-pseudocode/issues/10)

## [1.1.2](https://github.com/leovan/quarto-pseudocode/compare/v1.1.1...v1.1.2) (2025-08-02)

### Bug Fixes

- Respect options in meta data. [#9](https://github.com/leovan/quarto-pseudocode/pull/9) ([RyoNakagami](https://github.com/RyoNakagami))
- Fix alignment when using Quarto custom cross reference.
- Fix `pdf-line-number` not working for PDF document.

## [1.1.1](https://github.com/leovan/quarto-pseudocode/compare/v1.1.0...v1.1.1) (2024-11-03)

### Bug Fixes

- Remove tailing space after the cross reference.

## [1.1.0](https://github.com/leovan/quarto-pseudocode/compare/v1.0.0...v1.1.0) (2024-06-08)

### Features

- Add Quarto custom cross reference support.
- Add build-in cross reference with ["float" cross reference](https://quarto.org/docs/authoring/cross-references.html#floats) support.
- Add parameter `caption-number` to show number in build-in caption.
- Automatically add chapter level to number in build-in caption for `book` type project.

### Breaking Changes

- Change parameter `alg-title` to `caption-prefix` and `alg-prefix` to `reference-prefix` to keep consistent with Quarto custom cross reference.

### Bug Fixes

- Fix caption number with chapter level not working due to typo.

## 1.0.0 (2023-08-10)

### Features

- First release version.
