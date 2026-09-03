# Runbook: canlıda veritabanı bağlantı havuzu tükendiğinde

**Kapsam:** Uygulama `TimeoutException: pool exhausted` / `connection timeout waiting for pool` hatası verdiğinde. Nöbetçi mühendis için.

## 1. Doğrula (0-3 dk)

Alarmı olduğu gibi kabul etme. Önce havuzun gerçekten dolu olduğunu gör:

- Uygulama metriklerinden `pool.active`, `pool.idle`, `pool.pending` değerlerini oku. Aktif sayısı `MaxPoolSize`'a dayanmışken pending kuyruğu büyüyorsa teşhis doğru.
- Bir de veritabanı tarafından say: `SELECT state, count(*) FROM pg_stat_activity GROUP BY state;` Burada gördüğün bağlantı sayısı uygulamanın iddiasıyla uyuşmuyorsa sorun havuzda değil, ölçümde.
- Etkilenen instance sayısını belirle. Tek pod mu, tüm cluster mı? Tek pod ise sorun büyük ihtimalle o pod'a özgü.

## 2. Kanamayı durdur (3-15 dk)

Kök nedeni bulmadan önce servisi ayakta tut.

- `idle in transaction` durumunda 5 dakikadan uzun bekleyen bağlantıları tespit et. Bunlar commit edilmemiş transaction'lar. Havuzu asıl tıkayan da genellikle bunlar oluyor. `pg_terminate_backend(pid)` ile teker teker sonlandır, toplu değil. Önce en eskisinden başla.
- Uzun süren sorguları listele. Tek bir raporlama sorgusu havuzu boğuyorsa çoğu zaman onu iptal etmek yeter.
- Deploy penceresi içindeysen rollback'i değerlendir. Son 24 saatte giden bir değişiklik varsa geri almak hata ayıklamaktan hızlı.
- Havuz boyutunu büyütmek son çaredir. Veritabanının `max_connections` limitini de kontrol etmeden büyütme; havuzu genişletip veritabanını devirmek olağan bir hata.

## 3. Kök nedeni bul

Servis nefes aldıktan sonra sebebe in. Sık görülen üç şekil:

- **Sızıntı:** Kod bir yerde bağlantıyı `dispose` etmiyor. Sızıntı grafiği merdiven gibi: trafik düşse bile aktif sayı geri inmez. Bunu tespit ettiren şey trafiğin değil, eğrinin şekli.
- **Yavaşlama:** Sorgular yavaşladığı için bağlantılar daha uzun tutuluyor. Havuz aslında normal, altındaki disk ya da index bozulmuş.
- **Trafik artışı:** Gerçek yük artışı. Bu durumda kapasite kararı gerekir, hotfix değil.

## 4. Kapat

Havuz metriklerinin 30 dakika boyunca normale döndüğünü doğrula, sonra incident'ı kapat. Postmortem'de tek bir soruya cevap ver: bu, alarm çalmadan önce hangi metrikten görülebilirdi? Cevap genellikle `pool.pending`. O metriğin alarmı da genellikle yok.

**Escalation:** 30 dakikada toparlanmazsa veritabanı ekibine, veri kaybı şüphesi varsa doğrudan incident komutasına.
