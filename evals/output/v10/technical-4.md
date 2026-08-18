# PostgreSQL'de Index Seçimi

Yavaş sorguya verilen ilk refleks index eklemek. Oysa yanlış index hiçbir sorunu çözmediği gibi her INSERT ve UPDATE'e sessiz bir maliyet bindirir. Doğru seçim sorgunun erişim desenini anlamakla başlar.

## Seçicilik her şeyden önce gelir

Bir index ancak tablonun küçük bir kısmına işaret ediyorsa işe yarar. `status = 'active'` koşulu satırların %80'ini getiriyorsa planlayıcı index'i görmezden gelip sequential scan yapar. Doğrusu da bu: rastgele sayfa okumak sıralı okumaktan pahalıya gelir. Cinsiyet, boolean bayrak gibi düşük kardinaliteli kolonlara tek başına index atmak neredeyse hep israf.

Böyle durumlarda kısmi index (partial index) çok daha isabetli:

```sql
CREATE INDEX ON orders (created_at) WHERE status = 'pending';
```

Bekleyen siparişler tüm tablonun binde biriyse, index de o oranda küçük ve sıcak kalır.

## Bileşik index'te sıra belirleyici

Çok kolonlu index'lerde PostgreSQL'in kuralı "en sol önek" (leftmost prefix). `(tenant_id, created_at)` index'i `tenant_id` üzerinden yapılan aramaya da hizmet eder. Yalnızca `created_at` filtreleyen bir sorguya ise verimli biçimde yardım etmez. Genel yaklaşım: eşitlik karşılaştırılan kolonlar başa, aralık (`>`, `BETWEEN`) ve `ORDER BY` kolonları sona. Böylece index hem filtrelemeyi hem sıralamayı tek geçişte karşılar; planda maliyetli bir sort adımı da belirmez.

## Index tipini veri belirler

B-tree varsayılan; karşılaştırma operatörleriyle çalışan her şeyi kapsar. Fakat:

- **GIN**: `jsonb` içi arama, dizi kapsama (`@>`), tam metin arama ve `pg_trgm` ile `LIKE '%...%'` sorguları için.
- **GiST**: geometrik veri, aralık tipleri, komşuluk (nearest-neighbour) sorguları.
- **BRIN**: sadece sona eklenen, fiziksel olarak zaman/ID sırasına yakın duran çok büyük tablolarda. Boyutu B-tree'nin yüzde biri kadar; karşılığında hassasiyetten feragat eder.

## Planlayıcıya sorun, tahmin etmeyin

`EXPLAIN (ANALYZE, BUFFERS)` çıktısında tahmini satır sayısı ile gerçek satır sayısı arasında uçurum varsa, bu index seçiminden önce bir istatistik sorununa işaret eder. Böyle bir durumda `ANALYZE` çalıştırmak ya da `ALTER TABLE ... ALTER COLUMN ... SET STATISTICS` ile örneklemi genişletmek, yeni bir index'ten daha fazla kazandırır.

Index-only scan istiyorsanız gerekli kolonları `INCLUDE` ile index'e taşıyabilirsiniz. Ama bu taşıma tabloyu şişirir; visibility map güncel değilse de yine heap'e gidilir.

## Silmeyi de hesaba katın

`pg_stat_user_indexes` tablosunda `idx_scan` değeri sıfır kalmış bir index, disk ve yazma maliyeti dışında hiçbir şey üretmiyor demektir. Bir de indexlenen bir kolonu güncellemek HOT update optimizasyonunu devre dışı bırakıp yazma yükünü artırır.

Index tasarımı ekleme değil seçim işi. Sorgu desenini ölçün, en az sayıda index'le en çok sorguya hizmet edin, kalanını kaldırın.
