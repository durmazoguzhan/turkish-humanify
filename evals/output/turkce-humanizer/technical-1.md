# Türkçe Humanizer Çıktısı — technical-1

## 1. Tespit Raporu

**Register teşhisi:** Teknik blog / açıklayıcı mühendislik yazısı. Analitik-gazetecilik ile Deneme-blog sınırında duruyor; **Deneme-blog** olarak işledim (kullanıcı onayı istenmeden karar verildi). Yani Faz 2 tam uygulanır, ama teknik doğruluk ve terminoloji korunarak — argo/edebi katman (Sinyal 19-21) uygulanmaz.

**Genel not:** Metin ağır AI-imzalı değil. Baskın sinyallerin çoğu **yok**. Bulunanlar iki kümede toplanıyor: noktalama enflasyonu ve nominalleştirme yoğunluğu.

### Baskın sinyaller

**Sinyal 1b — Noktalı virgül suistimali (3 örnek):**
- P5: "Silme işlemi ise idempotenttir**;** bir sonraki okuma..." → TDK'nın üç kullanımından hiçbiri değil; iki bağımsız fikri birleştiriyor.
- P10: "...asla kullanılmamalıdır**;** Redis tek thread'li çalıştığı için..." → aynı yapı; buradaki bağ aslında nedensellik ("çünkü").
- P13: "Tolerans yüksekse TTL yeterlidir**;** düşükse explicit invalidation..." → bu üçüncüsü **paralel eksiltili karşıtlık**, TDK-savunulabilir bir kullanım. Dokunmadım (aşağıda not düşüldü).

**Sinyal 1c — Cümle-içi iki nokta üst üste, açıklama modu (5 örnek):**
- P1: "...meşhur sözü boşuna değil**:** bilgisayar bilimlerindeki..."
- P4: "Burada kritik soru şudur**:** silmek mi, güncellemek mi?"
- P6: "Sıralama da önemlidir**:** önce veritabanını yazın..."
- P9: "İkincisi ise probabilistic early expiration**:** TTL dolmadan..."
- P13: "...güvenlik ağı olarak bırakın**:** invalidation mantığınız er ya da geç..."
- (Kod bloğunu tanıtan üç iki nokta ve başlıktaki iki nokta TDK-uygun; onlara dokunulmadı.)

**Sinyal 3 — Kalıp tekrarı (bürokratik bağlaç ya da "-mektedir" değil, retorik hamle tekrarı; 3 örnek):**
"[Yargı cümlesi]-dir **:** [açıklama]" hamlesi belgede dört kez tekrarlanıyor (P4, P6, P9, P13). Tek başına doğal, dört kez üst üste kalıp.

**Sinyal 5a — Boş değerlendirici sıfat (1 örnek, eşiğin altında):**
- P4: "Burada **kritik** soru şudur" — "kritik" bilgi taşımıyor, cümleden çıkınca anlam aynı.

**Sinyal 11 — Nominalleştirme / kişisiz yüklem yoğunluğu (6 örnek):**
"kullanmaktır", "karar vermektir", "toparlamasıdır", "görebilmesidir", "asla kullanılmamalıdır", "kendi kendine ölmesidir". Belgenin geri kalanı canlı 2. çoğul kişi kullanıyor ("biçersiniz", "yazın", "gömersiniz"); bu altı yer o sesle çelişiyor.

**Sinyal 14 — Fragment cümle (2 örnek, eşiğin bir altında):**
- P1: "...iki zor problemden biri cache invalidation." (yüklemsiz bırakılmış)
- P9: "...bir istek yüzdesinin cache'i proaktif olarak yenilemesi." (iki noktayla açılıp isim öbeğiyle bitiyor)

### İkincil sinyaller

**Sinyal 8 — Devrik cümle yokluğu (belge geneli):** 26 cümlenin tamamı düz kurulmuş. Tek bir devrik yok. Bu uzunlukta bir Türkçe blog yazısında istatistiksel olarak beklenmez.

## 2. Sinyal Yoğunluğu

Belge gövdesi ≈ 365 kelime (başlıklar ve kod blokları hariç).

| | Sinyal sayısı | Yoğunluk |
|---|---|---|
| **Önce** | 21 | **5.8 sinyal / 100 kelime** |
| **Sonra** | 3 | **0.8 sinyal / 100 kelime** |
| **İyileşme** | — | **%86** |

Dağılım (önce → sonra): 1b: 3→1 (kasıtlı) · 1c: 5→0 · 3: 3→0 · 5a: 1→0 · 11: 6→2 (bilinçli ton payı) · 14: 2→0 · 8: 1→0.

## 3. Onarılmış Versiyon

# Redis'te Cache Invalidation: Doğru Veriyi Doğru Zamanda Unutmak

Cache'leme kolaydır. Zor olan, cache'lenmiş verinin ne zaman geçersiz hale geldiğine karar vermek. Phil Karlton'ın meşhur sözü boşuna değil. Bilgisayar bilimlerindeki iki zor problemden biri cache invalidation'dır.

## TTL: En basit ve çoğu zaman en doğru yaklaşım

Redis'te invalidation'ın en yalın hali `EXPIRE` kullanmak. Veriye bir ömür biçersiniz, süre dolunca Redis onu kendisi temizler:

```
SET user:1042 "{...}" EX 300
```

Bu yaklaşımın güzelliği, hata durumunda kendini toparlaması. Invalidation mantığınızda bir bug olsa bile bayat veri en fazla TTL kadar yaşar. Sonra kendiliğinden ölür. Dezavantajı ise TTL süresince kullanıcıların eski veriyi görmesi. Ürün fiyatı için 5 dakika kabul edilebilir, kullanıcı yetkileri için felaket olabilir.

## Write-through ve explicit invalidation

Veri değiştiğinde cache'i doğrudan silmek (`DEL`) ya da güncellemek daha keskin bir kontrol sağlar. Peki hangisi doğru, silmek mi güncellemek mi?

Genel kural, **güncellemek yerine silmektir**. Ya da daha dikkatli söyleyelim, güncellemek de çalışır ama yanlış gittiğinde sessizce yanlış gider. Cache'i yazma anında güncellerseniz eşzamanlı iki yazma işleminin sırası karışabilir ve cache kalıcı olarak yanlış değeri tutabilir. Silme işlemi ise idempotent. Bir sonraki okuma veriyi veritabanından tazeler.

Sıralama da önemli. Önce veritabanını yazın, sonra cache'i silin. Tersi sırada, silme ile yazma arasındaki pencerede başka bir okuma eski veriyi tekrar cache'e koyabilir.

## Cache stampede problemi

Popüler bir key expire olduğu anda yüzlerce istek aynı anda veritabanına yönelir. Buna cache stampede denir. Production'da veritabanı çökertecek kadar da ciddidir.

İki pratik çözüm var. Birincisi, bir lock key ile yalnızca tek bir isteğin veriyi yeniden üretmesine izin vermek:

```
SET lock:user:1042 1 NX EX 10
```

`NX` sayesinde yalnızca ilk istek lock'u alır, diğerleri ya kısa süre bekler ya da bayat veriyi döner. İkincisi ise probabilistic early expiration. TTL dolmadan biraz önce, rastgele seçilen küçük bir istek yüzdesi cache'i kendiliğinden yeniler.

## Grup halinde invalidation

Tek bir key'i silmek kolay. Ama "bu kullanıcıya ait tüm cache'leri sil" demek zor. `KEYS user:1042:*` komutunu asla kullanmayın. Redis tek thread'li çalışır, bu komut da tüm sunucuyu bloke eder. `SCAN` daha güvenli, yine de yavaş.

Daha temiz yöntem, versiyon damgası. Key'lere bir versiyon numarası gömersiniz:

```
user:1042:v7:profile
```

Kullanıcı verisi değiştiğinde `INCR user:1042:version` yaparsınız. Eski versiyonlu key'ler artık hiç okunmaz, TTL'leriyle sessizce ölür. Tek bir atomik komutla binlerce key'i mantıksal olarak geçersiz kılmış olursunuz.

## Kapanış

Doğru strateji, verinin bayatlığa toleransına bağlıdır. Tolerans yüksekse TTL yeterlidir; düşükse explicit invalidation ve versiyonlama gerekir. Her durumda TTL'i bir güvenlik ağı olarak bırakın. Invalidation mantığınız ne kadar dikkatli kurulursa kurulsun, bir gün mutlaka kaçırırsınız bir senaryoyu. O an sizi kurtaran şey, verinin kendi kendine ölmesi olur.

## 4. Notlar

**Uygulanan Faz 2 sinyalleri (register: Deneme-blog):**
- **Sinyal 15 — Cümle uzunluğu patlamaları:** "Sonra kendiliğinden ölür." · "Sıralama da önemli." · "Silme işlemi ise idempotent." · "Tek bir key'i silmek kolay." Hepsi anlamın gerçekten durduğu yere kondu, ritim doldurmak için değil.
- **Sinyal 16 — Konuşma bağlaçları:** "Ama", "Peki", "Ya da", "yine de". Metinde zaten iki "ama" vardı; sayıyı zorlamadan artırdım.
- **Sinyal 17 — Retorik soru:** "Peki hangisi doğru, silmek mi güncellemek mi?" — orijinaldeki "Burada kritik soru şudur:" kurulumunun yerine geçti. Yani yeni bir soru eklenmedi, var olan soru iki nokta koltuk değneğinden kurtarıldı.
- **Sinyal 18 — Öz-düzeltme:** "Ya da daha dikkatli söyleyelim, güncellemek de çalışır ama yanlış gittiğinde sessizce yanlış gider." Bu ayrıca bir bilgi kazancı: orijinal metnin "güncelleme kalıcı olarak yanlış değer tutabilir" iddiasını sezdirerek hazırlıyor.
- **Sinyal 22 — Birinci çoğul:** "söyleyelim" (tek örnek). Metnin hâkim sesi 2. çoğul ("biçersiniz, yazın, gömersiniz"); bunu bozmamak için tek yerde kullandım.
- **Sinyal 8 onarımı — Devrik:** "bir gün mutlaka kaçırırsınız bir senaryoyu." Belgedeki tek devrik. Kapanışta, vurgunun zaten yükseldiği yerde.

**Dokunmadıklarım — kasıtlı tercih olabilir:**
- **P13'teki noktalı virgül** ("Tolerans yüksekse TTL yeterlidir; düşükse..."). Bu, ikinci cümlede yüklem eksiltilmiş paralel bir karşıtlık kurulumu — AI'nin "iki fikri birleştir" refleksi değil, bilinçli bir ritim hamlesi. Kaldırmak cümleyi zayıflatırdı.
- **Kapanış paragrafının resmi tonu** ("bağlıdır", "yeterlidir", "gerekir"). Yazı burada özet moduna geçiyor; nominalleştirmeyi sıfırlamak yerine yoğunluğunu düşürdüm ("ölmesidir" → "ölmesi olur"). Skill'in "tam temizleme yerine yoğunluk düşürme" kuralı.
- **Başlıktaki ve kod bloklarını tanıtan iki noktalar.** TDK-uygun; Sinyal 1c bunları kapsamıyor.
- **Teknik terimlerin İngilizcesi** (cache, invalidation, key, lock, stampede, idempotent, probabilistic early expiration). Türkçeleştirmek metnin izleyicisinden koparırdı; skill sinonim değiştirici değil.
- **Yapı:** Başlık hiyerarşisi, dört kod bloğu, bold vurgu ve paragraf sınırları birebir korundu. Hiçbir liste paragrafa, hiçbir paragraf listeye çevrilmedi.

**YOK olduğu için not düştüklerim — yazarın hanesine yazılır:**
- **Sinyal 1a (uzun tire enflasyonu):** Tek bir em dash yok. Türkçe AI metninin bir numaralı fenotipi bu; metin temiz.
- **Sinyal 1d ("ki" bitişik yazımı) ve 1e (slash-ayırıcı):** Hiç yok.
- **Sinyal 2 (cümle monotonluğu):** Metinde zaten kısa cümle patlamaları vardı — "Cache'leme kolaydır." (2 kelime), "İki pratik çözüm var." (4 kelime). Varyans sağlıklı.
- **Sinyal 3a ("-mektedir/-maktadır" salgını):** Belgede sıfır örnek. Türkçe teknik yazıda nadir bir başarı.
- **Sinyal 3b (bürokratik bağlaç yığını):** "Bu bağlamda", "söz konusu", "bu doğrultuda", "öte yandan" — hiçbiri yok.
- **Sinyal 3c (AI kapanış klişeleri):** "Kritik bir rol oynamaktadır" ailesinden tek örnek yok. Kapanış paragrafı gerçek bir karar kuralı veriyor, boş övgü değil.
- **Sinyal 4 ("sadece X değil, aynı zamanda Y"):** Yok.
- **Sinyal 5b (boş değerlendirici kapanış):** Hiçbir paragraf içi boş bir değerlendirmeyle bitmiyor.
- **Sinyal 6 (adeta/sanki bağımlılığı):** Tek benzetme yok; metin somut konuşuyor.
- **Sinyal 7 (zorlama üçlü liste):** Yok. Listeler ikili ve gerçekten iki farklı şey ("Birincisi... İkincisi...").
- **Sinyal 10 (somut anchor eksikliği):** Tam tersi — `EX 300`, `NX EX 10`, `user:1042:v7`, "5 dakika", Phil Karlton atfı. Her soyut iddianın altında çalışan bir örnek var. Bu metnin en insan yanı.
- **Sinyal 12 (İngilizce vurgu-doldurucuları):** "tam da", "tam anlamıyla", "gerçekten de", "nihayetinde", "esasen" — ailenin dokuz üyesinden hiçbiri yok.
- **Sinyal 13 (eş anlamlı rotasyonu):** Aynı kavram baştan sona aynı adla anılıyor (key hep "key", bayat veri hep "bayat veri"). Türkçe teknik yazının doğru refleksi.
