#!/usr/bin/env bash
# Asserts that every register-dependent rule states its own register dose.
#
# The rule's section is the specification; registers.md is a summary of it. That
# only holds if a rule which varies by register actually says so where it is
# read. Twice it did not, and both times a blind judge found it instead:
#
#   layer-1-structure.md §2  told you to break a paragraph where the text turns
#                            and named only procedural writing as the limit, so
#                            it fired in academic register, where the dosage
#                            table says the structure layer is off.
#   layer-3-surface.md   §5  gave the semicolon no dose at all, because the file
#                            opened by declaring that none of it is style. The
#                            skill then wrote academic semicolon rates in blogs
#                            for six rounds.
#
# So: every section below must either name a register, or be on the invariant
# list. A section that leaves the invariant list has become register-dependent
# and must say so. A section that joins it must genuinely be correctness rather
# than style.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

refs="skills/turkish-humanify/references"

# Rules that are facts about Turkish or about correctness, identical in every
# register. layer-2 §1-3 are here deliberately: branching, converbs and focus
# are the highest-value rules in the skill and they do not vary.
invariant=$(cat <<'EOF'
layer-1-structure.md|6. Bold and emoji inflation
layer-1-structure.md|7. Subheadings
layer-1-structure.md|Reading the layer as a whole
layer-2-sentence.md|1. Branching direction
layer-2-sentence.md|2. The converb system (`ulaç`)
layer-2-sentence.md|3. Focus position
layer-2-sentence.md|10. Pro-drop
layer-2-sentence.md|11. Noun-compound chains
layer-2-sentence.md|12. `ki` clauses
layer-2-sentence.md|Reading the layer as a whole
layer-3-surface.md|1. Technical terminology — three buckets
layer-3-surface.md|3. Apostrophe (`kesme işareti`)
layer-3-surface.md|4. `da/de` and `ki`
layer-3-surface.md|7. Circumflex
layer-3-surface.md|8. Calqued idioms and empty intensifiers
EOF
)

fail=0
for f in layer-1-structure.md layer-2-sentence.md layer-3-surface.md; do
  while IFS=$'\t' read -r sec hits; do
    [ -z "$sec" ] && continue
    key="$f|$sec"
    listed=$(printf '%s\n' "$invariant" | grep -Fxq "$key" && echo yes || echo no)
    if [ "$listed" = no ] && [ "$hits" -eq 0 ]; then
      printf 'FAIL %s §%s names no register and is not on the invariant list\n' "$f" "$sec" >&2
      printf '     either state its register dose, or add it to scripts/check-doses.sh\n' >&2
      fail=1
    fi
    if [ "$listed" = yes ] && [ "$hits" -gt 0 ]; then
      printf 'FAIL %s §%s is on the invariant list but now names a register\n' "$f" "$sec" >&2
      printf '     it has become register-dependent; remove it from the list\n' >&2
      fail=1
    fi
  done < <(awk '
      /^## / { if (sec != "") printf "%s\t%d\n", sec, n; sec = $0; sub(/^## /, "", sec); n = 0; next }
      { if (sec != "" && $0 ~ /academic|blog|technical|corporate|register|official|legal/) n++ }
      END { if (sec != "") printf "%s\t%d\n", sec, n }' "$refs/$f")
done

if [ "$fail" -eq 0 ]; then
  echo "ok   every register-dependent rule states its own dose"
else
  exit 1
fi
