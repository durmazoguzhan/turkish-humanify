# Ödeme kesintisi incident raporu, 3 Eylül 2026

**Durum:** Kapandı | **Şiddet:** SEV-1 | **Süre:** 1 saat 47 dakika

## Özet

3 Eylül öğleden sonra ödeme servisi kademe kademe yanıt veremez hale geldi. Checkout akışının tamamı iki saate yakın kullanılamadı. Sorunun kaynağı bir gün önce devreye alınan connection pool ayarı. Yük altında yetersiz kaldı.

## Zaman çizelgesi (TSİ)

| Saat | Olay |
|------|------|
| 13:42 | Ödeme servisinde p99 latency 400 ms'den 3,2 saniyeye çıktı, uyarı eşiğinin altında kaldığı için alarm üretilmedi |
| 14:05 | İlk `timeout` hataları görüldü, hata oranı %2 |
| 14:11 | PagerDuty alarmı tetiklendi, nöbetçi ekip devreye girdi |
| 14:20 | Hata oranı %61'e çıktı, incident SEV-1 olarak sınıflandırıldı |
| 14:34 | Veritabanı bağlantı havuzu tamamen dolu çıktı |
| 14:52 | Şüphe bir önceki günün deployment'ına yöneldi |
| 15:08 | Havuz boyutu geçici olarak 25'ten 120'ye çıkarıldı, servis yeniden başlatıldı |
| 15:16 | Hata oranı %4'e düştü, kuyruktaki işlemler işlenmeye başladı |
| 15:29 | Tüm metrikler normal aralığa döndü |
| 16:40 | Bekleyen işlemlerin mutabakatı bitti, incident kapandı |

## Etki

Yaklaşık 1 saat 47 dakika boyunca **8.400 ödeme denemesi** başarısız oldu. Bunların 6.100'ü kullanıcıya açık hata döndürdü. Kalan 2.300'ü ise provider tarafında işlendiği halde bizim tarafımızda kayıt altına alınamadı, elle mutabakat gerektirdi. Çift çekim yaşayan 47 müşteriye aynı gün iade yapıldı. Tahmini ciro kaybı 1,2 milyon TL. Sepet ve ürün sayfaları etkilenmedi.

## Kök neden

2 Eylül'de retry mekanizmasında yapılan değişiklik, başarısız çağrıları üç kez tekrar deniyor ancak her denemede havuzdan yeni bir bağlantı alıyordu. Normal trafikte fark edilmeyen bu davranış, öğleden sonraki kampanya trafiğiyle birlikte havuzu tüketti. Tükenen havuz daha fazla timeout üretti, timeout'lar daha fazla retry tetikledi. Sistem kendi kendini besleyen bir döngüye girmişti.

İkinci bir etken: latency alarmı 5 saniye eşiğine göre ayarlıydı. Servis 3,2 saniyede takılı kaldığı 23 dakika boyunca hiçbir uyarı çıkmadı.

## Aksiyonlar

| Aksiyon | Sahip | Tarih |
|---------|-------|-------|
| Retry'lar mevcut bağlantıyı yeniden kullanacak | Ödeme ekibi | 8 Eylül |
| Latency alarm eşiği 1,5 saniyeye çekilecek | SRE | 6 Eylül |
| Circuit breaker eklenecek | Ödeme ekibi | 15 Eylül |
| Havuz doygunluğu için ayrı metrik ve alarm tanımlanacak | SRE | 10 Eylül |
| Kampanya öncesi yük testi zorunlu olacak | Platform | 20 Eylül |
