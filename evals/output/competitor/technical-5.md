## 1. Tespit Raporu

**Register teşhisi:** Deneme-blog (teknik anlatım / how-to). Metin okura doğrudan sesleniyor ("başlayın," "test edin," "ihmal etmeyin"), giriş cümlesi bir blog açılışı. Bu yüzden Faz 2'nin tam seti uygulandı, edebi-yaratıcı sinyaller (19, 20, 21) hariç. Onay istenmedi, seçim burada yapıldı; belge 7 paragraf olduğu için "tümünü tek seferde" modu seçildi.

**Paragraf sınıflandırması:**

| Paragraf | Baskın sinyal | Sınıf |
|---|---|---|
| P1 (giriş) | Sinyal 4 | Orta |
| P2 (temel imaj) | Sinyal 1b | Orta |
| P3 (çok aşamalı) | Sinyal 4 | Orta |
| P4 (katmanlar) | — (yalnızca ikincil 11) | Temiz |
| P5 (.dockerignore) | — | Temiz |
| P6 (ölçün) | — | Temiz |
| P7 (özet) | Sinyal 5a, 5b | Orta |

**Baskın sinyaller:**

- **Sinyal 4 — "Sadece X değil, aynı zamanda Y" ailesi: 2 örnek.**
  - P1 c.1: "Şişkin Docker imajları **yalnızca** disk alanı sorunu **değildir**." Klasik "It's not just X" hamlesinin Türkçeye zorla çevrilmiş hâli; Y'yi bir sonraki cümleye bırakıyor.
  - P3 son cümle: "...farklar yaratır **ve aynı zamanda** ... risklerini **de** ortadan kaldırır." Aynı ailenin "aynı zamanda Y" varyantı.
- **Sinyal 1b — Noktalı virgül suistimali: 1 örnek.** P2: "...sorunlar çıkarabilir**;** geçmeden önce test edin." TDK'nın üç kullanımından hiçbiri değil (ne tür gruplama, ne ögeleri arasında virgül bulunan sıralı cümle, ne özne vurgusu). AI'nin "iki fikri birleştir" kullanımı.
- **Sinyal 5a — Boş değerlendirici niteleme: 2 örnek.** P7: "**dramatik biçimde** düşürür," "**belirgin şekilde** hızlandırır." İkisi de çıkarıldığında cümlenin bilgisi aynı kalıyor.
- **Sinyal 5b — Boş değerlendirici kapanış: 1 örnek.** P7 son cümlesi bir sonuç bildirmek yerine kendi kendini övüyor. Ancak içinde gerçek bir iddia da var ("beş adım boyutu düşürür"), o yüzden silinmedi, yeniden ifade edildi.

**İkincil sinyaller:**

- **Sinyal 11 — Pasif/öznesiz yapı: 3 örnek.** "indirmek **mümkündür**" (P1), "bulunmasına gerek **yoktur**" (P3), "aynı `RUN` komutunda **yapılmalıdır**" (P4), "bir katmanda **silinen** dosya" (P4). Metnin geri kalanı aktif 2. çoğul kullanırken bu dört yer öznesizleşiyor.
- **Sinyal 8 — Devrik cümle yokluğu: belge geneli.** Yedi paragrafta tek devrik yok, hepsi düz özne-nesne-yüklem.
- **İngilizce kalıp söylem belirteci (Sinyal 12 komşusu): 1 örnek.** P1: "**İyi haber şu ki,**" — "The good news is" kalıbı. Vurgu-doldurucu değil ama aynı refleksin ürünü.

**Sınırda kalan, sinyal saymadıklarım:**

- P1'deki üçlü ("CI süresini uzatır, dağıtım hızını düşürür, saldırı yüzeyini genişletir") Sinyal 7 gibi duruyor ama üç öğe gerçekten farklı üç maliyet. Dolgu değil, korundu.
- P7'deki "Sıralama basit:" Sinyal 14 (fragment) gibi görünüyor ama yüklemi var ("basit"), gerçek fragment değil. Yine de iki nokta yükünü hafifletmek için noktaya çevrildi.
- "build / derleme" ikili terminolojisi teknik olarak Sinyal 13'e (eş anlamlı rotasyonu) benziyor. Türk geliştirici yazısının gerçek alışkanlığı bu ("build context," "build süresi" yerleşik terim), zorla Türkçeleştirmedim.

## 2. Sinyal Yoğunluğu

Düzyazı gövdesi (başlıklar ve kod blokları hariç) ~305 kelime.

- **Önce:** 11 sinyal → **3,6 sinyal/100 kelime**
- **Sonra:** 1 sınırda vaka (bilinçli bırakılan build/derleme ikiliği) → **0,3 sinyal/100 kelime**
- **İyileşme oranı: ~%91**

Paragraf bazında: P1 3 → 0, P2 1 → 0, P3 3 → 0, P4 2 → 0, P5 0 → 0, P6 0 → 0, P7 3 → 0.

## 3. Onarılmış Versiyon

# Docker İmajlarını Küçültme Yöntemleri

Şişkin bir Docker imajı disk alanından fazlasını götürür. Her yüz megabaytlık fazlalık CI süresini uzatır, dağıtım hızını düşürür, saldırı yüzeyini genişletir. İyi tarafı da var. Tipik bir imajın boyutunu birkaç basit teknikle üçte birine, kimi zaman onda birine indirebilirsiniz.

## Doğru temel imajla başlayın

En büyük kazanç genellikle ilk satırda gizlidir. `ubuntu` veya `node:20` gibi tam dağıtımlar yüzlerce megabayt taşır. Çoğu uygulama için `-slim` varyantları fazlasıyla yeterli. Alpine tabanlı imajlar daha da küçük. Ne var ki musl libc kullandıkları için native bağımlılıklarda beklenmedik sorunlar çıkarabilirler. Geçmeden önce test edin. Go veya Rust gibi statik binary üretebilen dillerde `scratch` ya da `distroless` imajları neredeyse sıfır ek yük getirir.

## Çok aşamalı derleme (multi-stage build)

Derleme araçlarının çalışma zamanında bulunmasına gerek yok. Daha doğrusunu söyleyelim. Uygulamayı derleyen şeylerin nihai imajda hiç işi yok. Derleyiciler, geliştirme başlıkları, test bağımlılıkları ve paket yöneticisi önbellekleri yalnızca build sırasında lazım. Çok aşamalı derlemede ilk aşamada uygulamayı derler, ikinci aşamada sadece üretilen çıktıyı ince bir temel imaja kopyalarsınız:

```dockerfile
FROM golang:1.22 AS builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o /app

FROM gcr.io/distroless/static
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
```

Tek başına yüzlerce megabaytlık fark yaratır bu yaklaşım. Bir de derleme araçlarının doğurduğu güvenlik risklerinden kurtulursunuz.

## Katman sayısını ve içeriğini kontrol edin

Docker imajları katmanlardan oluşur ve bir katmanda sildiğiniz dosya önceki katmanda durmaya devam eder. Silmek tek başına yetmiyor yani. Kurulumu ve temizliği aynı `RUN` komutunda yapın:

```dockerfile
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*
```

`--no-install-recommends` bayrağı gereksiz önerilen paketleri engeller. Paket yöneticilerinde de benzer seçenekler var. `npm ci --omit=dev` ya da `pip install --no-cache-dir` önbellek dosyalarının imaja sızmasını önler.

## .dockerignore dosyasını ihmal etmeyin

`.git`, `node_modules`, test verileri, log dosyaları ve yerel ortam dosyaları build context'e girdiğinde hem imajı büyütür hem de build süresini uzatır. Küçük bir `.dockerignore` dosyası çoğu projede anında kazanç sağlar.

## Ölçün ve doğrulayın

Nereden başlamalı? Ölçün önce, tahmin yürütmeyin. `docker history <imaj>` hangi katmanın ne kadar yer kapladığını gösterir. `dive` aracı ise katman katman gezinerek boşa giden alanı ortaya çıkarır. Küçültme çalışmasına buradan başlamak, en çok kazanç getiren noktaya odaklanmanızı sağlar.

## Özet

Sıralama basit. Önce ölçün, sonra temel imajı daraltın, çok aşamalı derlemeye geçin, katmanları temizleyin, build context'i sınırlayın. Beşi birlikte çoğu projede imaj boyutunu düşürür ve dağıtımı hızlandırır.

## 4. Notlar

**Yapı korundu.** Yedi başlık (H1 + altı H2) yerinde ve aynı sırada. İki kod bloğu karakter karakter aynı — tek dokunuş yapmadım. Başlık metinlerine de dokunmadım; hepsi zaten temiz, aktif emir kipinde.

**Faz 1'de ne yapıldı:**
- İki Sinyal 4 örneği söküldü. P1'de "yalnızca X değildir" yerine gerçek mantıksal bağ kuruldu ("disk alanından fazlasını götürür") ve Y bir sonraki cümlede zaten duruyordu. P3'te "ve aynı zamanda ... de" iki bağımsız cümleye ayrıldı, ikincisi "Bir de" ile bağlandı.
- P2'deki noktalı virgül nokta oldu, cümle ikiye bölündü. Bölünme aynı anda kısa bir nefes cümlesi kazandırdı ("Geçmeden önce test edin.").
- P7'deki "dramatik biçimde" ve "belirgin şekilde" silindi. Kapanış cümlesi bilgi taşıdığı için silinmedi, "Beşi birlikte..." diye yeniden kuruldu.
- "İyi haber şu ki," kalıbı "İyi tarafı da var." oldu.
- Pasif yapılar aktife çevrildi: "indirmek mümkündür" → "indirebilirsiniz", "yapılmalıdır" → "yapın", "silinen dosya" → "sildiğiniz dosya", "yoktur/lazımdır" → "yok/lazım. Metnin geri kalanı zaten 2. çoğula seslendiği için bu bir tutarlılık kazancı da.
- P4'teki "Benzer şekilde ... gibi seçenekler" yığını iki cümleye açıldı.

**Faz 2'de ne uygulandı (register izin verdiği için):**
- **Sinyal 15 (cümle patlamaları):** "İyi tarafı da var." / "Daha doğrusunu söyleyelim." / "Geçmeden önce test edin." / "Silmek tek başına yetmiyor yani." / "Sıralama basit." P3'ün ritmi artık 7-3-10-14-17 kelime.
- **Sinyal 16 (konuşma bağlaçları):** "Ne var ki" (bürokratik "ancak"ın yerine), "Bir de", "yani".
- **Sinyal 17 (retorik soru):** "Nereden başlamalı?" — ölçüm bölümünün açılışı. Bir tane yetti; teknik anlatımda fazlası numaraya döner.
- **Sinyal 18 (öz-düzeltme):** "Daha doğrusunu söyleyelim." + arkasından aynı iddianın daha keskin hâli.
- **Sinyal 22 (birinci çoğul):** yalnızca "söyleyelim"de. Metin baştan sona okura 2. çoğulla sesleniyor; daha fazla "biz" Sinyal 9 (register kayması) üretirdi.
- **Sinyal 8 (devrik):** iki yerde, ikisi de doğal geldiği noktada: "Tek başına yüzlerce megabaytlık fark yaratır bu yaklaşım." ve "Ölçün önce, tahmin yürütmeyin."

**Uygulanmayanlar:** Sinyal 19 (duyusal detay), 20 (zaman kipi kayması), 21 (diyalog izi) — bunlar edebi-yaratıcı register'a ait, teknik anlatıma sokmak yapay olurdu.

**Bilgi sadakati:** Hiçbir yeni teknik iddia, sayı, sürüm veya araç adı eklenmedi. Uydurma somut anchor yok. "Beş adım" ifadesi korundu çünkü listedeki öğe sayısı gerçekten beş — sayı ile liste uyuşuyor. Alpine/musl uyarısı, `--no-install-recommends`, `docker history`, `dive`, `scratch`/`distroless` iddialarının hepsi kaynak metindeki hâliyle duruyor. P3'te "derleme araçlarının **oluşturduğu**" → "**doğurduğu**" dışında anlam kaydırmadım; "imajda bıraktığı" gibi mekanizma açıklaması eklemekten kaçındım, çünkü bu metinde yazılmamış bir teknik gerekçe olurdu.

**YOK olduğu için not düştüğüm şeyler.** Bu metin girdi olarak beklediğimden çok temiz geldi, tanımak lazım:
- **Sinyal 1a — uzun tire yok.** Tek bir cümle-içi em dash bile yok. Türkçe AI metninin en yaygın imzası bu, burada sıfır.
- **Sinyal 3a — tek bir "-mektedir/-maktadır" yok.** Yedi paragraf boyunca geniş zaman ve emir kipi. Teknik metinlerde bunun tersi normdur.
- **Sinyal 3b — bürokratik bağlaç yığını yok.** "Bu bağlamda," "söz konusu," "öte yandan," "bu doğrultuda," "bu çerçevede" — hiçbiri geçmiyor.
- **Sinyal 3c — AI kapanış klişesi yok.** "Kritik bir rol oynamaktadır," "hayati önem taşımaktadır" türü tek kapanış yok.
- **Sinyal 1e — slash-ayırıcı yok.** Alternatifler zaten "veya / ya da" ile veriliyor; metindeki eğik çizgiler yalnızca dosya yollarında.
- **Sinyal 6 — "adeta/sanki" yok.** Tek benzetme yok, bunun yerine gerçek örnek var.
- **Sinyal 10 — somut anchor bolluğu.** `node:20`, `golang:1.22`, `distroless`, `dive`, `--no-install-recommends`, `--omit=dev`, `--no-cache-dir`. Soyut iddia hemen çalıştırılabilir örnekle takip ediliyor. Metnin en insan tarafı bu.
- **Sinyal 12 — İngilizce vurgu-doldurucusu yok.** "tam da," "tam anlamıyla," "gerçekten de," "esasen," "nihayetinde" — hiçbiri yok.
- **Sinyal 13 — terminoloji tutarlı.** "İmaj" baştan sona "imaj," "katman" baştan sona "katman." Eş anlamlı rotasyonu yapılmamış.
- **Sinyal 2 — cümle uzunluğu varyansı zaten vardı.** Ortalama ~13 kelime, en kısası 4 ("Tahmin yürütmek yerine ölçün."), en uzunu 21. AI monotonluğu eşiğinin (22+ kelime ortalama, düşük sapma) çok altında. Faz 2'de eklediğim patlamalar bu yüzden onarım değil, mevcut ritmi belirginleştirme.
