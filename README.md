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

### One-time setup

```bash
python3 -m venv .venv
./.venv/bin/pip install pypdf   # used for ATS text-extraction checks
```

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

`cv-tailor` verifies the generated PDF with `scripts/ats.py`:
`check` confirms the contact email, section headings, and job titles extract in
order; `coverage` reports which job keywords appear. Note: no tool can certify
against every applicant tracking system — these checks make the output robustly
parseable and flag problems.

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
