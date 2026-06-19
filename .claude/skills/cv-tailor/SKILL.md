---
name: cv-tailor
description: Use when the user provides a job description and wants a CV tailored to it. Selects, reorders, and lightly rephrases their real content from master-cv.yaml (never inventing), renders a named ATS-friendly PDF into output/, and reports keyword coverage.
---

# Tailoring a CV to a job description

Goal: produce a job-specific, ATS-friendly CV from `master-cv.yaml` that surfaces
the most relevant real experience — **without inventing anything**.

## Steps

1. **Read inputs.** Load `master-cv.yaml` and the job description (text, file, or
   URL the user provides). If a URL, fetch it — this works for most public
   postings (company career pages, Greenhouse/Lever/Ashby, etc.). But if the
   fetch returns a login wall, an anti-bot/challenge page, or an empty/near-empty
   body (common for LinkedIn, Indeed, Glassdoor), do **not** tailor against that
   junk: tell the user the link isn't fetchable and ask them to paste the job
   description text (or save the page and give you the file).

2. **Identify Company and Role** for naming. If either is ambiguous, ask the user.

3. **Extract the job's key requirements/keywords** (skills, technologies,
   responsibilities, seniority signals).

4. **Tailor truthfully.** Build a copy of the data that:
   - Selects the most relevant experiences, bullets, and skills; drops the least
     relevant to keep focus.
   - Reorders entries/bullets so the most job-relevant points come first.
   - Reorders each `tech:` list to put job-relevant technologies first.
   - Lightly rephrases bullets to mirror the job's language.
   - **NEVER invents employers, dates, metrics, or skills the user lacks, and
     never inflates scope.** Tailoring = surfacing real experience, not creating it.

5. **Determine the output folder.** Slugify Company, Role, and the CV `name` into
   filesystem-safe tokens (trim; spaces → `-`; strip other punctuation). Folder:
   `output/{Company}-{Role}-{Name}/`. Create it.

6. **Write the tailored data** to `output/{Company}-{Role}-{Name}/cv.yaml`
   (same schema as master-cv.yaml).

7. **Compile the PDF:**
   `typst compile --input data=output/{Company}-{Role}-{Name}/cv.yaml --font-path ./assets/fonts resume.typ output/{Company}-{Role}-{Name}/{Company}-{Role}-{Name}.pdf`

8. **ATS text-extraction verification.** Read the generated PDF back with the
   Read tool and confirm — top to bottom — that the contact email, every section
   heading, and every selected employer/role appear in the order you wrote them.
   If anything is missing or out of order, the layout scrambled the text —
   investigate and re-render before delivering.

9. **ATS keyword-coverage report.** From the job's key requirements/keywords
   (step 3), check which appear in the PDF text you just read, and report
   coverage as present vs. missing. Review MISSING keywords: if the user
   genuinely has that experience, surface it (truthfully); otherwise leave it
   out. Never fabricate to raise coverage.

   *Optional deterministic check.* For a model-independent verification (catches
   font/glyph extraction corruption that visual reading can miss), and only if
   `pypdf` is installed (`pip install pypdf`), write an ordered anchors file and a
   one-keyword-per-line file into the output folder and run
   `python3 scripts/ats.py check <pdf> <anchors-file>` and
   `python3 scripts/ats.py coverage <pdf> <keywords-file>`.

10. **Write `job.md`** in the output folder: the job description, a short note on
    what you tailored (what you surfaced/dropped/rephrased), and the
    keyword-coverage result.

## Constraints

- Single column only — never populate the Typst `sidebar`.
- Do all work on a feature branch, not `main`. `output/` is gitignored.
- Truthfulness is non-negotiable: select/reorder/light-rephrase only.
