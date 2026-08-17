#!/usr/bin/env bash
# Asserts count.sh against a fixture whose counts were verified by hand.
# If a number disagrees, work out by hand which side is wrong before changing
# either — the fixture exists so that a silently broken counter cannot pass.
#
# Frequency signals are per 100 words; the fixture has 38 words, so one raw
# hit is 2.6 and two are 5.3.
#
# The fixture carries both vowel-harmony forms of -mektedir on purpose
# (artmaktadır, edilmektedir). It used to carry only the back-vowel one, which
# is why a counter blind to -mektedir passed this test for four rounds.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

expected="words=38 sentences=6 len_mean=6.3 len_sd=3.2 em_dash=1 mektedir_p=5.3 dir_p=7.9 mis_p=0.0 p1_p=0.0 p2_p=0.0 ve_p=2.6 part_p=2.6 calque_p=5.3 forced=0 tilde=0 pct_wrong=0 bold=0 bullets=2"

row=$(./count.sh fixtures/known.md | tail -n 1)
read -r _file words sentences len_mean len_sd em_dash mektedir_p dir_p mis_p p1_p p2_p \
        ve_p part_p calque_p forced tilde pct_wrong bold bullets <<<"$row"

actual="words=$words sentences=$sentences len_mean=$len_mean len_sd=$len_sd em_dash=$em_dash mektedir_p=$mektedir_p dir_p=$dir_p mis_p=$mis_p p1_p=$p1_p p2_p=$p2_p ve_p=$ve_p part_p=$part_p calque_p=$calque_p forced=$forced tilde=$tilde pct_wrong=$pct_wrong bold=$bold bullets=$bullets"

if [ "$actual" = "$expected" ]; then
  echo "ok   count.sh matches the hand-verified fixture"
else
  echo "FAIL count.sh disagrees with the fixture"
  echo "  expected: $expected"
  echo "  actual:   $actual"
  exit 1
fi
