# template-cv-typst

A minimal, single-page CV/resume template built with [Typst](https://typst.app/).

Inter and Roboto fonts are bundled locally under [`assets/fonts/`](assets/fonts/), so builds are reproducible without installing anything system-wide.

## Installing Typst

The only requirement is [Typst](https://github.com/typst/typst) on your `PATH`.
Pick whichever method below fits your platform, then verify with:

```bash
typst --version
```

### Linux (incl. WSL2)

Any one of:

```bash
# Snap (most distros)
sudo snap install typst

# Cargo (if you have the Rust toolchain)
cargo install --locked typst-cli

# Distro package managers (check https://repology.org/project/typst/versions)
sudo pacman -S typst        # Arch
brew install typst          # Homebrew on Linux
```

Or install the prebuilt binary manually (works everywhere, including WSL2):

```bash
ARCH=$(uname -m)            # x86_64 or aarch64
curl -fsSL "https://github.com/typst/typst/releases/latest/download/typst-${ARCH}-unknown-linux-musl.tar.xz" \
  | tar -xJ
install -Dm755 "typst-${ARCH}-unknown-linux-musl/typst" ~/.local/bin/typst
```

Make sure `~/.local/bin` is on your `PATH`.

### Windows 11

Using the built-in WinGet package manager (PowerShell or Terminal):

```powershell
winget install --id Typst.Typst
```

Alternatives: `scoop install typst` (Scoop), or download the prebuilt
`typst-x86_64-pc-windows-msvc.zip` from the
[releases page](https://github.com/typst/typst/releases/), extract it, and add
the folder to your `PATH`.

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
