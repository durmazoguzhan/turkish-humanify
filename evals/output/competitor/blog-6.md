# Competitor output

**Register teşhisi:** Edebi-yaratıcı (kişisel anlatı / anı-deneme). Kullanıcı doğrulaması istenmeden, metin türü açıkça anlatı olduğu için doğrudan uygulandı. Bu register'da Faz 2'nin tamamı artı duyusal detay (S19) ve zaman kipi çeşitliliği (S20) devrededir; Sinyal 22 (birinci çoğul) bu register'da hariç tutulur.

---

## 1. Tespit Raporu

Metin 12 paragraf, 357 kelime. **Baskın sinyallerin hiçbiri eşiği geçmiyor.** Tarama sonuçları:

**Sinyal 1 — Noktalama enflasyonu:** YOK.
- 1a. Uzun tire: metinde 0 adet. Cümle-içi em dash mantığı hiç kullanılmamış.
- 1b. Noktalı virgül: 1 adet (P9: "yüzeye çıkmalarını izledim; bazıları açıldı, içindeki kıyma suya karıştı"). Eşik paragrafta 2+; ayrıca noktalı virgülden sonraki sıralı cümlenin ögeleri arasında virgül var — TDK'nın 2. kullanımına uygun. Alarm değil.
- 1c. İki nokta üst üste: 4 adet, dördü de TDK-uygun bağlamda. Üçü konuşma/diyalog girişi (P1 "Sonra soruyu tekrarlardım:", P3 "arkamdan sesi geldi:", P6 "İçi hazırdı:"), biri açıklama gerektiren tam cümlenin sonunda (P10 "rengi doğruydu:"). Cümle-içi mini açıklama modu yok.
- 1d. Bitişik bağlaç "ki": 0 adet.
- 1e. Slash-ayırıcı: 0 adet.

**Sinyal 2 — Cümle monotonluğu:** YOK. Varyans yüksek. Örnek olarak P3'ün ritmi: 3 / 8 / 20 / 5 / 6 / 2 / 3 kelime. Metinde 5 kelimeden kısa cümle bolca var ("Unu eledim.", "Panikledim.", "Onu uyandırmadım.", "Şimdi dinlensin.", "Bilerek.").

**Sinyal 3 — Kalıp tekrarı:** YOK.
- 3a. "-mektedir/-maktadır": 0 adet.
- 3b. Bürokratik bağlaç yığını ("bu bağlamda", "söz konusu", "öte yandan", "bu doğrultuda"): 0 adet.
- 3c. AI kapanış klişesi ("kritik bir rol oynamaktadır" ailesi): 0 adet.

**Sinyal 4 — "Sadece X değil, aynı zamanda Y" ailesi:** 0 adet. Metinde tek bir varyantı bile yok.

**Sinyal 5 — Boş övgü + boş kapanış:** YOK. Değerlendirici sıfat kümesi ("eşsiz", "benzersiz", "paha biçilmez", "çok boyutlu") hiç geçmiyor. Paragraf sonları bilgi taşıyor: "başı tabureye yaslanmıştı", "Tuzu az", "Üçüncüyü de."

**İkincil sinyaller:**
- S6 ("adeta"/"sanki" bağımlılığı): 0 adet. Benzetme yerine somut eylem var.
- S7 (zorlama üçlü liste): YOK. Tek liste var, o da dört öğeli ve gerçek: "kıyma, soğan, tuz, karabiber."
- S8 (devrik cümle yokluğu): Sinyal değil — devrik/eksiltili kuruluş mevcut ("Ben mantıyı hâlâ yapıyorum, hâlâ ölçüsüz.", "Misafire düzgün olanlar gider, açılanları ev sahibi yer.").
- S9 (register kayması): YOK. Metin baştan sona aynı katmanda: mutfak, el, ölçü.
- S10 (somut anchor eksikliği): Tersine, anchor yoğunluğu yüksek — Kayseri, kırk yıl, üç yıl önce, yirmi dakika, bir buçuk parmak, onuncu/yirminci/ellinci mantı. Hiçbiri uydurma-spesifik değil, hepsi anlatının içinde iş görüyor.
- S11 (pasif yapı bağımlılığı): YOK. Neredeyse tüm yüklemler aktif ve birinci tekil.
- S12 (İngilizce vurgu-doldurucuları): 0 adet. "tam da", "gerçekten de", "esasen", "nihayetinde", "bir bakıma" — hiçbiri yok.
- S13 (eş anlamlı rotasyonu): YOK. Aynı özne baştan sona "babaannem"; hamur hep "hamur".
- S14 (fragment cümle bağımlılığı): 1 sınırda örnek (P10'da iki noktadan sonraki "beyazın üstünde kırmızı bir halka, ortada nane"). Eşik metinde 3+; ayrıca bu, edebi register'da bilinçli bir imge kuruluşu. Alarm değil.

---

## 2. Sinyal Yoğunluğu (Nicel Metrik)

| | Baskın sinyal | İkincil sinyal | Toplam | 100 kelimede |
|---|---|---|---|---|
| **Önce** | 0 | 0 | 0 | 0.0 |
| **Sonra** | 0 | 0 | 0 | 0.0 |

**İyileşme oranı: %0 — çünkü iyileştirilecek bir şey yoktu.** Bu, skill'in başarısızlığı değil, metnin temizliğidir. Karşılaştırma için: bu külliyattaki tipik AI-imzalı bir blog paragrafı 6-9 sinyal/100 kelime bandında geliyor.

**Faz 2 doluluk kontrolü (enjeksiyon gerekiyor mu?):**

| Sinyal | Durum | Kanıt |
|---|---|---|
| S15 — Cümle uzunluğu patlamaları | ZATEN VAR | "Panikledim." / "Onu uyandırmadım." / "Bilerek." |
| S16 — Konuşma bağlaçları | ZATEN VAR | "Ama kaç bardak?", "Anlamadım ama yaptım.", "Olsun." |
| S17 — Retorik soru | ZATEN VAR | "Bardak nereden bilsin senin elini?" |
| S18 — Öz-düzeltme / yeniden ifade | KISMEN | "Anlamadım ama yaptım." geri-alma jestine yakın; tam bir yeniden-ifade yok. |
| S19 — Duyusal somut detay | ZATEN VAR | "hâlâ hamuru serdiğimde onun mutfağını kokluyorum", "altındaki masanın damarlarını görebiliyordum", "beyazın üstünde kırmızı bir halka". Koku, dokunma, görme üçü de var. |
| S20 — Zaman kipi kayması | ZATEN VAR | Geniş-geçmiş ("vermezdi, yazardım"), belirli geçmiş ("eledim, kırdım"), öğrenilen geçmiş ("tırnak kadar olurmuş"), şimdiki zamana geçiş ("hâlâ yapıyorum, bazen fazla su koyuyorum"). |
| S21 — Diyalog izi | ZATEN VAR | Metnin yaklaşık üçte biri doğrudan alıntı; babaannenin sesi kendi sözdizimiyle duyuluyor. |
| S22 — Birinci çoğul | UYGULANMAZ | Edebi-yaratıcı register'da hariç. |

Faz 2'nin ilgili sekiz sinyalinden yedisi metinde hâlihazırda mevcut. Enjeksiyon gerekmiyor — steril bir metne nefes vermek değil, zaten nefes alan bir metne dokunmamak doğru hamle.

---

## 3. Onarılmış Versiyon

Faz 1'de çıkarılacak sinyal, Faz 2'de yerleştirilecek boşluk bulunmadığı için metin değişmeden kalır. Aşağıdaki sürüm, tarama sonrası onaylanmış hâlidir.

# Babaannemin Hamuru

Babaannem tarif vermezdi. "Yaz kızım" dediğimde eline un alır, avucunu açar, "işte bu kadar" derdi. Ben de defterime "bir avuç un" yazardım. Sonra soruyu tekrarlardım: "Ama kaç bardak?" O gülerdi. "Bardak nereden bilsin senin elini?"

O yaz Kayseri'ye gittiğimde artık ayakta zor duruyordu. Mutfağa girdik, tabureyi masanın başına çektik. "Sen yapacaksın" dedi. "Ben bakacağım."

Unu eledim. Yumurtayı kırdım, tuzu attım, suyu azar azar döktüm. Hamuru yoğurmaya başladığımda arkamdan sesi geldi: "Sertleştir. Mantının hamuru yumuşak olmaz, yumuşak olursa açarken yırtılır, yırtılırsa suyunu içeri kaçırır." Bileklerim ağrıyana kadar yoğurdum. Parmağımla bastırdığımda çukur kalmayınca, "tamam" dedi. "Şimdi dinlensin. Sen de dinlen."

Yarım saat karşılıklı oturduk. Bana dedemden bahsetti, ilk mantısını kaynanasına nasıl yaptığını, ellerinin nasıl titrediğini. "Kırk yıl oldu" dedi, "hâlâ hamuru serdiğimde onun mutfağını kokluyorum."

Oklavayı elime aldım. Hamur direniyordu, benim istediğim yöne değil kendi istediği yöne gidiyordu. "Ortadan dışa" dedi babaannem. "İterken bırakma, çekerken sıkma." Anlamadım ama yaptım. Yirmi dakika sonra masanın üstünde, kenarları biraz eğri büğrü ama neredeyse şeffaf bir yaprak vardı. Altındaki masanın damarlarını görebiliyordum.

"Şimdi ölçü" dedi ve bir bıçak uzattı. Kareleri kestim. Benimkiler bir buçuk parmak genişliğindeydi, onunkiler tırnak kadar olurmuş. "Olsun" dedi. "İlk sefer herkesin mantısı yorgan gibi olur."

İçi hazırdı: kıyma, soğan, tuz, karabiber. Bir küçük parça koyup kareleri kapatmaya başladım. Dört köşesini ortada birleştirip sıkıştırmak gerekiyordu. Onuncusunda elim öğrendi. Yirmincisinde bakmadan yapıyordum. Ellisinde babaannemin uyuduğunu fark ettim, başı tabureye yaslanmıştı.

Onu uyandırmadım. Tepsiyi tek başıma doldurdum, üstüne temiz bir bez örttüm, suyu kaynattım. Mantılar suya girdiğinde yüzeye çıkmalarını izledim; bazıları açıldı, içindeki kıyma suya karıştı. Panikledim. Babaannem gözünü açmadan, "açılanları ayır, onlar bizim" dedi. "Misafire düzgün olanlar gider, açılanları ev sahibi yer."

Sarımsaklı yoğurdu ezdim. Tereyağını kızdırdım, pul biberi son anda attım, yanmasın diye. Tabağa koyduğumda rengi doğruydu: beyazın üstünde kırmızı bir halka, ortada nane.

İlk lokmayı o aldı. Uzun uzun çiğnedi. "Tuzu az" dedi.

Sonra ikinci lokmayı aldı. Üçüncüyü de.

Babaannem üç yıl önce öldü. Geride bir defter bıraktı ama içinde tarif yoktu, sadece komşu telefonları vardı. Ben mantıyı hâlâ yapıyorum, hâlâ ölçüsüz. Bazen fazla su koyuyorum, bazen hamur yırtılıyor. Ama parmağımla bastırıp çukur kalmadığını gördüğüm an, arkamda birinin oturduğunu biliyorum.

Ve tuzu hep az atıyorum. Bilerek.

---

## 4. Notlar

**Dokunmadım, çünkü kasıtlı tercih:**

- **P9'daki noktalı virgül.** "yüzeye çıkmalarını izledim; bazıları açıldı, içindeki kıyma suya karıştı." Sonraki sıralı cümlenin ögeleri arasında virgül olduğu için TDK'nın ikinci kullanımına uyuyor. Ayrıca burada bir zamansal kırılma yapıyor: izleme bitiyor, felaket başlıyor. Nokta koysak bu bitişiklik kaybolurdu. Etik bölümündeki "Bıçakçı tarzı noktalı virgül" istisnası.
- **P10'daki iki noktadan sonraki eksiltili yapı.** "rengi doğruydu: beyazın üstünde kırmızı bir halka, ortada nane." Sinyal 14 eşiği metinde 3+ fragment ister, burada bir tane var ve edebi bir imge kuruluşu — tabak tarif ediliyor, yüklem eklemek ("nane vardı") görüntüyü yavaşlatırdı.
- **"Sen de dinlen." tekrarı.** "Şimdi dinlensin. Sen de dinlen." Aynı kökün iki kullanımı; eş anlamlı rotasyonunun tam tersi ve kasıtlı bir ses eşleşmesi.
- **Kapanışın iki cümleye bölünmüşlüğü.** "Ve tuzu hep az atıyorum. Bilerek." Tek cümleye birleştirmek ("Tuzu hep bilerek az atıyorum") metnin en güçlü nefes noktasını yok ederdi.
- **"Ve" ile başlayan cümle.** Konuşma dilinden gelen bilinçli bir kapanış hamlesi, AI tiki değil.

**Register kısıtı nedeniyle muhafazakâr davrandığım yerler:** Yok. Edebi-yaratıcı register kısıt getirmiyor; kısıtı metnin kendisi getirdi, çünkü onarılacak yer bırakmamış.

**Uygulanan Faz 2 sinyalleri:** Hiçbiri — enjeksiyon anlamında. S15, S16, S17, S19, S20, S21 metinde yazarın kendi elinden zaten mevcut. S18 (öz-düzeltme) sadece kısmen var; ekleyebilirdim ama zorlama olurdu ve anlatıcının kendinden emin, sakin sesini bozardı. S22 (birinci çoğul) bu register'da hariç.

**YOK olduğu için not düştüklerim** (metinde bulunması beklenip bulunmayanlar):

- Uzun tire (—) enflasyonu: **hiç yok.** Türkçe AI metninin bir numaralı fenotipi bu metinde tek bir kez bile görünmüyor.
- "-mektedir/-maktadır": **hiç yok.**
- "Sadece X değil, aynı zamanda Y" ailesi: **hiç yok.**
- Bürokratik bağlaç ("bu bağlamda", "söz konusu", "bu doğrultuda"): **hiç yok.**
- "Adeta" / "sanki" ile örtülen belirsiz benzetme: **hiç yok.** Metin benzetme yerine eylem gösteriyor — "hamuru serdiğimde onun mutfağını kokluyorum" bir metafor değil, gerçek bir duyu iddiası.
- İngilizce vurgu-doldurucuları ("tam da", "gerçekten de", "nihayetinde"): **hiç yok.**
- Boş değerlendirici kapanış: **hiç yok.** Duygusal doruk noktası olan paragraf bile ("Tuzu az" dedi) yorumsuz bırakılmış. AI burada mutlaka "Bu, benim için bir dönüm noktasıydı" tarzı bir cümle eklerdi.
- Slash-ayırıcı, eş anlamlı rotasyonu, pasif çatı yığılması: **hiç yok.**

**Editör notu:** Bu metin, skill'in aradığı sinyallerin neredeyse tam tersini gösteriyor — soyut iddia yerine ölçü ("bir buçuk parmak", "onuncusunda", "kırk yıl"), değerlendirme yerine eylem, açıklama yerine diyalog. Skill'in bir metne yapabileceği en iyi şey, bazen ona hiç dokunmamaktır. Bu metin o durumdadır.
