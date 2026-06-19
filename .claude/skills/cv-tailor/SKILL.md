---
name: cv-tailor
description: Use when the user provides a job description and wants a CV tailored to it. Selects, reorders, and lightly rephrases their real content from master-cv.yaml (never inventing), renders a named ATS-friendly PDF into output/, and reports keyword coverage.
---

# Tailoring a CV to a job description

Goal: produce a job-specific, ATS-friendly CV from `master-cv.yaml` that surfaces
the most relevant real experience — **without inventing anything** — laid out in
the fixed structure and house style below (optimized for both ATS parsing and the
6-second recruiter scan).

## Steps

1. **Read inputs.** Load `master-cv.yaml` and the job description (text, file, or
   URL the user provides). If a URL, fetch it — this works for most public
   postings (company career pages, Greenhouse/Lever/Ashby, etc.). But if the
   fetch returns a login wall, an anti-bot/challenge page, or an empty/near-empty
   body (common for LinkedIn, Indeed, Glassdoor), do **not** tailor against that
   junk: tell the user the link isn't fetchable and ask them to paste the job
   description text (or save the page and give you the file).

2. **Identify Company and Role** for naming. If either is ambiguous, ask the user.

3. **Extract the job's key requirements/keywords** (15-20: skills, technologies,
   responsibilities, seniority signals).

4. **Tailor truthfully** into the fixed structure (see "Output structure" and
   "House style" below). Build a copy of the data that:
   - Selects the most relevant experiences, bullets, and skills; drops the least
     relevant to keep focus.
   - Reorders entries/bullets so the most job-relevant points come first.
   - Lightly rephrases bullets to mirror the job's language.
   - **NEVER invents employers, dates, metrics, or skills the user lacks, and
     never inflates scope or completion.** Tailoring = surfacing real experience,
     not creating it.

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
   `python3 scripts/ats.py coverage <pdf> <keywords-file>`. Keep the anchors file
   in sync with the actual section order/names if you change the structure.

10. **Write `job.md`** in the output folder: the job description, a short note on
    what you tailored (what you surfaced/dropped/rephrased), and the
    keyword-coverage result.

## Output structure (fixed section order)

Always emit sections in this order. Use the standard titles verbatim (ATS parsers
expect them); skip a section only if there's genuinely no content for it.

1. **Summary** — 3-4 lines, keyword-dense (not the master's full prose block).
2. **Core Competencies** — a 6-8 phrase keyword strip, the first landing zone for
   the recruiter's eye. One title-less item, a single `lines` entry with phrases
   joined by ` • ` (e.g. `Full-Stack JavaScript • Node.js & Express • RESTful API
   Design • MongoDB & NoSQL • ...`). Pull phrases from the JD requirements that the
   candidate genuinely has.
3. **Work Experience** — reverse chronological; bullets strongest-first per role.
4. **Projects** — only if the candidate has 3-4 relevant ones; otherwise omit.
5. **Education & Certifications** — merged into one section (degrees as entries; a
   title-less `lines` item like `*Certifications:* … • …` for licenses/certs).
6. **Skills** — the full categorized block goes LAST. Fold spoken languages in
   here as a `*Spoken languages:*` line (do not make a separate Languages section).

Note: this mirrors the user's house style documented in
`~/projects/career-ops/modes/pdf.md` and `modes/_shared.md`. The Typst template
auto-skips the heading row for title-less items, so Summary / Core Competencies /
Skills render with no blank gap under the section bar.

## House style (recruiter-scan + ATS)

- **Summary:** 3-4 lines, keyword-dense, **pronoun-free** (no "I"/"my" — write
  "Senior Full-Stack Developer with 10+ years…", "Ships…", "Writes…"). Bold the
  first occurrence of ~5 top JD keywords. No cliché phrases (passionate, robust,
  seamless, proven track record, leveraged, spearheaded, results-oriented).
- **Bullets — front-load.** Within each role, order bullets strongest-first
  (biggest result + most JD-relevant keyword), NOT chronological-within-role. No
  scene-setting bullet; weave scope/stack into the achievement.
- **Strong openers, truthfully.** Start bullets with a precise past-tense verb
  where facts support it (Led, Built, Designed, Cut, Reduced, Migrated, Raised…).
  Never upgrade real ownership/completion: "helped/contributed" stays
  Contributed/Co-built; in-progress work stays present tense; only use
  Shipped/Launched when it actually went live.
- **Bold for the scanning eye, capped.** Bold the bullet's lead-in result phrase
  so the eye catches it first; optionally bold one more first-occurrence JD
  keyword. **Cap ~2 bold spans per bullet.** Never bold an entire bullet and never
  bold every tech token — scattered mid-bullet bolds are noise, not signal.
- **Clarity over density.** One idea per bullet, ≤2 lines. 3-5 bullets for recent/
  relevant roles, 1-3 for older ones. Cut a weak bullet before crowding a strong one.
- **No per-role `Technologies:` lines.** Tech lives in the consolidated Skills
  section; inject keywords into the achievement bullets themselves. (Do not use
  the schema's `tech:` field in tailored output.)
- **ASCII punctuation only** (ATS rule). No em-dashes (`—`), smart quotes, or
  zero-width characters — use `-`, straight quotes. En-dashes in date ranges
  (`(Apr 2022 – Present)`) are fine.
- **Contact = one line.** Keep it short enough not to wrap; use a short label like
  `LinkedIn` (linking to the profile) rather than the full `linkedin.com/in/...`
  URL.

## Constraints

- Single column only — never populate the Typst `sidebar`.
- Do all work on a feature branch, not `main`. `output/` is gitignored.
- Truthfulness is non-negotiable: select/reorder/light-rephrase only.
