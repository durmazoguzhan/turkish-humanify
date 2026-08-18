# Docker imajını üçte birine indirmek

Şişkin bir Docker imajı yalnızca disk alanı sorunu değil. Her yüz megabaytlık fazlalık CI süresini uzatır, dağıtımı yavaşlatır ve saldırı yüzeyini genişletir. Neyse ki tipik bir imajın boyutunu birkaç basit teknikle üçte birine indirebilirsiniz, kimi zaman onda birine.

## Doğru temel imajla başlayın

En büyük kazanç genellikle ilk satırda gizli. `ubuntu` ya da `node:20` gibi tam dağıtımlar yüzlerce megabayt taşır. Çoğu uygulama için `-slim` varyantı fazlasıyla yeterli. Alpine tabanlı imajlar daha da küçük. Ama musl libc kullandıkları için native bağımlılıklarda beklenmedik sorunlar çıkarabilir; geçmeden önce test edin. Go veya Rust gibi statik binary üretebilen dillerde `scratch` ya da `distroless` imajları neredeyse sıfır ek yük getirir.

## Çok aşamalı derleme (multi-stage build)

Derleme araçlarının çalışma zamanında bulunmasına gerek yok. Derleyiciler, geliştirme başlıkları, test bağımlılıkları ve paket yöneticisi önbellekleri yalnızca build sırasında lazım. Çok aşamalı derlemede ilk aşamada uygulamayı derleyip ikinci aşamada sadece üretilen çıktıyı ince bir temel imaja kopyalarsınız:

```dockerfile
FROM golang:1.22 AS builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o /app

FROM gcr.io/distroless/static
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
```

Bu yaklaşım tek başına yüzlerce megabaytlık fark yaratır, derleme araçlarının oluşturduğu güvenlik risklerini de ortadan kaldırır.

## Katman sayısını ve içeriğini kontrol edin

Docker imajları katmanlardan oluşur. Bir katmanda silinen dosya önceki katmanda durmaya devam eder. Bu yüzden kurulumla temizliği aynı `RUN` komutunda yapın:

```dockerfile
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*
```

`--no-install-recommends` bayrağı önerilen gereksiz paketleri engeller. `npm ci --omit=dev`, `pip install --no-cache-dir` gibi seçenekler de önbellek dosyalarının imaja sızmasını önler.

## .dockerignore dosyasını ihmal etmeyin

Build context'e `.git`, `node_modules`, test verileri, log dosyaları ve yerel ortam dosyaları girdiğinde hem imaj büyür hem de build süresi uzar. Küçük bir `.dockerignore` dosyası çoğu projede anında kazanç sağlar.

## Ölçün ve doğrulayın

Tahmin yürütmek yerine ölçün. `docker history <imaj>` hangi katmanın ne kadar yer kapladığını gösterir. `dive` aracı ise katman katman gezinerek boşa giden alanı ortaya çıkarır. Küçültmeye buradan başlarsanız en çok kazanç getiren noktaya odaklanırsınız.

## Sıralama

Önce ölçün, sonra temel imajı daraltın, çok aşamalı derlemeye geçin, katmanları temizleyin, build context'i sınırlayın. Bu beş adım çoğu projede imaj boyutunu ciddi biçimde düşürür, dağıtım süreçlerinizi de belirgin şekilde hızlandırır.
