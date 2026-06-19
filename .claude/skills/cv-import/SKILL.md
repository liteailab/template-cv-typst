---
name: cv-import
description: Use when the user wants to import or parse their existing CV/resume into this project's data store (master-cv.yaml). One-time setup that captures their real CV faithfully so job-tailored versions can be generated later with cv-tailor.
---

# Importing a CV into master-cv.yaml

Goal: turn the user's existing CV into `master-cv.yaml` — the single source of
truth — without losing or inventing anything. This is normally a one-time step.

## Steps

1. **Get the source CV.** Ask the user for a file path (PDF / text / DOCX) or to
   paste the text. For a PDF, read it with the file Read tool (it reads PDFs).

2. **Parse faithfully into the schema.** Map the CV onto `master-cv.yaml`:
   - `name`, `contact: [{text, link?}]` (LinkedIn, GitHub, site, email — keep the
     real URLs; email link is `mailto:…`).
   - `sections: [{title, items: [...]}]` — typically Experience, Skills,
     Education. Order sections as in the source.
   - Each experience `item`: `title` (employer), `titleEnd` (location),
     `subTitle` (role), `subTitleEnd` (dates, e.g. `"(Jan 2023 – Present)"`),
     `bullets: [str]` (achievements), and optional `tech: [str]` (the
     technologies line — store as a list, not prose).
   - Skills/Education items use `lines: [str]` instead of `bullets`.
   - **Copy content faithfully. Do not invent, drop, summarize, or embellish.**

3. **Preserve emphasis with Typst markup.** Inside `bullets`/`lines`, wrap key
   terms/metrics in `*…*` for bold (e.g. `*50k+ users*`). Quote every
   bullet/line value in YAML (they start with `*` or contain `:`). Escape any
   literal `#`, `@` at the start of a token, or `_` that should not be markup.

4. **Write `master-cv.yaml`** at the repo root (this overwrites the shipped
   "Alex Doe" sample — that's expected).

5. **Render to verify nothing is lost.** Run `./build.sh` and open `resume.pdf`.
   Show the user a short summary of what was captured (sections, employer count,
   any fields you were unsure about).

6. **Iterate** until the user confirms the data is complete and correct.

## Notes

- If the repo isn't on a feature branch, create one before writing files.
- Privacy: `master-cv.yaml` is tracked by git. If the user does not want their
  real CV in git history, tell them they can `git rm --cached master-cv.yaml`
  and add it to `.gitignore`; the file stays on disk and everything still works.
- Do NOT populate the Typst `sidebar` — output stays single-column for ATS.
