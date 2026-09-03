---
purpose: hand-labelled sentences for an inversion counter that does not exist yet
added: 2026-09-04
issue: https://github.com/durmazoguzhan/turkish-humanify/issues/9
---

# Inversion fixture

`count.sh` does not measure inversion rate and says so in its own header:
morphology-dependent signals are left out because grep cannot separate *zaman*
from an `-an` participle, and a noisy number is worse than none. That stance is
right and this file does not change it.

What this file does is remove the excuse. Issue #9 reports "too much inversion"
and the project's one contribution rule is that a rule has to be measured, so
the report is currently unactionable in the direction it was written. Anyone who
builds the counter needs labelled data to validate it against, and building the
labels *after* building the counter is how a counter gets validated against its
own mistakes. So the labels are here first.

**Where they come from.** The competing skill `turkce-humanizer` reports its own
work: every file in `evals/output/turkce-humanizer/` names the sentence it
inverted, verbatim, in its analysis notes. That is an independent hand
annotation by a different author for a different purpose, which makes it better
evidence than anything this repository would produce by labelling its own
output. Nine of the twelve below are theirs.

**Three per class, deliberately.** A fixture is a tripwire, not a corpus: it
exists so a broken counter cannot pass, and the third example of a shape the
first two already cover buys nothing but maintenance. If a real counter later
disagrees with a sentence that is not here, that sentence gets added and the
disagreement gets written down — which is how the file grows for a reason
instead of by accumulation.

**One caution before anyone scores against this.** Turkish `devrik cümle` is not
a binary. *Kimse okumuyor bu yazıları* is plainly inverted; *Bedava değil
dağıtık sistemlerde tutarlılık* has a nominal predicate and no verb to move at
all. A counter that reports one number for both is measuring two things. The
three classes below are separated for that reason.

---

## Class A — verb fronted, material trails behind it

The canonical `devrik cümle`. The predicate is finite and something that would
normally precede it has been moved after it.

> Grafikte hiç çatal kalmaz, tek sıraya girer hepsi.
> Invalidation mantığınız ne kadar dikkatli kurulursa kurulsun, bir gün mutlaka kaçırırsınız bir senaryoyu.
> Tek başına yüzlerce megabaytlık fark yaratır bu yaklaşım.

## Class B — nominal predicate, no verb to move

These read as inverted and get called `devrik` by readers, but there is no
finite verb in them. A counter keyed on verb position will score every one of
them as canonical, and a counter keyed on "does the last word inflect like a
predicate" will score them as inverted. Whichever it does, it has to do it on
purpose.

> Bedava değil dağıtık sistemlerde tutarlılık.
> Bir tür sessiz deneycilik bu.
> Ciddiye almak, dikkat vermek demek aslında.

## Class C — post-verbal trailing material, which is not inversion

This is the class issue #9 is actually about, and it is the reason this file
separates the three. Nothing is fronted. The predicate lands mid-sentence and
what follows it is apposition, a colon-introduced expansion, or a verbless
`-mAk için` tail. Readers describe the result as *devrik* and as unfluent; a
verb-position counter would report it as neither.

The first is the output quoted in issue #9. The second is its source, for
contrast — same content, three units, each one closed.

> Tüm workspace'i taradığımda GET tek-sipariş varyantını (`mark-is-export/order-number/{orderNumber}`) çağıran tek yer çıktı: ErpService'in `OrderServiceClient.cs:41`'i, o da push aktarımı tuttuktan sonra siparişi işaretlemek için.

> - `mark-is-export/order-number/{orderNumber}` (**GET**, tek sipariş) → tek iç çağıran ErpService `OrderServiceClient.cs:41`; push aktarımı başarılı olunca işaretlemek için.

## Class D — negatives

Plainly verb-final. A counter that fires on any of these is over-reporting.

> Bu yöntem işe yaramıyor.
> Cache dolunca istekler yavaşladı.
> Her gece verileri tarayıp raporlayan bir sistem kurduk.

## A counter was attempted for Class C and is not being built

Recorded so nobody spends the effort twice. Class C's narrowest surface — a
sentence **ending** in a verbless purpose or manner tail, `-mAk için.`,
`üzere.`, `diye.`, `kaydıyla.` — is trivially greppable, so it was measured
before it was written:

| corpus | hits / sentences |
|---|---|
| published Turkish, `human-reference/` | **0 / 206** |
| unaided model Turkish, `input/` | 3 / 700 |
| this skill's repair output | 2 / 98 |
| `turkce-humanizer` output | 5 / 2157 |

Three reasons it stops there, and the third is the one that settles it.

**The base rate is too low to be a rate.** Zero observations in 206 published
sentences does not establish that the form is absent — the upper bound on a
0/206 rate is around 1.8 percent — it establishes that this corpus cannot tell
rare from absent. There is no band to compare an output against, which is the
whole method `registers.md` uses for `-mAktAdIr` and the semicolon.

**Most hits are not prose.** Of the five hits in the two model corpora, three sit
inside list items, which `count.sh`'s prose view already drops. The signal was
mostly rediscovering bullets.

**It cannot decide the cases it finds, which is not the same as finding the wrong
ones.** This paragraph used to say the regex confuses the defect with *correct*
Turkish, and gave *"Tereyağını kızdırdım, pul biberi son anda attım, yanmasın
diye."* as the clean positive. A reader disagreed, and the disagreement is the
useful part:

> A (in the corpus): Tereyağını kızdırdım, pul biberi son anda attım, **yanmasın diye.**
> B (a reader's version): Tereyağını kızdırdım, pul biberi **yanmasın diye** son anda attım.

B is the canonical placement — the purpose clause sits in the preverbal zone
modifying `attım`, and the sentence closes on its verb. A trails it. A is not
*wrong*: appending the reason as an afterthought is something people genuinely
say, and in a first-person kitchen story it reads as speech rather than as a
slip. But it is not obviously better than B either, and calling it "correct" was
overstating what anybody had established.

So the honest statement is narrower and it still holds. The regex finds A and it
finds *"…o da push aktarımı tuttuktan sonra siparişi işaretlemek için."*, and
**nothing in the match tells them apart** — not because one is right and the
other wrong, but because whether a trailing tail earns its place is a judgement
about register, about length, and about whether the tail is an afterthought or
the sentence's whole content. A count reports the shape and never the judgement,
which is `CONTRIBUTING.md`'s second rule arriving from a third direction.

**And then a third reading arrived, which is the actual finding.** Asked again,
the same reader preferred a version with `ve` in it, and the sentence now has
four defensible forms — one of which is the one this repository's own rules
prescribe, and it is arguably the worst of them:

| | |
|---|---|
| **A** — in the corpus | Tereyağını kızdırdım, pul biberi son anda attım, yanmasın diye. |
| **B** — canonical placement | Tereyağını kızdırdım, pul biberi yanmasın diye son anda attım. |
| **C** — the reader's second | Tereyağını kızdırdım **ve** pul biberi yanmasın diye son anda attım. |
| **D** — what `layer-2` §2 asks for | Tereyağını kızdır**ıp** pul biberi yanmasın diye son anda attım. |
| **E** — §2 and §9 together | Tereyağını kızdır**ıp** pul biberi **de** yanmasın diye son anda attım. |

Read them inside the paragraph they belong to, because that is where the answer
is: *"Sarımsaklı yoğurdu ezdim. […] Tabağa koyduğumda rengi doğruydu."* The
passage is a run of closed, completed steps.

**B is the tightest of the first three** — the comma keeps that clipped
step-by-step beat and the sentence closes on its verb. **C is slower and more
written**, and §2's own limit covers it exactly: *"`ve` is right when the two
clauses are genuinely parallel and you want the beat between them"*. Two pan
actions are genuinely parallel. **A** reads as speech and leaves the paragraph's
last clause dangling. **D** fuses two separate steps into one motion, and the
passage is about the steps.

That was as far as the analysis got before **E arrived and corrected it.** The
objection to D was that the converb fuses two steps into one motion. It does —
and a single `de` on the second element undoes it. `pul biberi de` marks the
pepper as a second thing alongside the butter, which is exactly the separation
`-ip` had collapsed.

And `de` is not an outside repair. It is the first item in §9's own list of
discourse particles, under the sentence *"machine Turkish has none of them"*. So
E satisfies three of this file's rules at once: §2's converb, the preverbal
purpose clause, and §9's particle.

**The finding is therefore not the one written above.** It is not that a rule
applied by the book degrades the sentence. It is that **§2 applied alone degrades
it and §2 applied with §9 improves it**, and nothing in this file says the
sections repair each other's side effects. "Reading the layer as a whole" says
two sections account for most of the work; it does not say a converb can flatten
a sequence and that a particle is what puts the sequence back.

That is a claim about how the layer is *read*, not about Turkish, and it is worth
more than the placement question that produced it. It is also unmeasured: five
readings of one sentence by one reader.

The "where it stops" observation survives at reduced strength. §2's `ve` limit
still has **no worked example** — the `-ip` same-subject limit has one (*Ben
geldim ve o gitti*), the three-converb warning has none, and "`ve` is sometimes
right" has none — and this sentence is still a candidate for it. It is a weaker
candidate now that the converb turns out to work here with one particle added.

**It cannot go into `layer-2-sentence.md`, and that is not a technicality.**
`blog-6` is in the evaluation corpus, and round eight established that a worked
example drawn from the corpus it is measured on stops being a test — the
generation after that fix returned the example's title verbatim. So the pair
lives here, where it is data, and not there, where it would become an answer key.

**Two things worth keeping from that pair.** It is the first concrete repair
anybody has written for Class C — *move the tail into the preverbal zone*, not
delete it — and it exposes a gap wider than Class C: **no section of
`layer-2-sentence.md` covers adverbial placement at all.** §3 decides which
single element takes the preverbal slot; nothing says where a purpose clause
belongs when it is not the focus. Searching that file for `diye`, `adverbial` or
`purpose clause` returns nothing. A is untouched in the unaided baseline and in
`v7`, `v9`, `v10`, `v11` and the competitor's output, which is what a rule
nobody has written looks like from the outside.

So Class C cannot be **counted**. That is not the same as unmeasurable, and this
paragraph used to say it was — "what would actually resolve it is a parse". It
was answered by a reader in one question.

## Class C measured by reading, 2026-09-04

Three clean-context readers, one text each, told nothing about this project or
about any shape being looked for. The question was deliberately open: *"kulağını
tırmalayan, doğal durmayan, Türkçe konuşan birinin öyle kurmayacağı cümle varsa
göster"* — quote it, say what bothers you, and if there is none say `yok`.

**Reader A**, given a five-line evidence fragment, named the Class C sentence
unprompted and named its mechanism:

> *"…o da aktarım onaylandıktan sonra işaretlemek için."* — "işaretlemek için" hem
> nesnesiz hem de **bağlanacağı yüklem yok**, cümle yarıda kesilmiş gibi duruyor

That is the diagnosis this file spent a probe failing to reach with a regex.

**Reader C**, given a runbook meant as a control, named a second instance —
which makes the control a failed one and the finding a stronger one:

> *"…teker teker sonlandır, toplu değil."* — Sondaki "toplu değil" İngilizcedeki
> "not in bulk" kuyruğunun birebir çevirisi gibi duruyor

Two unrelated texts, two readers, neither asked about tails, both landing on one.
The control was not clean and that is recorded rather than repaired, because a
clean control is what the next pass needs and pretending this one was clean is
worse than admitting it was not.

**Reader B is the result that matters most, because it is negative.** Given the
kitchen paragraph — the one this file has been arguing about — the reader found
**four** things wrong with it and walked straight past *"…yanmasın diye."*:

> "Sarımsaklı yoğurdu ezdim." — ezilen şey sarımsaktır, yoğurt değil
> "bazıları açıldı, içindeki kıyma…" — çoğulun ardından tekil "içindeki" tökezletiyor
> "Tabağa koyduğumda rengi doğruydu" — "the color was right" çevirisi kokuyor
> "Mantılar suya girdiğinde yüzeye çıkmalarını izledim" — "I watched them rise" kalıbı

A reader actively hunting for unnatural sentences, finding four, and not seeing
the trailing tail, has settled what four rounds of argument here could not: **A
is fine.** The forms B, C and E are refinements of a sentence that was not
broken.

**So the distinction is not "post-verbal material is bad".** It is length and
what the tail is. A short adverbial trailing a first-person narrative is
invisible. A verbless proposition trailing a reference document — a whole clause
that lost its predicate — is named on sight, by a stranger, in the first thing
they say. That is the shape issue #9 objected to, and it now has evidence.

**One thing the counters have never found, found here by accident.** Reader B's
first item is a semantic error in `evals/input/blog-6.md`: you crush the garlic,
not the yoghurt. It has been in the corpus through nine rounds, both skills'
outputs and every counting pass, unremarked.

## What would count as a working counter

Not a percentage. The thing `layer-2-sentence.md` §8 and `registers.md` actually
assert is a **dose** — "two or three across a whole piece" in blog, none in
technical — so the number that has to be measurable is a count per document,
with the three classes reported separately. A single blended rate would satisfy
the letter of the rule and tell nobody whether the skill is writing Class A in a
runbook.

And it has to be validated the way `count.sh` is: a case that the previous
version gets wrong, hand-computed expectations, and a note in the commit saying
how many corpus files move. Eight counting bugs went in before that discipline
existed and every one of them had already produced a confident wrong finding.
