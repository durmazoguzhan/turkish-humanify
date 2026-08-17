# Rubric

What "better" means for this skill, and how it is checked.

Two parts. Neither is sufficient alone: the countable half catches tics a reader
stops noticing after the third file, and the reading half catches everything that
makes a text worth reading. A version that wins on the numbers and loses on the
reading has not improved anything.

## Part one — countable signals

Produced by `evals/count.sh FILE...`, which reports and does not judge.

| Signal | Target | Applies to |
|---|---|---|
| `em_dash` | 0 | all registers |
| `mektedir` | 0 | all but academic |
| `dir_copula` | falling vs the input | all but academic |
| `len_sd` | ≥ 4.0, and higher than the input's | blog, technical, corporate |
| `ve_per100` | falling vs the input | all |
| `particles` | > 0 | blog only |
| `calque` | 0 | all |
| `forced` | 0 | all — a hit is a hard failure |
| `tilde`, `pct_wrong` | 0 | all |
| `bullets` | ≤ the input's | blog, corporate |
| claims added vs input | 0 | repair mode |

`len_sd` is the single most useful number here. Sentence-length variance is what
separates written-by-a-person from generated: a human writes a three-word sentence
next to a thirty-five-word one, and Turkish agglutination makes the short end
shorter than English can manage — `Olmadı.` is a complete sentence. A text whose
sentences all land between eighteen and twenty-five words is machine-shaped no
matter how clean its vocabulary is.

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
fixed before any comparison is run on it. Results live in
`## Calibration results` below, filled in by the corpus task.
