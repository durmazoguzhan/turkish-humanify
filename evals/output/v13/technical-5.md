# Docker imajını küçültmek: önce ölçün, sonra daraltın

Şişkin bir Docker imajı yalnızca disk alanı sorunu değil. Her yüz megabaytlık fazlalık CI süresini uzatır, dağıtımı yavaşlatır, saldırı yüzeyini de genişletir. İyi tarafı şu: tipik bir imajın boyutunu birkaç basit teknikle üçte birine, kimi zaman onda birine indirmek mümkün.

## Doğru temel imajla başlayın

En büyük kazanç genellikle ilk satırda gizli. `ubuntu` veya `node:20` gibi tam dağıtımlar yüzlerce megabayt taşır. `-slim` varyantları ise çoğu uygulamaya fazlasıyla yeter.

Alpine tabanlı imajlar daha da küçük. Ama musl libc kullandıkları için native bağımlılıklarda beklenmedik sorunlar çıkarabiliyor; geçmeden önce test edin. Go veya Rust gibi statik binary üretebilen dillerde `scratch` ya da `distroless` imajları neredeyse sıfır ek yük getirir.

## Çok aşamalı derlemeye geçin (multi-stage build)

Derleme araçlarının çalışma zamanında işi yok. Derleyiciler, geliştirme başlıkları, test bağımlılıkları, paket yöneticisi önbellekleri: hepsi yalnızca build sırasında lazım. Çok aşamalı derlemede ilk aşamada uygulamayı derler, ikinci aşamada sadece üretilen çıktıyı ince bir temel imaja kopyalarsınız:

```dockerfile
FROM golang:1.22 AS builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o /app

FROM gcr.io/distroless/static
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
```

Tek başına bu yaklaşım yüzlerce megabaytlık fark yaratır. Derleme araçlarının oluşturduğu güvenlik risklerini de ortadan kaldırır.

## Silinen dosya önceki katmanda kalır

Docker imajı katmanlardan oluşur. Bir katmanda silinen dosya önceki katmanda durmaya devam eder. Bu yüzden kurulumu da temizliği de aynı `RUN` komutunda yapın:

```dockerfile
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*
```

`--no-install-recommends` bayrağı önerilen gereksiz paketleri engeller. Paket yöneticilerinde de aynı mantık geçerli: `npm ci --omit=dev`, `pip install --no-cache-dir` gibi seçenekler önbellek dosyalarının imaja sızmasını önler.

## .dockerignore dosyasını ihmal etmeyin

`.git`, `node_modules`, test verileri, log dosyaları ve yerel ortam dosyaları build context'e girdiğinde hem imajı büyütür hem de build süresini uzatır. Küçük bir `.dockerignore` dosyası çoğu projede anında kazanç sağlar.

## Tahmin yürütmek yerine ölçün

`docker history <imaj>` hangi katmanın ne kadar yer kapladığını gösterir. `dive` aracı ise katman katman gezinerek boşa giden alanı ortaya çıkarır. Küçültme çalışmasına buradan başlamak, en çok kazanç getiren noktaya odaklanmanızı sağlar.

## Sıralama basit

Önce ölçün, sonra temel imajı daraltın, çok aşamalı derlemeye geçin, katmanları temizleyin, build context'i sınırlayın. Bu beş adım çoğu projede imaj boyutunu dramatik biçimde düşürür, dağıtım süreçlerinizi de belirgin biçimde hızlandırır.
