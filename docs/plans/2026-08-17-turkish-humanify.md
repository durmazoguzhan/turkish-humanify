# turkish-humanify Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Claude skill that writes and repairs Turkish which reads as human-written, shipped as a Claude Code plugin, an `npx skills add` package, and a skillsllm.com entry.

**Architecture:** A thin `SKILL.md` router that picks a mode (write / repair), a register, and a voice, then applies three ordered layers — composition, sentence, surface — reading one reference file per layer at the moment of use. Quality is measured, not asserted: an eval corpus of real LLM-generated Turkish is scored by a rubric whose countable half is a shell script and whose reading half is human judgment.

**Tech Stack:** Markdown (skill content), Bash + GNU sed/awk (eval tooling), Git. No runtime dependencies — the skill is prose, and the tooling is POSIX shell.

**Spec:** `docs/design/2026-08-17-turkish-humanify-design.md` — read it before Task 1. Every task below argues from a section of it.

## Global Constraints

Copied verbatim from the spec. Every task's requirements implicitly include this section.

- **No fabrication.** No number, name, date, or claim that is not in the source or supplied by the user. Adding soul is not inventing detail.
- **Meaning is preserved.** Repair mode may restructure within the register dose, but every claim in the input survives in the output.
- **No forced translation** of technical terms. `endpoint` → "uç nokta" and `event-driven` → "olay güdümlü" are failure outputs.
- **No em dash (`—`) in skill output.**
- **No chat residue** — no emoji, no "Elbette!", no "Umarım yardımcı olmuştur".
- **Default output is the text and nothing else.** No preamble, no detection report.
- **English scaffolding, Turkish examples.** Folder names, file names, and explanatory prose in English (pending Task 6's decision for skill prose specifically); every example is Turkish. Turkish grammar terms stay Turkish with an English gloss on first use.
- **Git identity is local, never global.** This repo already has `user.email=durmazoguzhan@yahoo.com` in `.git/config`. Never run the `git_personal` / `git_work` aliases — they mutate global config. Verify before each commit: `git config --list --local | grep user.email`.
- **Subagents used for corpus generation, skill runs, and judging must have clean context.** A subagent that has read this plan or the spec cannot produce an honest baseline or an unbiased judgment.
- **Scratch files go to `.scratch/`** at the repository root, which is gitignored. Do not use `/tmp` — intermediate score tables are worth keeping until the task that consumes them is done.

---

## File Structure

| Path | Responsibility |
|---|---|
| `.claude-plugin/plugin.json` | Claude Code plugin manifest |
| `skills/turkish-humanify/SKILL.md` | Router: mode, register, voice, layer order, output contract |
| `skills/turkish-humanify/references/ai-tells.md` | Diagnosis checklist for repair mode |
| `skills/turkish-humanify/references/layer-1-structure.md` | Composition rules |
| `skills/turkish-humanify/references/layer-2-sentence.md` | Sentence architecture — the core |
| `skills/turkish-humanify/references/layer-3-surface.md` | Terminology, orthography, punctuation, numbers |
| `skills/turkish-humanify/references/registers.md` | Four registers and the dosage matrix |
| `skills/turkish-humanify/references/voices.md` | Five voice profiles + user-voice extraction |
| `evals/rubric.md` | What "better" means: countable signals + reading questions |
| `evals/count.sh` | Computes the countable half. Reports, does not judge. |
| `evals/test-count.sh` | Asserts `count.sh` against a fixture with hand-verified counts |
| `evals/fixtures/known.md` | Fixture with hand-verified signal counts |
| `evals/signals/*.txt` | Phrase lists consumed by `count.sh` |
| `evals/input/` | Twelve LLM-generated Turkish baselines |
| `evals/human-reference/` | Real human Turkish excerpts, with attribution |
| `evals/output/` | Skill output, one subdirectory per version |
| `README.md`, `CHANGELOG.md`, `LICENSE` | Distribution |

---

### Task 1: Repository scaffolding and plugin manifest

Implements spec §4.

**Files:**
- Create: `.claude-plugin/plugin.json`
- Create: `LICENSE`
- Create: `.gitignore`
- Create: `README.md` (skeleton; filled in Task 12)
- Create: `skills/turkish-humanify/references/.gitkeep`
- Test: `scripts/check-structure.sh`

**Interfaces:**
- Consumes: nothing.
- Produces: the directory layout every later task writes into, and the plugin `name` field `turkish-humanify`, which is how Claude Code and `npx skills add` address the skill.

- [ ] **Step 1: Write the failing structure test**

Create `scripts/check-structure.sh`:

```bash
#!/usr/bin/env bash
# Asserts the repository layout that all three distribution channels expect.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

fail=0
check() { if eval "$1"; then echo "ok   $2"; else echo "FAIL $2"; fail=1; fi; }

check '[ -f .claude-plugin/plugin.json ]'                 "plugin manifest exists"
check 'node -e "JSON.parse(require(\"fs\").readFileSync(\".claude-plugin/plugin.json\",\"utf8\"))"' \
                                                          "plugin manifest is valid JSON"
check '[ "$(node -p "require(\"./.claude-plugin/plugin.json\").name")" = turkish-humanify ]' \
                                                          "plugin name is turkish-humanify"
check '[ -d skills/turkish-humanify/references ]'         "skill directory exists"
check '[ -f LICENSE ]'                                    "LICENSE exists"
check '[ -f README.md ]'                                  "README exists"

exit $fail
```

Make it executable: `chmod +x scripts/check-structure.sh`

- [ ] **Step 2: Run it to verify it fails**

Run: `./scripts/check-structure.sh`
Expected: FAIL lines for the manifest, skill directory, and LICENSE.

- [ ] **Step 3: Create the plugin manifest**

`.claude-plugin/plugin.json`:

```json
{
  "name": "turkish-humanify",
  "version": "0.1.0",
  "description": "Writes and repairs Turkish that reads as human-written: native sentence architecture, register-aware intervention, and technical terms left intact",
  "author": {
    "name": "Oguzhan Durmaz",
    "email": "durmazoguzhan@yahoo.com"
  },
  "homepage": "https://github.com/durmazoguzhan/turkish-humanify",
  "repository": "https://github.com/durmazoguzhan/turkish-humanify",
  "license": "MIT",
  "keywords": ["turkish", "turkce", "writing", "humanizer", "localization", "skills"]
}
```

- [ ] **Step 4: Create LICENSE, .gitignore, README skeleton, and the skill directory**

`LICENSE`: MIT, copyright line `Copyright (c) 2026 Oguzhan Durmaz`.

`.gitignore`:

```
.DS_Store
node_modules/
.scratch/
```

`README.md` skeleton — three headings only, no content yet (Task 12 fills them):

```markdown
# turkish-humanify

## What it does

## Install

## How it works
```

Then: `mkdir -p skills/turkish-humanify/references && touch skills/turkish-humanify/references/.gitkeep`

- [ ] **Step 5: Run the test to verify it passes**

Run: `./scripts/check-structure.sh`
Expected: every line `ok`, exit 0.

- [ ] **Step 6: Commit**

```bash
git config --list --local | grep user.email   # must print durmazoguzhan@yahoo.com
git add .claude-plugin LICENSE .gitignore README.md scripts skills
git commit -m "chore: repository scaffolding and plugin manifest"
```

---

### Task 2: The measuring instrument — rubric.md, count.sh, and its fixture test

Implements spec §11.2. Built **before** the corpus, so the corpus can be validated with it.

**Files:**
- Create: `evals/rubric.md`
- Create: `evals/count.sh`
- Create: `evals/test-count.sh`
- Create: `evals/fixtures/known.md`
- Create: `evals/signals/calques.txt`, `evals/signals/forced-translations.txt`, `evals/signals/particles.txt`

**Interfaces:**
- Consumes: Task 1's directory layout.
- Produces: `evals/count.sh FILE...` printing one TSV row per file with the header
  `file words sentences len_mean len_sd em_dash mektedir dir_copula ve_per100 particles calque forced tilde pct_wrong bold bullets`.
  Tasks 3, 6 and 11 call it exactly this way.

- [ ] **Step 1: Write the fixture with hand-verified counts**

`evals/fixtures/known.md` — content is fixed; do not edit it, the expected numbers are computed from these exact bytes:

```markdown
# Fixture

Bu cümle kısa. Bu ikinci cümle biraz daha uzun oldu ve içinde bir bağlaç var.
Kullanım giderek artmaktadır. Bu yöntem son derece etkilidir.

Günün sonunda önemli olan şey buydu — yani hiçbir şey.

- Madde bir
- Madde iki
```

Hand-verified expectations, after headings, bullets, blank lines and standalone dashes are stripped for prose measurement:

| Signal | Expected | Why |
|---|---|---|
| words | 32 | 15 + 8 + 9 across the three prose lines |
| sentences | 5 | lengths 3, 12, 3, 5, 9 |
| len_mean | 6.4 | 32 / 5 |
| len_sd | 3.6 | population sd of {3,12,3,5,9} |
| em_dash | 1 | "buydu — yani" |
| mektedir | 1 | "artmaktadır" |
| dir_copula | 2 | "artmaktadır." and "etkilidir." |
| ve_per100 | 3.1 | one ` ve `, 32 words |
| particles | 1 | "yani" |
| calque | 1 | "günün sonunda" |
| forced | 0 | none present |
| tilde | 0 | none present |
| pct_wrong | 0 | no `41%`-style number |
| bold | 0 | no `**` |
| bullets | 2 | two list lines |

- [ ] **Step 2: Write the failing test**

`evals/test-count.sh`:

```bash
#!/usr/bin/env bash
# Asserts count.sh against a fixture whose counts were verified by hand.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

expected="words=32 sentences=5 len_mean=6.4 len_sd=3.6 em_dash=1 mektedir=1 dir_copula=2 ve_per100=3.1 particles=1 calque=1 forced=0 tilde=0 pct_wrong=0 bold=0 bullets=2"

row=$(./count.sh fixtures/known.md | tail -n 1)
read -r _file words sentences len_mean len_sd em_dash mektedir dir_copula \
        ve_per100 particles calque forced tilde pct_wrong bold bullets <<<"$row"

actual="words=$words sentences=$sentences len_mean=$len_mean len_sd=$len_sd em_dash=$em_dash mektedir=$mektedir dir_copula=$dir_copula ve_per100=$ve_per100 particles=$particles calque=$calque forced=$forced tilde=$tilde pct_wrong=$pct_wrong bold=$bold bullets=$bullets"

if [ "$actual" = "$expected" ]; then
  echo "ok   count.sh matches the hand-verified fixture"
else
  echo "FAIL count.sh disagrees with the fixture"
  echo "  expected: $expected"
  echo "  actual:   $actual"
  exit 1
fi
```

`chmod +x evals/test-count.sh`

- [ ] **Step 3: Run it to verify it fails**

Run: `./evals/test-count.sh`
Expected: FAIL — `./count.sh: No such file or directory`.

- [ ] **Step 4: Write the signal phrase lists**

`evals/signals/calques.txt` — one phrase per line, `#` comments allowed:

```
# Calqued idioms and empty intensifiers that mark English-shaped Turkish.
günün sonunda
değer katmak
kritik öneme sahip
hayati önem taşı
bir adım öteye taşı
oyunun kurallarını değiştir
ötesine geçen
son derece
oldukça önemli
büyük ölçüde
yadsınamaz
göz ardı edilemez
önemli bir rol oyn
dikkat çekici bir şekilde
sadece bir başlangıç
bilmeniz gereken her şey
kapsamlı bir rehber
giderek önem kazan
```

`evals/signals/forced-translations.txt`:

```
# Renderings that destroy meaning by translating a term that has no Turkish
# equivalent. Any hit is a hard failure, not a style note.
uç nokta
olay güdümlü
olay tabanlı mimari
son nokta
kap teknolojisi
yığın taşması
sıcak yeniden yükleme
bulut yerlisi
mikro hizmet
kaynak kod deposu
çekme isteği
dal birleştirme
```

`evals/signals/particles.txt`:

```
# Discourse particles. Their absence is the signal; count.sh reports presence
# so the reader can see whether the text has any speaking voice at all.
ise
işte
zaten
hani
yani
bir de
ki
canım
```

- [ ] **Step 5: Write count.sh**

`evals/count.sh`:

```bash
#!/usr/bin/env bash
# Counts the mechanically countable signals from rubric.md.
#
# This tool reports; it does not judge. Signals that need Turkish morphology
# (participle density, inversion rate, focus placement) are deliberately
# absent: grep cannot separate "zaman" from an -an participle, and a noisy
# number is worse than no number. Those live in the reading half of rubric.md.
#
# Usage: evals/count.sh FILE...
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
signals="$here/signals"

# Prose view: drop headings, list items, blank lines; drop standalone dashes
# so they are not counted as words.
prose() {
  sed -E '/^[[:space:]]*#/d; /^[[:space:]]*[-*+•]/d; /^[[:space:]]*$/d' "$1" \
  | sed -E 's/(^| )[—–]+( |$)/ /g'
}

count_re() { grep -oE "$1" "$2" 2>/dev/null | wc -l | tr -d ' '; }

count_list() {   # $1 = phrase list, $2 = target file
  local n=0 line hits
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    case "$line" in \#*) continue ;; esac
    hits=$(grep -oiF -- "$line" "$2" 2>/dev/null | wc -l | tr -d ' ')
    n=$(( n + hits ))
  done < "$1"
  echo "$n"
}

printf 'file\twords\tsentences\tlen_mean\tlen_sd\tem_dash\tmektedir\tdir_copula\tve_per100\tparticles\tcalque\tforced\ttilde\tpct_wrong\tbold\tbullets\n'

for f in "$@"; do
  words=$(prose "$f" | wc -w | tr -d ' ')

  read -r sentences len_mean len_sd < <(
    prose "$f" \
    | sed -E 's/([.!?…]+)([[:space:]]|$)/\1\n/g' \
    | awk '
        { n = split($0, w, " "); c = 0
          for (i = 1; i <= n; i++) if (w[i] ~ /[^[:punct:]]/) c++
          if (c > 0) { s++; t += c; a[s] = c } }
        END { if (s == 0) { print 0, 0, 0; exit }
              m = t / s
              for (i = 1; i <= s; i++) d += (a[i] - m) * (a[i] - m)
              printf "%d %.1f %.1f\n", s, m, sqrt(d / s) }'
  )

  em_dash=$(count_re '—|–' "$f")
  mektedir=$(count_re '(mekte|makta)dır' "$f")
  dir_copula=$(count_re '[a-zçğıöşü]{2,}(dır|dir|dur|dür|tır|tir|tur|tür)[[:space:]]*[.,;!?]' "$f")
  ve_raw=$(count_re ' ve ' "$f")
  particles=$(count_list "$signals/particles.txt" "$f")
  calque=$(count_list "$signals/calques.txt" "$f")
  forced=$(count_list "$signals/forced-translations.txt" "$f")
  tilde=$(count_re '~' "$f")
  pct_wrong=$(count_re '[0-9]+%' "$f")
  bold=$(( $(count_re '\*\*' "$f") / 2 ))
  bullets=$(grep -cE '^[[:space:]]*[-*+•] ' "$f" || true)

  if [ "$words" -gt 0 ]; then
    ve_per100=$(awk -v v="$ve_raw" -v w="$words" 'BEGIN { printf "%.1f", v * 100 / w }')
  else
    ve_per100=0.0
  fi

  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$(basename "$f")" "$words" "$sentences" "$len_mean" "$len_sd" \
    "$em_dash" "$mektedir" "$dir_copula" "$ve_per100" "$particles" \
    "$calque" "$forced" "$tilde" "$pct_wrong" "$bold" "$bullets"
done
```

`chmod +x evals/count.sh`

- [ ] **Step 6: Run the test to verify it passes**

Run: `./evals/test-count.sh`
Expected: `ok   count.sh matches the hand-verified fixture`

If a number disagrees, the fixture table in Step 1 is the authority — it was verified by hand. Fix `count.sh`, not the fixture.

- [ ] **Step 7: Write rubric.md**

`evals/rubric.md` states what "better" means. Two parts, both required — neither is sufficient alone.

Part one, **countable signals**, with the target for each and a note that `count.sh` produces them:

| Signal | Target | Applies to |
|---|---|---|
| `em_dash` | 0 | all registers |
| `mektedir` | 0 | all but academic |
| `dir_copula` | falling vs the input | all but academic |
| `len_sd` | ≥ 4.0, and higher than the input's | blog, technical, corporate |
| `ve_per100` | falling vs the input | all |
| `particles` | > 0 | blog only |
| `calque` | 0 | all |
| `forced` | 0 | all — a hit is a hard failure |
| `tilde`, `pct_wrong` | 0 | all |
| `bullets` | ≤ the input's | blog, corporate |
| claims added vs input | 0 | repair mode |

The "claims added" count is not mechanical; it is checked by reading input and output side by side and listing any number, name, date, or assertion in the output that is absent from the input. Any hit is a hard failure regardless of how good the prose reads.

Part two, **reading questions**, one paragraph each on why counting cannot reach them:

1. Did the first sentence pull me in, or did it announce the topic?
2. Would I believe a human wrote this?
3. Does the writer hold an opinion, or only report?
4. Which single sentence smells most like a template, and why?
5. If I read only the last paragraph, does it earn its place or restate the piece?

- [ ] **Step 8: Commit**

```bash
git config --list --local | grep user.email
git add evals/
git commit -m "test: eval rubric, signal counter, and its fixture test"
```

---

### Task 3: Eval corpus — twelve LLM baselines and human reference excerpts

Implements spec §11.1.

**Files:**
- Create: `evals/input/blog-{1,2,3}.md`, `evals/input/technical-{1,2,3}.md`, `evals/input/corporate-{1,2,3}.md`, `evals/input/academic-{1,2,3}.md`
- Create: `evals/human-reference/*.md`
- Create: `evals/input/PROMPTS.md`

**Interfaces:**
- Consumes: `evals/count.sh` from Task 2.
- Produces: twelve input files that Tasks 6 and 11 run the skill over, and human reference excerpts that calibrate the reading questions.

- [ ] **Step 1: Generate the baselines with clean-context subagents**

Dispatch **twelve separate subagents**, each with clean context, each given only a short ordinary prompt — the kind a Turkish user actually types. No prompt engineering, no mention of this project, no style guidance. That is the whole point: the baseline must be honest LLM Turkish, not an imitation of it.

The twelve prompts, one per subagent:

```
blog-1       Kapadokya'da 3 gün nasıl geçirilir, bir blog yazısı yaz.
blog-2       Evde kahve demlemeyi ciddiye almak üzerine bir yazı yaz.
blog-3       Tek başına seyahat etmek hakkında bir blog yazısı yaz.
technical-1  Redis'te cache invalidation üzerine bir yazı yaz.
technical-2  Mikroservislerde dağıtık transaction yönetimini anlatan bir yazı yaz.
technical-3  Git rebase ile merge arasındaki farkı anlatan bir yazı yaz.
corporate-1  SaaS ürünümüz için landing page metni yaz.
corporate-2  Yeni açılan kahve dükkanımız için Instagram tanıtım metni yaz.
corporate-3  Şirketimizin uzaktan çalışma politikasını duyuran bir e-posta yaz.
academic-1   Yapay zekânın eğitimdeki rolü üzerine bir makale girişi yaz.
academic-2   Kentleşmenin sosyal ilişkiler üzerindeki etkisi hakkında bir makale özeti yaz.
academic-3   Uzaktan eğitimin öğrenci motivasyonuna etkisi üzerine bir literatür taraması girişi yaz.
```

Ask each for roughly 300–500 words. Save each response verbatim to its file — do not edit, do not improve, do not shorten. An edited baseline is a corrupted baseline.

Record the exact prompts in `evals/input/PROMPTS.md` with a one-paragraph note explaining why they are deliberately short.

- [ ] **Step 2: Verify the baselines actually exhibit AI tells**

Run: `./evals/count.sh evals/input/*.md | column -t`

Expected, and this is the real test of the corpus: across the twelve files, `em_dash`, `mektedir`, `calque` and `ve_per100` are visibly elevated, `particles` is at or near zero for the blog files, and `len_sd` is low (uniform sentence length). If the baselines look clean, either the corpus is not representative or `count.sh` is broken — investigate before continuing. Record the table in `evals/input/PROMPTS.md` under a "Baseline signals" heading.

- [ ] **Step 3: Collect human reference excerpts**

Save 4–6 excerpts of real Turkish writing, one file each, in `evals/human-reference/`. Each file starts with a YAML front matter block carrying attribution:

```yaml
---
source: https://www.getmidas.com/midasin-kulaklari/bir-zamanlar-frigyada-kral-midas-kimdir-p-7966
publisher: Midas
register: blog
retrieved: 2026-08-17
---
```

Cover at least blog and technical register. Sources already identified during design: getmidas.com (Midas'ın Kulakları and Midas Akademi), bizevdeyokuz.com, gezimanya.com, eventmag.co. Keep each excerpt short — a few paragraphs, quoted for evaluation purposes, always with the source link.

- [ ] **Step 4: Calibrate the instrument against human writing**

Run: `./evals/count.sh evals/human-reference/*.md | column -t`

Expected: `em_dash` and `calque` near zero, `len_sd` clearly higher than the baselines, `particles` present in the blog excerpts. This is a falsifiable check on `count.sh` itself — if the instrument says real Turkish blogs look machine-written, the instrument is wrong and must be fixed before any of it is trusted. Record the table in a `## Calibration` section of `evals/rubric.md`.

- [ ] **Step 5: Commit**

```bash
git config --list --local | grep user.email
git add evals/input evals/human-reference evals/rubric.md
git commit -m "test: eval corpus — twelve LLM baselines and human reference excerpts"
```

---

### Task 4: v0 skill slice, English prose

Implements spec §5 and §6.1. This is one arm of the Task 6 experiment.

**Files:**
- Create: `skills/turkish-humanify/SKILL.md`
- Create: `skills/turkish-humanify/references/layer-2-sentence.md`

**Interfaces:**
- Consumes: nothing from earlier tasks at runtime; the skill is self-contained prose.
- Produces: a working skill entry point. Task 5 mirrors these two files exactly. Task 6 runs both. Tasks 7–10 extend whichever wins.

- [ ] **Step 1: Write SKILL.md**

Front matter follows the convention verified against installed skills:

```markdown
---
name: turkish-humanify
description: Use when writing or repairing Turkish text that must read as human-written — blog posts, technical writing, marketing copy, or academic prose. Applies native Turkish sentence architecture instead of English structure rendered in Turkish words.
---
```

Body covers, and nothing more — detail belongs in reference files:

1. **The problem in two sentences.** LLM Turkish is Turkish words in English architecture. This skill fixes the architecture, not the vocabulary.
2. **Mode.** User supplied text → repair. User supplied a brief → write. State explicitly that write mode is *not* draft-then-humanise: composition decisions come first, sentence rules apply during generation.
3. **Register.** The four options with a one-line identification cue each. Until Task 10 exists, inline the dosage matrix from spec §7 here and mark it as moving to `references/registers.md`.
4. **Layer order.** structure → sentence → surface. Until Tasks 7 and 9 exist, only the sentence layer is live; say so.
5. **Reading rule.** Read `references/layer-2-sentence.md` before rewriting a single sentence. Do not work from memory of it.
6. **Invariants.** The Global Constraints list above, verbatim.
7. **Output contract.** The text, nothing else.

Target length: 150 lines or fewer. If it grows past that, content is leaking out of a reference file.

- [ ] **Step 2: Write layer-2-sentence.md**

One subsection per phenomenon, in the order of spec §6.1's table. All fourteen are required:

branching direction · converb system (`ulaç`) · focus position · evidentiality (`-mIş`) · aorist vs `-yor` · `-DIr` inflation · `-mektedir` inflation · `devrik cümle` · discourse particles · pro-drop · noun-compound chains · `ki` clauses · length variance · passive bleed

Each subsection has exactly three parts:

- **The contrast**, one sentence naming what English does and what Turkish does instead.
- **At least two before/after pairs**, both sides in Turkish, drawn from spec §6.1 plus new ones. Label the sides `AI:` and `İnsan:`. Worked examples are what change model behaviour; an abstract instruction like "vary your sentences" does not.
- **When not to apply it.** Every rule has a domain. Inversion is wrong in a legal document; `-mIş` is wrong when the writer witnessed the event; dropping `-DIr` is wrong in a definition. A rule without its limit becomes a new tic.

Do not describe the register dosage here — that is `registers.md`'s job. This file states the grammar; the dosage decides how much of it runs.

- [ ] **Step 3: Verify the skill loads and runs**

Dispatch a clean-context subagent: point it at `skills/turkish-humanify/SKILL.md`, give it `evals/input/blog-1.md`, and ask it to follow the skill. Save output to `evals/output/v0-en/blog-1.md`.

Run: `./evals/count.sh evals/input/blog-1.md evals/output/v0-en/blog-1.md | column -t`
Expected: `em_dash` 0 in the output, `len_sd` higher than the input, `calque` and `forced` both 0. If `forced` is above 0 the skill is force-translating and the terminology rule needs strengthening even though it lives in a later task.

- [ ] **Step 4: Commit**

```bash
git config --list --local | grep user.email
git add skills/turkish-humanify evals/output/v0-en
git commit -m "feat: v0 skill slice — router and sentence layer, English prose"
```

---

### Task 5: v0 skill slice, Turkish prose

Implements spec §12 step 2. The other arm of the experiment.

**Files:**
- Create: `experiments/prose-language/tr/SKILL.md`
- Create: `experiments/prose-language/tr/references/layer-2-sentence.md`
- Create: `experiments/prose-language/en/` — a copy of Task 4's two files, so both arms sit side by side and neither is privileged by living in the "real" location

**Interfaces:**
- Consumes: Task 4's two files, translated.
- Produces: two complete, comparable skill slices for Task 6.

- [ ] **Step 1: Copy the English arm into the experiment directory**

```bash
mkdir -p experiments/prose-language/en/references
cp skills/turkish-humanify/SKILL.md experiments/prose-language/en/SKILL.md
cp skills/turkish-humanify/references/layer-2-sentence.md \
   experiments/prose-language/en/references/layer-2-sentence.md
```

- [ ] **Step 2: Write the Turkish arm**

Translate the explanatory prose of both files into Turkish. **Only the prose language changes.** The rules, their order, every Turkish example, the section headings' meaning, the file names, and the front matter `name` field are identical. Any other difference invalidates the experiment — it would no longer be a single-variable comparison.

The `description` front matter field is translated too, since it is prose the model reads.

- [ ] **Step 3: Verify the two arms differ in exactly one dimension**

Run:

```bash
diff <(grep -oE '^#{1,4} ' experiments/prose-language/en/references/layer-2-sentence.md | wc -l) \
     <(grep -oE '^#{1,4} ' experiments/prose-language/tr/references/layer-2-sentence.md | wc -l)
```

Expected: no output — the two files have the same number of headings, i.e. the same structure.

Then read both side by side and confirm every Turkish example string appears in both, byte for byte. Any example present in one arm and not the other is a defect.

- [ ] **Step 4: Commit**

```bash
git config --list --local | grep user.email
git add experiments/
git commit -m "test: two skill arms differing only in prose language"
```

---

### Task 6: Run the prose-language experiment and decide

Implements spec §12. This is a decision gate — Tasks 7 through 10 cannot start until it closes.

**Files:**
- Create: `evals/output/exp-en/*.md`, `evals/output/exp-tr/*.md`
- Create: `experiments/prose-language/RESULT.md`
- Modify: `skills/turkish-humanify/SKILL.md` and `references/layer-2-sentence.md` if Turkish wins

**Interfaces:**
- Consumes: Task 3's corpus, Task 5's two arms, Task 2's `count.sh`.
- Produces: a decision recorded in `RESULT.md` that Tasks 7–10 obey.

- [ ] **Step 1: Run both arms over all twelve inputs**

Twenty-four runs, each by a **clean-context subagent** that is told which arm directory to read and which input file to process, and nothing else. A subagent that knows an experiment is running will try to be impressive.

Outputs go to `evals/output/exp-en/<name>.md` and `evals/output/exp-tr/<name>.md`.

- [ ] **Step 2: Score the countable half**

```bash
mkdir -p .scratch
./evals/count.sh evals/input/*.md         | column -t > .scratch/base.txt
./evals/count.sh evals/output/exp-en/*.md | column -t > .scratch/en.txt
./evals/count.sh evals/output/exp-tr/*.md | column -t > .scratch/tr.txt
```

Record all three tables in `RESULT.md`.

- [ ] **Step 3: Blind pairwise judgment**

For each of the twelve inputs, build a pair with the arm labels stripped and the order randomised:

```bash
mkdir -p .scratch/blind
for f in evals/output/exp-en/*.md; do
  n=$(basename "$f")
  if [ "$(shuf -i 0-1 -n 1)" = 0 ]; then a=exp-en; b=exp-tr; else a=exp-tr; b=exp-en; fi
  echo "$n A=$a B=$b" >> .scratch/blind-key.txt
  { echo "## A"; cat "evals/output/$a/$n"; echo; echo "## B"; cat "evals/output/$b/$n"; } \
    > ".scratch/blind/$n"
done
```

Dispatch one clean-context judge subagent per pair. Give it only the pair file and one question: which of these two reads as written by a Turkish person rather than generated, and which specific sentences decide it. The judge must not be told what the arms are, that an experiment is running, or that a skill produced either text.

Tally the verdicts against `blind-key.txt`.

- [ ] **Step 4: Decide and record**

Write `experiments/prose-language/RESULT.md` containing: the three signal tables, the blind tally, the judges' cited sentences, and the decision.

Apply the pre-registered rule from spec §12, which was fixed before the experiment and is not open to reinterpretation now: **if the difference is within noise, English wins.** With twelve pairs, treat 8–4 or wider as a signal and 7–5 or narrower as noise. If Turkish wins, replace the two files under `skills/turkish-humanify/` with the Turkish arm.

- [ ] **Step 5: Commit**

```bash
git config --list --local | grep user.email
git add evals/output experiments/prose-language/RESULT.md skills/turkish-humanify
git commit -m "test: prose-language experiment result and decision"
```

---

### Task 7: layer-1-structure.md

Implements spec §6.2. Written in the language Task 6 selected.

**Files:**
- Create: `skills/turkish-humanify/references/layer-1-structure.md`
- Modify: `skills/turkish-humanify/SKILL.md` — activate the structure layer

**Interfaces:**
- Consumes: the prose language decided in Task 6.
- Produces: `references/layer-1-structure.md`, referenced by `SKILL.md`'s layer order.

- [ ] **Step 1: Write the file**

Seven sections, each following the same three-part shape as `layer-2-sentence.md` (contrast, at least two before/after pairs, when not to apply):

1. **Opening move** — replace "Günümüzde X giderek önem kazanmaktadır" with a question, a scene, an objection, or a number. Use the real example from the spec: *"Bir şey satın alırken önce neye bakarız? Etiketine değil mi?"* and the objection-opening from bizevdeyokuz: *"İlk gidişlerimde 'Paris'i biraz abartmıyorlar mı?' dediysem de..."*
2. **Paragraph skeleton** — break the topic-sentence → three-supports → summary loop; vary paragraph length; a one-sentence paragraph is allowed.
3. **Closing** — "Sonuç olarak X'in önemi yadsınamaz" is banned. Show four real closing moves: a turn, a recommendation, a question, and simply stopping.
4. **Titles** — replace the "X Nedir? Bilmeniz Gereken Her Şey" and "X: Kapsamlı Bir Rehber" templates. Contrast with the eventmag-style specific title.
5. **Bullet dependence** — convert lists back to prose where the content is not genuinely enumerable. Show one list-to-prose conversion in full.
6. **Bold and emoji inflation** — remove.
7. **Subheadings** — sentence-shaped and sentence-cased, never Title Case.

- [ ] **Step 2: Activate the layer in SKILL.md**

Change the layer-order section from "only the sentence layer is live" to structure → sentence, and add the reading rule for the new file.

- [ ] **Step 3: Verify against a blog input**

Dispatch a clean-context subagent over `evals/input/blog-2.md`, output to `evals/output/v1/blog-2.md`.

Run: `./evals/count.sh evals/input/blog-2.md evals/output/v1/blog-2.md | column -t`
Expected: `bullets` at or below the input's, `bold` at or below the input's, `calque` 0. Then read the output and answer reading questions 1 and 5 from `rubric.md` — the opening and closing are what this layer exists to fix.

- [ ] **Step 4: Commit**

```bash
git config --list --local | grep user.email
git add skills/turkish-humanify evals/output/v1
git commit -m "feat: composition layer"
```

---

### Task 8: layer-3-surface.md

Implements spec §6.3. The owner's hard constraint on technical terms lives here.

**Files:**
- Create: `skills/turkish-humanify/references/layer-3-surface.md`
- Modify: `skills/turkish-humanify/SKILL.md` — activate the surface layer
- Modify: `evals/signals/forced-translations.txt` — extend with anything discovered while writing

**Interfaces:**
- Consumes: the prose language from Task 6.
- Produces: `references/layer-3-surface.md`.

- [ ] **Step 1: Write the terminology section**

The three buckets from spec §6.3, each with a worked list, not a rule alone:

- **Kept verbatim** — `Elasticsearch`, `cache`, `endpoint`, `deploy`, `pipeline`, `event-driven`, `commit`, `container`, `merge`, `rebase`, `framework`, `middleware`. State the forbidden outputs explicitly: "uç nokta", "olay güdümlü". A reader who only skims must still see that these are banned.
- **Established Turkish exists — use it** — developer → geliştirici, marketplace → pazaryeri, validation → doğrulama, production → canlı ortam, feature → özellik, performance → performans.
- **Both acceptable, consistency is the rule** — cache/önbellek, database/veritabanı, server/sunucu. Show the first-occurrence pairing pattern with the real example: *"hisse başına kâr (earnings per share — EPS)"*.

State the test for which bucket a term falls into: does a Turkish word already exist that Turkish engineers actually say? If yes, bucket two. If the Turkish word exists only in dictionaries, bucket one.

- [ ] **Step 2: Write the suffix-follows-pronunciation section**

Turkish vowel harmony operates on how a word is *said*, not how it is spelled, and this is the most common LLM error in Turkish technical writing. Worked examples: `cache'i` (keş-i), `queue'yu`, `SQL'i` (es-kü-el), `JSON'ı` (ceyson), `Google'ın`, `Redis'i`.

Include the honest case: where pronunciation genuinely varies in the wild, both forms are defensible and the rule is internal consistency. A writer who says *sörç* writes `Elasticsearch'ü`; one who says *serç* writes `Elasticsearch'i`; nobody writes both in one text. Do not invent a single correct answer where usage has not settled — a fabricated rule is worse than a stated choice.

- [ ] **Step 3: Write the orthography, punctuation and number sections**

- **Apostrophe (`kesme işareti`)**: before inflectional suffixes on proper nouns (`Türkiye'de`, `Redis'i`), not before derivational suffixes (`Türkçe`, `Türklük`), on abbreviations (`TBMM'nin`, `MCP'yi`). Verify each rule against tdk.gov.tr while writing; carry a working subset, not the full manual.
- **`da/de`**: conjunction written separately, locative suffix joined. **`ki`**: conjunction separate, suffix joined.
- **Punctuation**: the em dash is not a Turkish explanatory mark — it belongs to dialogue and ranges. Replace with a semicolon, a connective (`böylece`, `bu sayede`, `ayrıca`), or a sentence break. State clearly that the Turkish semicolon is legitimate and must not be purged wholesale; what grates is the English `; and` chain.
- **Numbers**: `%41` with the sign leading, `1.250,75`, "yaklaşık" instead of `~`, `10 kat`.
- **Circumflex**: only where it disambiguates (`kâr`/`kar`, `hâlâ`/`hala`), never decorative.
- **Calque idiom dictionary**: mirror `evals/signals/calques.txt` so the skill and the counter agree on what a calque is.

- [ ] **Step 4: Activate the layer and verify**

Update `SKILL.md` to structure → sentence → surface, all three live.

Dispatch a clean-context subagent over `evals/input/technical-1.md`, output to `evals/output/v2/technical-1.md`.

Run: `./evals/count.sh evals/input/technical-1.md evals/output/v2/technical-1.md | column -t`
Expected: `forced` = 0, `em_dash` = 0, `tilde` = 0, `pct_wrong` = 0. Then read the output and confirm by eye that `Redis`, `cache` and similar terms survived untranslated and that their suffixes harmonise with pronunciation. `forced` above 0 is a hard failure — fix before committing.

- [ ] **Step 5: Commit**

```bash
git config --list --local | grep user.email
git add skills/turkish-humanify evals/signals evals/output/v2
git commit -m "feat: surface layer — terminology policy, orthography, punctuation"
```

---

### Task 9: registers.md and voices.md

Implements spec §7 and §8.

**Files:**
- Create: `skills/turkish-humanify/references/registers.md`
- Create: `skills/turkish-humanify/references/voices.md`
- Modify: `skills/turkish-humanify/SKILL.md` — move the inlined dosage matrix out, point at the two files

**Interfaces:**
- Consumes: the three layer files from Tasks 4, 7, 8 — the dosage matrix names their rules.
- Produces: `references/registers.md` and `references/voices.md`.

- [ ] **Step 1: Write registers.md**

The four registers, each with: how to recognise it in two lines, the dosage row from spec §7, and one worked example showing the *same* input sentence treated at two different doses so the difference is visible rather than asserted.

Reproduce the dosage matrix exactly as spec §7 gives it, including the rule that surface is always on because orthography and terminology are correctness, not style.

- [ ] **Step 2: Write voices.md**

Open with the nine observable dimensions from spec §8: address · mean sentence length and variance · preferred clause linkage · tense-mood distribution · particle density · terminology preference · inversion rate · paragraph length · concreteness.

Then the five profiles — `senli-benli anlatıcı`, `teknik anlatıcı`, `denemeci`, `kurumsal ama insan`, `nötr-resmi` — each specified as a value on all nine dimensions plus three to five real sentences in that voice. Never describe a voice with adjectives; "samimi" and "akıcı" carry no instruction.

Close with the user-voice extraction procedure: given a sample text, read off each of the nine dimensions and write them down as a profile before writing anything. State the failure mode explicitly — extracting the sample's *topic* instead of its *voice* is the mistake to avoid.

- [ ] **Step 3: Slim SKILL.md**

Remove the inlined dosage matrix; replace with a pointer to `references/registers.md` and `references/voices.md` and the reading rule. Confirm `SKILL.md` is still under 150 lines: `wc -l skills/turkish-humanify/SKILL.md`

- [ ] **Step 4: Verify voice selection changes the output**

Dispatch two clean-context subagents over the same input, `evals/input/blog-3.md`, one instructed to use `denemeci`, one `senli-benli anlatıcı`. Output to `evals/output/v3/blog-3-denemeci.md` and `evals/output/v3/blog-3-senli-benli.md`.

Run: `./evals/count.sh evals/output/v3/*.md | column -t`
Expected: the two rows differ visibly on `particles` and `len_mean` — `senli-benli` should carry more particles. If the two outputs are near-identical, the voice profiles are not specific enough to bite, and the fix is more concrete example sentences, not more adjectives.

- [ ] **Step 5: Commit**

```bash
git config --list --local | grep user.email
git add skills/turkish-humanify evals/output/v3
git commit -m "feat: register dosage matrix and voice profiles"
```

---

### Task 10: ai-tells.md and final SKILL.md wiring

Implements spec §5's repair path.

**Files:**
- Create: `skills/turkish-humanify/references/ai-tells.md`
- Modify: `skills/turkish-humanify/SKILL.md` — final router, all six references wired
- Delete: `skills/turkish-humanify/references/.gitkeep`

**Interfaces:**
- Consumes: all five reference files.
- Produces: the complete skill.

- [ ] **Step 1: Write ai-tells.md**

A fast diagnostic pass for repair mode: read the text once and mark what is present, before any rewriting starts. Each entry is one line — the tell, and which layer file fixes it. This file is a router into the other five, not a fifth copy of their content.

Cover, at minimum: em dash for explanation · `-mektedir` · `-DIr` as default copula · uniform sentence length · zero particles · zero inversion · "sadece X değil aynı zamanda Y" · topic-sentence paragraph loop · "Günümüzde..." opening · "Sonuç olarak..." closing · bullet dependence · bold inflation · Title Case headings · calqued idioms · forced term translations · `~` and `41%` · passive bleed · noun-compound chains.

- [ ] **Step 2: Finalise SKILL.md**

Confirm the router covers the full flow from spec §5 — mode, register, voice, layers, gate, output — and that each of the six reference files is named with an explicit instruction to read it at the moment of use rather than from memory.

Add the silent self-check gate: before emitting, verify the invariants (no em dash, no forced translation, no added claims, no chat residue) and, in repair mode, that every claim in the input survives.

Add the explanation mode required by spec §10, which no earlier task has built: default output is the text alone, and only when the user asks what changed or why does the skill report — naming the tell it found, the layer that fixed it, and the before/after pair. It never volunteers this. Write the trigger as a condition on the user's request, not as an option the skill may exercise on its own judgment.

- [ ] **Step 3: Verify the whole skill on one input per register**

Four clean-context subagents, one each over `blog-1`, `technical-2`, `corporate-1`, `academic-1`, output to `evals/output/v4/`.

Run: `./evals/count.sh evals/input/{blog-1,technical-2,corporate-1,academic-1}.md evals/output/v4/*.md | column -t`
Expected per `rubric.md`: `em_dash` 0, `calque` 0, `forced` 0, `len_sd` up on all four, `mektedir` 0 except possibly `academic-1`, `particles` above 0 for `blog-1` only.

- [ ] **Step 4: Commit**

```bash
git config --list --local | grep user.email
git rm skills/turkish-humanify/references/.gitkeep
git add skills/turkish-humanify evals/output/v4
git commit -m "feat: repair-mode diagnostics and complete router"
```

---

### Task 11: Full corpus run and three-way comparison

Implements spec §11.3. This is where the claim "better than turkce-humanizer" is either earned or dropped.

**Files:**
- Create: `evals/output/v5/*.md` (twelve files)
- Create: `evals/output/turkce-humanizer/*.md` (twelve files)
- Create: `evals/RESULTS.md`

**Interfaces:**
- Consumes: the complete skill, the corpus, `count.sh`, `rubric.md`.
- Produces: `evals/RESULTS.md`, the evidence README claims rest on.

- [ ] **Step 1: Install the comparison skill outside this repo**

```bash
mkdir -p .scratch
git clone https://github.com/bushrabeg/turkce-humanizer .scratch/turkce-humanizer
```

It is a comparison target, not a dependency — it must not be committed into this repository.

- [ ] **Step 2: Run both skills over all twelve inputs**

Twenty-four clean-context subagents. Ours writes to `evals/output/v5/`, `turkce-humanizer` to `evals/output/turkce-humanizer/`. Each subagent is pointed at one skill directory and one input file and told nothing else.

- [ ] **Step 3: Score all three columns**

```bash
./evals/count.sh evals/input/*.md                   > .scratch/c-base.tsv
./evals/count.sh evals/output/turkce-humanizer/*.md > .scratch/c-th.tsv
./evals/count.sh evals/output/v5/*.md               > .scratch/c-ours.tsv
```

- [ ] **Step 4: Blind three-way reading**

For each input, build a shuffled triple with labels stripped, using the same key-file pattern as Task 6 Step 3. Dispatch one clean-context judge per triple: rank the three by which reads as written by a Turkish person, and name the sentences that decide it. The judge is not told what produced any of them.

- [ ] **Step 5: Check the fidelity invariant**

For each of the twelve pairs, read input and `v5` output side by side and list every number, name, date, or assertion present in the output but absent from the input. The target is zero. A file that reads beautifully and invents a statistic has failed, and failing this check outranks winning the blind ranking.

- [ ] **Step 6: Write RESULTS.md**

Three signal tables, the blind ranking tally with cited sentences, the fidelity check, and an honest verdict. If we did not beat `turkce-humanizer` on a given register, say so and name what to fix. A results file that only records wins is not evidence.

- [ ] **Step 7: Fix what the rubric exposed, then re-run**

Any hard failure — `forced` above 0, an added claim, an em dash — is fixed in the relevant reference file and Steps 2 through 6 are repeated for the affected register. Iterate until every hard failure is zero.

- [ ] **Step 8: Commit**

```bash
git config --list --local | grep user.email
git add evals/output evals/RESULTS.md skills/
git commit -m "test: full corpus run and three-way comparison"
```

---

### Task 12: README, CHANGELOG, and publication

Implements spec §4's distribution requirement.

**Files:**
- Modify: `README.md`
- Create: `CHANGELOG.md`
- Modify: `.claude-plugin/plugin.json` — version to `1.0.0`

**Interfaces:**
- Consumes: `evals/RESULTS.md` for every quality claim.
- Produces: a published repository.

- [ ] **Step 1: Write README.md**

Fill the three headings from Task 1 and add install instructions for all three channels:

```markdown
## Install

**Claude Code plugin**
/plugin install turkish-humanify@durmazoguzhan

**Skills CLI**
npx skills add durmazoguzhan/turkish-humanify --skill turkish-humanify

**Manual**
Copy skills/turkish-humanify/ into ~/.claude/skills/
```

Every quality claim must cite `evals/RESULTS.md`. Do not write "better than turkce-humanizer" unless the results file says so for the register in question. Include a short section on adapting the repo for another language — the layer split is the reusable part, and that reuse was the reason the scaffolding is in English.

- [ ] **Step 2: Write CHANGELOG.md**

`1.0.0` entry listing the skill's capabilities and pointing at the design doc and the results file.

- [ ] **Step 3: Verify structure and eval tooling still pass**

```bash
./scripts/check-structure.sh && ./evals/test-count.sh
```
Expected: all `ok`, exit 0.

- [ ] **Step 4: Bump the version and commit**

```bash
git config --list --local | grep user.email
git add README.md CHANGELOG.md .claude-plugin/plugin.json
git commit -m "docs: README, changelog, and 1.0.0"
```

- [ ] **Step 5: Publish to the personal account**

Confirm with the owner before this step — publishing is outward-facing and irreversible in effect.

```bash
gh repo create durmazoguzhan/turkish-humanify --public --source=. --remote=origin --push
```

Verify afterwards that the pushed commits carry `durmazoguzhan@yahoo.com`:

```bash
git log --format='%an <%ae>' | sort -u
```
Expected: one line only, the personal identity.
