# Rubric

What "better" means for this skill, and how it is checked.

Two parts. Neither is sufficient alone: the countable half catches tics a reader
stops noticing after the third file, and the reading half catches everything that
makes a text worth reading. A version that wins on the numbers and loses on the
reading has not improved anything.

## Part one — countable signals

Produced by `evals/count.sh FILE...`, which reports and does not judge.

Frequency columns are per 100 words. The **power** column records what the
calibration below actually showed, so that a version is not called an
improvement on the strength of a signal that separates nothing.

| Signal | Target | Applies to | Power |
|---|---|---|---|
| `bold` | ≪ the input's; 0–2 for prose | blog, technical, academic | **high** |
| `bullets` | ≤ the input's, and 0 where the content is not a list | blog, corporate | **high** |
| `len_sd` | ≥ 6.0, and higher than the input's | blog, technical, corporate | **high at the low end** |
| `dir_p` | falling vs the input, toward ≤ 1.5 | all but academic | **high in technical/academic** |
| `mis_p` | present where the content narrates | blog only | conditional |
| `ve_p` | falling vs the input | all | low |
| `part_p` | > 0 | blog only | low |
| `em_dash` | 0 | all | low, but still correct when it fires |
| `mektedir_p` | 0 | all but academic | low outside academic |
| `calque_p` | 0 | all | none observed — kept as a guard |
| `forced` | 0 | all — a hit is a hard failure | untested; hard rule regardless |
| `tilde`, `pct_wrong` | 0 | all | low |
| claims added vs input | 0 | repair mode | hard rule |

`len_sd` measures what separates written-by-a-person from generated: a human
writes a three-word sentence next to a thirty-five-word one, and Turkish
agglutination makes the short end shorter than English can manage — `Olmadı.`
is a complete sentence. The threshold is 6.0 because that is the floor of the
three human reference texts, not because it is a round number. Note the
asymmetry: a low `len_sd` reliably indicates machine rhythm, while a high one
does not by itself indicate good writing.

The **claims added** count is not mechanical. It is checked by reading input and
output side by side and listing every number, name, date, or assertion present in
the output and absent from the input. Any hit is a hard failure regardless of how
well the prose reads. A beautiful paragraph that invents a statistic is a worse
outcome than a clumsy one that does not.

### What this half deliberately cannot see

`count.sh` omits every signal that needs Turkish morphology to measure: participle
density (the branching proxy), inversion rate, focus placement, and the aorist /
`-yor` distinction. `grep` cannot separate "zaman" from an `-an` participle, and a
number that is wrong a third of the time is worse than no number, because it gets
quoted. Those live in part two.

## Part two — reading questions

Answered by a person, or by a judge that has not been told what produced the text.

**1. Did the first sentence pull me in, or did it announce the topic?**
The most reliable single tell in Turkish LLM writing is an opening that states
what the piece is about instead of starting it. No count catches this, because the
sentence is grammatical, idiomatic, and empty.

**2. Would I believe a human wrote this?**
Deliberately unfalsifiable and deliberately first among equals. Every other
question exists to explain an answer to this one.

**3. Does the writer hold an opinion, or only report?**
Turkish blog and essay writing carries a position, often signalled by particles
and inversion rather than by an explicit claim. Text can pass every count and
still have nobody behind it.

**4. Which single sentence smells most like a template, and why?**
Forces a specific answer. "It feels AI-ish" is not usable feedback; "the third
sentence uses the same three-part list rhythm as the first" tells you what to fix.

**5. If I read only the last paragraph, does it earn its place or restate the piece?**
The summary-closing is the composition-layer tell that survives the longest,
because it looks like good structure.

## Calibration

`count.sh` is checked against real human Turkish before its output is trusted
anywhere. The check is falsifiable: if the instrument reports that published
Turkish blog writing looks machine-generated, the instrument is wrong and gets
fixed before any comparison is run on it.

## Calibration results

Run on 2026-08-17 against `evals/human-reference/` and `evals/input/`.

```
file                       words  sentences  len_mean  len_sd  em_dash  mektedir_p  dir_p  mis_p  ve_p  part_p  calque_p  forced  tilde  pct_wrong  bold  bullets
bizevdeyokuz-acilislar.md  151    14         10.8      8.0     1        0.0         0.0    0.0    2.0   0.0     0.0       0       0      0          0     0
midas-akademi-fk-orani.md  286    26         10.9      7.0     1        0.0         0.7    0.0    2.1   1.4     0.0       0       0      0          1     0
midas-kral-midas.md        184    19         9.7       6.3     1        0.0         1.1    2.7    2.7   0.5     0.0       0       0      0          0     0
```

The instrument did not fail the way the plan expected it to fail. It failed a
different way, and the result is worth more than a pass would have been.

**The folklore tells are largely gone.** The plan predicted the twelve LLM
baselines would show elevated `em_dash`, `mektedir_p` and `calque_p` against
the human references. They do not. Em dashes appear in four baselines and in
*all three* human excerpts. `mektedir` appears only in the two academic
baselines, where it belongs. `calque_p` is 0.0 in eleven of twelve baselines
and 0.0 in every human text — the entire calque list scores nothing on either
side. Discourse particles do not separate the two groups either.

This is the single most useful thing the calibration produced. The five
phenotypes that `turkce-humanizer` hunts — punctuation inflation, `-mektedir`
inflation, template repetition, the "sadece X değil aynı zamanda Y" calque,
hollow closings — are mostly absent from this model's Turkish before any
intervention. A skill built to remove them would be fighting the previous war
and would measure as a success while changing nothing a reader cares about.

**What does separate the two groups:**

- **Bold and bullet inflation, by a wide margin.** `corporate-1` carries 20
  bold spans and 5 bullet lines, `blog-1` 16 and 4. The human texts carry 0–1
  bold and no bullets at all. This is a composition-layer tell, and it is the
  clearest signal in the table.
- **Sentence-length variance.** All three human texts sit at `len_sd` 6.3–8.0.
  The baselines cluster lower, with `corporate-1` at 3.0 and `blog-3` at 3.9.
  The overlap is real — `academic-3` reaches 10.6 — so this is evidence, not
  proof, and it is strongest at the low end: a `len_sd` under 4.5 is a reliable
  sign of machine rhythm.
- **`-DIr` density in technical and academic prose.** `technical-2` 7.7,
  `academic-2` 4.5, `technical-1` 3.7, against 0.0–1.1 in the human texts.
- **Narrative `-mIş`, where the content is narrative.** The Midas folk-history
  excerpt scores 2.7; every baseline is at or below 1.5. The other two human
  texts score 0.0, because they are not narrating — so this signal is
  register-conditional and must be read as such, never as a target to hit.

**What this changes.** The surface layer keeps its rules, because a rule that
fires rarely is still right when it fires: `blog-1` really does have four em
dashes. But surface work is no longer where the value is, and no version of
this skill should be called an improvement on the strength of surface counts
alone. The composition and sentence layers carry the weight, and the reading
questions carry the verdict.

**A caveat on the calque list.** It scored zero on every text in both groups,
so nothing in this corpus validates it. It stays in the repository as a guard
against phrases that would be wrong if they appeared, not as a diagnostic that
has been shown to detect anything.
