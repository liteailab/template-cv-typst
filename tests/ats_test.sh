#!/usr/bin/env bash
# Plain-shell tests for scripts/ats.py (no bats available).
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ATS=(python3 "$ROOT/scripts/ats.py")
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
fail=0
assert_exit() { # desc expected actual
  if [ "$2" = "$3" ]; then echo "PASS: $1"; else echo "FAIL: $1 (expected exit $2, got $3)"; fail=1; fi
}
assert_contains() { # desc haystack needle
  if printf '%s' "$2" | grep -qF "$3"; then echo "PASS: $1"; else echo "FAIL: $1 (missing '$3')"; fail=1; fi
}

cat > "$tmp/cv.txt" <<'EOF'
ALEX DOE
alex@example.com
EXPERIENCE
ACME CLOUD
Led Kubernetes migration on AWS
SKILLS
EOF

printf 'Alex Doe\nExperience\nAcme Cloud\nSkills\n' > "$tmp/ok.txt"
"${ATS[@]}" check "$tmp/cv.txt" "$tmp/ok.txt" >/dev/null; assert_exit "in-order anchors pass" 0 $?

printf 'Alex Doe\nNonexistent Corp\n' > "$tmp/missing.txt"
"${ATS[@]}" check "$tmp/cv.txt" "$tmp/missing.txt" >/dev/null; assert_exit "missing anchor fails" 1 $?

printf 'Skills\nExperience\n' > "$tmp/ooo.txt"
"${ATS[@]}" check "$tmp/cv.txt" "$tmp/ooo.txt" >/dev/null; assert_exit "out-of-order fails" 1 $?

printf 'Kubernetes\nAWS\nTerraform\n' > "$tmp/kw.txt"
out="$("${ATS[@]}" coverage "$tmp/cv.txt" "$tmp/kw.txt")"
assert_contains "coverage lists present" "$out" "PRESENT: Kubernetes, AWS"
assert_contains "coverage lists missing" "$out" "MISSING: Terraform"

if [ $fail -eq 0 ]; then echo "ALL TESTS PASSED"; else echo "SOME TESTS FAILED"; fi
exit $fail
