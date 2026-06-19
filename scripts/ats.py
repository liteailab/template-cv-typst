#!/usr/bin/env python3
"""ATS verification helpers for generated CVs.

Usage:
  ats.py check    <file> <anchors-file>   Verify anchor strings appear, in order.
  ats.py coverage <file> <keywords-file>  Report which job keywords appear.

<file> may be a .pdf (text extracted via pypdf) or any other file (read as UTF-8).
In anchor/keyword files, blank lines and lines starting with '#' are ignored.
Matching is case-insensitive and whitespace-normalized.
"""
import sys


def extract_text(path):
    if path.lower().endswith(".pdf"):
        from pypdf import PdfReader  # lazy: only needed for PDFs
        reader = PdfReader(path)
        return "\n".join((page.extract_text() or "") for page in reader.pages)
    with open(path, encoding="utf-8") as fh:
        return fh.read()


def normalize(text):
    return " ".join(text.split()).lower()


def read_list(path):
    items = []
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if line and not line.startswith("#"):
                items.append(line)
    return items


def cmd_check(cv_file, anchors_file):
    text = normalize(extract_text(cv_file))
    problems, cursor = [], 0
    for anchor in read_list(anchors_file):
        needle = normalize(anchor)
        idx = text.find(needle, cursor)
        if idx == -1:
            problems.append(("OUT OF ORDER" if needle in text else "MISSING", anchor))
        else:
            cursor = idx + len(needle)
    if problems:
        print("ATS check FAILED:")
        for kind, anchor in problems:
            print(f"  {kind}: {anchor!r}")
        return 1
    print(f"ATS check PASSED: all anchors present and in order.")
    return 0


def cmd_coverage(cv_file, keywords_file):
    text = normalize(extract_text(cv_file))
    keywords = read_list(keywords_file)
    present = [kw for kw in keywords if normalize(kw) in text]
    missing = [kw for kw in keywords if normalize(kw) not in text]
    print(f"Keyword coverage: {len(present)}/{len(keywords)} present.")
    print("PRESENT: " + (", ".join(present) if present else "(none)"))
    print("MISSING: " + (", ".join(missing) if missing else "(none)"))
    return 0


def main(argv):
    if len(argv) != 3:
        print(__doc__)
        return 2
    cmd, cv_file, list_file = argv
    if cmd == "check":
        return cmd_check(cv_file, list_file)
    if cmd == "coverage":
        return cmd_coverage(cv_file, list_file)
    print(f"Unknown command: {cmd!r}")
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
