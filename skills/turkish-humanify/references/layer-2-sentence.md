# Layer 2 — Sentence architecture

This is where Turkish stops being English with different words.

Fourteen places where the two languages genuinely diverge, and where an LLM
trained mostly on English structure reliably produces Turkish that parses but
does not read. Each entry states the contrast, shows worked pairs, and — this
part matters as much as the rule — says where the rule stops. A rule applied
without its limit becomes a new tic, and a text full of inversions is no more
human than a text with none.

Labels: `AI:` is what comes out unaided. `İnsan:` is what a Turkish writer
would put there. The pairs read as before/after, which suits repair, but they are
the same target either way: writing, `İnsan:` is what to produce; repairing, it
is what to produce instead.

**Suffixes are written with capital vowels standing for the whole harmony set**,
the usual Turkish convention. `-DIr` covers *-dır/-dir/-dur/-dür* and their
*t-* forms; `-mIş` covers *-mış/-miş/-muş/-müş*; `-mAktAdIr` covers both
*-maktadır* and *-mektedir*. Naming a suffix by one of its surface forms makes
a rule look like it applies to half the language — and it is not a theoretical
worry: `evals/count.sh` searched for the literal string `-maktadır` for four
rounds and reported every `-mektedir` as absent.

---

## 1. Branching direction

English is head-initial: the noun comes first and its modifiers trail behind
it, hooked on with relative pronouns, dashes and appositives. Turkish is
head-final. Everything that modifies a noun stands **in front of** it, built
with participles — `-en/-an`, `-dığı/-diği`, `-acak/-ecek`.

This is the single largest structural difference, and the one that produces
that unmistakable trailing-clause rhythm in machine Turkish.

> AI: Bir kural motoru geliştirdim — 55'ten fazla kural tipi içeren; bunu bir veri modeli üzerine kurdum.
> İnsan: Dinamik ve statik segmentler için 55'ten fazla kural tipi destekleyen bir segmentasyon modülünü uçtan uca geliştirdim.

> AI: Bir sistem kurduk, bu sistem her gece verileri tarayıp raporluyor.
> İnsan: Her gece verileri tarayıp raporlayan bir sistem kurduk.

> AI: Bir özellik ekledik ki kullanıcılar artık kendi şablonlarını kaydedebiliyor.
> İnsan: Kullanıcıların kendi şablonlarını kaydedebildiği bir özellik ekledik.

**Where it stops.** Turkish left-branching has a load limit that English
right-branching does not. Once the modifier stack in front of the head passes
roughly ten or twelve words, the reader is holding too much open and the head
arrives too late. At that point the fix is two sentences, not a longer front
stack. Nesting one participle inside another (`...eden ...dığı ...`) is where
this usually goes wrong.

---

## 2. The converb system (`ulaç`)

English joins clauses with *and*, *when*, *while*, *because*. Turkish can fuse
them into one verb chain with a suffix, so `ve` standing between two predicates
is usually a missed converb.

`-ip` same subject, sequential · `-erek/-arak` manner · `-ince/-ınca` when ·
`-dikçe` as / the more · `-meden` without · `-ken` while · `-diğinde` when ·
`-eli` since

> AI: Sistemleri kurar **ve** ölçeklerim.
> İnsan: Sistemleri kur**up** ölçeklerim.

> AI: Veriyi çektik **ve** sonra işledik.
> İnsan: Veriyi çek**ip** işledik.

> AI: Cache doldu **ve** istekler yavaşladı.
> İnsan: Cache dol**unca** istekler yavaşladı.

> AI: Trafik arttı **ve** buna bağlı olarak hatalar da arttı.
> İnsan: Trafik art**tıkça** hatalar da arttı.

**Where it stops.** `-ip` requires the same subject in both halves: *Ben geldim
ve o gitti* cannot become *gelip gitti*. Three converbs chained in one sentence
produce something nobody can read aloud. And `ve` is right when the two clauses
are genuinely parallel and you want the beat between them — the goal is to stop
reaching for it by reflex, not to ban it.

---

## 3. Focus position

Turkish marks emphasis by **position**. The slot immediately before the verb
carries the focus. Move a word there and you change what the sentence is about,
without changing a single word.

> Ben dün İzmir'e gittim. — neutral
> İzmir'e dün **ben** gittim. — it was *I* who went
> Ben İzmir'e **dün** gittim. — it was *yesterday*

> AI: Sıfırdan, AI destekli bir mikroservis tasarladım.
> İnsan: AI destekli bir mikroservisi **sıfırdan** tasarladım.

> AI: Hızlıca bu sorunu çözdük.
> İnsan: Bu sorunu **hızlıca** çözdük.

**Where it stops.** Do not mechanically push every adverb into the preverbal
slot. Ask what question the sentence answers; the answer goes there, and
nothing else does. An adverb parked before the verb that is not carrying the
emphasis actively misdirects the reader.

---

## 4. Evidentiality — `-mIş`

Turkish grammatically marks whether the speaker witnessed the event. `-DI` is
direct: I saw it, it happened, I did it. `-mIş` is everything else — heard,
inferred, discovered afterwards, or narrated as story. English has no
equivalent, so unaided LLM Turkish uses `-DI` for everything and narrative
comes out reading like a police report.

> AI: Kahinler kehanette bulundu.
> İnsan: Kahinler kehanette bulun**muş**.

> AI: O dönemde krallar Gordios olarak biliniyordu.
> İnsan: O dönemde krallar Gordios olarak bilin**ir**miş.

> AI: Sunucu gece yeniden başladı. — but you are reading this off a log, not remembering it
> İnsan: Sunucu gece yeniden başla**mış**.

> AI: Bütün gece çalıştılar. — you found out the next morning
> İnsan: Meğer bütün gece çalış**mışlar**.

**Where it stops.** If the writer was there, `-DI` is correct and `-mIş` is a
lie about the source of the knowledge. Writing about your own work takes `-DI`:
*Servisi .NET 8'e taşıdım*, never *taşımışım*. Legal and official texts do not
narrate events of record in `-mIş`.

---

## 5. Aorist versus `-yor`

English simple present covers both the habitual and the current. Turkish splits
them: `geniş zaman` (`-Ir/-Ar`) for properties, habits and general truths;
`-yor` for what is happening now or across a bounded current period. Mapping
English present onto `-yor` by default makes descriptions of how something
works sound like a live commentary.

> AI: Bu servis istekleri işl**iyor**. — describing what the service does
> İnsan: Bu servis istekleri işl**er**.

> AI: Redis veriyi bellekte tut**uyor**. — a general fact about Redis
> İnsan: Redis veriyi bellekte tut**ar**.

> AI: Yeni özellikler geliştir**iyor**, mimariye katkı ver**iyor**um. — a standing role
> İnsan: Yeni özellikler geliştir**ir**, mimariye katkı ver**ir**im.

**Where it stops.** `-yor` is right for a genuinely ongoing state, and in blog
register it often reads warmer and less lecture-like than the aorist: *Son
dönemde AI tarafına yöneliyorum* is correct as it stands. Converting every
`-yor` to an aorist produces an encyclopedic stiffness that is its own kind of
inhuman.

---

## 6. `-DIr` inflation

`-DIr` is not the Turkish copula. Turkish normally has **no** copula in the
present tense at all. `-DIr` marks generalisation, assumption, or formal
assertion, and using it as a default sentence-ender is one of the strongest
measurable machine signals in technical and academic Turkish.

> AI: Bu yöntem etkili**dir**.
> İnsan: Bu yöntem etkili.

> AI: Cache invalidation zor**dur**.
> İnsan: Cache invalidation zor iş.

> AI: Silme işlemi idempotent**tir**.
> İnsan: Silme işlemi idempotent.

> AI: Bu, sistemin en kritik parçası**dır**.
> İnsan: Burası sistemin en kritik parçası.

**Where it stops.** `-DIr` is correct and required in definitions, standards,
specifications and legal text — *Bu sözleşme iki nüsha olarak düzenlenmiştir* —
and in genuine assumption, where it means "presumably": *Şimdi evdedir.*
Stripping it out of a specification makes the specification wrong.

---

## 7. `-mAktAdIr` inflation

The `-mAktAdIr` form is bureaucratic present. It belongs to academic and
official registers and nowhere else, but LLM Turkish reaches for it whenever
the topic sounds serious.

> AI: Kullanım art**maktadır**.
> İnsan: Kullanım artıyor.

> AI: Bu çalışma, kentleşmenin etkilerini incele**mektedir**.
> İnsan (blog): Bu yazı kentleşmenin etkilerine bakıyor.

**Where it stops.** Academic Turkish genuinely uses it, and removing it from a
journal article makes the article sound like a blog post — which is a
different failure, not a fix. Keep it in academic register; remove it
everywhere else.

How much it uses it is measured, not guessed: 0.4 to 2.3 per 100 words across
five Turkish journal articles from 2015–2019. `registers.md` carries the band and
what happens on either side of it. Writing academic prose with none of this form
is as wrong as writing a blog post full of it.

---

## 8. `devrik cümle` — inversion

Turkish default order is verb-final, but speech, blog writing and literary
prose break it constantly, pulling the verb forward and letting a phrase trail
after it. Prose that is one hundred percent verb-final reads as generated,
because no Turkish person writes that way for a whole page.

> AI: Kimse bu yazıları okumuyor.
> İnsan: Kimse okumuyor bu yazıları.

> AI: Orası gerçekten güzeldi.
> İnsan: Güzeldi orası, gerçekten.

> AI: Bunu daha sonra konuşuruz.
> İnsan: Konuşuruz bunu sonra.

**Where it stops.** Inversion is wrong in technical documentation, legal text
and academic prose, where it reads as carelessness rather than voice. Even in
blog register it is a spice: two or three across a whole piece. An inverted
sentence that is not carrying emphasis is just a word-order error.

---

## 9. Discourse particles

`de/da` · `ise` · `ki` · `işte` · `zaten` · `hani` · `bir de` · `yani` · `ya` ·
`canım`

These carry tone, and machine Turkish has none of them. Their absence is why
text can be completely correct and still have nobody behind it.

> AI: Bu yöntem işe yaramıyor. Başka bir yol denemeliyiz.
> İnsan: Bu yöntem işe yaramıyor işte. Başka bir yol denemek lazım.

> AI: Birinci grup hızlı, ikinci grup yavaş.
> İnsan: Birinci grup hızlı, ikincisi ise yavaş.

> AI: Bu arada bir konu daha var.
> İnsan: Bir de şu var.

**Where it stops.** Particles are register-bound. `işte`, `hani` and `canım` in
a legal notice or an academic abstract are simply wrong. They also cannot be
sprinkled to hit a quota — a particle that is not doing tonal work is noise,
and noise reads as *trying* to sound human, which is worse than sounding
neutral.

---

## 10. Pro-drop

Turkish person endings already carry the subject, so the pronoun is dropped
unless it is doing work. English requires the pronoun, and that requirement
leaks through.

> AI: **Ben** bunu yaptım, sonra **ben** şunu ekledim.
> İnsan: Bunu yaptım, sonra şunu ekledim.

> AI: **Siz** eğer isterseniz **siz** bunu değiştirebilirsiniz.
> İnsan: İsterseniz değiştirebilirsiniz.

**Where it stops.** The pronoun stays when it contrasts — *Ben gittim, o kaldı*
— and when it is the focus, which is the case in §3: *İzmir'e dün ben gittim.*

---

## 11. Noun-compound chains

Turkish builds compounds by stacking nouns with possessive suffixes, and the
stack has a much lower ceiling than English noun-piling. Four nouns in a row
suffocates the phrase.

> AI: müşteri segmentasyon modülü performans iyileştirme çalışması
> İnsan: müşteri segmentasyon modülünde yaptığımız performans çalışması

> AI: kullanıcı davranış analiz raporu hazırlama süreci
> İnsan: kullanıcı davranışlarını analiz eden raporları nasıl hazırladığımız

Three linked nouns is the practical ceiling. Break longer chains with `-de` /
`-deki`, `için`, `ile`, or a participle.

**Where it stops.** Established multi-word terms are single units and must not
be taken apart: *bilgi işlem daire başkanlığı*, *gelir vergisi beyannamesi*,
*kurumlar vergisi oranı*. Breaking those does not simplify anything; it just
produces a phrase that names nothing.

---

## 12. `ki` clauses

Turkish has a native `ki`, but the right-branching relative `ki` — the one that
stands in for English *that* or *which* — is a calque. Turkish makes relative
clauses with participles, in front of the noun, per §1.

> AI: Bir sistem kurduk **ki** bu sistem her gece çalışıyor.
> İnsan: Her gece çalışan bir sistem kurduk.

> AI: Düşünüyorum **ki** bu doğru değil.
> İnsan: Bence bu doğru değil. / Bunun doğru olmadığını düşünüyorum.

**Where it stops.** Several `ki` constructions are entirely native and removing
them breaks the idiom: the intensifier (*Öyle yoruldum ki*), and the fixed
forms *belli ki*, *demek ki*, *ne var ki*, *oysa ki*, *sanmam ki*. Only the
relative `ki` that a participle could replace is the target.

---

## 13. Length variance

Turkish agglutination lets a single word be a whole clause — *Olmadı.*
*Gidebilseydik.* *Bilmiyorum.* — so Turkish prose can swing wider than English
between its shortest and longest sentence. Machine Turkish does the opposite:
every sentence lands in the same band, and the resulting flatness is the tell
readers notice first without being able to name it.

> AI: Bu yaklaşımı denedik ancak beklediğimiz sonucu alamadık ve bir süre sonra tamamen farklı bir yöntem üzerinde çalışmaya başladık. Ekip olarak bu kararın doğru olduğunu düşünüyoruz çünkü yeni yöntem hem daha hızlı hem de bakımı daha kolay bir çözüm sunuyor.
>
> İnsan: Bu yaklaşımı denedik. Olmadı. Bir süre sonra bambaşka bir yöntemin üzerine oturduk — ekip olarak da doğru karar olduğunu düşünüyoruz, çünkü yenisi hem daha hızlı çalışıyor hem de bakımı bizi daha az yoruyor.

**Where it stops.** Do not manufacture staccato in academic or legal register.
There the variance comes from clause structure, not from one-word sentences;
a lone *Olmadı.* in a journal article is a register error.

---

## 14. Passive bleed

Academic Turkish prefers the passive, and that preference leaks into every
other register, where it drains the agent out of sentences that need one.

> AI: Cache temizlenmeli ve veri yeniden yüklenmelidir.
> İnsan: Cache'i temizleyin, veriyi yeniden yükleyin.

> AI: Bu sorun tarafımızdan çözülmüştür.
> İnsan: Bu sorunu çözdük.

> AI: Segmentasyon modülü geliştirilmiştir.
> İnsan: Segmentasyon modülünü geliştirdim.

**Where it stops.** Academic and official Turkish genuinely use the passive as
a convention of the form, and converting a methods section to the active voice
makes it read as an unpublishable draft.

---

## 15. Self-correction — `öz-düzeltme`

English prose revises before it is published, and the revision is invisible.
Turkish writing that reads as written by a person often shows the revision: the
writer says something, then narrows it in the next breath. Machine Turkish
never does this, because it writes as though it already knew.

This is the device that blind readers reach for most often when they explain
why one Turkish text feels human and another does not.

Forms: `Daha doğrusu, …` · `Ya da şöyle söyleyeyim, …` · `Daha dikkatli
söylemek gerekirse, …` · `Ya da değildi, bilmiyorum` · `Aslında tam öyle de
değil`

> AI: Silme işlemi idempotenttir, bu yüzden tercih edilir.
> İnsan: Silme idempotent olduğu için tercih ediliyor. Daha doğrusu, güncellemek de çalışır; ama yanlış gittiğinde sessizce yanlış gider.

> AI: Dün fazla keskindi, su çok sıcaktı belki.
> İnsan: Dün fazla keskindi. Su çok sıcak olmuş olabilir. Ya da değildi, bilmiyorum.

> AI: Bu yöntem her ölçekte çalışır.
> İnsan: Bu yöntem çalışıyor. Daha doğrusu, çoğu durumda çalışıyor.

Note what the third pair does: it **narrows a claim the source already made**.
That is the fidelity-safe form of this device and the one to reach for. The
correction qualifies, hedges, or admits uncertainty about something already in
the text. It never introduces anything.

**Where it stops.** Three limits, and the first is the one that gets broken.

*The correction must correct something.* Blind readers penalise a hollow one as
sharply as they reward a real one — *"hiçbir düzeltme getirmeyen ara cümle"*,
*"araya sıkıştırılmış, akışı bozan yapay bir samimiyet eki"*. If the second
clause restates the first, delete both halves of the move.

*The corrected claim must still be the source's claim.* Narrowing what is there
is a rewrite; widening it, or correcting toward something new, is fabrication
wearing a rhetorical costume.

*Register.* Wrong in academic and official writing entirely — an abstract that
second-guesses itself has lost its authority, and a reader will say so. At most
once or twice across a blog or technical piece.

## 16. Sprinkling — how this layer fails

The other fourteen sections tell you what to do. This one tells you how doing
it goes wrong, and it is not hypothetical: in a blind comparison, judges who
did not know a skill was involved diagnosed exactly this in output produced by
these rules.

> "bunlar sonradan uygulanmış devrik dokunuşlar gibi duruyor; iskelet neredeyse birebir aynı kalmış"
> "samimiyet sonradan serpiştirilmiş gibi duruyor"
> "'Ne o olur, ne bu.' zaten söyleneni tekrar eden, yerine oturmamış bir deyim eklentisi"
> "'Peki hangisi doğru? …' kalıbı yapay bir soru-cevap tikine benziyor"

Every one of those is a device from this file, applied where it was not doing
work. The reader does not experience them as voice; they experience them as
retouching.

### The bookend failure

A machine draft opens with a personal note, goes impersonal for the middle
eighty percent, and closes with a flourish. Applying this layer only to the
first and last paragraphs reproduces that shape exactly — and it is worse than
applying nothing, because the contrast between the lively edges and the flat
middle is itself the tell.

If the sixth paragraph reads the same as the input's sixth paragraph, the layer
did not run. Check the middle first.

### The test for any device

Delete it. If the sentence loses nothing, it was decoration and it goes.

An inversion must be carrying emphasis onto the fronted element. A particle
must be marking a real contrast or a real return to something. A `-mIş` must be
marking that the writer did not witness it. A short sentence must be short
because that is how long the thought is.

### Over-application tells

These are what this layer produces when it is applied by quota. Each is the
Turkish form of a pattern that reads as machine-written in any language.

**Staccato fragments.** §13 asks for length variance. Variance is not a
drumbeat of three-word sentences.

> Fazla: Hata yok. Uyarı yok. Her şey yeşil.
> İyi: Ne hata vardı ne uyarı; her şey yolunda görünüyordu.

**Bumper-sticker aphorisms.** A compressed maxim standing in for the
explanation.

> Fazla: Göremediğin şeyi düzeltemezsin.
> İyi: İsteğin nerede takıldığını göremiyorsan, tahmin ediyorsun demektir.

**Three-beat reveals.** Two negations and a punchline.

> Fazla: Config sorunu değildi. Kod hatası değildi. Deploy eskiydi.
> İyi: Ne config sorunuydu ne de kod hatası; deploy eskiydi.

**Smug simplicity.** Ending on a self-congratulating flourish.

> Fazla: [kod] Bu kadar. Hepsi bu.
> İyi: [kod] sonra kodun ne yaptığını anlat, ya da hiçbir şey deme.

**Parallel ad copy.** Two symmetrical clauses that sound like a slogan.

> Fazla: Metrikler neyin bozulduğunu söyler, trace'ler nedenini.
> İyi: Metrikler neyin bozulduğunu gösteriyor ama nedenini asıl trace'lerde buluyorsun.

**Manufactured question-and-answer.** A question the writer immediately answers,
used as a rhythm trick rather than because the reader would ask it.

> Fazla: Peki hangisi doğru? Ekibinize bağlı.
> İyi: Doğru cevap ekibinizin geçmişten ne beklediğine bağlı.

### Density

In blog register, across a whole piece: two or three inversions, a handful of
particles, `-mIş` wherever the content is genuinely non-witnessed. In technical
register, roughly half that and no inversion. If you find yourself counting up
to a target, stop — the count is a ceiling, never a quota.

## Reading the layer as a whole

These fourteen are not a checklist to run top to bottom. Two of them —
branching direction and the converb system — account for most of what makes
machine Turkish feel machine-made, because both are about how clauses attach to
each other, which is the level at which English structure survives translation
most stubbornly. Fix those two and the paragraph already breathes differently.

The rest are corrections and, in the case of inversion, evidentiality and
particles, permissions: things a Turkish writer does that an LLM will not do
unless told it may.
