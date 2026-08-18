**Git'te merge geçmişe ekler, rebase geçmişi değiştirir**

Bir dalda çalışırken ana dal ilerlemeye devam eder. Er ya da geç bu iki çizgiyi birleştirmeniz gerekir; Git'in de bunun için iki yolu var: merge ve rebase. İkisi de sonuçta aynı kodu bir araya getirir ama commit geçmişine bıraktıkları iz taban tabana zıt.

**Merge yeni bir commit ekler, eskilere dokunmaz**

`git merge`, iki dalın uçlarını alıp iki ebeveyni olan yeni bir commit oluşturur. Mevcut commit'lerin hiçbirine dokunmaz. Hepsi kimliğiyle, yani hash'iyle, olduğu gibi kalır. Geçmiş dalların ayrıldığı ve tekrar buluştuğu noktaları gösteren bir grafiğe dönüşür.

Bunun en büyük avantajı dürüstlüğü: projede gerçekte ne olduysa geçmişte de o görünür. Kimin ne zaman hangi daldan ayrıldığı kaybolmaz. Dezavantajı ise kalabalık. Onlarca kişinin çalıştığı bir depoda log çıktısı, birbirine giren çizgilerden okunmaz hâle gelebilir. "Merge branch 'main' into feature" commit'leri de bilgi taşımadan yer kaplar.

**Rebase commit'leri baştan yazar**

`git rebase`, dalınızdaki commit'leri toplayıp hedef dalın en son hâlinin üzerine tek tek yeniden uygular. Yani commit'leriniz sanki baştan beri güncel main üzerinde yazılmış gibi görünür. Sonuç düz, doğrusal, yukarıdan aşağıya okunabilen bir geçmiş.

Buradaki kritik nokta şu: commit'ler taşınmaz, yeniden yaratılır. Aynı değişikliği içeren yeni commit'lerin hash'leri farklı çıkar. Eskiler teknik olarak hâlâ ortada durur ama artık dalınız onlara işaret etmez.

Somut düşünelim. main'den ayrıldınız, üç commit attınız; bu sırada ekip main'e beş commit ekledi. Merge yaparsanız bu sekiz commit'in yanına bir de birleştirme commit'i eklenir. Dalınızın nereden çıktığı grafikte görünür kalır. Rebase yaparsanız sizin üç commit'iniz ekibin beş commit'inin üzerine taşınır. Grafikte hiç çatal kalmaz, hepsi sıraya girmiş gibi olur.

**Asıl ayrım: geçmişi yeniden yazmak**

Merge geçmişe ekler, rebase geçmişi değiştirir. Buradan da altın kural doğar: paylaşılan dalları rebase etmeyin. Push ettiğiniz bir commit'i başkası da almışsa, rebase sonrası herkesin geçmişi çatallanır. `--force` ile push etmek de arkadaşlarınızın çalışmasını uçurabilir. Rebase, henüz kimsenin görmediği kendi yerel dalınız için biçilmiş kaftan.

Çakışmalar da farklı davranır. Merge'de tüm çakışmaları tek seferde çözersiniz. Rebase'te commit'ler sırayla uygulandığı için aynı dosyada birkaç kez çakışma çözmeniz gerekebilir. Karşılığında her commit kendi başına anlamlı kalır.

**Pratikte hangisini seçmeli?**

Yaygın yaklaşım ikisini birlikte kullanmak: özellik dalınızı güncel tutmak için `git rebase main` yapın, gözden geçirilmiş dalı ana dala katarken merge kullanın. Böylece hem temiz bir commit dizisi elde eder hem de özelliğin projeye ne zaman girdiğini geçmişte görünür bırakırsınız. Bazı ekipler bunu tek adıma indirger: pull request'i squash ile birleştirip dalın tüm çalışmasını tek commit'e düşürür.

Hangisini seçerseniz seçin, önemli olan ekibin aynı kuralı uygulaması. Karışık kullanılan bir geçmiş her iki yöntemin de faydasını götürür.

Merge "ne oldu"yu, rebase "ne anlatmak istediğinizi" kaydeder. Doğru cevap, ekibinizin geçmişten ne beklediğine bağlı.
