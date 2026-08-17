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
source. Measured: zero additions across all twenty-one texts of the
evaluation corpus, in every round it has been checked.

## Install

**Claude Code plugin**

```
/plugin marketplace add durmazoguzhan/turkish-humanify
/plugin install turkish-humanify@durmazoguzhan
```

Both lines are needed: `@durmazoguzhan` names a marketplace, and a marketplace
has to be added before anything can be installed from it.

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
seven reference files that are read at the moment they are used, because worked
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
the eight counting bugs found so far, each of which had already produced a
confident wrong finding.

**Repair mode.** `evals/RESULTS.md` records a three-way comparison against
[`turkce-humanizer`](https://github.com/bushrabeg/turkce-humanizer). Read it
before believing anything here. The short version:

- Against unaided model Turkish, both skills win clearly. Raw output never took
  first place in twelve blind rankings and came last nine times.
- Against `turkce-humanizer` on reading quality: **16–5 across twenty-one
  files**, two-sided sign test p=0.027, with the competitor's outputs held
  byte-identical so that the only thing that moved was this skill.
- On fidelity it is not close: **zero added claims across twenty-one files**
  here, against twenty-three across nine there, including one misstatement of
  what a cited theory says.
- One file, `blog-1`, has now lost five times to the same three invented
  sentences. It is not winnable without fabricating, so it stays lost.
- `turkce-humanizer` preserves document structure exactly, by design. If you
  are repairing a document whose skeleton must survive — a form, a
  specification, a template — that behaviour is better than this one's.

**Write mode.** `evals/RESULTS-write.md` records the same twelve prompts run with
and without the skill, the no-skill arm held byte-identical between rounds:
**11–1, p=0.0032**, up from 7–5 (p=0.387) before the mode split.

Both figures come from `evals/repair-protocol.md`, which fixes the generation
wrapper, the judge prompt, the randomisation and the fidelity check so that
rounds are comparable to each other. It exists because the first four rounds
described their procedure in prose and never committed it.

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
that language — in this project that check caught eight separate bugs, each of
which had already produced a confident wrong finding. And decide in advance
what beats what, in writing, before you see any results.

## Contributing

`CONTRIBUTING.md` has the details. The short version: rules in this skill are
measured before they are added, `evals/repair-protocol.md` is the procedure, and
fidelity to the source outranks the score. Reporting a bad Turkish sentence in an
issue is a genuinely useful contribution and costs you nothing.

Security policy: `SECURITY.md`. Code of conduct: `CODE_OF_CONDUCT.md`.

## Releases

Every merge to `master` is a release. CI tags it `v<version>` and publishes a
GitHub release with generated notes, so the tag is the commit count too and no
release step is done by hand.

## Versioning

[WendtVer](https://wendtver.org): the version is the commit count, written one
digit at a time. A skill has no contract to break, so SemVer would be encoding a
severity judgement that does not exist. `.claude-plugin/plugin.json` is the
update key Claude Code compares against, so it is derived by `scripts/version.sh`
and enforced in CI rather than maintained by hand — it had already drifted
through a mode split and seven counter fixes while still claiming `1.0.0`.

## Licence

MIT. See `LICENSE`.
