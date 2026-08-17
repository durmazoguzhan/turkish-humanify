#!/usr/bin/env bash
# Builds blind pairs for judging, per evals/repair-protocol.md §3.
#
# Usage: evals/pair.sh ARM_ONE_DIR ARM_TWO_DIR OUT_DIR
#
# For every file present in both arms, writes OUT_DIR/<name>/A.md and B.md with
# the order chosen by shuf, and records which is which in OUT_DIR/key.tsv. The
# judge is given the pair directory and never the key.
#
# Front matter is stripped so that source attribution cannot leak the arm.
set -euo pipefail

one="${1:?arm one directory}"
two="${2:?arm two directory}"
out="${3:?output directory}"

mkdir -p "$out"
key="$out/key.tsv"
: > "$key"
printf 'item\tA\tB\n' >> "$key"

strip() { awk 'NR==1 && $0=="---" { fm=1; next } fm && $0=="---" { fm=0; next } !fm' "$1"; }

n=0
for f in "$one"/*.md; do
  name=$(basename "$f")
  [ -f "$two/$name" ] || { printf 'skip %s: missing in %s\n' "$name" "$two" >&2; continue; }

  d="$out/${name%.md}"
  mkdir -p "$d"

  # shuf decides which arm gets the A slot.
  if [ "$(printf '%s\n%s\n' one two | shuf -n1)" = "one" ]; then
    strip "$f"          > "$d/A.md"; strip "$two/$name" > "$d/B.md"
    printf '%s\t%s\t%s\n' "${name%.md}" "$one" "$two" >> "$key"
  else
    strip "$two/$name"  > "$d/A.md"; strip "$f"         > "$d/B.md"
    printf '%s\t%s\t%s\n' "${name%.md}" "$two" "$one" >> "$key"
  fi
  n=$((n + 1))
done

printf 'built %d pairs in %s\nkey: %s\n' "$n" "$out" "$key"
