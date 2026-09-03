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

**Two things worth keeping from that pair.** It is the first concrete repair
anybody has written for Class C — *move the tail into the preverbal zone*, not
delete it — and it exposes a gap wider than Class C: **no section of
`layer-2-sentence.md` covers adverbial placement at all.** §3 decides which
single element takes the preverbal slot; nothing says where a purpose clause
belongs when it is not the focus. Searching that file for `diye`, `adverbial` or
`purpose clause` returns nothing. A is untouched in the unaided baseline and in
`v7`, `v9`, `v10`, `v11` and the competitor's output, which is what a rule
nobody has written looks like from the outside.

So Class C stays labelled and unmeasured. What would actually resolve it is a
parse — a real POS tagger giving verb position — not a better regex, and that is
a different-sized undertaking than this file was preparing for.

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
