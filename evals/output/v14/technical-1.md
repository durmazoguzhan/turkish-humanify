# Redis'te veriyi cache'e koymak kolay, çıkarmak zor

Cache'leme kolaydır. Zor olan, cache'lenmiş verinin ne zaman geçersiz hale geldiğine karar vermektir. Phil Karlton'ın meşhur sözü boşuna değil: bilgisayar bilimlerindeki iki zor problemden biri cache invalidation.

## TTL: en basit ve çoğu zaman en doğru yaklaşım

Redis'te invalidation'ın en yalın hali `EXPIRE` kullanmak. Veriye bir ömür biçersiniz, süre dolunca Redis onu kendisi temizler:

```
SET user:1042 "{...}" EX 300
```

Bu yaklaşımın güzelliği, hata durumunda kendini toparlaması. Invalidation mantığınızda bir bug olsa bile bayat veri en fazla TTL kadar hayatta kalır.

Dezavantajı ise şu: TTL süresince kullanıcılar eski veriyi görebilir. Ürün fiyatı için 5 dakika kabul edilebilirken kullanıcı yetkileri için felaket olabilir.

## Write-through ve explicit invalidation

Veri değiştiğinde cache'i doğrudan silmek (`DEL`) ya da güncellemek daha keskin bir kontrol sağlar. Burada kritik soru şu: silmek mi, güncellemek mi?

Genel kural, **güncellemek yerine silmek**. Cache'i yazma anında güncellerseniz eşzamanlı iki yazma işleminin sırası karışabilir, cache de kalıcı olarak yanlış değeri tutabilir. Silme işlemi ise idempotent. Bir sonraki okuma veriyi veritabanından tazeler.

Sıralama da önemli: önce veritabanını yazın, sonra cache'i silin. Ters sırada yaparsanız, silme ile yazma arasındaki pencerede başka bir okuma eski veriyi tekrar cache'e koyabilir.

## Cache stampede problemi

Popüler bir key expire olur olmaz yüzlerce istek birden veritabanına yönelir. Buna cache stampede denir. Canlı ortamda veritabanı çökertecek kadar ciddi.

İki pratik çözüm var. Birincisi, bir lock key ile yalnızca tek bir isteğin veriyi yeniden üretmesine izin vermek:

```
SET lock:user:1042 1 NX EX 10
```

`NX` sayesinde lock'u yalnızca ilk istek alır, diğerleri ya kısa süre bekler ya da bayat veriyi döner. İkincisi ise probabilistic early expiration: TTL dolmadan biraz önce, rastgele seçilen küçük bir istek yüzdesi cache'i proaktif olarak yeniler.

## Grup halinde invalidation

Tek bir key'i silmek kolay, ama "bu kullanıcıya ait tüm cache'leri sil" demek zor. `KEYS user:1042:*` komutu asla kullanılmamalı; Redis tek thread'li çalıştığı için bu komut tüm sunucuyu bloke eder. `SCAN` daha güvenli ama yine de yavaş.

Daha temiz yöntem, versiyon damgası. Key'lere bir versiyon numarası gömersiniz:

```
user:1042:v7:profile
```

Kullanıcı verisi değiştiğinde `INCR user:1042:version` yaparsınız. Eski versiyonlu key'ler artık hiç okunmaz, TTL'leriyle sessizce ölür. Tek bir atomik komutla binlerce key'i mantıksal olarak geçersiz kılmış olursunuz.

## Doğru strateji verinin bayatlığa toleransına bağlı

Tolerans yüksekse TTL yeter. Düşükse explicit invalidation ve versiyonlama gerekir.

Her durumda TTL'i bir güvenlik ağı olarak bırakın. Invalidation mantığınız er ya da geç bir senaryoyu kaçıracak. O an sizi kurtaracak olan şey, verinin kendi kendine ölmesi.
