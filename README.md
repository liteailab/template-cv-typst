# template-cv-typst

A minimal, single-page CV/resume template built with [Typst](https://typst.app/).

Inter and Roboto fonts are bundled locally under [`assets/fonts/`](assets/fonts/), so builds are reproducible without installing anything system-wide.

## Build

```bash
./build.sh
```

This compiles `resume.typ` to `resume.pdf` using the bundled fonts.

## Personalized CVs

Your CV lives as structured data in `master-cv.yaml` (the single source of
truth). Generated, job-tailored CVs land in `output/` (gitignored).

No setup beyond installing Typst — Claude does all the parsing, tailoring, and
ATS checking. Just clone, open in Claude Code, and follow the steps below.

### Import your CV (one-time)

Ask Claude to run the **cv-import** skill with your CV (PDF or text). It parses
your CV into `master-cv.yaml` and renders `resume.pdf` so you can verify nothing
was lost.

### Generate a tailored CV per job

Give Claude a job description and ask it to run the **cv-tailor** skill. It
selects/reorders/lightly-rephrases your real content (never invents), then writes
`output/{Company}-{Role}-{Name}/` containing:

- `{Company}-{Role}-{Name}.pdf` — the CV to send
- `cv.yaml` — the tailored data (re-compilable, auditable)
- `job.md` — the job description + tailoring notes + ATS keyword coverage

### Re-compile any tailored CV

```bash
typst compile --input data=output/<folder>/cv.yaml --font-path ./assets/fonts \
  resume.typ output/<folder>/<name>.pdf
```

### ATS checks

`cv-tailor` verifies the generated PDF itself: Claude reads the PDF back, confirms
the contact email, section headings, and job titles appear in order, and reports
which job keywords are present. No setup required.

For a deterministic, model-independent check, the optional helper
[`scripts/ats.py`](scripts/ats.py) does the same via text extraction. It needs
`pypdf` (`pip install pypdf`) and catches font/glyph extraction corruption that
visual reading can miss:

```bash
python3 scripts/ats.py check    <pdf> <anchors-file>   # headings/employers in order
python3 scripts/ats.py coverage <pdf> <keywords-file>  # which job keywords appear
```

Note: no tool can certify against every applicant tracking system — these checks
make the output robustly parseable and flag problems.

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
