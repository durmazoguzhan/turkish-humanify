# Write mode

Everything specific to composing a text that does not exist yet. The grammar
itself is in the shared layer files; this file holds what only applies when
there is no input.

---

## Composition comes before sentences

Write mode is **not** draft-then-humanise. Decide, in Turkish, before the first
sentence:

- **The opening move** — a question, a scene, an objection, or a number. Not an
  announcement of the topic. See `layer-1-structure.md` §1.
- **Where the piece turns** — the paragraph that changes direction, and the
  contrast word that marks it.
- **Where it lands** — a turn, a recommendation, a question, or simply stopping.
  Decide this before writing the middle, or the middle will wander toward a
  summary.

Then write with the sentence rules already in force.

A piece drafted in English shape and cleaned afterwards keeps its English
skeleton, and the skeleton is what the reader feels. Measured: applying the
layers only to the opening and closing reproduces the exact shape of a machine
draft — lively edges, flat middle — and blind readers name it
*"sonradan serpiştirilmiş"*.

---

## Reading the dosage table in write mode

`registers.md` is written in repair verbs, and they do not transfer literally.
In write mode there is nothing to remove, so "cleanup" and "stays" have no
referent and get read as instructions to produce. Translate them:

| the table says | in repair it means | in write it means |
|---|---|---|
| `-DIr` **cleanup** | strip it from the input | do not use it as a default sentence-ender |
| `-mAktAdIr` **cleanup** | strip it from the input | do not reach for it |
| `-mAktAdIr` **stays** | do not delete what is there | **neither avoid it nor reach for it** — write at the register's own natural rate |
| structure **off** | do not restructure the input | follow the genre's own conventions |
| **no list-to-prose conversion** | leave the input's lists alone | use a list only where the content is genuinely a set the reader scans |

**The middle row is the one that has already gone wrong.** Measured on three
academic write tasks, `-mAktAdIr` per 100 words:

| | unaided | skill |
|---|---|---|
| `w-acad-1` | 0.0 | 2.8 |
| `w-acad-2` | 0.0 | 2.1 |
| `w-acad-3` | 0.0 | 1.9 |

Blind readers penalised it in those words: *"neredeyse her yüklem
`-mektedir/-maktadır` kalıbında"*, *"paragrafların hepsi aynı uzunlukta"*.
Academic Turkish does use `-mAktAdIr` — raising it from zero is correct — but
"stays" is not a licence to end every sentence with it.

---

## Facts you do not have

**This skill does not decide whether to invent them.** Whether a draft should
carry plausible specifics or leave them open is a property of the conversation
the user is having, not of Turkish, and the surrounding context governs it.
Repair mode is different — there the input's claims belong to somebody else and
fidelity is the skill's business (see `rewrite-mode.md`).

What *is* this skill's business is the Turkish of whichever choice gets made.

**If the context calls for placeholders, mind the suffixes.** Turkish suffixes
agree with the final vowel of the word they attach to, and a placeholder has no
final vowel until it is filled. `[Fırın adı]'nda` breaks: *Ekmekçi'nde* but
*Fırın'da*. Write around the join instead of guessing:

> Kırılgan: [Fırın adı]'nda her sabah taze ekmek çıkıyor.
> Sağlam: Her sabah taze ekmek çıkan bir yer var: [Fırın adı].

> Kırılgan: [Ürün adı]'yla başlayın.
> Sağlam: Şu ürünle başlayın: [Ürün adı].

**And do not let a placeholder replace a sentence you could simply write.** A
bracket is for a fact the reader must eventually see — a price, an address, a
phone number. It is not for every specific the sentence could live without.

> Fazla: Gün, mahalle uyanmadan [saat]'te başlıyor.
> İyi: Gün, mahalle uyanmadan başlıyor.

> Fazla: Akşamüstü [saat]-[saat] arası tezgah çabuk boşalıyor.
> İyi: Akşamüstü tezgah çabuk boşalıyor.

Measured: one 400-word bakery post came out with eighteen placeholders, eleven
of which the sentence did not need. A text that has to be de-bracketed line by
line is its own kind of unfinished.

---

## Concreteness is a style dimension, not a truth claim

`voices.md` dimension nine is concreteness: how many numbers, names and examples
a voice carries per paragraph. That is a statement about how the voice *sounds*,
not permission to make figures up. High concreteness with real detail is what
makes Turkish prose read as written by a person; high concreteness with invented
detail is the failure mode this project measured most clearly.

Where the detail comes from is the conversation's problem. Whether the sentence
around it is Turkish is ours.
