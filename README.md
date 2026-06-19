# template-cv-typst

A minimal, single-page CV/resume template built with [Typst](https://typst.app/).

Inter and Roboto fonts are bundled locally under [`assets/fonts/`](assets/fonts/), so builds are reproducible without installing anything system-wide.

## Build

```bash
./build.sh
```

This compiles `resume.typ` to `resume.pdf` using the bundled fonts.

## Choosing a font

The default font is **Inter**. Switch at build time with the `font` input:

```bash
./build.sh --input font=Roboto
```

Available fonts: `Inter`, `Roboto`.

## Editing

Put your content in [`resume.typ`](resume.typ). The layout and styling live in [`template.typ`](template.typ).

## Requirements

- [Typst](https://github.com/typst/typst) installed and on your `PATH`.
