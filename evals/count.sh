#!/usr/bin/env bash
# Counts the mechanically countable signals from rubric.md.
#
# This tool reports; it does not judge. Signals that need Turkish morphology
# (participle density, inversion rate, focus placement) are deliberately
# absent: grep cannot separate "zaman" from an -an participle, and a noisy
# number is worse than no number. Those live in the reading half of rubric.md.
#
# Usage: evals/count.sh FILE...
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
signals="$here/signals"

# Prose view: drop headings, list items, blank lines; drop standalone dashes
# so they are not counted as words.
prose() {
  sed -E '/^[[:space:]]*#/d; /^[[:space:]]*[-*+•]/d; /^[[:space:]]*$/d' "$1" \
  | sed -E 's/(^| )[—–]+( |$)/ /g'
}

# Zero matches is a legitimate answer, so grep's exit 1 is swallowed rather
# than allowed to kill the script under `set -e` / `pipefail`.
count_re() { { grep -oE "$1" "$2" 2>/dev/null || true; } | wc -l | tr -d ' '; }

# Build an alternation regex from a phrase list, ignoring comments and blanks.
list_re() {
  grep -vE '^[[:space:]]*(#|$)' "$1" | paste -sd'|' -
}

# Substring match: for multi-word idioms, where a stem is intended to catch
# inflected forms.
count_list() { { grep -oiE "$(list_re "$1")" "$2" 2>/dev/null || true; } | wc -l | tr -d ' '; }

# Word-boundary match: for short particles, where substring matching would
# find "ki" inside "ikinci" and report a speaking voice that is not there.
count_words() { { grep -oiE "\\b($(list_re "$1"))\\b" "$2" 2>/dev/null || true; } | wc -l | tr -d ' '; }

printf 'file\twords\tsentences\tlen_mean\tlen_sd\tem_dash\tmektedir\tdir_copula\tve_per100\tparticles\tcalque\tforced\ttilde\tpct_wrong\tbold\tbullets\n'

for f in "$@"; do
  words=$(prose "$f" | wc -w | tr -d ' ')

  read -r sentences len_mean len_sd < <(
    prose "$f" \
    | sed -E 's/([.!?…]+)([[:space:]]|$)/\1\n/g' \
    | awk '
        { n = split($0, w, " "); c = 0
          for (i = 1; i <= n; i++) if (w[i] ~ /[^[:punct:]]/) c++
          if (c > 0) { s++; t += c; a[s] = c } }
        END { if (s == 0) { print 0, 0, 0; exit }
              m = t / s
              for (i = 1; i <= s; i++) d += (a[i] - m) * (a[i] - m)
              printf "%d %.1f %.1f\n", s, m, sqrt(d / s) }'
  )

  em_dash=$(count_re '—|–' "$f")
  mektedir=$(count_re '(mekte|makta)dır' "$f")
  dir_copula=$(count_re '[a-zçğıöşü]{2,}(dır|dir|dur|dür|tır|tir|tur|tür)[[:space:]]*[.,;!?]' "$f")
  ve_raw=$(count_re ' ve ' "$f")
  particles=$(count_words "$signals/particles.txt" "$f")
  calque=$(count_list "$signals/calques.txt" "$f")
  forced=$(count_list "$signals/forced-translations.txt" "$f")
  tilde=$(count_re '~' "$f")
  pct_wrong=$(count_re '[0-9]+%' "$f")
  bold=$(( $(count_re '\*\*' "$f") / 2 ))
  bullets=$(grep -cE '^[[:space:]]*[-*+•] ' "$f" || true)

  if [ "$words" -gt 0 ]; then
    ve_per100=$(awk -v v="$ve_raw" -v w="$words" 'BEGIN { printf "%.1f", v * 100 / w }')
  else
    ve_per100=0.0
  fi

  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$(basename "$f")" "$words" "$sentences" "$len_mean" "$len_sd" \
    "$em_dash" "$mektedir" "$dir_copula" "$ve_per100" "$particles" \
    "$calque" "$forced" "$tilde" "$pct_wrong" "$bold" "$bullets"
done
