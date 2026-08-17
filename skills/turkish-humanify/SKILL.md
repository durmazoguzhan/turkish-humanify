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
input survives into the output. Start by reading the text once against
`references/ai-tells.md` and marking what is actually present — it routes you
to the layer that fixes each tell, and it records which tells are common and
which are nearly extinct, so the work goes where the damage is. If the text
shows none of them, say so and change little; rewriting text that was already
fine is its own failure.

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

Read `references/voices.md`. Default to the register's own voice; override when
the user names one ("denemeci sesle yaz") or supplies a sample ("şu metindeki
gibi yaz"), and in that case read the sample's voice off it — on the nine
dimensions that file lists — before writing anything.

## 4. Run the layers

Structure → sentence → surface, in that order.

Read the reference file for each layer at the moment you run it, not from
memory. The worked examples are the instruction, and a remembered summary of
them is not.

- `references/layer-1-structure.md` — opening move, paragraph rhythm, closing,
  titles, bullets, bold, subheadings. Run this first: it decides what the piece
  is, and there is no point polishing a paragraph you are about to delete.
- `references/layer-2-sentence.md` — the fourteen places Turkish and English
  genuinely diverge. This is where most of the work happens.
- `references/layer-3-surface.md` — terminology buckets, suffixes on kept
  English terms, apostrophe, `da/de` and `ki`, punctuation, numbers.

### Dosage

How much of each layer runs depends on the register. Read
`references/registers.md` for the table and for what each dose means in
practice. Surface is always on, in every register: orthography and terminology
are correctness, not style.

## 5. Check before emitting

Silently, without reporting it:

- **In repair mode: every claim in the input is still in the output, and
  nothing is in the output that was not in the input.** Check both directions.
  A number, name, date or assertion you added is a hard failure however well
  the paragraph reads.
- No technical term was translated into an invented Turkish equivalent.
- No explanatory em dash. No emoji. No chat residue.
- Read the piece aloud in your head. If every sentence is the same length, the
  sentence layer did not run.
- Count the bold spans and the bullet lines. If they came through unchanged
  from a text that had many, the structure layer did not run either.

## 6. Emit

The text. Nothing else. No preamble, no summary of what changed, no offer to
adjust the tone, no word count.

**Explanation mode.** If — and only if — the user asks what changed or why,
answer by naming the tell, the layer that addressed it, and the before/after
pair. The trigger is the user's question, not your own judgement that an
explanation would be useful. Never volunteer it, and never attach a short
version of it to a normal response.

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
