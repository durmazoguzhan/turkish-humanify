# Repair-mode evaluation protocol

Written down because it was not. Rounds one through four describe the procedure
in prose — *"clean-context subagents given the same English wrapper instruction
and one input file each"* — but the wrapper itself was never committed, so no
round could be reproduced exactly and no two rounds could be shown to have used
the same one. From round five on, this file is the wrapper.

Anything that changes here is a change to the instrument, and gets recorded in
`RESULTS.md` the same way a change to `count.sh` does.

---

## 0. What a round runs on

**Seven files, generated twice each. Not twenty-one generated once.**

This changed on 2026-09-04 and it is a correction, not an economy. Round eight
established the bar a finding has to clear: a site counts when it appears in
**two of *n* generations of the same input**, because two runs under
byte-identical conditions were observed to disagree, one clean and one not. A
round of twenty-one files generated once **cannot satisfy that bar at all** — it
has no second generation of anything, so every result it produces is a lead by
construction. Twenty-one generations were being spent to buy answers the bar
then rejected.

Fourteen generations is fewer than twenty-one and every one of them is
bar-eligible. That is the whole argument.

### The standing sample

| file | why it is in |
|---|---|
| `blog-1` | has lost five times to the same three invented sentences; the standing fabrication control |
| `technical-4` | fidelity rule 4's site, the most-generated file in the repository |
| `corporate-4` | list-heavy marketing, the register whose list rule was measured off |
| `academic-3` | hedges, `-mAktAdIr`, the evidential band |
| `reference-2` | tables and code fences, the lowest `prose_pct` in the corpus |
| `reference-3` | bullets and label bold |
| `reference-5` | the five-line fragment shape from issue #9 |

Four registers and three document shapes. The rest of the corpus is **reserve**,
not retired.

### The overfitting guard, because seven files is few

Running the same seven every round fits rules to those seven. So: **a change that
clears the sample gets one confirmation generation on three reserve files before
it ships**, chosen to be unlike the sample files it was tested on. Three
generations is cheap and it is the difference between "works" and "works here".

### When the full corpus still runs

A **tally** round — the blind pairwise ranking — needs the whole corpus and says
so. At seven files a sign test needs 7–0 to reach p=0.016 and 6–1 is p=0.125, so
the sample cannot rank anything; the measured noise floor alone moves about one
file in seven. §5 already says the tally is the wrong instrument for most
changes. Now it is also the only thing the default round cannot do, which is the
right way round.

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

The third judge is consulted **only where the first two disagree.** This is not
a shortcut with a cost: once two judges have chosen the same text, a third vote
cannot change the majority, so sequential and simultaneous majority-of-three
produce identical verdicts on every item. What it gives up is the census — the
2–1 count becomes a lower bound, because an item where judges one and two agreed
might still have drawn a dissenting third. The disagreement figure reported is
therefore the **pairwise** rate between judges one and two, which is the
better-behaved statistic anyway: it is a direct observation rather than a
majority-vote residue.

This changed after round six, which accidentally measured the noise floor. Two
of the thirteen files that round's skill changes **could not have touched**
flipped their verdict anyway — roughly 3.2 files per twenty-one from
regeneration and judging alone. Position bias was checked first and ruled out:
across forty-two single-judge verdicts, A was chosen 24 times and B 18,
two-sided p = 0.44.

**The per-judge error rate is now measured, not assumed.** Round seven ran the
first two judges on all twenty-one items and they disagreed on **four — 19
percent pairwise.** If an item has a right answer and judges err independently,
a pairwise disagreement rate `d` implies a per-judge minority rate
`p = (1 − √(1 − 2d)) / 2`, so:

| | error rate | files of 21 |
|---|---|---|
| one judge | **10.7%** | 2.2 |
| majority of three | **3.2%** | 0.7 |

Both are better than the fifteen and six percent this section assumed before the
measurement, so the case for three judges is slightly weaker than it was argued
and the noise floor slightly lower. Neither figure rescues a one-file move.

Two cautions on that arithmetic. It assumes every item *has* a right answer: an
item where the two texts are genuinely indistinguishable produces disagreement
without either judge being wrong, and inflates `p` with something that is not
error. And it assumes independence, which judges drawn from one model family
plainly violate in the direction that makes agreement cheap — so 10.7% is a
floor on single-judge error, not an estimate of it.

The 2–1 count still goes in each round's report, because it is the only
judge-variance number the round produces at no extra cost.

Rounds up to and including six used one judge. **Their tallies are not
comparable to later ones** and no round should be read as beating an earlier one
across that boundary.

**Voting-judge prompt, verbatim:**

> Aşağıda aynı konuda iki Türkçe metin var. Hangisi bir Türk tarafından
> yazılmış gibi okunuyor?
>
> Cevabın SADECE iki satır olsun:
> SEÇİM: A   (veya B)
> Gerekçe: \<tek cümle\>
>
> Başka hiçbir şey yazma.

The judge is asked which reads as written by a Turkish person, not which is
better, and not which is more human-*like* — the second phrasing is what
`voices.md` records as winnable by fabrication.

**All three voting judges get this prompt and no other.** Rounds one to six used
a longer form that asked the judge to justify the choice with verbatim
quotations, and round seven used the long form for its first judge and this one
for the other two. That is an instrument inconsistency, recorded rather than
hidden: demanding quoted evidence changes what a reader attends to, so it can
change the vote, and votes from two different prompts should not be pooled. The
terse form is the one kept because the tally only needs the vote.

**Quotes come from a diagnostic judge, outside the tally.** The report has to say
what still loses and why, in the judge's words, which the terse prompt does not
produce. So each losing item gets one further clean-context judge on the long
prompt:

> Aşağıda aynı konuda iki Türkçe metin var. Hangisi bir Türk tarafından
> yazılmış gibi okunuyor? Tek bir metin seç ve neden seçtiğini yaz. Seçimini
> gerekçelendirirken metinden birebir cümleler alıntıla.
>
> Seçmediğin metinde Türkçe olmayan, çeviri kokan veya makine izi taşıyan ne
> varsa tek tek göster ve her biri için metinden alıntı ver.

**Its vote is not counted.** It is run only on items the majority has already
decided, where a fourth opinion cannot move the verdict, and it is run only on
losses — which is a biased selection and would corrupt a tally, and is harmless
for diagnosis. Anything it says is a hypothesis to be counted, not a finding:
round seven's diagnostic rationale for `blog-4` named the passive voice, and
measurement found the same two passive predicates in both texts.

## 4. Fidelity, which outranks the ranking

Independently of the judging, every output of ours is checked against its input
by a subagent asked to list every number, name, date, claim or experience
assertion present in the output and absent from the source.

**The check has widened twice, and rounds either side of a widening are not
comparable.** Rounds one to six asked only the question above. Round seven added
*strengthening*: a hedge deleted, a plain adjective made superlative, a body's
qualified claim stated flatly in a title — material that is in the source but
said harder. Round eight's third probe added *relations*: two source statements
joined by a connective that asserts a link the source did not. Each widening
found something the previous phrasing could not have, so **a rise in the count
across a widening is not evidence of a worse text**, and the round it appears in
has to say which.

**Pre-registered from round one and unchanged:** a text that reads beautifully
and invents a fact has failed, and failing this check outranks winning the blind
ranking. This is not a tiebreaker. It is the first thing read.

### This check has a noise floor too, and it is now measured

Round eight set a bar of zero findings and hit one, twice, then went looking for
whether "one" meant anything. `evals/input/technical-4.md` was generated five
times across two skill states:

| skill state | generations | findings |
|---|---|---|
| before the title rule | 3 | **1** |
| after the title rule | 2 | **2** |

Two conclusions, and they pull in opposite directions.

**The site is real.** Three of five generations produced the same addition — two
unconnected source paragraphs joined by `çünkü` — which is far too often to be an
accident and is why `rewrite-mode.md` gained fidelity rule 4. Nothing else
appeared in any of the five.

**And a single generation cannot be trusted to reveal it.** Two runs under
byte-identical conditions disagreed: one clean, one not. So **a count of zero on
one generation is not evidence of zero**, and the round-eight bar as written was
unmeasurable. What is measurable is a rate.

**The bar is therefore a rate, not a count.** A site that appears in *k* of *n*
generations of the same input is a defect worth a rule when *k ≥ 2*; a single
appearance across a single generation of each file is a lead to be re-run, not a
finding to write a rule against. Five files generated once each — the shape of
every round up to eight — resolves "four findings" from "one" and does not
resolve "one" from "zero".

**When the check is asked about deletions, it has to be told what is
prescribed.** Testing a fidelity rule for over-correction means asking whether
the output dropped a relation the source stated — and that question, asked plain,
reports every discourse marker the skill removes on purpose. Round eight's probe
four flagged a deleted `Kısacası` in both runs as a lost relation; it is deleted
in eight generations of eight, and `layer-1-structure.md` §3 names that marker
family and requires its removal. Ask the question, and give it the list of
prescribed deletions, or the answer is a list of the rules working.

**Why this is different from the tally's floor.** The tally flips whole verdicts
on files the skill did not touch, so its noise is unattributable. Fidelity noise
is attributable: the finding either is or is not in the text, quotably, and a
re-run tells you which. It costs one generation to resolve instead of three
judges, which is the cheaper instrument and the reason §5 prefers countable
targets in the first place.

## 5. The countable target is the evidence, when there is one

The blind tally is the noisiest instrument in this repository and it is not the
right one for most changes. A fix with a countable target — a suffix rate, a
punctuation rate, a bullet count — is tested by measuring that target, which
needs generations and **zero judges**, and which resolves effects far smaller
than three files.

**And a countable target has a failure mode of its own, which is not noise.** A
count reports that something moved; whether moving it was right is a separate
question and the number does not answer it. Round nine cleared a pre-registered
bar on `bold` and the conclusion was still false, because three of the four
movements it counted were the rule under test behaving correctly. Any signal that
can legitimately move in either direction — bold, bullets, rows, headings,
sentence length, hedge counts — needs the individual instances read before the
rate means anything. `CONTRIBUTING.md` carries the episode.

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
