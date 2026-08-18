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

# Prose view: drop headings and list items, join each paragraph onto one line,
# drop standalone dashes so they are not counted as words.
#
# The join matters. Sentence splitting downstream is line-based, so a
# hard-wrapped paragraph used to be read as one sentence per source line: a
# 78-column file with three-line sentences measured three times the sentences at
# a third the length. 42 of 183 corpus files were affected, one of them by a
# factor of two. Blank lines are kept until after the join so that paragraphs
# stay separate; headings are removed first, and markdown leaves blank lines
# around them, so removing a heading does not fuse its neighbours.
prose() {
  sed -E '/^[[:space:]]*#/d; /^[[:space:]]*[-*+•]/d' "$1" \
  | awk '
      /^[[:space:]]*$/ { if (buf != "") print buf; buf = ""; next }
      { if (buf == "") buf = $0; else buf = buf " " $0 }
      END { if (buf != "") print buf }' \
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

printf 'file\twords\tsentences\tlen_mean\tlen_sd\tem_dash\tendash\tsemi_p\tmektedir_p\tdir_p\tmis_p\tp1_p\tp2_p\tve_p\tpart_p\tcalque_p\tforced\ttilde\tpct_wrong\tbold\tbullets\n'

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

for src in "$@"; do
  f="$tmp/body.md"
  body "$src" > "$f"

  # The prose view is written out, not just piped, because one signal is scoped
  # to it. See the semicolon comment below for why that signal and not the
  # others, and for the asymmetry this leaves behind.
  p="$tmp/prose.md"
  prose "$f" > "$p"

  words=$(wc -w < "$p" | tr -d ' ')

  read -r sentences len_mean len_sd < <(
    sed -E 's/([.!?…]+)([[:space:]]|$)/\1\n/g' "$p" \
    | awk '
        { n = split($0, w, " "); c = 0
          for (i = 1; i <= n; i++) if (w[i] ~ /[^[:punct:]]/) c++
          if (c > 0) { s++; t += c; a[s] = c } }
        END { if (s == 0) { print 0, 0, 0; exit }
              m = t / s
              for (i = 1; i <= s; i++) d += (a[i] - m) * (a[i] - m)
              printf "%d %.1f %.1f\n", s, m, sqrt(d / s) }'
  )

  # Only a space-flanked dash with a digit on neither side counts. A dash
  # inside a range is correct Turkish and is not the calqued explanatory dash
  # this signal looks for — whether written tight (04.30–05.00, Nisan–haziran)
  # or spaced (MÖ 738 – MÖ 696, 15 Aralık – 2 Ocak).
  #
  # The trailing [^0-9] was added on 2026-08-17. Without it, a range whose left
  # side ends in a word ("15 Aralık – 2 Ocak") was counted as an explanatory
  # dash, and round five briefly reported a hard-rule violation that was not
  # one. The first version of this exclusion covered only the cases that had
  # been looked at, which is how the previous six counting bugs also happened.
  em_dash=$(count_re '[^0-9] [—–] [^0-9]' "$f")
  # The en dash is not a Turkish mark at all. TDK lists kısa çizgi and uzun
  # çizgi and gives ranges to the short hyphen, so every '–' is a surface error
  # and the raw count is the verdict. Across the nine published texts in
  # human-reference/, ranges use the plain hyphen 70 times and an en dash 3.
  #
  # This signal did not exist until 2026-08-18 because layer-3 had the rule
  # backwards — it called range dashes correct — and em_dash was then built to
  # exclude them, so the instrument was configured to look away from the thing
  # the rule got wrong. A blind judge found it instead.
  endash=$(count_re '–' "$f")
  # Semicolon frequency, the one signal counted on the prose view rather than
  # the whole body. The rule it measures (layer-3 §5) permits the mark for
  # separating grouped list items and objects only to its use as a default
  # connective between independent clauses — so counting list-item semicolons
  # would score an allowed usage against the text, and would do it hardest on
  # the list-heavy corporate register. Numerator and denominator are therefore
  # both prose.
  #
  # This leaves the instrument asymmetric: every other count_re signal reads
  # the body, including headings and list items, while `words` has always been
  # prose-only. A -maktadır inside a bullet is counted but its words are not.
  # Migrating the rest is a separate change, because it moves every per-100
  # figure recorded in RESULTS.md.
  semi=$(count_re ';' "$p")
  # Vowel harmony gives two forms of this suffix and the count needs both.
  # This regex read '(mekte|makta)dır' until 2026-08-17, which matched only the
  # back-vowel -maktadır and silently missed every -mektedir — the form the
  # column is named after, and the more common one after front-vowel stems
  # (görülmektedir, gerekmektedir, edilmektedir). Every mektedir_p figure
  # reported before that date is roughly half the real rate.
  mektedir=$(count_re '(mekte|makta)d[iı]r' "$f")
  dir_copula=$(count_re '[a-zçğıöşü]{2,}(dır|dir|dur|dür|tır|tir|tur|tür)[[:space:]]*[.,;!?]' "$f")
  # Narrative -mIş: the evidential past that marks Turkish storytelling and
  # hearsay, and that LLM Turkish almost never reaches for. Participial uses
  # ("geçmiş", "yapılmış") are counted too — this is a frequency proxy, not a
  # parse, and its job is to show whether the mood is present at all.
  mis_past=$(count_re '[a-zçğıöşü]{2,}(mış|miş|muş|müş)(ım|im|um|üm|sın|sin|sun|sün|ız|iz|uz|üz|sınız|siniz|sunuz|sünüz|lar|ler)?\b' "$f")
  # Address. Voice profiles differ most visibly on who the text speaks as and
  # to, and nothing else here measures that — two profiles can land on identical
  # particle and length numbers while one says "kalıyorum" and the other says
  # "kalırsın". Distinctive verbal endings plus pronouns; possessive -ım/-im is
  # deliberately excluded because it is not an address marker.
  p1=$(count_re '\b(ben|benim|bana|beni|bende|benden)\b|[a-zçğıöşü]{2,}(yorum|dım|dim|dum|düm|tım|tim|tum|tüm|acağım|eceğim|mışım|mişim|muşum|müşüm)\b' "$f")
  p2=$(count_re '\b(sen|senin|sana|seni|sende|senden|siz|sizin|size|sizi|sizde|sizden)\b|[a-zçğıöşü]{2,}(yorsun|yorsunuz|sınız|siniz|sunuz|sünüz|dın|din|dun|dün|tın|tin|tun|tün|dınız|diniz|dunuz|dünüz|tınız|tiniz|tunuz|tünüz|acaksın|eceksin|acaksınız|eceksiniz)\b|[a-zçğıöşü]{2,}(rsın|rsin|rsun|rsün)\b' "$f")
  # Word-bounded, not space-bounded: ' ve ' missed every "ve" that a line break
  # or a sentence start put next to something other than a space, which in a
  # hard-wrapped file is a sizeable share of them.
  ve_raw=$(count_re '\b[Vv]e\b' "$f")
  particles=$(count_words "$signals/particles.txt" "$f")
  calque=$(count_list "$signals/calques.txt" "$f")
  forced=$(count_list "$signals/forced-translations.txt" "$f")
  tilde=$(count_re '~' "$f")
  pct_wrong=$(count_re '[0-9]+%' "$f")
  bold=$(( $(count_re '\*\*' "$f") / 2 ))
  bullets=$(grep -cE '^[[:space:]]*[-*+•] ' "$f" || true)

  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$(basename "$src")" "$words" "$sentences" "$len_mean" "$len_sd" \
    "$em_dash" "$endash" "$(per100 "$semi" "$words")" "$(per100 "$mektedir" "$words")" "$(per100 "$dir_copula" "$words")" \
    "$(per100 "$mis_past" "$words")" "$(per100 "$p1" "$words")" \
    "$(per100 "$p2" "$words")" "$(per100 "$ve_raw" "$words")" \
    "$(per100 "$particles" "$words")" "$(per100 "$calque" "$words")" \
    "$forced" "$tilde" "$pct_wrong" "$bold" "$bullets"
done
