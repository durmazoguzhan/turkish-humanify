#!/usr/bin/env bash
# Asserts that the two experiment arms differ in exactly one dimension: the
# language of the explanatory prose. Structure, ordering and every Turkish
# example must be identical, or the comparison measures two things at once and
# its result means nothing.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

fail=0
report() { if [ "$1" = 0 ]; then echo "ok   $2"; else echo "FAIL $2"; fail=1; fi; }

for f in SKILL.md references/layer-2-sentence.md; do
  en_h=$(grep -cE '^#{1,6} ' "en/$f")
  tr_h=$(grep -cE '^#{1,6} ' "tr/$f")
  [ "$en_h" = "$tr_h" ]; report $? "$f: same heading count ($en_h)"
done

f=references/layer-2-sentence.md
en_q=$(grep -c '^> ' "en/$f")
tr_q=$(grep -c '^> ' "tr/$f")
[ "$en_q" = "$tr_q" ]; report $? "$f: same example-line count ($en_q)"

# Example lines may carry a trailing gloss after the last " — ", and that gloss
# is prose, so it is expected to differ. Everything to its left is the example
# itself and must match byte for byte.
strip_gloss() { sed -E 's/ — [^—]*$//' ; }

if diff -q <(grep '^> ' "en/$f" | strip_gloss) \
           <(grep '^> ' "tr/$f" | strip_gloss) >/dev/null; then
  report 0 "$f: every Turkish example identical across arms"
else
  report 1 "$f: examples diverge —"
  diff <(grep '^> ' "en/$f" | strip_gloss) <(grep '^> ' "tr/$f" | strip_gloss) || true
fi

for f in SKILL.md; do
  en_n=$(grep -m1 '^name:' "en/$f")
  tr_n=$(grep -m1 '^name:' "tr/$f")
  [ "$en_n" = "$tr_n" ]; report $? "$f: same front matter name"
done

exit $fail
