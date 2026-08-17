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

# Strip a leading YAML front matter block. Human-reference files carry source
# attribution up top; counting it would measure our own annotations.
body() {
  awk 'NR==1 && $0=="---" { fm=1; next } fm && $0=="---" { fm=0; next } !fm' "$1"
}

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

# Frequency signals are reported per 100 words so texts of different lengths
# compare; hard-zero signals (em_dash, forced, tilde, pct_wrong) and structural
# ones (bold, bullets) stay raw, because there the count itself is the verdict.
per100() { awk -v n="$1" -v w="$2" 'BEGIN { if (w == 0) { print "0.0"; exit } printf "%.1f", n * 100 / w }'; }

printf 'file\twords\tsentences\tlen_mean\tlen_sd\tem_dash\tmektedir_p\tdir_p\tmis_p\tve_p\tpart_p\tcalque_p\tforced\ttilde\tpct_wrong\tbold\tbullets\n'

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

for src in "$@"; do
  f="$tmp/body.md"
  body "$src" > "$f"

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

  # Only a space-flanked dash that does not follow a digit counts. A dash
  # inside a range is correct Turkish and is not the calqued explanatory dash
  # this signal looks for — whether written tight (04.30–05.00, Nisan–haziran)
  # or spaced (MÖ 738 – MÖ 696).
  em_dash=$(count_re '[^0-9] [—–] ' "$f")
  mektedir=$(count_re '(mekte|makta)dır' "$f")
  dir_copula=$(count_re '[a-zçğıöşü]{2,}(dır|dir|dur|dür|tır|tir|tur|tür)[[:space:]]*[.,;!?]' "$f")
  # Narrative -mIş: the evidential past that marks Turkish storytelling and
  # hearsay, and that LLM Turkish almost never reaches for. Participial uses
  # ("geçmiş", "yapılmış") are counted too — this is a frequency proxy, not a
  # parse, and its job is to show whether the mood is present at all.
  mis_past=$(count_re '[a-zçğıöşü]{2,}(mış|miş|muş|müş)(ım|im|um|üm|sın|sin|sun|sün|ız|iz|uz|üz|sınız|siniz|sunuz|sünüz|lar|ler)?\b' "$f")
  ve_raw=$(count_re ' ve ' "$f")
  particles=$(count_words "$signals/particles.txt" "$f")
  calque=$(count_list "$signals/calques.txt" "$f")
  forced=$(count_list "$signals/forced-translations.txt" "$f")
  tilde=$(count_re '~' "$f")
  pct_wrong=$(count_re '[0-9]+%' "$f")
  bold=$(( $(count_re '\*\*' "$f") / 2 ))
  bullets=$(grep -cE '^[[:space:]]*[-*+•] ' "$f" || true)

  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$(basename "$src")" "$words" "$sentences" "$len_mean" "$len_sd" \
    "$em_dash" "$(per100 "$mektedir" "$words")" "$(per100 "$dir_copula" "$words")" \
    "$(per100 "$mis_past" "$words")" "$(per100 "$ve_raw" "$words")" \
    "$(per100 "$particles" "$words")" "$(per100 "$calque" "$words")" \
    "$forced" "$tilde" "$pct_wrong" "$bold" "$bullets"
done
