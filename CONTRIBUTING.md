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

## Running an evaluation round

`evals/repair-protocol.md` is the procedure, verbatim: the generation wrapper,
the judge prompt, the randomisation, the fidelity check. Follow it rather than
improvising, because rounds are only comparable to each other if the instrument
did not move.

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

## Touching `evals/count.sh`

Eight counting bugs have been found in this file, and every one of them had
already produced a confident wrong finding that was reported as a result. If you
change a regex:

- Add a case to `evals/fixtures/known.md` that the old version fails.
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
./scripts/version.sh --check   # version against the commit count
```

All three run in CI.

## Scope

This is a Turkish-language skill. Pull requests that generalise it into a
multi-language framework will be declined — the README's "Adapting this for
another language" section exists so you can fork it for yours, which is the
better outcome for both of us.
