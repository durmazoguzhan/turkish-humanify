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

Frequency columns are per 100 words. The **power** column records what the
calibration below actually showed, so that a version is not called an
improvement on the strength of a signal that separates nothing.

| Signal | Target | Applies to | Power |
|---|---|---|---|
| `em_dash` | 0 | all | **separates** — 3 of 12 baselines, 0 of 3 human texts |
| `dir_p` | falling vs the input, toward ≤ 1.5 | all but academic | **separates in technical/academic** — up to 7.7 vs 0.0–1.3 |
| `bold` | ≪ the input's; 0–2 for prose | blog, technical, academic | **separates where present** — up to 20 vs 0–1 |
| `bullets` | ≤ the input's, and 0 where the content is not a list | blog, corporate | **separates where present** — up to 5 vs 0 |
| `mis_p` | present where the content narrates | blog only | conditional — 3.2 in the one narrative human text, ≤1.5 in every baseline |
| `p1_p` / `p2_p` | matches the chosen voice profile | all | **separates voices** — the same input written as `denemeci` scores p1 2.6 / p2 0.9, as `senli-benli anlatıcı` 0.0 / 3.2 |
| `len_sd` | higher than the input's | blog, technical, corporate | **none** — both groups average about 5.6 |
| `ve_p` | falling vs the input | all | none |
| `part_p` | > 0 | blog only | none |
| `mektedir_p` | 0 outside academic; **0.4–2.3 in academic** | all | none outside academic; **two-sided inside it** — see below |
| `calque_p` | 0 | all | none observed — kept as a guard |
| `forced` | 0 | all — a hit is a hard failure | untested; hard rule regardless |
| `tilde`, `pct_wrong` | 0 | all | untested; both zero everywhere so far |
| claims added vs input | 0 | repair mode | hard rule |

**`mektedir_p` is the one two-sided target here, and the only one calibrated
against dated published text.** Five Turkish journal articles from 2015–2019 in
`evals/human-reference/` put the academic band at 0.4–2.3 per 100 words over full
article bodies. Both ends have been failed in practice: unaided output writes
academic prose at 0.0, and an earlier version of the skill wrote it at 2.9–4.5.
Aiming at 0 in academic register is therefore wrong, and so is maximising.
`RESULTS-write.md`, "Round three", has the per-article figures — and the note
that this column was blind to the front-vowel `-mektedir` until 2026-08-17, so
any figure quoted before then is about half the real rate.

A signal with no power is not thereby wrong. `len_sd` still measures something
real — a human writes a three-word sentence next to a thirty-five-word one, and
Turkish agglutination makes the short end shorter than English manages, since
`Olmadı.` is a complete sentence. What the calibration shows is only that this
model's Turkish is already about as varied as published Turkish on this
measure, so the number cannot be used as evidence of improvement. Report it,
do not argue from it.

The **claims added** count is not mechanical. It is checked by reading input and
output side by side and listing every number, name, date, or assertion present in
the output and absent from the input. Any hit is a hard failure regardless of how
well the prose reads. A beautiful paragraph that invents a statistic is a worse
outcome than a clumsy one that does not.

### A third instrument failure, found the same way

The voice profiles were checked by writing one input twice, as `denemeci` and
as `senli-benli anlatıcı`, and comparing. On every column the counter then had,
the two outputs were indistinguishable: identical particle density, sentence
counts within one, `len_sd` 4.6 against 4.3. Read side by side they are
obviously different texts — one says *"istiyorsam kalıyorum"* and *"Meğer ben
de yapıyormuşum bunu"*, the other says *"istiyorsan kalırsın"* and *"seçersin,
olur biter"*.

They differ on **address**, the first of the nine voice dimensions, and nothing
in the counter measured it. `p1_p` and `p2_p` were added for exactly this, and
the same comparison now reads p1 2.6 / p2 0.9 against p1 0.0 / p2 3.2.

Worth stating plainly, because it is the third time in this project: a
disagreement between the numbers and the reading has meant the numbers were
incomplete every time so far, never the reading.

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
bizevdeyokuz-acilislar.md  111    6          18.5      5.1     0        0.0         0.0    0.0    2.7   0.0     0.0       0       0      0          0     0
midas-akademi-fk-orani.md  244    18         13.4      6.6     0        0.0         0.8    0.0    2.5   1.6     0.0       0       0      0          1     0
midas-kral-midas.md        157    12         13.1      5.2     0        0.0         1.3    3.2    3.2   0.6     0.0       0       0      0          0     0
```

### First: what the calibration caught in the instrument

Three measurement bugs, all of which had produced confident wrong readings
before they were found. They are recorded because each one had already been
reported as a finding.

1. **Range dashes counted as explanatory dashes.** `04.30–05.00`,
   `Nisan–haziran`, `MÖ 738 – MÖ 696` are correct Turkish. Counting them made
   `em_dash` look like a dead signal — it is not.
2. **YAML front matter counted as prose.** The human-reference files carry
   source attribution up top, and the counter was measuring our own annotation
   notes. This inflated their `len_sd` from roughly 5.6 to roughly 7.1 and
   manufactured a difference that does not exist.
3. **`baseline-prompts.md` counted as a baseline** because it sat inside
   `input/`. It has been moved up one level.

The general lesson is worth more than the three fixes: a signal that has never
been checked against a text whose true value is known by hand is not evidence,
it is a number.

### Later: three more, found the same way

Numbered on from the three above. Each was found by checking what a regex
actually matches before trusting a comparison built on it, which is now the
habit this section exists to enforce.

4. **`mektedir_p` was blind to `-mektedir`.** The regex read
   `(mekte|makta)dır`, which vowel harmony makes half a signal: it catches the
   back-vowel `-maktadır` and misses every front-vowel `-mektedir`, the form the
   column is named after and the common one after stems like `görül-`,
   `gerek-`, `edil-`. 52 of 183 files change; every figure published before
   2026-08-17 is about half the real rate. See `RESULTS-write.md`, "Round three".
5. **Sentence statistics were line-bound.** Splitting ran per source line, so a
   hard-wrapped paragraph counted one sentence per line: `w-acad-2` measured 45
   sentences of 7.5 words where it has 19 of 17.8. 42 of 183 files affected, the
   worst by a factor of two. `prose()` now joins each paragraph onto one line
   first.
6. **`ve_p` was space-bound.** ` ve ` requires a space on both sides, so every
   `ve` that a line break or a sentence start put next to something else went
   uncounted. Now `\b[Vv]e\b`; 16 files change.

Bugs 5 and 6 share a root — signals written as if every paragraph were one line
— and neither moves a conclusion. The `len_sd` verdict below survives the fix
exactly: unaided baselines 5.6, published non-academic Turkish 5.6. The
prose-language experiment's two arms stay indistinguishable, mean `len_sd` gap
0.12.

What the fix does surface is a gap nobody had looked for. In **academic**
register the same measure reads 9.8 for the five published articles against 7.2
for this skill's output and 6.9 unaided. The ranges overlap heavily (published
6.3–13.4, ours 6.6–7.8) and n is 5 against 3, so this is a hypothesis, not a
finding: published academic Turkish may vary its sentence length considerably
more than either the model or this skill does, and nothing has tested it.

### Then: what the corrected numbers show

**Some folklore tells survive; the headline ones do not.** `mektedir_p` fires
only in the two academic baselines, where it belongs. (Still true after the
corpus grew to 21 and the counter was fixed: 4 of the 5 academic baselines fire,
none of the 16 others do. What changed is the size of the numbers, not which
files carry them.) `calque_p` is 0.0 across
all fifteen texts — the entire eighteen-phrase list scores nothing on either
side. Discourse particles do not separate the groups. `ve_p` does not either.

The five phenotypes that `turkce-humanizer` hunts — punctuation inflation,
`-mektedir` inflation, template repetition, the "sadece X değil aynı zamanda Y"
calque, hollow closings — are, apart from punctuation, largely absent from this
model's Turkish before any intervention. A skill built to remove them would
measure as a success while changing nothing a reader cares about.

**What does separate the two groups:**

- **The explanatory dash.** Once range dashes are excluded, three baselines
  carry it (5, 5, 4 occurrences) and no human text carries any.
- **`-DIr` density in technical and academic prose.** `technical-2` 7.7,
  `academic-2` 4.5, `technical-1` 3.7, `academic-3` 3.4, against 0.0–1.3 in the
  human texts.
- **Bold and bullet inflation, where it appears.** `corporate-1` carries 20
  bold spans and 5 bullet lines, `blog-1` 16 and 4, against 0–1 bold and no
  bullets in the human texts. Six of twelve baselines are clean here, so this
  is a strong signal with partial coverage rather than a universal one.
- **Narrative `-mIş`, where the content narrates.** The folk-history excerpt
  scores 3.2; every baseline is at or below 1.5. The other two human texts
  score 0.0 because they are not narrating, so this is register-conditional and
  must never be treated as a number to hit.

**What does not separate them, against expectation:** sentence-length variance.
Both groups average about 5.6. This was reported as the strongest signal before
the front-matter bug was found, and it is not a signal at all on this evidence.

### The limits of this calibration

The human reference set is three excerpts, one of them 111 words. That is
enough to **falsify** — had the instrument called published Turkish
machine-written, the instrument would be wrong and we would know it — but
nowhere near enough to **establish** thresholds. No number in the table above
should be turned into a pass mark. Read the power column as "this separated
three human texts from twelve machine texts on one afternoon", not as a norm.

**A caveat on the calque list.** It scored zero on every text in both groups,
so nothing here validates it. It stays as a guard against phrases that would be
wrong if they appeared, not as a diagnostic shown to detect anything.
