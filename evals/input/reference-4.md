# Ödeme Kesintisi İncident Raporu — 3 Eylül 2026

**Durum:** Kapandı | **Şiddet:** SEV-1 | **Süre:** 1 saat 47 dakika

## Özet

3 Eylül günü öğleden sonra ödeme servisi kademeli olarak yanıt veremez hale geldi ve checkout akışının tamamı iki saate yakın süreyle kullanılamadı. Sorun, bir gün önce devreye alınan connection pool ayarının yük altında yetersiz kalmasından kaynaklandı.

## Zaman Çizelgesi (TSİ)

| Saat | Olay |
|------|------|
| 13:42 | Ödeme servisinin p99 latency değeri 400ms'den 3.2s'ye çıktı, uyarı eşiğinin altında kaldığı için alarm üretilmedi |
| 14:05 | İlk `timeout` hataları görüldü, hata oranı %2 seviyesinde |
| 14:11 | PagerDuty alarmı tetiklendi, nöbetçi ekip devreye girdi |
| 14:20 | Hata oranı %61'e çıktı, incident SEV-1 olarak sınıflandırıldı |
| 14:34 | Veritabanı bağlantı havuzunun tamamen dolu olduğu tespit edildi |
| 14:52 | Bir önceki günün deployment'ı şüpheli olarak işaretlendi |
| 15:08 | Pool boyutu geçici olarak 25'ten 120'ye çıkarıldı, servis yeniden başlatıldı |
| 15:16 | Hata oranı %4'e düştü, kuyruktaki işlemler işlenmeye başladı |
| 15:29 | Tüm metrikler normal aralığa döndü |
| 16:40 | Bekleyen işlemlerin mutabakatı tamamlandı, incident kapatıldı |

## Etki

Yaklaşık 1 saat 47 dakika boyunca **8.400 ödeme denemesi** başarısız oldu. Bunların 6.100'ü kullanıcıya açık hata döndürdü; kalan 2.300'ü provider tarafında işlendiği halde bizim tarafımızda kayıt altına alınamadı ve manuel mutabakat gerektirdi. Çift çekim yaşanan 47 müşteriye aynı gün içinde iade yapıldı. Tahmini ciro kaybı 1,2 milyon TL. Sepet ve ürün sayfaları etkilenmedi.

## Kök Neden

2 Eylül'de yapılan retry mekanizması değişikliği, başarısız çağrıları üç kez tekrar deniyor ancak her denemede havuzdan yeni bir bağlantı alıyordu. Normal trafikte fark edilmeyen bu davranış, öğleden sonraki kampanya trafiğiyle birlikte havuzu tüketti. Tükenen havuz daha fazla timeout üretti, timeout'lar daha fazla retry tetikledi ve sistem kendi kendini besleyen bir döngüye girdi.

İkinci bir etken: latency alarmı 5 saniye eşiğine göre ayarlıydı. Servis 3.2 saniyede takılı kaldığı 23 dakika boyunca hiçbir uyarı üretilmedi.

## Aksiyonlar

| Aksiyon | Sahip | Tarih |
|---------|-------|-------|
| Retry'ların mevcut bağlantıyı yeniden kullanması | Ödeme ekibi | 8 Eylül |
| Latency alarm eşiğinin 1.5s'ye çekilmesi | SRE | 6 Eylül |
| Circuit breaker eklenmesi | Ödeme ekibi | 15 Eylül |
| Pool doygunluğu için ayrı metrik ve alarm | SRE | 10 Eylül |
| Kampanya öncesi yük testinin zorunlu hale getirilmesi | Platform | 20 Eylül |
