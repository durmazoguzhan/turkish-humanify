---
name: turkish-humanify
description: İnsan yazmış gibi okunması gereken Türkçe metinleri yazarken veya onarırken kullan — blog yazısı, teknik metin, pazarlama metni, akademik nesir. Türkçe kelimelere giydirilmiş İngilizce yapı yerine Türkçenin kendi cümle mimarisini uygular.
---

# turkish-humanify

LLM Türkçesi dilbilgisel olarak doğru ama boş. Kelimeler Türkçe; altındaki
mimari İngilizce — niteleyenler başlarının arkasında sürükleniyor, vurgu
İngilizcenin koyacağı yere konuyor, her cümle aynı on sekiz-yirmi beş kelime
bandına düşüyor. Bu skill mimariyi onarır. Bir kelime filtresi değildir.

## 1. Modu seç

**Kullanıcı metin verdiyse → onar.** Var olanın üzerinde çalış. Girdideki her
iddia çıktıda da durur.

**Kullanıcı bir konu, brief ya da istek verdiyse → yaz.**

Yazma modu **önce yaz sonra insanlaştır değildir.** İlk cümleden önce kurguyu
Türkçe düşünerek karara bağla: açılış hamlesi ne, yazı nerede dönüyor, nerede
iniyor. Sonra cümle kuralları çoktan yürürlükteyken yaz. İngilizce biçimde
taslaklanıp sonradan temizlenen bir metin İngilizce iskeletini korur ve
okurun hissettiği şey tam olarak o iskelettir.

## 2. Register'ı teşhis et

| Register | Nasıl tanınır |
|---|---|
| **blog / deneme** | okumayı kendi seçmiş bir okura sesleniyor; yazarın bir görüşü olabilir |
| **teknik** | bir sistemi ya da yordamı, ona göre iş yapacak birine anlatıyor |
| **kurumsal / pazarlama** | bir marka konuşuyor; bir karar isteniyor |
| **akademik / resmi** | kurallar bağlayıcı, sapma itibar kaybettirir |

## 3. Sesi seç

Varsayılan, register'ın kendi sesidir. Kullanıcı bir ses adı verdiyse
("denemeci sesle yaz") ya da örnek metin verdiyse ("şu metindeki gibi yaz")
onu geçersiz kıl — ikinci durumda yazmaya başlamadan önce örneğin sesini
okuyup çıkar.

## 4. Katmanları çalıştır

Kurgu → cümle → yüzey. **Bu sürümde yalnızca cümle katmanı uygulanmıştır;**
diğer ikisi yapım aşamasında.

Tek bir cümleyi bile yeniden yazmadan önce `references/layer-2-sentence.md`
dosyasını oku. Ezberden değil, şimdi oku — talimat, oradaki işlenmiş
örneklerin kendisidir ve onların hatırlanan bir özeti aynı şey değildir.

### Doz

Her katmanın ne kadarının çalışacağını register belirler. (Bu tablo
`references/registers.md` oluşturulduğunda oraya taşınacak.)

| Katman | blog / deneme | teknik | kurumsal | akademik / resmi |
|---|---|---|---|---|
| kurgu | tam | orta | orta | kapalı |
| cümle | tam — devrik, parçacıklar, `-mIş` hepsi oyunda | kısıtlı — devrik ve parçacık yok; dallanma, ulaç, odak ve `-DIr` temizliği açık | orta | yalnızca dallanma, ulaç, odak ve `-mektedir` temizliği |
| yüzey | tam | tam | tam | tam |

Yüzey her zaman açıktır: imla ve terminoloji üslup değil, doğruluk meselesidir.

## 5. Çıktıdan önce denetle

Sessizce, raporlamadan:

- Girdideki her iddia çıktıda duruyor. Hiçbir şey eklenmedi.
- Hiçbir teknik terim uydurma bir Türkçe karşılığa çevrilmedi.
- Uzun tire yok. Emoji yok. Sohbet artığı yok.
- Metni içinden sesli oku. Bütün cümleler aynı uzunluktaysa cümle katmanı
  çalışmamış demektir.

## 6. Çıktıyı ver

Metin. Başka hiçbir şey. Ne giriş cümlesi, ne neyi değiştirdiğinin özeti, ne
de tonu ayarlama teklifi.

Yalnızca sorulursa açıkla. Kullanıcı neyin neden değiştiğini sorarsa, izi,
onu gideren katmanı ve önce/sonra çiftini göster — ama bunu asla kendiliğinden
sunma.

## Değişmezler

Bunlar her modda, her register'da ve her seste geçerlidir.

1. **Olgu uydurma yok.** Ruh katmak somut detay icat etmek değildir. Kaynakta
   olmayan ya da kullanıcının vermediği hiçbir sayı, isim, tarih veya iddia
   eklenmez. Güzel okunup istatistik uyduran bir paragraf başarısızdır.
2. **Anlam korunur.** Onarma, register dozunun izin verdiği ölçüde yapıyı
   serbestçe değiştirebilir; söylenen şeyi değiştiremez.
3. **Zorlama çeviri yok.** Gerçek bir Türkçe karşılığı olmayan teknik terim
   olduğu gibi kalır. `endpoint` "uç nokta" olmaz; `event-driven` "olay
   güdümlü" olmaz. Türkçesi gerçekten varsa ve Türk mühendisler onu gerçekten
   söylüyorsa o kullanılır: geliştirici, pazaryeri, doğrulama.
4. **Çıktıda uzun tire yok.** Türkçede açıklama işareti değildir. Noktalı
   virgül, bağlayıcı bir sözcük ya da yeni bir cümle kullan.
5. **Sohbet artığı yok.** Emoji yok, "Elbette!" yok, "Umarım yardımcı
   olmuştur" yok, sonda kelime sayısı yok.

## Bu skill ne değildir

Türkçe özleştirme aracı değildir — korunan İngilizce terimler bir kusur değil,
bir tercihtir. Tespit aracı atlatma aracı değildir; hedef kalite, sınıflandırıcı
değil. Savunulan görüşün iyi olup olmadığına karar vermez.
