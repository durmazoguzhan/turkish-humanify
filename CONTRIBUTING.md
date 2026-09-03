# Contributing

Contributions are welcome. This file is short on ceremony and long on the two
things that are unusual here: how claims get made, and how the version works.

## The one rule that matters

**Do not add a rule to the skill without measuring it.**

Every rule in `skills/turkish-humanify/references/` is there because something
was measured, and several rules that seemed obviously right made the output
measurably worse. `evals/RESULTS.md` records four rounds of that happening,
including a round where five of six changes did nothing and one made things
worse. A patch that adds a rule and says it reads better will be asked for a
number.

If you are not set up to run an evaluation round, open an issue describing what
you think is wrong and quote the Turkish. That is genuinely useful and costs you
nothing.

## The second rule, learned the expensive way

**A count tells you something moved. It does not tell you whether moving it was
right.**

Measuring is not enough, and this is not a refinement of the rule above — it is a
separate failure that the rule above does not catch. Round nine measured `bold`
source-to-output across eight repair runs, found it fell in four, and wrote a
rule into `layer-1-structure.md` §6 against a threshold **set before the data
existed.** The rule was wrong. Reading *which* spans had gone reversed it: what
got deleted was a word bolded in both entries of a two-entry list, which
distinguishes nothing, while the finding the document existed to state survived
every single run. Three of the four "losses" were the rule working correctly. A
reviewer found it in one sentence; the instrument never would have.

**The tell is a signal that can legitimately move either way.** Bold is the clear
case — too much of it is a defect, too little is a defect, and leaving it alone
is often right — but `bullets`, `rows`, `heads`, sentence length, hedge counts and
every per-100 rate in `count.sh` have the same property. For all of them the
direction of a change is not its correctness.

So, before an aggregate becomes a rule:

- **List the individual instances and judge each one.** If most of the movement
  was the skill behaving correctly, there is no finding, however clean the rate
  looked.
- **State the finding per instance until per-instance evidence exists.** "Four of
  eight runs deleted bold" is not a finding. "Four of eight deleted the span
  carrying the document's claim" would be one, and it is not what happened.
- **Pre-registration does not cover this.** It protects against reading noise as
  signal. It does not protect against measuring the wrong quantity, and round
  nine is the proof: the bar was written first and cleared honestly, and the
  conclusion was still false.

## Running an evaluation round

`evals/repair-protocol.md` is the procedure, verbatim: the generation wrapper,
the judge prompt, the randomisation, the fidelity check. Follow it rather than
improvising, because rounds are only comparable to each other if the instrument
did not move.

**A round is seven files generated twice, not twenty-one generated once.** That
is smaller *and* stronger: the bar a finding has to clear is two appearances in
two generations of the same input, and twenty-one-by-one cannot produce one. The
standing sample, the reserve, and the confirmation run that guards against
fitting rules to seven files are all in §0 of that file.

Three things that this project learned the hard way and that the protocol now
enforces:

1. **One variable per round.** Round two of this project is uninterpretable
   because the corpus and the skill changed together, and round five had to be
   thrown away and re-run because a notation change landed mid-flight.
2. **Write the threshold down before you look.** If you are testing whether a
   mechanism is real, state in the file what result would confirm it and what
   would reject it, and commit that before generating anything. Round five's
   corporate hypothesis was rejected under a threshold set in advance, which is
   the only reason it was not talked into the results.
3. **Fidelity outranks the score.** A text that reads beautifully and invents a
   fact has failed. This is not a tiebreaker; it is read first. A blind "which
   reads more human" test can be won by lying, and one file in the corpus has
   now lost five times to exactly that.

## The third rule: not countable is not the same as not measurable

**Deterministic tools bound correctness. Reading passes bound quality. Both are
instruments and both need a protocol.**

This is written down because the repository had started to conflate them, and
the conflation is visible in its own files: `evals/fixtures/devrik.md` concluded
that a defect could not be acted on because `grep` could not find it, and said
resolving it "needs a parse". That was wrong twice over. It is not what
`count.sh` says — its header says *those signals live in the reading half of
`rubric.md`* — and it is not what this project does, since the fidelity check,
the blind tally and the diagnostic judge are all reading passes already.

What is genuinely deterministic is a short list, and it is the list a machine
can be right about: orthography, vowel harmony on a suffix, the apostrophe, a
banned mark, a phrase that appears verbatim or does not. Everything the skill
actually exists for — whether a text reads as written by a person, whether a
device earns its place, whether a sentence is fluent — is a judgement, and a
count of a judgement is not a measurement of it.

**But a reading pass is not "an agent had an opinion".** Reading judgements have
a measured error rate here: round six found that judges flip verdicts on files
the skill did not touch, and round seven's diagnostic judge blamed the passive
voice on a text that had the same passives as its competitor. So a reading pass
is run like an instrument:

1. **Do not lead the witness.** Ask what reads wrong, not whether *this* reads
   wrong. Unprompted identification is evidence; confirmation of a shape you
   named is not.
2. **Clean context, and nothing about the project.** No mention of a skill, a
   comparison, or what is being tested.
3. **Per instance, with the quotation.** "It feels AI-ish" is unusable. The
   sentence, quoted, plus what is wrong with it.
4. **Run a control** — a text without the shape you are chasing. If the reader
   names something there too, you are reading noise.
5. **A negative result counts.** A reader who hunts through a paragraph, finds
   four other things and walks past your shape has told you your shape is fine
   there.

The worked instance is in `evals/fixtures/devrik.md`: three readers, one
non-leading question, one of them naming a verbless tail and its mechanism
without being asked, and one walking past the same shape in a register where it
belongs.

## How much testing is enough

Three cases per class. Not seven, not "one more to be safe".

This is a deliberate loosening, written down on 2026-09-04 because the repository
was drifting the other way. A fixture is a **tripwire**, not a corpus: its job is
that a broken counter cannot pass, and the fourth example of a shape the first
three already cover buys nothing except a file nobody rereads. When a real
failure turns up that the three do not catch, *that* one gets added, with a note
saying what it caught. The file then grows for a reason instead of by
accumulation.

**The distinction that keeps this honest.** Deterministic checks are cheap and
nearly noiseless — a bullet either survived the rewrite or it did not — so three
of them settle the question. Judge tallies are neither, and nothing here relaxes
that: the noise floor in `evals/repair-protocol.md` was measured, three files of
movement is still noise, and a fidelity site still needs two appearances before
it justifies a rule. Loosen the cheap instrument, not the expensive one.

## Touching `evals/count.sh`

Eight counting bugs have been found in this file, and every one of them had
already produced a confident wrong finding that was reported as a result. If you
change a regex:

- Add a case to `evals/fixtures/known.md` that the old version fails. One case
  is the requirement; see "How much testing is enough" above.
- Hand-compute the expected numbers and put them in `evals/test-count.sh`.
- Say in the commit message how many corpus files change, and whether any
  published conclusion moves.

Turkish morphology is where these bugs live. Check vowel harmony on any suffix
you match: `-mAktAdIr` is *maktadır* **and** *mektedir*, and the counter missed
the second one for four rounds.

## Turkish text in the corpus

`evals/human-reference/` holds excerpts of published Turkish, used to calibrate
what "normal" looks like. If you add to it:

- Published before 2022, so it cannot be model output. Say where and when in the
  front matter.
- Keep excerpts short and attribute the source.
- Note that the set includes a deliberate **negative** control
  (`gezinomi-negative-control.md`). Human-written is not the target; good is.

## How a change lands

**Squash is the only merge method, and merging is the maintainer's alone.**
Reviewing is not: anyone can review a pull request here and anyone can approve
one. The repository is public and needs no collaborator access for that. What is
restricted is the button, and only that.

The settings that hold this up, so that a future disagreement is with a
configuration rather than with a paragraph:

| setting | state |
|---|---|
| merge commit / rebase merge | **disabled** on the repository |
| squash merge | the only option |
| `master` | protected: pull request required, linear history, no force push, no deletion |
| required status check | `check`, strict |
| required approving reviews | **0**, deliberately — requiring one would block the sole maintainer from merging their own work, since GitHub does not allow self-approval |
| `enforce_admins` | on; the maintainer goes through a pull request too |
| write access | the maintainer only. On a personal repository GitHub offers no "restrict who can push" list, so this is a matter of not granting `write` rather than a switch |

### One pull request is one commit is one PATCH

This follows from squash-only and it is not a convention — it is arithmetic.
[WendtVer](https://wendtver.org) makes the version the commit count, a squash
merge adds exactly one commit to `master` however many the branch carries, so
**a pull request bumps PATCH by exactly one no matter how much work is in it.**

`scripts/version.sh --write` computes it from the base branch rather than from
your own HEAD, and CI checks for equality rather than for "moved forward".

Both of those were wrong until 2026-09-04 and the failure is worth keeping,
because it is silent in the direction that costs most. A four-commit branch
whose version was computed from its own HEAD carried a bump of four. The
pull-request gate asked only whether the version had moved forward, so it
**passed**. The push gate on `master` compares for equality, so it would have
failed *after* the merge — with the branch gone, the release job skipped, and
nothing cheap left to fix. The gate now fails on the pull request, where the fix
is one command.

If you are changing the merge method, this is the paragraph to change with it.
The version depends on it, and nothing about that dependency is obvious from
reading `plugin.json`.

## Versioning

This repository uses [WendtVer](https://wendtver.org): start at 0.0.0, every
commit increments PATCH, PATCH rolls to 0 at ten and increments MINOR, MINOR
rolls to 0 at ten and increments MAJOR. The version is therefore the commit
count written one digit at a time.

SemVer is not used because a skill has no contract to break — there is no API
whose removal is a MAJOR event, and no addition that is a MINOR one. Every
change is "the prose is different now", so a scheme that claims to encode
severity would be encoding a guess.

The version in `.claude-plugin/plugin.json` is not decoration: Claude Code uses
it as the update key and **skips the update when it matches what the user
already has**. A stale version means installed users silently never receive
anything. That happened here — `1.0.0` shipped unchanged through a mode split, a
recalibration and seven counter fixes — which is why it is now derived and
CI-enforced rather than maintained by hand.

Before you commit:

```
scripts/version.sh --write
```

CI fails a pull request whose version was not bumped, and fails a push to
`master` whose version does not match the commit count. Because `master` takes
squash merges only, one pull request is one commit is one version.

## How changes land

`master` is protected: no direct pushes, pull request required, CI must pass,
linear history, no force pushes. Squash is the only merge method enabled, which
is what keeps the commit count meaningful as a version.

Anyone can review and approve a pull request — approving needs only read access
on a public repository. Merging needs write access, and write access is the
maintainer only. Branches are deleted automatically once merged.

## Checks

```
./scripts/check-structure.sh   # repo layout the three distribution channels expect
./evals/test-count.sh          # counter against the hand-verified fixture
./scripts/check-doses.sh       # every register-dependent rule states its own dose
./scripts/version.sh --check   # version against the commit count
```

`check-doses.sh` deserves a note, because it encodes a failure this project made
three times. A rule that varies by register has to say so **where the rule is
read**. `registers.md` is a summary; the rule's own section is the specification.
Three rules forgot: the paragraph rule fired in academic register, the semicolon
carried academic rates into blogs for six rounds, and `-mIş` relied on the table
alone. The first two were caught by blind judges. The third was caught by this
script, which is the point of having it.

All three run in CI.

## Scope

This is a Turkish-language skill. Pull requests that generalise it into a
multi-language framework will be declined — the README's "Adapting this for
another language" section exists so you can fork it for yours, which is the
better outcome for both of us.
