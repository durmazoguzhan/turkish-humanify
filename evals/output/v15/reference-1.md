## Kanıt

Aranan endpoint `GET /api/v1/products/{id}/availability`. Tanımı `ProductsController.GetAvailability` içinde. Route attribute'u v1 prefix'ini elle taşıyor, yani gateway'deki versiyon yönlendirmesinden bağımsız olarak ayakta. Çağıranları üç ayrı yerden çıkardım: monorepo genelinde route string'i ve generate edilmiş client metodu üzerinden grep, `api-gateway` access log'larının son yedi günü, bir de service mesh'in kaydettiği çağrı grafiği. Üçü de aynı tabloyu veriyor.

Kod tarafında üç call site var. Birincisi `mobile-bff` içindeki `AvailabilityAggregator`. Ürün detay ekranı açıldığında tek tek çağırıyor, batch'lemiyor. İkincisi `stock-sync-job`, gece 03:00'te çalışıp katalogdaki tüm SKU'ları dolaşan zamanlanmış iş. Üçüncüsü `admin-panel`'in stok düzeltme ekranı, ama oradaki çağrı `LegacyAvailabilityCheck` feature flag'ine bağlı, o flag de production'da on sekiz aydır kapalı. Yani kodda görünen üç çağırandan gerçekte ikisi trafik üretiyor.

Çağırmayanlar en az bunlar kadar önemli. `web-storefront` geçen yıl v2'ye taşınmış, kodunda v1 route'una dair tek referans kalmamış. `checkout-service` stok kontrolünü hiç bu endpoint üzerinden yapmıyor. Kendi `ReservationClient`'ı ile doğrudan stok servisine gidip aradaki HTTP hop'unu atlıyor. `search-indexer` ise availability alanını Kafka'daki `stock.changed` event'inden okuyor. Bu üçünün dışarıda kalması, endpoint'in "herkesin kullandığı ortak yol" olmadığı anlamına geliyor.

Trafik dağılımı bunu doğruluyor. Yedi günlük pencerede toplam 4,2 milyon istek düşmüş. Bunun %71'i `stock-sync-job`'a ait, tamamı da tek bir saatlik pencerede yoğunlaşıyor. Gece kuyruğu, gündüz sıfıra yakın. %26'sı ise `mobile-bff`'ten geliyor, gün içine yayılmış durumda. Geriye kalan %3'ün User-Agent'ı ne ikisine ne de admin panele uyuyor.

O %3'ü ayrıca kovaladım. İstemci sertifikası ve IP aralığı, mobil uygulamanın 4.x sürümlerine işaret ediyor: BFF'i bypass edip endpoint'i doğrudan çağıran eski build'ler. Store telemetrisine göre aktif kullanıcıların yaklaşık %1,4'ü hâlâ o sürümlerde. Trafikleri düşük ama sıfır değil. Zorla güncelleme uygulanmadığı için de kendiliğinden bitmeyecek.

Bu kanıtın söylemediği bir şey var: log penceresi yalnızca yedi gün, içinde de kampanya günü yok. Ayda bir çalışan bir entegrasyon varsa bu pencerede görünmez. Aynı sorguyu doksan günlük arşiv üzerinde tekrarlamadan "başka çağıran yok" demek doğru olmaz; şu an elimizdeki, "yedi günde başka çağıran görünmedi".
