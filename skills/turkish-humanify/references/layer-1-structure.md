# Layer 1 — Composition

The sentence layer fixes how clauses attach. This layer fixes what the piece
*is*: where it starts, how it moves, where it stops, and how much scaffolding
it wears.

It matters more than it looks. Measured against published Turkish writing, the
loudest single signal in machine Turkish is not a word choice — it is
structural furniture. One landing page in the corpus carries twenty bold spans
and five bullet lines; the human reference texts carry zero to one bold and no
bullets at all. Nobody reads a paragraph and thinks "too many bold spans", but
everybody feels the page was assembled rather than written.

Labels: `AI:` is what comes out unaided. `İnsan:` is what a Turkish writer
would put there.

---

## 1. The opening move

Machine Turkish announces its topic. Turkish writing starts the piece. The
difference is not enthusiasm; it is that an announcement is a sentence about
the article, and a start is the article.

Four moves that work, all taken from real Turkish writing: a **question**, a
**scene**, an **objection**, a **number**.

> AI: Bilgi ve iletişim teknolojilerindeki gelişmeler, öğrenmenin fiziksel sınıfla kurduğu geleneksel bağı köklü biçimde dönüştürmüştür.
> İnsan (soru): Bir şey satın alırken önce neye bakarız? Etiketine değil mi?

> AI: Tek başına seyahat etmenin pek çok faydası bulunmaktadır.
> İnsan (itiraz): İlk gidişlerimde "Paris'i biraz abartmıyorlar mı?" dediysem de Fransa'da yaşadığım iki senenin ardından bugün bana "Avrupa'nın bir başkenti olsaydı neresi olurdu?" diye sorsanız gözüm kapalı Paris derdim.

> AI: Kapadokya, Türkiye'nin en çok ziyaret edilen bölgelerinden biridir ve pek çok tarihi yapıya ev sahipliği yapmaktadır.
> İnsan (sahne): Sabahın dördünde kalkmak kulağa işkence gibi geliyor. Balonlar havalanırken vadiye bakınca geliyor mu, orası ayrı.

**Where it stops.** An academic abstract, a legal notice and a policy email
are supposed to state their subject in the first sentence; that is the form
working, not a tell. Judge the opening against what the register promises the
reader, not against a preference for drama. And a question opening that the
piece never answers is worse than a flat announcement.

---

## 2. The paragraph skeleton

Machine Turkish writes the same paragraph repeatedly: a topic sentence, three
supporting sentences, a closing sentence that restates the topic. It is a
competent shape and its repetition is the problem — four of them in a row and
the reader stops hearing a person.

Real Turkish prose varies paragraph length hard. A one-sentence paragraph is
allowed and is often where the piece turns.

> AI: Evde kahve demlemek dikkat gerektiren bir uğraştır. Öncelikle taze çekirdek kullanmak gerekir. İkinci olarak öğütme kalınlığı yönteme göre ayarlanmalıdır. Son olarak su sıcaklığı doğru aralıkta tutulmalıdır. Bu üç unsura dikkat edildiğinde sonuç belirgin biçimde iyileşir.
>
> İnsan: Taze çekirdek, ona uygun öğütme, doğru sıcaklıkta su. Liste bu kadar.
>
> Üçü de para değil, dikkat istiyor. İşin ciddiye alınacak tarafı da burası zaten, ekipman değil.

**Where it stops.** Procedural writing — a runbook, a recipe, a migration
guide — genuinely wants uniform paragraphs, because the reader is scanning for
their step and irregular rhythm makes that harder. Do not break a structure
that is doing work.

---

## 3. The closing

The restating close is the composition tell that survives longest, because it
looks like good structure. "Sonuç olarak", "Özetle", "Görüldüğü üzere" followed
by a compressed replay of the piece.

Four closings that are not that: a **turn** (the last line reframes what came
before), a **recommendation**, a **question**, or simply **stopping** on the
last real thing you had to say.

> AI: Sonuç olarak, tek başına seyahat etmenin bireye kattığı deneyimler yadsınamaz.
> İnsan (dönüş): Tadı da güzel oluyor tabii. Ama asıl mesele o değil.

> AI: Özetle, doğru cache stratejisi verinin bayatlığa toleransına bağlıdır ve bu konuda dikkatli olunmalıdır.
> İnsan (öneri): Her durumda TTL'i güvenlik ağı olarak bırakın. Invalidation mantığınız er ya da geç bir senaryoyu kaçıracak.

**Where it stops.** An academic abstract closes with its contribution, a policy
email closes with next steps, a landing page closes with an ask. Those are
required moves. What is banned is the closing that adds nothing — the one you
could delete without losing information.

---

## 4. Titles

Machine Turkish reaches for two templates: `X Nedir? Bilmeniz Gereken Her Şey`
and `X: Kapsamlı Bir Rehber`. Both describe a category of article rather than
this article.

A Turkish title can be long, specific, and shaped like something a person
would say. From a real Turkish culture magazine:

> İnsan: Nişantaşı'nda Yeni Açılan Her Mekandan Haberi Olan Semt İnsanı Bu Aralar Hangi Mekanlara Gidiyor?

> AI: Kapadokya Gezi Rehberi: Bilmeniz Gereken Her Şey
> İnsan: Kapadokya'da 3 Gün: Balonu İkinci Güne Koyun

> AI: Cache Invalidation Nedir?
> İnsan: Redis'te veriyi koymak kolay, çıkarmak zor

**Where it stops.** Reference documentation and academic work want titles that
are findable, not memorable. `Fiyat-Kazanç Oranı (F/K) Nedir?` is the correct
title for an explainer somebody will search for. Do not trade discoverability
for voice in a text whose job is to be found.

---

## 5. Bullet dependence

English technical writing bullets by default. Turkish long-form prose does not,
and a list where prose belonged reads as an outline somebody forgot to write
up. Convert back whenever the items are not genuinely parallel, enumerable
things.

> AI:
> - **Taze çekirdek:** Kavrulma tarihine bakın, birkaç haftayı geçmemiş olsun.
> - **Öğütme:** Yönteme göre değişir; French press için kalın, filtre için orta.
> - **Su:** Kaynama noktasının hemen altı, kireçli su ekstraksiyonu köreltir.
>
> İnsan: Çekirdek alırken bakılacak tek şey paketin üstündeki kavrulma tarihi; yazmıyorsa o kahve ne zaman kavrulduğunu söylemek istemiyor demektir. Öğütme yönteme göre değişiyor, French press için kalın, filtre için orta. Su da öyle: kireçli musluk suyu ekstraksiyonu köreltir, kaynattıktan sonra otuz saniye beklemek çoğu demleme için yeterli.

**Where it stops.** A list is right when the items really are a set the reader
will scan or return to: prices, opening hours, prerequisites, an ordered
procedure. The travel piece in the corpus keeps its practical-notes list for
exactly this reason. The test is whether a reader would ever want to find one
item without reading the others.

---

## 6. Bold and emoji inflation

Bolding a phrase means "this one matters more than its neighbours". Twenty of
them in one page means nothing matters more than anything, and the page reads
as a slide deck.

Keep bold for the few phrases a reader must not miss. In prose, that is
usually zero to two per screen. Delete decorative emoji entirely; they are the
single fastest way to make Turkish marketing copy read as generated.

> AI: **Saniyeler içinde fatura kesin** — Müşterinizi seçin, kalemleri girin, gönderin. **e-Fatura** ve **e-Arşiv** entegrasyonu ile faturanız doğrudan **GİB'e** iletilir. ☕
> İnsan: Müşteriyi seçin, kalemleri girin, gönderin. Fatura e-Fatura ve e-Arşiv entegrasyonuyla doğrudan GİB'e gidiyor.

**Where it stops.** A landing page's primary call to action is genuinely
allowed to be bold, and a documentation page may bold the one warning that
prevents data loss. Emphasis is not banned; inflation is.

---

## 7. Subheadings

Machine Turkish headings are Title Case noun phrases: `Pratik Notlar Ve
Öneriler`, `Sonuç Ve Değerlendirme`. Turkish uses sentence case, and a heading
can be a sentence.

> AI: ## Cache Stampede Problemi Ve Çözüm Yöntemleri
> İnsan: ## Popüler bir key expire olduğu anda ne oluyor

> AI: ## Son Olarak
> İnsan: (delete it and let the last paragraph be the last paragraph)

Turkish capitalisation also has a trap that is not a style question: under a
default locale, uppercasing `i` produces dotless `I`, so `DENEYIM` instead of
`DENEYİM`. If headings are uppercased anywhere downstream — CSS
`text-transform`, a template, a slide — that transformation must be
locale-aware or it will be wrong in a way the source text does not reveal.

**Where it stops.** Where a house style mandates Title Case, follow the house
style. And in reference documentation, noun-phrase headings are usually better
than sentence headings, because they are what a reader scans for.

---

## Reading the layer as a whole

Two of these seven do most of the work: the opening move and the structural
furniture (bullets, bold, template headings). The opening decides whether the
reader believes a person is present; the furniture decides whether the page
looks written or assembled. The closing matters nearly as much and is the one
writers defend longest, because a summary feels like diligence.

The rest are corrections you can make in a single pass.
