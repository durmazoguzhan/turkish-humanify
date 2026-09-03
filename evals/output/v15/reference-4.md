# 3 Eylül 2026 ödeme kesintisi incident raporu

**Durum:** Kapandı | **Şiddet:** SEV-1 | **Süre:** 1 saat 47 dakika

## Özet

3 Eylül öğleden sonra ödeme servisi kademeli olarak yanıt veremez hale geldi. Checkout akışının tamamı iki saate yakın kullanılamadı. Sorun, bir gün önce devreye alınan connection pool ayarının yük altında yetersiz kalmasından kaynaklandı.

## Zaman çizelgesi (TSİ)

| Saat | Olay |
|------|------|
| 13:42 | Ödeme servisinde p99 latency 400 ms'den 3,2 saniyeye çıktı, uyarı eşiğinin altında kaldığı için alarm çalmadı |
| 14:05 | İlk timeout hataları görüldü, hata oranı %2 seviyesinde |
| 14:11 | PagerDuty alarmı tetiklendi, nöbetçi ekip devreye girdi |
| 14:20 | Hata oranı %61'e çıktı, incident SEV-1 olarak sınıflandırıldı |
| 14:34 | Veritabanı bağlantı havuzunun tamamen dolduğu tespit edildi |
| 14:52 | Bir önceki günün deployment'ı şüpheli olarak işaretlendi |
| 15:08 | Pool boyutu geçici olarak 25'ten 120'ye çıkarıldı, servis yeniden başlatıldı |
| 15:16 | Hata oranı %4'e düştü, kuyruktaki işlemler işlenmeye başladı |
| 15:29 | Tüm metrikler normal aralığa döndü |
| 16:40 | Bekleyen işlemlerin mutabakatı tamamlandı, incident kapatıldı |

## Etki

Yaklaşık 1 saat 47 dakika boyunca 8.400 ödeme denemesi başarısız oldu. Bunların 6.100'ü kullanıcıya açık hata döndürdü. Kalan 2.300'ü ise provider tarafında işlendiği halde bizim tarafımızda kayıt altına alınamadı, manuel mutabakat gerektirdi. Çift çekim yaşayan 47 müşteriye aynı gün iade yaptık. Tahmini ciro kaybı 1,2 milyon TL. Sepet ve ürün sayfaları etkilenmedi.

## Kök neden

2 Eylül'de retry mekanizmasında yapılan değişiklik başarısız çağrıları üç kez yeniden deniyor, ama her denemede havuzdan yeni bir bağlantı alıyordu. Normal trafikte fark edilmeyen bu davranış, öğleden sonraki kampanya trafiğiyle birlikte havuzu tüketti. Tükenen havuz daha fazla timeout üretti, timeout'lar daha fazla retry tetikledi; sistem kendi kendini besleyen bir döngüye girdi.

İkinci bir etken de şu: latency alarmı 5 saniye eşiğine göre ayarlıydı. Servis 3,2 saniyede takılı kaldığı 23 dakika boyunca hiçbir uyarı çıkmadı.

## Aksiyonlar

| Aksiyon | Sahip | Tarih |
|---------|-------|-------|
| Retry'lar mevcut bağlantıyı yeniden kullanacak | Ödeme ekibi | 8 Eylül |
| Latency alarm eşiği 1,5 saniyeye çekilecek | SRE | 6 Eylül |
| Circuit breaker eklenecek | Ödeme ekibi | 15 Eylül |
| Pool doygunluğu için ayrı metrik ve alarm kurulacak | SRE | 10 Eylül |
| Kampanya öncesi yük testi zorunlu olacak | Platform | 20 Eylül |
