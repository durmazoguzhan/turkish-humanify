# Docker İmajlarını Küçültme Yöntemleri

Şişkin Docker imajları yalnızca disk alanı sorunu değildir. Her yüz megabaytlık fazlalık, CI süresini uzatır, dağıtım hızını düşürür ve saldırı yüzeyini genişletir. İyi haber şu ki, tipik bir imajın boyutunu birkaç basit teknikle üçte birine, kimi zaman onda birine indirmek mümkündür.

## Doğru temel imajla başlayın

En büyük kazanç genellikle ilk satırda gizlidir. `ubuntu` veya `node:20` gibi tam dağıtımlar yüzlerce megabayt taşır. Bunun yerine `-slim` varyantları çoğu uygulama için fazlasıyla yeterlidir. Alpine tabanlı imajlar daha da küçüktür, ancak musl libc kullandıkları için native bağımlılıklarda beklenmedik sorunlar çıkarabilir; geçmeden önce test edin. Go veya Rust gibi statik binary üretebilen dillerde `scratch` ya da `distroless` imajları neredeyse sıfır ek yük getirir.

## Çok aşamalı derleme (multi-stage build)

Derleme araçlarının çalışma zamanında bulunmasına gerek yoktur. Derleyiciler, geliştirme başlıkları, test bağımlılıkları ve paket yöneticisi önbellekleri yalnızca build sırasında lazımdır. Çok aşamalı derlemede ilk aşamada uygulamayı derler, ikinci aşamada sadece üretilen çıktıyı ince bir temel imaja kopyalarsınız:

```dockerfile
FROM golang:1.22 AS builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o /app

FROM gcr.io/distroless/static
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
```

Bu yaklaşım tek başına yüzlerce megabaytlık farklar yaratır ve aynı zamanda derleme araçlarının oluşturduğu güvenlik risklerini de ortadan kaldırır.

## Katman sayısını ve içeriğini kontrol edin

Docker imajları katmanlardan oluşur ve bir katmanda silinen dosya, önceki katmanda durmaya devam eder. Bu yüzden kurulum ve temizlik aynı `RUN` komutunda yapılmalıdır:

```dockerfile
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*
```

`--no-install-recommends` bayrağı gereksiz önerilen paketleri engeller. Benzer şekilde `npm ci --omit=dev`, `pip install --no-cache-dir` gibi seçenekler önbellek dosyalarının imaja sızmasını önler.

## .dockerignore dosyasını ihmal etmeyin

`.git`, `node_modules`, test verileri, log dosyaları ve yerel ortam dosyaları build context'e girdiğinde hem imajı büyütür hem de build süresini uzatır. Küçük bir `.dockerignore` dosyası çoğu projede anında kazanç sağlar.

## Ölçün ve doğrulayın

Tahmin yürütmek yerine ölçün. `docker history <imaj>` hangi katmanın ne kadar yer kapladığını gösterir. `dive` aracı ise katman katman gezinerek boşa giden alanı ortaya çıkarır. Küçültme çalışmasına buradan başlamak, en çok kazanç getiren noktaya odaklanmanızı sağlar.

## Özet

Sıralama basit: önce ölçün, sonra temel imajı daraltın, çok aşamalı derlemeye geçin, katmanları temizleyin ve build context'i sınırlayın. Bu beş adım çoğu projede imaj boyutunu dramatik biçimde düşürür ve dağıtım süreçlerinizi belirgin şekilde hızlandırır.
