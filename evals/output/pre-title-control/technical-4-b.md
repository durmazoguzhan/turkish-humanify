# PostgreSQL'de index tasarımı ekleme değil, seçim işi

Sorgu yavaşlayınca ilk refleks index eklemek oluyor. Oysa yanlış index hiçbir sorunu çözmediği gibi her INSERT ve UPDATE'e sessiz bir maliyet bindirir. Doğru seçim, sorgunun erişim desenini anlamakla başlar.

## Seçicilik her şeyden önce gelir

Bir index ancak tablonun küçük bir kısmına işaret ediyorsa işe yarar. `status = 'active'` koşulu satırların %80'ini getiriyorsa planlayıcı index'i görmezden gelip sequential scan yapar. Haklı da olur: rastgele sayfa okumak sıralı okumaktan pahalı.

Cinsiyet ya da boolean bayrak gibi düşük kardinaliteli kolonlara tek başına index atmak neredeyse hep israf. Böyle durumlarda kısmi index (partial index) çok daha isabetli:

```sql
CREATE INDEX ON orders (created_at) WHERE status = 'pending';
```

Bekleyen siparişler tüm tablonun binde biriyse index de o oranda küçük ve sıcak kalır.

## Bileşik index'te sıra belirleyici

Çok kolonlu index'lerde PostgreSQL "en sol önek" (leftmost prefix) kuralıyla çalışır. `(tenant_id, created_at)` index'i `tenant_id` üzerinden yapılan aramaya da hizmet eder. Yalnızca `created_at` filtreleyen bir sorguya ise verimli biçimde yardım etmez.

Genel yaklaşım şu: eşitlikle karşılaştırılan kolonlar başa, aralık (`>`, `BETWEEN`) ve `ORDER BY` kolonları sona. Böylece index hem filtrelemeyi hem sıralamayı tek geçişte karşılar, planda maliyetli bir sort adımı da belirmez.

## Index tipini veri belirler

Varsayılan B-tree, karşılaştırma operatörleriyle çalışan her şeyi kapsar. Fakat:

- GIN: `jsonb` içi arama, dizi kapsama (`@>`), tam metin arama ve `pg_trgm` ile `LIKE '%...%'` sorguları için.
- GiST: geometrik veri, aralık tipleri, komşuluk (nearest-neighbour) sorguları.
- BRIN: sadece sona eklenen, fiziksel olarak zaman/ID sırasına yakın duran çok büyük tablolar. Boyutu B-tree'nin yüzde biri kadar; karşılığında hassasiyetten feragat eder.

## Planlayıcıya sorun, tahmin etmeyin

`EXPLAIN (ANALYZE, BUFFERS)` çıktısında tahmini satır sayısıyla gerçek satır sayısı arasındaki uçurum, index seçiminden önce istatistik sorununa işaret eder. Böyle bir durumda `ANALYZE` çalıştırmak veya `ALTER TABLE ... ALTER COLUMN ... SET STATISTICS` ile örneklemi genişletmek, yeni bir index'ten daha fazla kazandırır.

Index-only scan istiyorsanız gerekli kolonları `INCLUDE` ile index'e taşıyabilirsiniz. Ama şunu unutmayın: bu, tabloyu şişirir, visibility map güncel değilse yine heap'e gidilir.

## Silmeyi de hesaba katın

`pg_stat_user_indexes` tablosundaki `idx_scan` değeri sıfır olan index'ler, disk ve yazma maliyeti dışında hiçbir şey üretmiyor demektir. Bir de şu var: index'lenen bir kolonu güncellemek HOT update optimizasyonunu devre dışı bırakıp yazma yükünü artırır.

Index tasarımı ekleme değil seçim işi. Sorgu desenini ölçün, en az sayıda index'le en çok sorguya hizmet edin, kalanını kaldırın.
