# Security

## What this project is

`turkish-humanify` is a set of Markdown instruction files read by an AI coding
assistant. It ships no executable code that runs on a user's machine as part of
using the skill: installing it copies text files into a skills directory, and
using it means a model reads them.

The shell scripts in `scripts/` and `evals/` are development and evaluation
tooling. They are not installed by `/plugin install` and are not run by the
skill.

That shapes the realistic threat model. The plausible risks are:

- **Prompt injection through the reference files.** If someone lands a change
  that adds instructions unrelated to Turkish writing, every user of the skill
  executes them the next time the file is read. This is the one that matters.
- **Malicious content in the evaluation corpus**, for the same reason: corpus
  files are read by subagents during evaluation.
- **Workflow injection** in `.github/workflows/`, via untrusted fields such as a
  pull request title or branch name interpolated into a `run:` block.

## Reporting

Report privately through GitHub's **Report a vulnerability** button on the
Security tab of <https://github.com/durmazoguzhan/turkish-humanify>, which opens
a private advisory.

Please do not open a public issue for anything you believe is exploitable.

Include what you found, the file and line, and what an attacker gets. A working
reproduction helps but is not required — a clear description of the mechanism is
enough.

I maintain this in my own time, so I will not promise a response window I cannot
keep. I will acknowledge what I receive and say plainly if I am not going to act
on it.

## Scope

**In scope**

- Instructions in `skills/turkish-humanify/` that do anything other than
  describe how to write Turkish.
- Anything in `.github/workflows/` that lets untrusted input reach a shell.
- Content in `evals/` crafted to influence a model that reads it.
- A `plugin.json` or `marketplace.json` that would cause Claude Code to fetch
  from somewhere other than this repository.

**Out of scope**

- The skill producing Turkish you disagree with. That is a quality issue; open a
  normal issue, ideally with the sentence that is wrong.
- Behaviour of Claude Code itself. Report that to Anthropic.
- The evaluation scripts mishandling deliberately malformed input you supply
  locally. They are development tools with no privilege boundary.

## For users installing this

Two things worth knowing regardless of this project:

1. A skill is instructions your assistant will follow. Read them before
   installing. Everything here is plain Markdown and deliberately readable;
   `skills/turkish-humanify/SKILL.md` is about 130 lines and links the rest.
2. Install from this repository, not from a mirror. The marketplace name is
   `durmazoguzhan` and the source is
   <https://github.com/durmazoguzhan/turkish-humanify>.
