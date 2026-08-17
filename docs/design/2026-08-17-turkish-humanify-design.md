# turkish-humanify — Design

**Date:** 2026-08-17
**Status:** approved for planning
**Owner:** Oguzhan Durmaz

All explanatory prose in this repository is English so that a developer working on
another language can read the scaffolding and adapt it. All *examples* are Turkish,
because the examples are the artifact. Turkish grammatical terms are kept in Turkish
with an English gloss on first use (`ulaç` / converb, `ortaç` / participle,
`devrik cümle` / inverted sentence).

---

## 1. Problem

LLMs write bad Turkish. Not ungrammatical Turkish — *soulless* Turkish. The output
parses, but no human wrote it: it does not flow, it has no voice, and a Turkish reader
recognises it as machine text within two sentences.

The cause is not vocabulary. It is that models learned Turkish mostly as a target for
English-shaped thought. They have read comparatively little Turkish journalism, few
Turkish novels, few blog posts by Turkish editors. So they produce Turkish words
arranged in English architecture:

- English is head-initial and right-branching. Turkish is head-final and
  **left-branching**: modifiers precede their head. LLM Turkish keeps the English
  shape and glues the modifiers on afterwards with em dashes and `ki` clauses.
- English marks emphasis with word choice and stress. Turkish marks it with
  **position** — the slot immediately before the verb. LLMs ignore that slot entirely.
- Turkish grammaticalises **evidentiality** (`-mIş` vs `-DI`), which English does not
  have. LLMs default to `-DI` for everything, so narrative reads like a report.
- Turkish fuses clauses with a rich **converb** system (`-ip`, `-erek`, `-ince`,
  `-dikçe`, `-meden`, `-ken`). LLMs reach for `ve` because English reaches for *and*.

The existing skill in this space, `turkce-humanizer`, is a genuine improvement over
nothing: it removes punctuation inflation, `-mektedir` inflation, sentence monotony,
the "sadece X değil aynı zamanda Y" calque, and hollow closings. But it operates at
the surface. It cleans sentences; the *composition* stays English. Remove every em
dash from a paragraph built as topic-sentence → three supports → summary, and you
still have a paragraph no Turkish essayist would write.

Second problem, stated as a hard constraint by the owner: forced translation of
technical terms. A skill that turns `endpoint` into "uç nokta" and `event-driven` into
"olay güdümlü" destroys meaning in the name of purity. Terms without a real Turkish
equivalent must survive untouched.

## 2. Goals

1. Produce Turkish that a Turkish reader attributes to a human writer.
2. Work in two directions: repair existing text, and write new text natively.
3. Cover four registers with different intervention doses.
4. Never invent facts, never force-translate technical terms, never change meaning.
5. Be measurably better than `turkce-humanizer` on a shared corpus.
6. Ship through three channels from one repository: Claude Code plugin,
   `npx skills add`, and skillsllm.com.

## 3. Non-goals

- Turkish purism. `Elasticsearch`, `cache`, `deploy`, `pipeline` stay as they are.
- Detector evasion. The target is quality, not fooling classifiers.
- Translation between languages. This skill operates on Turkish.
- A general writing coach. It does not judge whether the argument is good.

## 4. Distribution and repository layout

```
turkish-humanify/
├── .claude-plugin/
│   └── plugin.json                    # Claude Code plugin manifest
├── skills/
│   └── turkish-humanify/
│       ├── SKILL.md                   # thin router, target ~150 lines
│       └── references/
│           ├── ai-tells.md            # diagnosis: signatures of AI Turkish
│           ├── layer-1-structure.md   # composition layer
│           ├── layer-2-sentence.md    # sentence layer — the core
│           ├── layer-3-surface.md     # orthography, terminology, punctuation
│           ├── registers.md           # 4 registers x dosage table
│           └── voices.md              # voice profiles
├── evals/
│   ├── rubric.md
│   ├── input/                         # raw AI Turkish baselines
│   ├── human-reference/               # real human Turkish, with attribution
│   ├── output/                        # skill output, dated
│   └── count.sh                       # optional signal counter
├── docs/design/
├── README.md
├── LICENSE
└── CHANGELOG.md
```

`skills/<name>/SKILL.md` is the layout all three channels understand. Claude Code
reads the plugin manifest; `npx skills add durmazoguzhan/turkish-humanify --skill
turkish-humanify` reads the skills directory; skillsllm.com indexes the repository.

**Git identity.** This is personal work. The repository sets
`user.email=durmazoguzhan@yahoo.com` in **local** config only. Global config stays on
the work identity so no work repository can silently inherit the personal one.

## 5. Skill architecture

`SKILL.md` routes and does nothing else. Detail lives in reference files, read only
when the current job needs them.

```
1. MODE      user supplied text        -> repair
             user supplied a brief     -> write

2. REGISTER  blog/essay | technical | corporate/marketing | academic/official
             determines which layers run, and how hard

3. VOICE     register default
             | natural-language override ("denemeci sesle yaz")
             | extracted from a user-supplied sample ("şu metindeki gibi yaz")

4. LAYERS    run in order, reading the reference file at the moment of use
             structure -> sentence -> surface

5. GATE      silent self-check against the register's checklist

6. OUTPUT    the text, nothing else
```

**Write mode is not "draft then humanise."** Composition decisions are made in Turkish
*before* the first sentence: what the opening move is, how the piece turns, where it
lands. Sentence-layer rules apply during generation. Humanising as a post-process is
exactly the failure mode of the surface-only approach — the skeleton stays English.

**Repair mode** runs the same three layers over supplied text, bounded by the register
dose and by the fidelity rules in §9.

## 6. The language core

### 6.1 Layer 2 — sentence architecture

This is where the skill differentiates. Each rule ships with a real before/after pair;
abstract instructions ("vary your sentences") do not change model behaviour, worked
examples do.

| Phenomenon | AI Turkish | Human Turkish |
|---|---|---|
| **Branching direction** — Turkish is left-branching; modifiers precede the head | "Bir kural motoru geliştirdim — 55'ten fazla kural tipi içeren; bunu bir veri modeli üzerine kurdum." | "Dinamik ve statik segmentler için 55'ten fazla kural tipi destekleyen bir segmentasyon modülünü uçtan uca geliştirdim." |
| **Converb system** (`ulaç`) — `-ip / -erek / -ince / -dikçe / -meden / -ken` instead of `ve` | "Sistemleri kurar **ve** ölçeklerim." | "Sistemleri kur**up** ölçeklerim." |
| **Focus position** — the immediately preverbal slot carries emphasis | "Sıfırdan, AI destekli bir mikroservis tasarladım." | "AI destekli bir mikroservisi **sıfırdan** tasarladım." |
| **Evidentiality** — `-mIş` for non-witnessed, narrated, or later-discovered events | "Kahinler kehanette bulundu." | "Kahinler kehanette bulun**muş**." · "Meğer bütün gece çalış**mışlar**." |
| **Aorist vs `-yor`** — English simple present maps to Turkish aorist, not progressive | "Bu servis istekleri işl**iyor**." (describing a property) | "Bu servis istekleri işl**er**." |
| **`-DIr` inflation** — the assertive copula is not a default | "Bu yöntem etkili**dir**." | "Bu yöntem etkili." |
| **`-mektedir` inflation** | "Kullanım art**maktadır**." | "Kullanım artıyor." |
| **`devrik cümle`** (inversion) — 100% verb-final is a machine signature | (never occurs) | "Bir de şu var işte: kimse okumuyor bu yazıları." |
| **Discourse particles** — `de/da`, `ise`, `ki`, `işte`, `zaten`, `hani`, `bir de`, `yani` | (never occurs) | "Selanik'e kimimizi bir Balkanlar turu getiriyor, kimimizi 'aman ilk giriş Yunanistan'dan olsun'culuk." |
| **Pro-drop** — Turkish drops subject pronouns | "**Ben** bunu yaptım, sonra **ben** şunu ekledim." | "Bunu yaptım, sonra şunu ekledim." |
| **Noun-compound chains** — 4+ stacked nouns suffocate a Turkish sentence | "müşteri segmentasyon modülü performans iyileştirme çalışması" | "müşteri segmentasyon modülünde yaptığımız performans çalışması" |
| **`ki` clauses** — a that/which calque | "Bir sistem kurduk **ki** bu sistem..." | resolve with a participle: "...eden bir sistem kurduk" |
| **Length variance** — agglutination allows one-word sentences | every sentence 18–25 words | "Olmadı." · "Gidebilseydik." · then a 35-word sentence |
| **Passive bleed** — academic voice leaking everywhere | "yapılmaktadır", "edilmiştir" | active voice |

### 6.2 Layer 1 — composition

- **Opening move.** Replace "Günümüzde X giderek önem kazanmaktadır" with a question,
  a scene, an objection, or a number. Real example: *"Bir şey satın alırken önce neye
  bakarız? Etiketine değil mi?"*
- **Paragraph skeleton.** Break the topic-sentence → three-supports → summary loop.
  Vary paragraph length. A one-sentence paragraph is allowed.
- **Closing.** "Sonuç olarak X'in önemi yadsınamaz" is banned. Real closings turn,
  recommend, ask, or simply stop.
- **Titles.** Replace the "X Nedir? Bilmeniz Gereken Her Şey" and "X: Kapsamlı Bir
  Rehber" templates.
- **Bullet dependence.** Turkish long-form prose uses far fewer lists than English
  tech writing. Convert lists back to prose where the content is not genuinely
  enumerable.
- **Bold and emoji inflation.** Remove.
- **Subheadings** are sentence-shaped and sentence-cased, never Title Case.

### 6.3 Layer 3 — surface

**Technical terminology — three buckets.**

1. **Kept verbatim.** `Elasticsearch`, `cache`, `endpoint`, `deploy`, `pipeline`,
   `event-driven`, `commit`, `container`. No invented equivalents. "Uç nokta" and
   "olay güdümlü" are forbidden outputs.
2. **Established Turkish exists — use it.** developer → geliştirici,
   marketplace → pazaryeri, validation → doğrulama, production → canlı ortam,
   feature → özellik.
3. **Both acceptable — consistency is the rule.** cache/önbellek,
   database/veritabanı, server/sunucu. Pick one per text and never mix. First
   occurrence may pair them: *"hisse başına kâr (earnings per share — EPS)"*.

**Suffixes follow pronunciation, not spelling.** A kept term still has to inflect, and
Turkish vowel harmony operates on how the word is *said*: `cache'i` (keş-i),
`queue'yu`, `SQL'i` (es-kü-el), `JSON'ı` (ceyson), `Google'ın`, `Redis'i`. Where
pronunciation genuinely varies in the wild, both forms are defensible and the rule is
internal consistency: a writer who says *sörç* writes `Elasticsearch'ü`, one who says
*serç* writes `Elasticsearch'i` — but not both in one text. Guessing harmony from
spelling is the most common LLM error in Turkish technical writing.

**Orthography (TDK).** Apostrophe before inflectional suffixes on proper nouns
(`Türkiye'de`, `Redis'i`) but not before derivational suffixes (`Türkçe`, `Türklük`);
apostrophe on abbreviations (`TBMM'nin`, `MCP'yi`); `da/de` conjunction vs locative
suffix; `ki` conjunction vs suffix; capitalisation rules. The reference file carries a
working subset, verified against tdk.gov.tr during implementation, not the full manual.

**Punctuation.** The em dash is not a Turkish explanatory mark — it belongs to dialogue
and ranges. Replace with a semicolon, a connective (`böylece`, `bu sayede`, `ayrıca`),
or a sentence break. Note that the Turkish semicolon is legitimate and should not be
purged wholesale; what grates is the English `; and` chain.

**Numbers and units.** `%41` with the sign leading; `1.250,75`; "yaklaşık" instead of
`~`; `10 kat`.

**Circumflex.** Only where it disambiguates (`kâr`/`kar`, `hâlâ`/`hala`). Never
decorative.

**Calque idiom dictionary.** "günün sonunda", "değer katmak", "kritik öneme sahip",
"bir adım öteye taşımak", "oyunun kurallarını değiştirmek", "X'in ötesinde", plus
empty intensifiers "son derece", "oldukça", "büyük ölçüde".

## 7. Registers and dosage

| Layer | Blog / essay | Technical | Corporate | Academic / official |
|---|---|---|---|---|
| Structure | full | medium | medium | off |
| Sentence | full (inversion + particles + `-mIş`) | restricted (no inversion, few particles; branching, converbs, focus, `-DIr` cleanup active) | medium | branching + converbs + focus + `-mektedir` cleanup only |
| Surface | full | full | full | full |

Surface is always on: orthography and terminology are correctness, not style.

## 8. Voice profiles

A voice is defined by nine observable dimensions, never by adjectives, and each
profile ships with three to five real sentences in that voice:

address (ben/biz/sen/siz) · mean sentence length and variance · preferred clause
linkage (`ve` / converb / semicolon / sentence break) · tense-mood distribution
(`-DI`/`-mIş`/`-yor`/aorist) · particle density · terminology preference (English vs
established Turkish) · inversion rate · paragraph length · concreteness (numbers,
names, examples per paragraph)

| Profile | Who is speaking | Signature move |
|---|---|---|
| `senli-benli anlatıcı` | travel / lifestyle blogger | second-person address, opens with a question, `-mIş` narration, frequent inversion |
| `teknik anlatıcı` | engineer explaining to a peer | keeps terms, opens with an analogy, no ornament |
| `denemeci` | thinking first person | long–short rhythm, hedging (*bana kalırsa*, *sanırım*), unshowy literariness |
| `kurumsal ama insan` | a brand, addressing "siz" | short, committed, no inflated adjectives |
| `nötr-resmi` | academic or official text | impersonal but correct and fluent; lowest dose |

Plus **user voice**: given a sample text, the skill extracts the nine dimensions and
uses them as a profile.

## 9. Invariants

These hold in every mode, register, and voice.

1. **No fabrication.** Adding soul is not inventing detail. No number, name, date, or
   claim that is not in the source or supplied by the user.
2. **Meaning is preserved.** Repair mode may restructure freely within the register
   dose, but every claim in the input survives in the output.
3. **No forced translation** of technical terms (§6.3).
4. **No em dash** in output.
5. **No chat residue** — no emoji, no "Elbette!", no "Umarım yardımcı olmuştur".

## 10. Output contract

Default output is the text and nothing else. No preamble, no detection report, no
change log. An explanation mode exists and activates only when the user asks what
changed or why.

## 11. Evaluation

### 11.1 Corpus

`evals/input/` holds twelve texts of 300–500 words, three per register, on mutually
distinct topics. They are generated by **clean-context subagents given short, ordinary
prompts** — no prompt engineering:

> "Kapadokya'da 3 gün nasıl geçirilir, bir blog yazısı yaz."
> "Redis'te cache invalidation üzerine bir yazı yaz."
> "SaaS ürünümüz için landing page metni yaz."
> "Yapay zekânın eğitimdeki rolü üzerine bir makale girişi yaz."

The point is an honest baseline: what an LLM actually produces for a normal Turkish
user, not an imitation of it written by the skill's author.

`evals/human-reference/` holds excerpts of real human Turkish with source attribution,
as a north star for reading judgment.

### 11.2 rubric.md

Two parts.

**Countable signals**, verifiable by grep and not open to argument: em dash count → 0;
`-mektedir/-maktadır` → 0 outside academic; `-DIr` predicate ratio; sentence-length
mean **and standard deviation**; predicate pairs joined by `ve` (missed converb
opportunities); participle (`-en/-an/-dığı`) density as a branching proxy; inversion
rate; particle count; apostrophe errors; calque-idiom count; terminology-bucket
violations; and in repair mode, claims present in output but absent from input → 0.

**Reading questions**, which counting cannot reach: Did the first sentence pull me in?
Would I believe a human wrote this? Does the writer hold an opinion? Which sentence
smells like a template?

`evals/count.sh` computes the countable half. It reports; it does not decide.

### 11.3 Comparison

The same twelve inputs are also run through `turkce-humanizer`, giving a three-way
comparison — raw AI output / turkce-humanizer / turkish-humanify. The claim "better
than turkce-humanizer" is only made on that evidence.

## 12. Open decision: prose language experiment

Whether `SKILL.md` and the reference files should be written in English or Turkish is
an empirical question, not a matter of taste, and it is resolved by measurement before
the bulk of the content is written.

**Procedure.**

1. Build the eval corpus (§11.1).
2. Write the smallest real slice of the skill — `SKILL.md` plus
   `layer-2-sentence.md` — in both languages. The only variable is the language of the
   explanatory prose: rules, Turkish examples, file names, and ordering are identical.
3. Run all twelve inputs through both versions using clean-context subagents.
4. Score with the countable half of `rubric.md`, and with a **blind pairwise
   judgment**: a judge subagent that does not know which version produced which output
   is asked which reads as human-written.
5. Write the remaining five reference files in the winning language.

**Pre-registered tiebreaker.** If the difference is within noise, English wins —
because in that case there is no quality argument left, and the remaining criterion is
forkability. This rule is fixed before the experiment so the result cannot be
rationalised afterwards.

## 13. Build order

1. Repository scaffolding, plugin manifest, licence, README skeleton.
2. Eval corpus: twelve inputs via clean-context subagents; human-reference excerpts.
3. `rubric.md` and `count.sh`.
4. Language experiment (§12) → decision.
5. Remaining reference files in the winning language.
6. Full run over the corpus; three-way comparison against `turkce-humanizer`.
7. Iterate on whatever the rubric exposes.
8. README, CHANGELOG, publish to GitHub under the personal account.
