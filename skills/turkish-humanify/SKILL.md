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

**The user supplied text → repair.** Read `references/rewrite-mode.md`.

**The user supplied a brief, a topic, or a request → write.** Read
`references/write-mode.md`.

Read the one that applies before anything else. Each holds what is true only of
its mode — fidelity and the diagnostic pass for repair; composition-first and
the dosage translation for write — and each tells you how to read the shared
files from where you are standing.

Everything else is shared: the grammar, the surface rules, the registers and the
voices apply the same way in both modes.

## 2. Identify the register

| Register | How to recognise it |
|---|---|
| **blog / essay** | addressed to a reader who chose to read it; the writer may have an opinion |
| **technical** | explains a system or a procedure to someone who will act on it |
| **corporate / marketing** | a brand speaking; a decision is being asked for |
| **academic / official** | conventions are binding and deviation costs credibility |

## 3. Pick a voice

Read `references/voices.md`. Default to the register's own voice; override when
the user names one ("denemeci üslubuyla yaz") or supplies a sample ("şu metindeki
gibi yaz"), and in that case read the sample's voice off it — on the nine
dimensions that file lists — before writing anything.

## 4. Run the layers

Structure → sentence → surface, in that order. These three, plus `registers.md`
and `voices.md`, are the **shared** set — identical in both modes.

Read the reference file for each layer at the moment you run it, not from
memory. The worked examples are the instruction, and a remembered summary of
them is not.

- `references/layer-1-structure.md` — opening move, paragraph rhythm, closing,
  titles, bullets, bold, subheadings. Run this first: it decides what the piece
  is, and there is no point polishing a paragraph you are about to delete.
  **In repair mode, read the source's shape before any of it.** If the lines
  carrying the content are list items, table rows and headings rather than
  sentences, the document is its structure and this layer works inside the
  units. §5 and §6 of that file say which parts of this are measured and which
  are diagnosis; round nine tested both and neither cleared its threshold, so
  read them as orientation and not as new instructions.
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

- **In repair mode only: run the fidelity check in `rewrite-mode.md`.** It
  outranks every other item here.
- No technical term was translated into an invented Turkish equivalent.
- No explanatory em dash. No emoji. No chat residue.
- Read the piece aloud in your head. If every sentence is the same length, the
  sentence layer did not run.
- Count the bold spans and the bullet lines. If they came through unchanged
  from a text that had many, the structure layer did not run either — and in
  repair mode ask it the other way round too: if the input had a list or a table
  and the output has none, layer 1 ran on the skeleton instead of inside it.
- **Read the middle third alone.** If it is indistinguishable from the input's
  middle third, the work landed only on the opening and closing — which is the
  shape of a machine draft, not a repair of one.
- **Delete-test every device you added.** Each inversion, particle and short
  sentence: remove it and see whether anything is lost. If nothing is, it was
  decoration and it goes.

### The bar

Would a Turkish reader believe nobody edited this?

Not "is it grammatical", and not "does it sound human" — that second question can
be passed by inventing an experience the writer never had.

An earlier version of this line asked whether an editor would publish it
untouched. That was wrong, and measurably so: blind readers reward text that
reads **unedited** — *"gerçek bir esnaf ağzı"*, *"klavyeden döktüğü cümleler"* —
and their standing criticism of this skill's output is *"cilalanmış"*,
*"editoryal"*, *"ütülü"*. An editor-safe text is a tidy text, and tidy is the
thing being penalised.

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

1. **No forced translation.** A technical term with no true Turkish equivalent
   stays as it is. `endpoint` does not become "uç nokta"; `event-driven` does
   not become "olay güdümlü". Where a Turkish word genuinely exists and Turkish
   engineers actually say it, use it: geliştirici, pazaryeri, doğrulama.
2. **No em dash in output.** It is not a Turkish explanatory mark. Use a
   semicolon, a connective, or a sentence break.
3. **No chat residue.** No emoji, no "Elbette!", no "Umarım yardımcı olmuştur",
   no word count at the end.

Repair mode adds a fourth that does not apply to writing, because it has no
referent there: **fidelity to the supplied text.** It lives in
`references/rewrite-mode.md`, and it outranks everything else in this file.

## What this skill is not

It is not a Turkish purism tool — kept English terms are a feature. It is not a
detector-evasion tool; the target is quality, not classifiers. It does not
judge whether the argument is any good.
