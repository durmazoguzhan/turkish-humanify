# Docker imajını küçültmenin beş adımı

Şişkin bir Docker imajı yalnızca disk alanı sorunu değil. Her yüz megabaytlık fazlalık CI süresini uzatır, dağıtım hızını düşürür, saldırı yüzeyini genişletir. Neyse ki tipik bir imajın boyutunu birkaç basit teknikle üçte birine, kimi zaman onda birine indirmek mümkün.

## Doğru temel imajla başlayın

En büyük kazanç genellikle ilk satırda saklı. `ubuntu` ya da `node:20` gibi tam dağıtımlar yüzlerce megabayt taşır. Çoğu uygulama içinse `-slim` varyantları fazlasıyla yeterli.

Alpine tabanlı imajlar daha da küçük, ama musl libc kullandıkları için native bağımlılıklarda beklenmedik sorun çıkarabilir. Geçmeden önce test edin. Go ya da Rust gibi statik binary üretebilen dillerde `scratch` veya `distroless` imajları neredeyse sıfır ek yük getirir.

## Çok aşamalı derleme (multi-stage build)

Derleme araçlarının çalışma zamanında bulunmasına gerek yok. Derleyiciler, geliştirme başlıkları, test bağımlılıkları, paket yöneticisi önbellekleri; hepsi yalnızca build sırasında lazım. Çok aşamalı derlemede ilk aşamada uygulamayı derler, ikinci aşamada sadece üretilen çıktıyı ince bir temel imaja kopyalarsınız:

```dockerfile
FROM golang:1.22 AS builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o /app

FROM gcr.io/distroless/static
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
```

Bu yaklaşım tek başına yüzlerce megabaytlık fark yaratır. Üstelik derleme araçlarının oluşturduğu güvenlik risklerini de ortadan kaldırır.

## Katman sayısını ve içeriğini kontrol edin

Docker imajı katmanlardan oluşur. Bir katmanda sildiğiniz dosya, bir önceki katmanda durmaya devam eder. Bu yüzden kurulumu ve temizliği aynı `RUN` komutunda yapın:

```dockerfile
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*
```

`--no-install-recommends` bayrağı gereksiz önerilen paketleri engeller. Aynı mantıkla `npm ci --omit=dev` ve `pip install --no-cache-dir` gibi seçenekler de önbellek dosyalarının imaja sızmasını önler.

## .dockerignore dosyasını ihmal etmeyin

`.git`, `node_modules`, test verileri, log dosyaları ve yerel ortam dosyaları build context'e girdiğinde hem imajı büyütür hem de build süresini uzatır. Küçük bir `.dockerignore` dosyası çoğu projede anında kazanç sağlar.

## Ölçün ve doğrulayın

Tahmin yürütmek yerine ölçün. `docker history <imaj>` hangi katmanın ne kadar yer kapladığını gösterir. `dive` aracı ise katman katman gezinerek boşa giden alanı ortaya çıkarır. Küçültme çalışmasına buradan başlamak, en çok kazanç getiren noktaya odaklanmanızı sağlar.

## Sıralama basit

Önce ölçün. Sonra temel imajı daraltın, çok aşamalı derlemeye geçin, katmanları temizleyin, build context'i sınırlayın. Bu beş adım çoğu projede imaj boyutunu ciddi biçimde düşürür, dağıtım süreçlerini de belirgin biçimde hızlandırır.
