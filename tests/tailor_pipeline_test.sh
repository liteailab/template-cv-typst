#!/usr/bin/env bash
# Verifies the mechanical pipeline cv-tailor depends on: a tailored cv.yaml
# compiles to a named PDF in output/, and ATS check + coverage run against it.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
fail=0
ok() { echo "PASS: $1"; }
no() { echo "FAIL: $1"; fail=1; }

dir="output/TestCo-Backend-Engineer-Alex-Doe"
pdf="$dir/TestCo-Backend-Engineer-Alex-Doe.pdf"
rm -rf "$dir"; mkdir -p "$dir"

# A minimal tailored cv.yaml (subset of master, reordered for a backend role).
cat > "$dir/cv.yaml" <<'EOF'
name: Alex Doe
theme: "#0F83C0"
contact:
  - text: "alex@example.com"
    link: "mailto:alex@example.com"
sections:
  - title: Experience
    items:
      - title: Nimbus Analytics
        titleEnd: "Amsterdam, NL"
        subTitle: Backend Engineer
        subTitleEnd: "(Aug 2017 – May 2020)"
        bullets:
          - "Built data ingestion services in *Go* processing *2B+ events/day*."
        tech: [Go, Kafka, PostgreSQL]
EOF

typst compile --input data="$dir/cv.yaml" --font-path ./assets/fonts resume.typ "$pdf" \
  && [ -f "$pdf" ] && ok "tailored cv.yaml compiles to named PDF" || no "tailored cv.yaml compiles to named PDF"

printf 'Alex Doe\nExperience\nNimbus Analytics\n' > "$dir/anchors.txt"
./.venv/bin/python scripts/ats.py check "$pdf" "$dir/anchors.txt" >/dev/null \
  && ok "ATS check passes on tailored PDF" || no "ATS check passes on tailored PDF"

printf 'Go\nKafka\nRust\n' > "$dir/keywords.txt"
cov="$(./.venv/bin/python scripts/ats.py coverage "$pdf" "$dir/keywords.txt")"
printf '%s' "$cov" | grep -qF "MISSING: Rust" && ok "coverage reports missing keyword" || no "coverage reports missing keyword"

rm -rf "$dir"
if [ $fail -eq 0 ]; then echo "ALL TESTS PASSED"; else echo "SOME TESTS FAILED"; fi
exit $fail
