
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

