# turkish-humanify

A Claude skill for Turkish that reads as if a person wrote it.

## What it does

LLM Turkish is grammatical and empty. The words are Turkish; the architecture
underneath them is English — modifiers trailing behind their heads instead of
standing in front of them, emphasis placed where English would place it, `ve`
where a converb belongs, and every sentence landing in the same
eighteen-to-twenty-five-word band.

This skill fixes the architecture, in three layers:

- **Composition** — the opening move, paragraph rhythm, the closing, titles,
  and the bold-and-bullet furniture that machine text wears.
- **Sentence** — the fourteen places Turkish and English genuinely diverge:
  branching direction, the converb system (`ulaç`), focus position,
  evidentiality (`-mIş`), aorist against `-yor`, `-DIr` inflation, `devrik
  cümle`, discourse particles, pro-drop, noun-compound chains, `ki` clauses,
  length variance, passive bleed.
- **Surface** — terminology, orthography, punctuation, numbers.

It writes as well as repairs. In write mode the composition decisions are made
in Turkish before the first sentence, because a piece drafted in English shape
and cleaned afterwards keeps its English skeleton.

Four registers — blog, technical, corporate, academic — decide how hard each
layer presses. Five voice profiles decide who is speaking.

**Technical terms are not force-translated.** A term with no true Turkish
equivalent stays as it is: `endpoint` does not become "uç nokta",
`event-driven` does not become "olay güdümlü". Where a Turkish word genuinely
exists and Turkish engineers actually say it, that word is used. And a kept
English term still inflects from its **pronunciation**, not its spelling —
`cache'i`, `SQL'i`, `JSON'ı`, `queue'yu`.

**It never adds anything.** No number, name, date or claim that is not in the
source. Measured: zero additions across the twelve-text evaluation corpus.

## Install

**Claude Code plugin**

```
/plugin install turkish-humanify@durmazoguzhan
```

**Skills CLI**

```
npx skills add durmazoguzhan/turkish-humanify --skill turkish-humanify
```

**Manual**

```
cp -r skills/turkish-humanify ~/.claude/skills/
```

## How it works

`skills/turkish-humanify/SKILL.md` is a thin router: pick a mode, identify the
register, pick a voice, run the layers, check, emit. Everything else lives in
six reference files that are read at the moment they are used, because worked
before/after pairs are the instruction and a remembered summary of them is not.

Default output is the text and nothing else — no preamble, no report. It
explains what it changed only when asked.

## Evidence

Every claim above is checkable in this repository. `evals/` holds twenty-one
baseline texts of unaided model Turkish, produced by clean-context subagents
given ordinary short prompts, plus excerpts of published Turkish writing for
calibration — including five Turkish journal articles published between 2015 and
2019, early enough that none of them can be model output. `evals/count.sh`
measures what can be measured; `evals/rubric.md` says what it cannot, and lists
the six counting bugs found so far, each of which had already produced a
confident wrong finding.

**Repair mode.** `evals/RESULTS.md` records a three-way comparison against
[`turkce-humanizer`](https://github.com/bushrabeg/turkce-humanizer). Read it
before believing anything here. The short version:

- Against unaided model Turkish, both skills win clearly. Raw output never took
  first place in twelve blind rankings and came last nine times.
- Against `turkce-humanizer` on reading quality: **15–6 across twenty-one files**,
  p=0.039. Discounted in that file rather than claimed, because the same twelve
  files that once scored 6–6 now score 7–5, so almost all of the signal comes
  from the nine files added in the same round.
- On fidelity it is not close: zero added claims here across twenty-one files
  against twenty-three across nine there, including one misstatement of what a
  cited theory says.
- `turkce-humanizer` preserves document structure exactly, by design. If you
  are repairing a document whose skeleton must survive — a form, a
  specification, a template — that behaviour is better than this one's.

**Write mode.** `evals/RESULTS-write.md` records the same twelve prompts run with
and without the skill, the no-skill arm held byte-identical between rounds:
**11–1, p=0.0032**, up from 7–5 (p=0.387) before the mode split. Corporate is the
one register it still loses.

One caveat that applies to the repair figure and not the write one: it was
measured before `references/rewrite-mode.md` became its own file, so it describes
the skill one revision back and has not been re-run since the split.

The most useful thing the evaluation produced is a warning about evaluation
itself: a blind "which reads more human" test **rewards fabrication**, because
inventing the writer's experience is the fastest way to sound like a writer.
One judge ranked a text first specifically for three sentences that were not in
its source. Any measurement of a humanising tool that stops at human-likeness is
measuring something that can be won by lying.

## Adapting this for another language

The layer split is the reusable part, and it is why the explanatory prose here
is English while every example is Turkish.

Ask, for your language: where does it branch, and does the model get that
backwards? How does it mark emphasis — position, particle, morphology — and
does the model mark it the English way? Does it grammaticalise something
English lacks, the way Turkish grammaticalises evidentiality? What does it fuse
that English joins with a conjunction?

Those questions produce your layer 2. Layer 1 is largely language-independent.
Layer 3 is entirely local.

Two things are worth copying whatever the language. Build the measuring
instrument before the corpus, and calibrate it against published writing in
that language — in this project that check caught four separate bugs, each of
which had already produced a confident wrong finding. And decide in advance
what beats what, in writing, before you see any results.

## Licence

MIT. See `LICENSE`.
