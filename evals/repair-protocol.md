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

One clean-context judge subagent per item, told nothing about skills, tools,
models or the existence of this project.

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

## 5. What gets reported

The tally, by register and overall, with a two-sided sign test. Then the
discounts, before any conclusion. Then what still loses and why, quoting the
judge rather than paraphrasing.

A round that produces no improvement is reported as a round that produced no
improvement.
