# PostgreSQL'de index eklemek değil, seçmek

Yavaş sorguya verilen ilk refleks index eklemek. Oysa yanlış index hiçbir sorunu çözmediği gibi her INSERT ve UPDATE'e sessiz bir maliyet bindirir. Doğru seçim sorgunun erişim desenini anlamakla başlar.

## Seçicilik her şeyden önce gelir

Bir index ancak tablonun küçük bir kısmına işaret ediyorsa işe yarar. `status = 'active'` koşulu satırların %80'ini getiriyorsa planlayıcı index'i görmezden gelip sequential scan yapar. Bunda da haklı: rastgele sayfa okumak sıralı okumaktan pahalı. Cinsiyet, boolean bayrak gibi düşük kardinaliteli kolonlara tek başına index atmak neredeyse hep israf.

Neredeyse, çünkü böyle durumlarda kısmi index (partial index) çok daha isabetli oluyor:

```sql
CREATE INDEX ON orders (created_at) WHERE status = 'pending';
```

Bekleyen siparişler tüm tablonun binde biriyse, index de o oranda küçük ve sıcak kalır.

## Bileşik index'te sıra belirleyici

Çok kolonlu index'lerde PostgreSQL "en sol önek" (leftmost prefix) kuralıyla çalışır. `(tenant_id, created_at)` index'i `tenant_id` üzerinden yapılan aramaya da hizmet eder. Tersi ise geçerli değil: yalnızca `created_at` filtreleyen bir sorguya verimli biçimde yardım etmez.

Genel yaklaşım şu: eşitlik karşılaştırılan kolonlar başa, aralık (`>`, `BETWEEN`) ve `ORDER BY` kolonları sona. Böylece index hem filtrelemeyi hem sıralamayı tek geçişte karşılar, planda maliyetli bir sort adımı da belirmez.

## Index tipini veri belirler

B-tree varsayılan. Karşılaştırma operatörleriyle çalışan her şeyi kapsar. Fakat:

- **GIN**: `jsonb` içi arama, dizi kapsama (`@>`), tam metin arama ve `pg_trgm` ile `LIKE '%...%'` sorguları için.
- **GiST**: geometrik veri, aralık tipleri, komşuluk (nearest-neighbour) sorguları.
- **BRIN**: sadece sona eklenen, fiziksel olarak zaman/ID sırasına yakın duran çok büyük tablolarda. Boyutu B-tree'nin yüzde biri kadar, karşılığında hassasiyetten feragat eder.

## Planlayıcıya sorun, tahmin etmeyin

`EXPLAIN (ANALYZE, BUFFERS)` çıktısında tahmini satır sayısı ile gerçek satır sayısı arasındaki uçurum, index seçiminden önce istatistik sorununa işaret eder. Böyle bir durumda `ANALYZE` çalıştırmak ya da `ALTER TABLE ... ALTER COLUMN ... SET STATISTICS` ile örneklemi genişletmek, yeni bir index'ten daha fazla kazandırır.

Index-only scan istiyorsanız `INCLUDE` ile gerekli kolonları index'e taşıyabilirsiniz. Ama unutmayın: tabloyu şişirir, visibility map güncel değilse yine heap'e gidilir.

## Silmeyi de hesaba katın

`pg_stat_user_indexes` tablosunda `idx_scan` değeri sıfır olan index'ler, disk ve yazma maliyeti dışında hiçbir şey üretmiyor demektir. Ayrıca indexlenen bir kolonu güncellemek HOT update optimizasyonunu devre dışı bırakıp yazma yükünü artırır.

Index tasarımı ekleme değil, seçim işi. Sorgu desenini ölçün, en az sayıda index'le en çok sorguya hizmet edin, kalanını kaldırın.
