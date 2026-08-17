# Türkçe Humanizer Çıktısı — technical-4

**Register teşhisi:** Analitik-gazetecilik (teknik açıklama/blog sınırında). Metin ikinci tekil-çoğul emir kipiyle okura seslenen, kod örnekli bir teknik anlatım. Kullanıcı onayı istenmediği için seçimi kendim yaptım: Faz 1 tam uygulandı, Faz 2 kısıtlı uygulandı (Sinyal 15 cümle patlaması, Sinyal 18 hafif yeniden ifade, Sinyal 8 tek bir doğal devrik). Konuşma bağlaçlarının argo ucu ("valla, yani, he") ve retorik soru (Sinyal 17) bu register'da uygulanmadı.

**Uzun belge modu:** Belge 9 paragraf + 5 başlık + 1 kod bloğu + 3 maddelik liste. Yüksek AI-imzalı (3+ baskın sinyal) paragraf yok. Orta AI-imzalı: P2 (seçicilik), P5 (bileşik index), P6 (index tipi girişi + liste), P7 (planlayıcı), P9 (kapanış). Temiz: P1, P3, P4, P8. Mod olarak "tümünü tek seferde" seçildi.

---

## 1. Tespit Raporu

**Baskın sinyaller**

- **Sinyal 1a — Uzun tire enflasyonu (4 örnek).**
  - P2: "...sequential scan yapar **—** ve haklıdır, çünkü..." → boşluklu, cümle-içi em dash; TDK'da uzun çizgi yalnızca konuşma çizgisidir.
  - Madde listesi: "**GIN** —", "**GiST** —", "**BRIN** —" → İngilizce sözlük-tanım tiresi mantığı.
- **Sinyal 1b — Noktalı virgül suistimali (1 örnek).** P7: "...index'e taşıyabilirsiniz**;** ancak bunun tabloyu şişirdiğini..." → TDK'nın üç kullanımının hiçbiri değil; klasik "iki fikri birleştir" hamlesi.
- **Sinyal 1c — Cümle-içi iki nokta (1 örnek, sınırda).** P9: "...seçim işidir**:** sorgu desenini ölçün, ..." → sıralama öncesi iki nokta TDK'ya aykırı değil ama cümle burada iki bağımsız hükmü tek gövdede taşıyor.
- **Sinyal 2 — Cümle monotonluğu (1 paragraf).** P7: üç cümle, sırasıyla ~20 / ~20 / ~22 kelime. Varyans neredeyse sıfır, 5 kelimeden kısa hiç cümle yok.

**İkincil sinyaller**

- **Sinyal 14 — Fragment cümle bağımlılığı (2 örnek).** P5: "Genel yaklaşım: eşitlik karşılaştırılan kolonlar başa, ... sona." (yüklem yok). P6: "Fakat:" (tek bağlaçlık fragment).
- **Sinyal 8 — Devrik cümle yokluğu (belge geneli).** Dokuz paragrafın hiçbirinde devrik kurulmamış; hepsi özne-tümleç-yüklem.

**Bulunması beklenip BULUNMAYANLAR** (aşağıdaki Notlar'da da var, yazarın hanesine yazılır)

- Sinyal 3a "-mektedir/-maktadır" salgını: **yok** — metin geniş zaman ve emir kipiyle yazılmış.
- Sinyal 3b bürokratik bağlaç yığını: **yok** — "bu bağlamda / söz konusu / bu doğrultuda" hiç geçmiyor.
- Sinyal 3c AI kapanış klişesi ("kritik bir rol oynamaktadır" vb.): **yok**.
- Sinyal 4 "sadece X değil, aynı zamanda Y": **yok**.
- Sinyal 5a boş övgü sıfatları ("kritik", "hayati", "eşsiz"): **yok**.
- Sinyal 6 "adeta / sanki" bağımlılığı: **yok**.
- Sinyal 12 İngilizce vurgu-doldurucuları ("tam da", "gerçekten de", "nihayetinde"): **yok**.
- Sinyal 13 eş anlamlı rotasyonu: **yok** — "index", "planlayıcı", "sorgu" baştan sona aynı adla anılıyor.
- Sinyal 11 pasif yapı bağımlılığı: **yok** — çatı ağırlıkla aktif.
- Sinyal 1e slash-ayırıcı: **yok** ("zaman/ID" bir tanesi var, o da alternatif değil eşleştirme; dokunulmadı).

## 2. Sinyal Yoğunluğu (Nicel Metrik)

Belge 382 kelime (başlıklar ve kod bloğu dahil).

| | Sinyal sayısı | 100 kelimede |
|---|---|---|
| Önce | 10 | 2,6 |
| Sonra | 1 | 0,3 |

**İyileşme oranı: %90.** Kalan 1 sinyal, madde etiketlerinde uzun tire yerine kullanılan iki nokta — TDK'nın sıralama-öncesi iki nokta kullanımına uyduğu için bilinçli bırakıldı, ihlal değil kalıntı sayıldı.

## 3. Onarılmış Versiyon

# PostgreSQL'de Index Seçimi

Index eklemek, yavaş sorguya verilen ilk reflekstir. Oysa yanlış index hiçbir sorunu çözmediği gibi her INSERT ve UPDATE'e sessiz bir maliyet bindirir. Doğru seçim, sorgunun erişim desenini anlamakla başlar.

## Seçicilik her şeyden önce gelir

Bir index, ancak tablonun küçük bir kısmına işaret ediyorsa işe yarar. `status = 'active'` koşulu satırların %80'ini getiriyorsa planlayıcı index'i görmezden gelip sequential scan yapar. Haklıdır da, çünkü rastgele sayfa okumak sıralı okumaktan pahalıdır. Cinsiyet, boolean bayrak gibi düşük kardinaliteli kolonlara tek başına index atmak neredeyse hep israftır.

Böyle durumlarda çok daha isabetlidir **kısmi index** (partial index):

```sql
CREATE INDEX ON orders (created_at) WHERE status = 'pending';
```

Bekleyen siparişler tüm tablonun binde biriyse, index de o oranda küçük ve sıcak kalır.

## Bileşik index'te sıra belirleyicidir

Çok kolonlu index'lerde PostgreSQL "en sol önek" (leftmost prefix) kuralıyla çalışır. `(tenant_id, created_at)` index'i `tenant_id` üzerinden yapılan aramaya da hizmet eder, ancak yalnızca `created_at` filtreleyen bir sorguya verimli biçimde yardım etmez. Genel yaklaşım şöyledir: eşitlik karşılaştırılan kolonlar başa, aralık (`>`, `BETWEEN`) ve `ORDER BY` kolonları sona gelir. Böylece index hem filtrelemeyi hem sıralamayı tek geçişte karşılar ve planda maliyetli bir sort adımı belirmez.

## Index tipini veri belirler

B-tree varsayılandır ve karşılaştırma operatörleriyle çalışan her şeyi kapsar. Fakat her veri B-tree'ye uymaz:

- **GIN:** `jsonb` içi arama, dizi kapsama (`@>`), tam metin arama ve `pg_trgm` ile `LIKE '%...%'` sorguları için.
- **GiST:** geometrik veri, aralık tipleri, komşuluk (nearest-neighbour) sorguları.
- **BRIN:** sadece sona eklenen, fiziksel olarak zaman/ID sırasına yakın duran çok büyük tablolarda. Boyutu B-tree'nin yüzde biri kadardır, karşılığında hassasiyetten feragat eder.

## Planlayıcıya sorun, tahmin etmeyin

`EXPLAIN (ANALYZE, BUFFERS)` çıktısında tahmini satır sayısı ile gerçek satır sayısı arasındaki uçurum, index seçiminden önce istatistik sorununa işaret eder. Yani sorun index'te değil, tahminde. Bu durumda `ANALYZE` çalıştırmak veya `ALTER TABLE ... ALTER COLUMN ... SET STATISTICS` ile örneklem genişletmek, yeni bir index'ten daha fazla kazandırır. Index-only scan istiyorsanız `INCLUDE` ile gerekli kolonları index'e taşıyabilirsiniz. Ama bunun tabloyu şişirdiğini ve visibility map güncel değilse yine heap'e gidileceğini unutmayın.

## Silmeyi de hesaba katın

`pg_stat_user_indexes` tablosundaki `idx_scan` değeri sıfır olan index'ler, disk ve yazma maliyeti dışında hiçbir şey üretmiyor demektir. Ayrıca indexlenen bir kolonu güncellemek HOT update optimizasyonunu devre dışı bırakır ve yazma yükünü artırır.

Kısacası index tasarımı ekleme değil, seçim işidir. Sorgu desenini ölçün, en az sayıda index'le en çok sorguya hizmet edin, kalanını kaldırın.

## 4. Notlar

**Yapılan onarımlar (sinyal → müdahale)**

- **1a:** P2'deki cümle-içi em dash kaldırıldı, cümle bölündü ("...sequential scan yapar. Haklıdır da, çünkü..."). Bu bölme aynı zamanda Faz 2 Sinyal 15'in nefes noktasını kazandırdı. Liste etiketlerindeki üç em dash iki noktaya çevrildi; madde yapısına dokunulmadı.
- **1b:** P7'deki noktalı virgül iki bağımsız cümleye ayrıldı, ikincisi "Ama" ile başlatıldı (Sinyal 16'nın register'a uygun, ölçülü ucu).
- **1c/14:** "Genel yaklaşım:" fragmenti yüklemle tamamlandı ("Genel yaklaşım şöyledir: ... sona **gelir**."). "Fakat:" fragmenti tam cümleye çevrildi ("Fakat her veri B-tree'ye uymaz:"). Kapanıştaki iki nokta kaldırılıp cümle ikiye bölündü.
- **2 + 15:** P7'ye kısa bir yeniden ifade cümlesi yerleştirildi: "Yani sorun index'te değil, tahminde." Paragrafın 20/20/22 kelimelik düz ritmi kırıldı; cümle yeni bilgi taşımıyor, ilk cümlenin hükmünü özetliyor (Sinyal 18'in hafif biçimi).
- **8:** Tek bir doğal devrik kuruldu: "Böyle durumlarda çok daha isabetlidir **kısmi index** (partial index):". Zorlama olmasın diye belgede başka devrik denenmedi.

**Dokunulmayanlar — kasıtlı tercih sayıldı**

- "Kısacası index tasarımı ekleme değil, seçim işidir." Bu, Sinyal 4'ün ("sadece X değil, aynı zamanda Y") eklemeli kalıbı değil; gerçek bir karşıtlık kuruyor. Korundu.
- Kapanıştaki üç emir ("ölçün, hizmet edin, kaldırın") Sinyal 7 (zorlama üçlü) olarak değerlendirildi ve elenmedi: üç öğe birbirinden gerçekten farklı üç eylem.
- "Bu durumda", "Ayrıca", "Böylece", "Oysa" bağlaçları bürokratik yığın listesinde değil ve metnin mantığını taşıyor. Korundu.
- Emir kipli okur hitabı ("ölçün", "unutmayın", "hesaba katın") metnin tutarlı sesi. Bu yüzden Sinyal 22 (birinci çoğul: "görüyoruz", "sanıyoruz") uygulanmadı — register kayması (Sinyal 9) yaratırdı.
- "tabloyu şişirdiğini" ifadesi olduğu gibi bırakıldı. `INCLUDE` teknik olarak index'i şişirir; ancak bu bir dil sinyali değil olgusal bir düzeltme olurdu ve skill'in kapsamı dışında. Yazara ayrıca bildirilmesi gerekir.
- Kod bloğu, başlık hiyerarşisi (H1 + beş H2) ve üç maddelik liste yapısı birebir korundu.

**Register kısıtı nedeniyle uygulanmayan Faz 2 sinyalleri**

- Sinyal 17 (retorik soru), Sinyal 19 (duyusal detay), Sinyal 20 (zaman kipi kayması), Sinyal 21 (diyalog izi) — teknik açıklama register'ında yeri yok.
- Sinyal 16'nın edebi ucu ("valla", "he", "canım") uygulanmadı; sadece "Ama" ve mevcut "Oysa" düzeyinde kaldı.
- Sinyal 15'in 1-3 kelimelik agresif patlamaları ("Bitti.", "Kalakaldı.") kullanılmadı; teknik metinde yapay durur. Yerine 5 kelimelik bir yeniden ifade cümlesi tercih edildi.

**Genel değerlendirme:** Metin baştan temiz sayılır. Beş baskın fenotipin üçü (3, 4, 5) hiç görünmüyor; AI imzası neredeyse tamamen noktalama katmanında (İngilizce em dash ve noktalı virgül refleksi) ve iki fragmentte toplanmış. Bilgi içeriğine tek kelime eklenmedi, tek iddia çıkarılmadı.
