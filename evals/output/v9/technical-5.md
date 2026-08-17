# Docker imajlarını küçültmenin beş adımı

Şişkin bir Docker imajı yalnızca disk alanı sorunu değil. Her yüz megabaytlık fazlalık CI süresini uzatır, dağıtım hızını düşürür, saldırı yüzeyini de genişletir. İyi tarafı, tipik bir imajın boyutunu birkaç basit teknikle üçte birine indirmek mümkün; kimi zaman onda birine kadar.

## Doğru temel imajla başlayın

En büyük kazanç genellikle ilk satırda saklı. `ubuntu` ya da `node:20` gibi tam dağıtımlar yüzlerce megabayt taşır; oysa `-slim` varyantları çoğu uygulama için fazlasıyla yeterli.

Alpine tabanlı imajlar daha da küçük. Daha doğrusu küçük, ama her yerde sorunsuz değil: musl libc kullandıkları için native bağımlılıklarda beklenmedik sorunlar çıkarabilir. Geçmeden önce test edin. Go ya da Rust gibi statik binary üretebilen dillerdeyse `scratch` ve `distroless` imajları neredeyse sıfır ek yük getirir.

## Çok aşamalı derleme (multi-stage build)

Derleme araçlarının çalışma zamanında bulunmasına gerek yok. Derleyiciler, geliştirme başlıkları, test bağımlılıkları, paket yöneticisinin önbellekleri; hepsi yalnızca build sırasında lazım. Çok aşamalı derlemede ilk aşamada uygulamayı derleyip ikinci aşamada sadece üretilen çıktıyı ince bir temel imaja kopyalarsınız:

```dockerfile
FROM golang:1.22 AS builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o /app

FROM gcr.io/distroless/static
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
```

Bu yaklaşım tek başına yüzlerce megabaytlık fark yaratır; üstelik derleme araçlarının oluşturduğu güvenlik risklerini de ortadan kaldırır.

## Katman sayısını ve içeriğini kontrol edin

Docker imajları katmanlardan oluşur, bir katmanda silinen dosya da önceki katmanda durmaya devam eder. Kurulumu ve temizliği bu yüzden aynı `RUN` komutunda yapın:

```dockerfile
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*
```

`--no-install-recommends` bayrağı gereksiz yere önerilen paketleri engeller. `npm ci --omit=dev`, `pip install --no-cache-dir` gibi seçenekler de önbellek dosyalarının imaja sızmasını önler.

## .dockerignore dosyasını ihmal etmeyin

`.git`, `node_modules`, test verileri, log dosyaları ve yerel ortam dosyaları build context'e girdiğinde hem imaj büyür hem de build süresi uzar. Küçük bir `.dockerignore` dosyası çoğu projede anında kazanç sağlar.

## Ölçün ve doğrulayın

Tahmin yürütmek yerine ölçün. Hangi katmanın ne kadar yer kapladığını `docker history <imaj>` gösterir; `dive` aracı ise katman katman gezinip boşa giden alanı ortaya çıkarır. Küçültme çalışmasına buradan başlamak, en çok kazanç getiren noktaya odaklanmanızı sağlar.

## Sıralama

Sıra basit: önce ölçün, sonra temel imajı daraltın, çok aşamalı derlemeye geçin, katmanları temizleyin, build context'i de sınırlayın. Bu beş adım çoğu projede imaj boyutunu ciddi biçimde düşürür, dağıtım süreçlerinizi de belirgin şekilde hızlandırır.
