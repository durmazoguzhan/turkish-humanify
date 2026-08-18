# Repair-mode evaluation protocol

Written down because it was not. Rounds one through four describe the procedure
in prose — *"clean-context subagents given the same English wrapper instruction
and one input file each"* — but the wrapper itself was never committed, so no
round could be reproduced exactly and no two rounds could be shown to have used
the same one. From round five on, this file is the wrapper.

Anything that changes here is a change to the instrument, and gets recorded in
`RESULTS.md` the same way a change to `count.sh` does.

---

## 1. Generation

One clean-context subagent per input file. No shared context between them, and
none of them is told that an evaluation is running, that a comparison exists, or
that another skill is involved.

**Wrapper, verbatim:**

> Read `skills/turkish-humanify/SKILL.md` in this repository and follow it.
> Apply it to the Turkish text in `evals/input/<FILE>`.
> Write the result to `evals/output/<ARM>/<FILE>`.
> Output only the resulting text. No preamble, no explanation of what you
> changed, no summary, no word count.

The `<FILE>` is substituted; nothing else varies between subagents. The wrapper
is in English because `experiments/prose-language/RESULT.md` settled that
question, and because it matches how the skill is actually invoked.

## 2. The competitor arm is not regenerated

`evals/output/turkce-humanizer-text/` is on disk and stays byte-identical
between rounds. Regenerating both arms in the same round is what made round two
uninterpretable. One variable moves per round, and it is ours.

The two adjustments that made the original comparison fair still hold and are
not repeated per round: only the section under *"Onarılmış Versiyon"* is
compared, because that skill's contract is report-then-text; and it was told to
pick the register itself rather than ask, because a batch run has no user. Both
are recorded at the top of `RESULTS.md`.

## 3. Blind pairwise judging

`evals/pair.sh ARM_ONE ARM_TWO OUT_DIR` builds the pairs. For each input the two
outputs are written to `OUT_DIR/<item>/A.md` and `B.md` with **the order decided
by `shuf`**, and the key goes to `OUT_DIR/key.tsv`, which the judge is never
given. Front matter is stripped so source attribution cannot leak the arm.

The script exists because the randomisation was previously done by hand, which
is both unrepeatable and the one step where a mistake would silently invalidate
the whole round.

**Three** clean-context judge subagents per item, each told nothing about
skills, tools, models or the existence of this project, and each unaware of the
others. The item goes to whichever text two of the three chose.

This changed after round six, which accidentally measured the noise floor. Two
of the thirteen files that round's skill changes **could not have touched**
flipped their verdict anyway — roughly 3.2 files per twenty-one from
regeneration and judging alone. Position bias was checked first and ruled out:
across forty-two single-judge verdicts, A was chosen 24 times and B 18,
two-sided p = 0.44.

With one judge per item, a fifteen percent per-item error rate puts three files
of movement inside noise, which is the size of every register-level effect this
project has measured. Majority of three cuts that to roughly six percent — about
1.3 files — and it also *measures* the judge-variance share for free: the count
of 2–1 splits is the disagreement rate, and it goes in the round's report.

Rounds up to and including six used one judge. **Their tallies are not
comparable to later ones** and no round should be read as beating an earlier one
across that boundary.

**Judge prompt, verbatim:**

> Aşağıda aynı konuda iki Türkçe metin var. Hangisi bir Türk tarafından
> yazılmış gibi okunuyor? Tek bir metin seç ve neden seçtiğini yaz. Seçimini
> gerekçelendirirken metinden birebir cümleler alıntıla.

The judge is asked which reads as written by a Turkish person, not which is
better, and not which is more human-*like* — the second phrasing is what
`voices.md` records as winnable by fabrication.

## 4. Fidelity, which outranks the ranking

Independently of the judging, every output of ours is checked against its input
by a subagent asked to list every number, name, date, claim or experience
assertion present in the output and absent from the source.

**Pre-registered from round one and unchanged:** a text that reads beautifully
and invents a fact has failed, and failing this check outranks winning the blind
ranking. This is not a tiebreaker. It is the first thing read.

## 5. The countable target is the evidence, when there is one

The blind tally is the noisiest instrument in this repository and it is not the
right one for most changes. A fix with a countable target — a suffix rate, a
punctuation rate, a bullet count — is tested by measuring that target, which
needs generations and **zero judges**, and which resolves effects far smaller
than three files.

So each round states, before running:

- the **countable prediction**, with the published Turkish figure it is aiming
  at and the value that would count as over-correction; and
- the tally as a **secondary** check, with the standing rule that movement of
  three files or fewer is noise and is not to be argued from.

The temptation this guards against is real and this file exists partly because
of it: six rounds were read as a sequence of improvements — 15–6, 16–5, 16–5 —
that are statistically indistinguishable from each other.

## 6. What gets reported

The countable prediction against its outcome. Then the tally, by register and
overall, with a two-sided sign test and the count of 2–1 judge splits. Then the
discounts, before any conclusion. Then what still loses and why, quoting the
judge rather than paraphrasing.

A round that produces no improvement is reported as a round that produced no
improvement.
