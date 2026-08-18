# Redis'te cache invalidation: veriyi doğru zamanda unutmak

Cache'leme kolaydır. Zor olan, cache'lenmiş verinin ne zaman geçersiz hale geldiğine karar vermektir. Phil Karlton'ın o meşhur sözü boşuna değil: bilgisayar bilimlerindeki iki zor problemden biri cache invalidation.

## TTL: En basit ve çoğu zaman en doğru yaklaşım

Redis'te invalidation'ın en yalın hali `EXPIRE`. Veriye bir ömür biçersiniz, süre dolunca Redis onu kendisi temizler:

```
SET user:1042 "{...}" EX 300
```

Bu yaklaşımın güzelliği, hata durumunda kendini toparlaması. Invalidation mantığınızda bir bug olsa bile bayat veri en fazla TTL kadar hayatta kalır. Dezavantajı ise şu: TTL süresince kullanıcılar eski veriyi görebilir. Ürün fiyatı için 5 dakika kabul edilebilir. Kullanıcı yetkileri için aynı 5 dakika felaket olabilir.

## Write-through ve explicit invalidation

Veri değiştiğinde cache'i doğrudan silmek (`DEL`) ya da güncellemek daha keskin bir kontrol sağlar. Burada asıl soru şu: silmek mi, güncellemek mi?

Genel kural, güncellemek yerine silmek. Genel diyorum, çünkü güncellemek de çalışır; sadece yanlış gitmesi daha kolay. Cache'i yazma anında güncellerseniz eşzamanlı iki yazma işleminin sırası karışabilir, cache de kalıcı olarak yanlış değeri tutabilir. Silme idempotent; bir sonraki okuma veriyi veritabanından tazeler.

Sıralama da önemli: önce veritabanını yazın, sonra cache'i silin. Tersi sırada, silme ile yazma arasındaki pencerede başka bir okuma eski veriyi cache'e geri koyabilir.

## Cache stampede problemi

Popüler bir key expire olduğu anda yüzlerce istek aynı anda veritabanına yönelir. Buna cache stampede deniyor; production'da veritabanını çökertecek kadar ciddi.

İki pratik çözüm var. Birincisi, bir lock key ile veriyi yalnızca tek bir isteğin yeniden üretmesine izin vermek:

```
SET lock:user:1042 1 NX EX 10
```

`NX` sayesinde lock'u ilk istek alır; diğerleri ya kısa süre bekler ya da bayat veriyi döner. İkincisi ise probabilistic early expiration: TTL dolmadan biraz önce, rastgele seçilen küçük bir istek yüzdesi cache'i proaktif olarak yeniler.

## Grup halinde invalidation

Tek bir key'i silmek kolay; "bu kullanıcıya ait tüm cache'leri sil" demek zor. `KEYS user:1042:*` komutu asla kullanılmamalı; Redis tek thread'li çalıştığı için bu komut tüm sunucuyu bloke eder. `SCAN` daha güvenli ama o da yavaş.

Daha temiz yol, versiyon damgası. Key'lere bir versiyon numarası gömersiniz:

```
user:1042:v7:profile
```

Kullanıcı verisi değiştiğinde `INCR user:1042:version` yaparsınız. Eski versiyonlu key'leri artık kimse okumaz; TTL'leriyle sessizce ölürler. Tek bir atomik komutla binlerce key'i mantıksal olarak geçersiz kılmış olursunuz.

Doğru strateji, verinin bayatlığa toleransına bağlı. Tolerans yüksekse TTL yeterli; düşükse explicit invalidation ve versiyonlama gerekir. Her durumda TTL'i bir güvenlik ağı olarak bırakın. Invalidation mantığınız er ya da geç bir senaryoyu kaçıracak; o an sizi kurtaran şey, verinin kendi kendine ölmesi olur.
