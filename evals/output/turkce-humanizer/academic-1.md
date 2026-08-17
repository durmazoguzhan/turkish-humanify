## 0. Register Teşhisi

**Akademik-kurumsal** (analitik-gazetecilik sınırına yakın). Metin birinci tekil şahısla kurulmuş bir makale/deneme girişi: tez cümlesi, karşı görüş haritası, yol haritası paragrafı. "Bu yazıda… ele alacağım" kalıbı akademik-kurumsal ailenin girişidir.

Kullanıcıya doğrulatma adımı atlandı, seçim skill tarafından yapıldı.

**Faz 2 uygulaması (kısıtlı):** Sinyal 15 (cümle uzunluğu patlamaları), Sinyal 18 (öz-düzeltme), Sinyal 22 (birinci çoğul — metinde zaten mevcut). Sinyal 16-17 ve 19-21 register nedeniyle uygulanmadı.

---

## 1. Tespit Raporu

Belge 5 paragraf, 356 kelime (başlık hariç). Sınıflandırma: **yüksek AI-imzalı paragraf yok**; P3 ve P4 orta (2'şer baskın sinyal), P2 orta (1), P1 ve P5 temiz.

**Sinyal 1b — Noktalı virgül suistimali (baskın).** Toplam 5 noktalı virgül, hiçbiri TDK'nın üç kullanımına girmiyor:
- P2: "…gerçek bir gözlem tutuyor**;** sorun belki de…" — iki bağımsız fikri birleştirme (AI kullanımı).
- P3: "…kolaylaştırması değil**;** öğrenmenin kanıtını…" ve "…bir arıza değil**;** sistemin…" — bir paragrafta 2 adet, alarm eşiği aşıldı.
- P4: "…tahammülü azalıyor**;** oysa…" ve "…için kullanırken**;** diğeri…" — 2 adet, alarm eşiği aşıldı. İkincisi ayrıca yanlış: yan cümle ("kullanırken") ile ana cümle arasına noktalı virgül girmiş.

**Sinyal 12 — İngilizce vurgu-doldurucuları (ikincil, eşik: 2+).** 2 örnek, ikisi de "tam da":
- P2: "…bir aracın, **tam da** eğitimin var olma sebebini aşındırdığını…"
- P4: "…öğrenmenin büyük kısmı **tam da** o tahammülün içinde…"

**Sinyal 3 / Sinyal 4 ailesi — "X değil, Y" kalıbının tekrarı (baskın).** Metnin retorik omurgası tek bir karşıtlık kalıbına yaslanmış: P1 "yönetmelikle değil, ödev teslim gecesiyle", P3 "kolaylaştırması değil… değersizleştirmesi", P3 "arıza değil… ayna", P3 "süreçle değil ürünle", P4 "teknolojinin kendisinden değil… pedagojiden", P4 "kapatmaktan çok…". Tek başına her biri doğal; art arda altı kez gelince Sinyal 4'ün ("sadece X değil, aynı zamanda Y") Türkçe akrabası hâline geliyor. Yoğunluk özellikle P3'te kritik: dört cümlede üç kalıp.

**Sinyal 8 — Devrik cümle yokluğu (ikincil).** 22 cümlenin tamamı düz kurulmuş. Bu uzunlukta bir metinde tek bir devrik bile olmaması LLM imzasıdır.

**Sinyal 13 — Eş anlamlı rotasyonu (ikincil, sınırda).** P4'te aynı gönderge üç adla anılıyor: "araç" → "teknoloji" → "yapay zekâ". Eşik teknik olarak aşılmış ama üçü de farklı iş yapıyor (bkz. Notlar) — onarılmadı.

**Sinyal 11 — Pasif yapı (ikincil, eşik altı).** "alınabiliyor", "ekleniyor", "üretilebiliyorsa" var ama metin genel olarak aktif; salgın değil, dokunulmadı.

---

## 2. Sinyal Yoğunluğu

| | Sayılan sinyal | Kelime | Yoğunluk |
|---|---|---|---|
| **Önce** | 13 | 356 | **3,7 sinyal / 100 kelime** |
| **Sonra** | 2 | 359 | **0,6 sinyal / 100 kelime** |

**İyileşme oranı: %84.**

Sayım dökümü — Önce: Sinyal 1b ×5, Sinyal 12 ×2, kalıp tekrarı (eşik üstü kullanımlar) ×4, Sinyal 8 ×1, Sinyal 13 ×1. Sonra: kalıp tekrarının bilinçli olarak korunan 1 örneği + Sinyal 13'ün korunan 1 örneği.

Paragraf bazında (önce → sonra): P1 1→1, P2 3→0, P3 5→1, P4 4→0, P5 0→0.

---

## 3. Onarılmış Versiyon

# Yapay Zekâ ve Eğitim: Neyi Ölçtüğümüzü Yeniden Sormak

Bir lise öğretmeni, verdiği kompozisyon ödevlerinin yarısının neredeyse aynı cümleyle başladığını fark ettiğinde, mesele artık "öğrenciler kopya çekiyor mu" sorusu olmaktan çıkmıştı. Metinler temizdi, kurgusu düzgündü, imla hatası yoktu. Eksik olan tek şey, o metinleri yazan çocukların sesiydi. Yapay zekânın eğitime girişi çoğu yerde böyle sessiz oldu: bir yönetmelikle değil, bir ödev teslim gecesiyle.

Tartışma hızla iki kampa bölündü. Bir tarafta, bu teknolojinin her öğrenciye kendi hızında ilerleyebileceği bir özel öğretmen kazandıracağını söyleyenler var. Haksız da sayılmazlar: iyi kurgulanmış bir alıştırma sistemi, matematikte zorlanan bir öğrencinin hangi ara basamağı atladığını, sınıf ortalamasına bakan bir öğretmenden çok daha erken görebiliyor. Dil öğreniminde haftada bir alınan geri bildirim, cümle düzeyinde ve anında alınabiliyor. Diğer tarafta ise düşünme zahmetini devralan bir aracın eğitimin var olma sebebini aşındırdığını savunanlar duruyor. İki taraf da elinde gerçek bir gözlem tutuyor. Sorun belki de tartışmanın bu ikilik üzerine kurulmasında.

Çünkü yapay zekânın eğitimde yarattığı asıl kırılma öğrenmeyi kolaylaştırması değil, öğrenmenin kanıtını değersizleştirmesi. Yüzyıllardır bilginin ölçüsü üretilen çıktıydı: ödev, kompozisyon, proje, sınav kâğıdı. Bu çıktıların büyük kısmı artık saniyeler içinde üretilebiliyorsa, gerçekte neyi ölçtüğümüzü yeniden sormak zorundayız. Teknoloji burada bir arıza çıkarmıyor, bir ayna tutuyor. Sistemin uzun zamandır süreçle değil ürünle ilgilendiğini görünür kılıyor bu ayna. Aynayı kırarak sorunu çözemeyiz.

Riskler ise fazlasıyla somut. Sürekli hazır cevaba erişen bir öğrencinin cevapsız kalmaya tahammülü azalıyor. Oysa öğrenmenin büyük kısmı o tahammülün içinde, bir problemin karşısında bir süre çaresiz kalmakta gerçekleşiyor. Buna bir de erişim eşitsizliğinin yeni bir biçimi ekleniyor. Aynı araca erişen iki okuldan biri onu tartışmayı derinleştirmek, öğrenciye kendi taslağını eleştirmeyi öğretmek için kullanıyor. Diğeri aynı aracı sadece iş yükünü kısaltmak için kullanabiliyor. Aradaki fark teknolojinin kendisinden değil, onu çevreleyen pedagojiden doğuyor (daha doğrusu, o pedagojinin olup olmadığından). Yani yapay zekâ, var olan farkları kapatmaktan çok, mevcut kurumsal kaliteyi çarpan bir katsayı gibi davranıyor.

Bu yazıda yapay zekânın eğitimi kurtaracağını ya da bitireceğini iddia etmeyeceğim. İkisi de fazla kolay ve fazla erken kurulmuş cümleler. Bunun yerine daha mütevazı ama yanıtlaması daha zor bir soruyu takip edeceğim: Öğrenmenin yükünü hafifleten bir araç, öğrenmenin kendisini nerede besliyor, nerede boşaltıyor? Sınıf içindeki gündelik değişimi, öğretmenin daralmak yerine yer değiştiren rolünü ve ölçme anlayışının neden kökten yeniden kurulması gerektiğini bu soru etrafında ele alacağım.

---

## 4. Notlar

**Yapılan onarımlar (Faz 1):**
- Beş noktalı virgülün tamamı kaldırıldı. İkisi virgüle döndü (TDK-uygun karşıtlık ve yan cümle bağı), üçü cümle bölmesine döndü — bölmeler aynı zamanda Faz 2 Sinyal 15'in nefes noktalarını üretti ("İki taraf da elinde gerçek bir gözlem tutuyor. Sorun belki de…").
- İki "tam da" silindi. İkisinde de cümlenin anlamı kelimesiz korunuyor.
- P3'teki kalıp yığılması çözüldü: "Bu, teknolojinin getirdiği bir arıza değil; … bir ayna" cümlesi olumsuz-olumlu yüklem çiftine çevrildi ("bir arıza çıkarmıyor, bir ayna tutuyor") ve ayna imgesi ayrı bir cümleye taşındı. Böylece paragraftaki "X değil Y" kalıbı üçten bire indi.
- P4'te "öğrencinin" ile yüklemi arasındaki hatalı virgül kaldırıldı; iki okul karşılaştırması iki bağımsız cümleye ayrıldı.

**Uygulanan Faz 2 sinyalleri (register izin verdiği ölçüde):**
- **Sinyal 15** — kısa cümle patlamaları noktalı virgül bölmelerinden doğal olarak çıktı; ayrıca zorlama bir "Bitti." tarzı ekleme yapılmadı, akademik register buna izin vermez.
- **Sinyal 18** — bir parantez içi öz-düzeltme eklendi: "(daha doğrusu, o pedagojinin olup olmadığından)". Gerçek bir ayrım taşıyor (hangi pedagoji ≠ pedagoji var mı), süs değil.
- **Sinyal 8** onarımı — tek bir devrik cümle yerleştirildi: "…görünür kılıyor bu ayna." Fazlası zorlama olurdu.
- **Sinyal 22** metinde zaten vardı ("ölçtüğümüzü", "sormak zorundayız", "çözemeyiz"), dokunulmadı.

**Kasıtlı tercih sayıp dokunmadıklarım:**
- P1'deki "bir yönetmelikle değil, bir ödev teslim gecesiyle" — kalıbın en işlevsel örneği, paragrafın vuruşu bu. Kalıp tekrarını azaltırken korunacak örnek olarak seçildi.
- P4'teki "araç / teknoloji / yapay zekâ" rotasyonu (Sinyal 13, sınırda) — üçü aynı şeyin süsleme amaçlı üç adı değil: "araç" okul pratiğindeki nesne, "teknoloji" pedagojiyle karşıtlığa giren soyut kategori, "yapay zekâ" sonuç cümlesinin öznesi. Ad birleştirmek karşıtlığı bozardı.
- Dört iki-nokta-üst-üste kullanımının hepsi TDK-uygun (açıklama/örnek gerektiren cümle sonu, liste girişi, soru girişi). Paragraf başına 1'i geçmiyor, alarm eşiği altında.
- P5'in uzun yol haritası cümlesi bölünmedi; akademik girişte üç maddeli plan cümlesi tür gereğidir, Sinyal 7 (zorlama üçlü) değil — üç öğe gerçekten farklı bölümlere işaret ediyor.

**Register kısıtı nedeniyle uygulanmayanlar:** Sinyal 16 (konuşma bağlaçları — metinde zaten "Oysa", "Yani", "Çünkü" var, fazlası eklenmedi), Sinyal 17 (retorik soru — P5'teki soru yazarın kendi kurduğu araştırma sorusu, ek retorik soru konmadı), Sinyal 19-21 (edebi-yaratıcı register sinyalleri).

**YOK olduğu için not düştüklerim — yazarın hanesine yazılır:**
- Sinyal 1a: cümle-içi uzun tire (—) hiç yok. Türkçe AI metninin bir numaralı fenotipi bu metinde bulunmuyor.
- Sinyal 3a: tek bir "-mektedir/-maktadır" bile yok. Akademik girişte bu nadir ve kıymetli.
- Sinyal 3b: "bu bağlamda", "söz konusu", "bu doğrultuda", "bunun yanı sıra" — hiçbiri yok.
- Sinyal 3c: AI kapanış klişesi ("kritik bir rol oynamaktadır" vb.) yok; paragrafların hiçbiri boş değerlendirmeyle bitmiyor.
- Sinyal 5a/5b: "eşsiz", "hayati", "çok boyutlu" tipi boş sıfat kümesi yok.
- Sinyal 6: "adeta"/"sanki" ile örtme yok; ayna ve katsayı metaforları somut ve işlevsel.
- Sinyal 10: somut anchor var — açılışta gerçek bir sınıf sahnesi, ardından matematikte ara basamak ve dil öğreniminde geri bildirim örnekleri. Uydurma spesifiklik yok.
- Sinyal 2: cümle uzunluğu varyansı zaten sağlıklıydı ("Riskler ise fazlasıyla somut.", "Aynayı kırarak sorunu çözemeyiz." gibi kısa vuruşlar yazarın kendi tercihi).
- Sinyal 14: fragment cümle bağımlılığı yok.
- Sinyal 1d, 1e: bitişik bağlaç "ki" ve slash-ayırıcı yok.

Yapı korundu: H1 başlık, paragraf sayısı ve sırası aynı; liste, tablo, alıntı, kod bloğu bulunmuyordu.
