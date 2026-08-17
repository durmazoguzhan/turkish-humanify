# Redis'te Cache Invalidation: Doğru Veriyi Doğru Zamanda Unutmak

Cache'lemek kolay. Zor olan, cache'lenmiş verinin ne zaman geçersiz hale geldiğine karar vermek. Phil Karlton'ın meşhur sözü boşuna değil: bilgisayar bilimlerindeki iki zor problemden biri cache invalidation.

## TTL: en basit ve çoğu zaman en doğru yaklaşım

Redis'te invalidation'ın en yalın hali `EXPIRE`. Veriye bir ömür biçersiniz, süre dolunca Redis onu kendi temizler:

```
SET user:1042 "{...}" EX 300
```

Bu yaklaşımın güzelliği, hata durumunda kendini toparlaması. Invalidation mantığınızda bir bug olsa bile bayat veri en fazla TTL kadar hayatta kalır. Dezavantajı ise TTL boyunca kullanıcıların eski veriyi görebilmesi. Ürün fiyatı için 5 dakika kabul edilebilirken kullanıcı yetkileri için felaket olabilir.

## Write-through ve explicit invalidation

Veri değiştiğinde cache'i doğrudan silmek (`DEL`) ya da güncellemek daha keskin bir kontrol sağlar. Kritik soru şu: silmek mi, güncellemek mi?

Genel kural, **güncellemek yerine silmek**. Cache'i yazma anında güncellerseniz eşzamanlı iki yazma işleminin sırası karışabilir; cache de kalıcı olarak yanlış değeri tutabilir. Silme ise idempotent, bir sonraki okuma veriyi veritabanından tazeler.

Sıralama da önemli: önce veritabanına yazın, sonra cache'i silin. Ters sırada, silme ile yazma arasındaki pencerede başka bir okuma eski veriyi tekrar cache'e koyabilir.

## Cache stampede: popüler bir key expire olduğu anda ne oluyor

Popüler bir key expire olduğu anda yüzlerce istek aynı anda veritabanına yönelir. Buna cache stampede denir; canlı ortamda veritabanını çökertecek kadar ciddi.

İki pratik çözüm var. Birincisi, bir lock key ile yalnızca tek bir isteğin veriyi yeniden üretmesine izin vermek:

```
SET lock:user:1042 1 NX EX 10
```

`NX` sayesinde lock'u yalnızca ilk istek alır; diğerleri ya kısa süre bekler ya da bayat veriyi döner. İkincisi ise probabilistic early expiration: TTL dolmadan az önce, rastgele seçilen küçük bir istek yüzdesi cache'i proaktif olarak yeniler.

## Grup halinde invalidation

Tek bir key'i silmek kolay. "Bu kullanıcıya ait tüm cache'leri sil" demek zor. `KEYS user:1042:*` komutunu asla kullanmayın: Redis tek thread'li çalıştığı için bu komut tüm sunucuyu bloke eder. `SCAN` daha güvenli ama yine de yavaş.

Daha temiz yöntem versiyon damgası. Key'lere bir versiyon numarası gömersiniz:

```
user:1042:v7:profile
```

Kullanıcı verisi değiştiğinde `INCR user:1042:version` yaparsınız. Eski versiyonlu key'ler artık hiç okunmaz, TTL'leriyle sessizce ölür. Tek bir atomik komutla binlerce key'i mantıksal olarak geçersiz kılmış olursunuz.

## Hangi strateji, ne zaman

Doğru strateji verinin bayatlığa toleransına bağlı. Tolerans yüksekse TTL yeter; düşükse explicit invalidation ve versiyonlama gerekir. Her durumda TTL'i güvenlik ağı olarak bırakın: invalidation mantığınız er ya da geç bir senaryoyu kaçıracak, o an sizi kurtaracak olan da verinin kendi kendine ölmesi.
