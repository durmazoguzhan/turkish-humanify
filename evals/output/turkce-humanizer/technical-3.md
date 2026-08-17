## 1. Tespit Raporu

**Register teşhisi:** Deneme-blog (teknik açıklayıcı blog yazısı). Metin "siz" hitabı kullanıyor, "Somut düşünelim" diyerek okuru sürece davet ediyor, "biçilmiş kaftandır" gibi deyim taşıyor. Bu, akademik-kurumsal değil blog register'ı. Faz 2 tam uygulanır. (Kullanıcı onayı istenmeden karar verildi.)

**Genel tablo:** Belge 10 paragraf. 0'ı yüksek AI-imzalı, 6'sı orta (P3, P5, P6, P7, P8, P9), 4'ü temiz (P1, P2, P4, P10). Metin baştan iyi yazılmış — baskın sinyallerin çoğu yok. Mod: tümü tek seferde.

**Bulunan sinyaller:**

- **Sinyal 1b — Noktalı virgül suistimali (baskın, 5 örnek).** P6'da iki tane ("üç commit attınız; bu sırada…", "üzerine taşınır; grafikte hiç çatal kalmaz") — bir paragrafta 2+ alarm eşiği aşılmış. Ayrıca P7 ("çatallanır; `--force` ile…"), P8 ("gerekebilir; karşılığında…"), P9 ("uygulaması; karışık kullanılan…"). Bunların üçü TDK'nın üç kullanımına da girmiyor; AI'nin "iki fikri birleştir" noktalı virgülü.
- **Sinyal 1c — Cümle-içi iki nokta (baskın, 1 örnek).** P3: "Bunun en büyük avantajı dürüstlüğü: projede gerçekte ne olduysa…" İngilizce inline colon mantığı; ayrıca yüklemsiz bırakılmış (Sinyal 14 ile akraba).
- **Sinyal 2 — Cümle monotonluğu (baskın, P9).** Dört cümle: 22, 18, 19, 20 kelime. Varyans neredeyse sıfır, 5 kelimeden kısa cümle yok. Belgenin tek nefessiz paragrafı.
- **Sinyal 5a — Boş değerlendirici sıfat (baskın, 1 örnek).** P5: "Buradaki kritik nokta şu."
- **Sinyal 7 — Zorlama üçlü liste (ikincil, 1 örnek).** P4: "düz, doğrusal, yukarıdan aşağıya okunabilen bir geçmiş." "Düz" ile "doğrusal" aynı şeyi söylüyor; ritim dolgusu.
- **Sinyal 8 — Devrik cümle yokluğu (ikincil, belge geneli).** On paragrafta tek devrik yok.
- **Sinyal 11 — Pasif yapı (ikincil, 2 örnek).** P6: "bir de birleştirme commit'i eklenir" (özne Git, gizlenmiş). P4: "yazılmış gibi görünür."
- **Sinyal 13 — Eş anlamlı rotasyonu (ikincil, zayıf).** Aynı özneye "ana dal / main / hedef dal". Paragraf içi 3+ eşiğinin altında ve `main` gerçek bir dal adı olduğu için sadece not düşüldü.

## 2. Sinyal Yoğunluğu

Metin 431 kelime.

- **Önce:** 12 sinyal → **2.8 sinyal/100 kelime**
- **Sonra:** 2 sinyal → **0.5 sinyal/100 kelime**
- **İyileşme oranı: %82**

Paragraf bazında en yoğun: P6 (2 sinyal/66 kelime) ve P9 (2 sinyal/86 kelime). En temiz: P1, P10 (0).

## 3. Onarılmış Versiyon

**Git Rebase ile Merge Arasındaki Fark**

Bir dalda çalışırken ana dal ilerlemeye devam eder. Er ya da geç bu iki çizgiyi birleştirmeniz gerekir ve Git bunun için iki yol sunar: merge ve rebase. İkisi de sonuçta aynı kodu bir araya getirir. Ama commit geçmişine bıraktıkları iz taban tabana zıttır.

**Merge ne yapar?**

`git merge`, iki dalın uçlarını alır ve iki ebeveyni olan yeni bir commit oluşturur. Mevcut commit'lerin hiçbirine dokunmaz; hepsi kimliğiyle, yani hash'iyle olduğu gibi kalır. Geçmiş, dalların ayrıldığı ve tekrar buluştuğu noktaları gösteren bir grafik hâline gelir.

Bunun en büyük avantajı dürüst olması. Projede gerçekte ne olduysa geçmişte de o görünür, kimin ne zaman hangi daldan ayrıldığı kaybolmaz. Dezavantajı ise kalabalık. Onlarca kişinin çalıştığı bir depoda log çıktısı, birbirine giren çizgilerden okunmaz hâle gelebilir. "Merge branch 'main' into feature" commit'leri de bilgi taşımadan yer kaplar.

**Rebase ne yapar?**

`git rebase`, dalınızdaki commit'leri toplar ve hedef dalın en son hâlinin üzerine tek tek yeniden uygular. Yani commit'leriniz, sanki baştan beri güncel main üzerinde yazılmış gibi görünür. Sonuç, yukarıdan aşağıya okunan doğrusal bir geçmiştir.

İşin püf noktası burada: commit'ler taşınmaz, yeniden yaratılır. Aynı değişikliği içeren yeni commit'lerin hash'leri farklıdır. Eskiler ortadan kalkmaz, daha doğrusu Git onları temizleyene kadar bir süre daha durur, ama artık dalınız onlara işaret etmez.

Somut düşünelim. main'den ayrıldınız, üç commit attınız. Bu sırada ekip main'e beş commit ekledi. Merge yaparsanız Git bu sekiz commit'in yanına bir de birleştirme commit'i ekler, dalınızın nereden çıktığı grafikte görünür kalır. Rebase yaparsanız sizin üç commit'iniz ekibin beş commit'inin üzerine taşınır. Grafikte hiç çatal kalmaz, tek sıraya girer hepsi.

**Asıl ayrım: geçmişi yeniden yazmak**

Merge geçmişe ekler, rebase geçmişi değiştirir. Buradan da altın kural doğar: paylaşılan dalları rebase etmeyin. Bir commit'i push ettiyseniz ve başkası onu almışsa, rebase sonrası herkesin geçmişi çatallanır. `--force` ile push etmek de arkadaşlarınızın çalışmasını uçurabilir. Rebase, henüz kimsenin görmediği kendi yerel dalınız için biçilmiş kaftandır.

Çakışmalar da farklı davranır. Merge'de tüm çakışmaları tek seferde çözersiniz. Rebase'de ise aynı dosya için birkaç kez çakışma çözmeniz gerekebilir, çünkü commit'ler sırayla uygulanır. Karşılığında her commit kendi başına anlamlı kalır.

**Pratikte nasıl karar verilir?**

Yaygın yaklaşım ikisini birlikte kullanmaktır: özellik dalınızı güncel tutmak için `git rebase main` yapın, gözden geçirilmiş dalı ana dala katarken merge kullanın. Böylece hem temiz bir commit dizisi elde edersiniz hem de özelliğin projeye ne zaman girdiği geçmişte görünür kalır. Bazı ekipler bunu tek adıma indirger, pull request'i squash ile birleştirip dalın tüm çalışmasını tek commit'e düşürür. Hangisini seçerseniz seçin, önemli olan ekibin aynı kuralı uygulaması. Karışık kullanılan bir geçmiş her iki yöntemin de faydasını götürür. Ne o olur, ne bu.

Kısacası merge "ne oldu"yu, rebase "ne anlatmak istediğinizi" kaydeder. Peki hangisi doğru? Ekibinizin geçmişten ne beklediğine bağlı.

## 4. Notlar

**Faz 1'de yapılanlar:**
- P6, P7, P8, P9'daki noktalı virgüller ayrı cümlelere bölündü. P2'deki noktalı virgül **korundu** — "hepsi kimliğiyle, yani hash'iyle olduğu gibi kalır" ögeleri arasında virgül taşıyan sıralı cümle, yani TDK'nın ikinci kullanımı. Kurala uyan noktalı virgüle dokunulmaz.
- P3'teki iki nokta kaldırıldı, yüklemsiz kalan cümle tamamlandı ("avantajı dürüstlüğü:" → "avantajı dürüst olması.").
- P4'teki üçlü "düz, doğrusal, yukarıdan aşağıya okunabilen" tek sıfata indirildi; "düz" ile "doğrusal" aynı bilgiydi.
- P5'teki "kritik" sıfatı atıldı.
- P6'da pasif "eklenir" aktife çevrildi ("Git… ekler") — özne belirginleşti.
- Metnin bütün teknik iddiaları korundu; hiçbir bilgi silinmedi.

**Faz 2'de eklenenler (register izin verdiği için):**
- **Sinyal 15 — cümle patlaması:** P9 sonuna "Ne o olur, ne bu." (Belgenin tek monoton paragrafıydı.) P10 sonundaki cevap da kısa tutuldu.
- **Sinyal 16 — konuşma bağlaçları:** P1'de "Ama" ile cümle başlatıldı, P8'de bürokratik bağ yerine "çünkü", P8'de "ise".
- **Sinyal 17 — retorik soru:** P10'da "Peki hangisi doğru?" Zaten soru başlıklı bir metin, bu ton yabancı gelmiyor.
- **Sinyal 18 — öz-düzeltme:** P5'te "Eskiler ortadan kalkmaz, daha doğrusu Git onları temizleyene kadar bir süre daha durur." Bu hem canlı düşünme imzası hem de teknik olarak doğru bir ek (unreachable commit'ler gc'ye kadar durur).
- **Sinyal 8 — devrik:** P6 sonu "tek sıraya girer hepsi."
- **Sinyal 22 — birinci çoğul:** Metinde zaten vardı ("Somut düşünelim"), artırılmadı.

**Dokunulmayanlar (kasıtlı tercih olabilir):**
- "biçilmiş kaftandır", "altın kural", "taban tabana zıt" deyimleri — bunlar AI tikî değil, yazarın sesi.
- "ana dal / main / hedef dal" rotasyonu (Sinyal 13): `main` gerçek bir dal adı, "hedef dal" ise rebase'in genel tanımında zorunlu. Kafa karıştırıcı değil, bırakıldı.
- Başlık hiyerarşisi, kod span'leri (`git merge`, `--force`) ve paragraf sırası aynen korundu.

**YOK olduğu için not düştüklerim** — yazar bu metni temiz yazmış, tanınmalı:
- Sinyal 1a: cümle-içi uzun tire (—) **hiç yok**. Türkçe AI metninin en sık imzası burada bulunmuyor.
- Sinyal 3a: tek bir "-mektedir/-maktadır" bile yok. Metin baştan sona geniş zaman ve 2. çoğul şahısla kurulmuş.
- Sinyal 3b: "bu bağlamda / söz konusu / bu doğrultuda" türü bürokratik bağlaç yok.
- Sinyal 3c: "kritik bir rol oynamaktadır" türü AI kapanış klişesi yok. Kapanış gerçek bir yargı taşıyor.
- Sinyal 4: "sadece X değil, aynı zamanda Y" ailesinden tek örnek yok.
- Sinyal 6: "adeta" yok; tek "sanki" gerçek bir yanılsamayı tarif ediyor, vage benzetme değil.
- Sinyal 10: somut anchor bol — "üç commit / beş commit / sekiz commit" örneği, `--force`, squash. Uydurma spesifiklik yok.
- Sinyal 12: "tam da / tam anlamıyla / nihayetinde / esasen" gibi İngilizce vurgu-doldurucusu yok.
- Sinyal 1d, 1e: bitişik "ki" ve slash-ayırıcı yok.
