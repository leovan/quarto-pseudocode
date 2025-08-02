# Changelog

## [1.1.2](https://github.com/leovan/quarto-pseudocode/compare/v1.1.1...v1.1.2) (2025-08-02)

### Bug Fixes

- Respect options in meta data. ([#8](https://github.com/leovan/quarto-pseudocode/issues/8))
- Fix alignment when using Quarto custom cross reference.
- Fix `pdf-line-number` not working for `pdf` document.

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
