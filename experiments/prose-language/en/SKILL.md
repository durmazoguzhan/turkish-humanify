---
name: turkish-humanify
description: Use when writing or repairing Turkish text that must read as human-written — blog posts, technical writing, marketing copy, or academic prose. Applies native Turkish sentence architecture instead of English structure rendered in Turkish words.
---

# turkish-humanify

LLM Turkish is grammatical and empty. The words are Turkish; the architecture
underneath them is English — modifiers trailing behind their heads, emphasis
placed where English would place it, every sentence landing in the same
eighteen-to-twenty-five-word range. This skill fixes the architecture. It is
not a vocabulary filter.

## 1. Pick a mode

**The user supplied text → repair.** Work on what is there. Every claim in the
input survives into the output.

**The user supplied a brief, a topic, or a request → write.**

Write mode is **not** draft-then-humanise. Decide the composition in Turkish
before the first sentence: what the opening move is, how the piece turns, where
it lands. Then write with the sentence rules already in force. A piece drafted
in English shape and cleaned afterwards keeps its English skeleton, and the
skeleton is the thing the reader feels.

## 2. Identify the register

| Register | How to recognise it |
|---|---|
| **blog / essay** | addressed to a reader who chose to read it; the writer may have an opinion |
| **technical** | explains a system or a procedure to someone who will act on it |
| **corporate / marketing** | a brand speaking; a decision is being asked for |
| **academic / official** | conventions are binding and deviation costs credibility |

## 3. Pick a voice

Default to the register's own voice. Override when the user names one
("denemeci sesle yaz") or supplies a sample ("şu metindeki gibi yaz") — in that
case read the sample's voice off it before writing anything.

## 4. Run the layers

Structure → sentence → surface. **Only the sentence layer is implemented in
this version;** the other two are being built.

Read `references/layer-2-sentence.md` before rewriting a single sentence. Read
it now, not from memory — its worked examples are the instruction, and a
remembered summary of them is not.

### Dosage

How much of each layer runs depends on the register. (This table moves to
`references/registers.md` once that file exists.)

| Layer | blog / essay | technical | corporate | academic / official |
|---|---|---|---|---|
| structure | full | medium | medium | off |
| sentence | full — inversion, particles, `-mIş` all in play | restricted — no inversion, few particles; branching, converbs, focus and `-DIr` cleanup active | medium | branching, converbs, focus and `-mektedir` cleanup only |
| surface | full | full | full | full |

Surface is always on: orthography and terminology are correctness, not style.

## 5. Check before emitting

Silently, without reporting it:

- Every claim in the input is still in the output. Nothing was added.
- No technical term was translated into an invented Turkish equivalent.
- No em dash. No emoji. No chat residue.
- Read the piece aloud in your head. If every sentence is the same length, the
  sentence layer did not run.

## 6. Emit

The text. Nothing else. No preamble, no summary of what changed, no offer to
adjust the tone.

Explain only when asked. If the user asks what changed or why, name the tell,
the layer that addressed it, and show the before/after pair — but never
volunteer this.

## Invariants

These hold in every mode, register and voice.

1. **No fabrication.** Adding soul is not inventing detail. No number, name,
   date or claim that is not in the source or supplied by the user. A paragraph
   that reads beautifully and invents a statistic has failed.
2. **Meaning is preserved.** Repair may restructure freely within the register
   dose; it may not change what is being said.
3. **No forced translation.** A technical term with no true Turkish equivalent
   stays as it is. `endpoint` does not become "uç nokta"; `event-driven` does
   not become "olay güdümlü". Where a Turkish word genuinely exists and Turkish
   engineers actually say it, use it: geliştirici, pazaryeri, doğrulama.
4. **No em dash in output.** It is not a Turkish explanatory mark. Use a
   semicolon, a connective, or a sentence break.
5. **No chat residue.** No emoji, no "Elbette!", no "Umarım yardımcı olmuştur",
   no word count at the end.

## What this skill is not

It is not a Turkish purism tool — kept English terms are a feature. It is not a
detector-evasion tool; the target is quality, not classifiers. It does not
judge whether the argument is any good.
