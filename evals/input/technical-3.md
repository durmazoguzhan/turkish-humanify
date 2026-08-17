**Git Rebase ile Merge Arasındaki Fark**

Bir dalda çalışırken ana dal ilerlemeye devam eder. Er ya da geç bu iki çizgiyi birleştirmeniz gerekir ve Git bunun için iki yol sunar: merge ve rebase. İkisi de sonuçta aynı kodu bir araya getirir, ama commit geçmişine bıraktıkları iz taban tabana zıttır.

**Merge ne yapar?**

`git merge`, iki dalın uçlarını alır ve iki ebeveyni olan yeni bir commit oluşturur. Mevcut commit'lerin hiçbirine dokunmaz; hepsi kimliğiyle, yani hash'iyle olduğu gibi kalır. Geçmiş, dalların ayrıldığı ve tekrar buluştuğu noktaları gösteren bir grafik hâline gelir.

Bunun en büyük avantajı dürüstlüğü: projede gerçekte ne olduysa geçmişte de o görünür. Kimin ne zaman hangi daldan ayrıldığı kaybolmaz. Dezavantajı ise kalabalık. Onlarca kişinin çalıştığı bir depoda log çıktısı, birbirine giren çizgilerden okunmaz hâle gelebilir. "Merge branch 'main' into feature" commit'leri de bilgi taşımadan yer kaplar.

**Rebase ne yapar?**

`git rebase`, dalınızdaki commit'leri toplar ve hedef dalın en son hâlinin üzerine tek tek yeniden uygular. Yani commit'leriniz, sanki baştan beri güncel main üzerinde yazılmış gibi görünür. Sonuç düz, doğrusal, yukarıdan aşağıya okunabilen bir geçmiştir.

Buradaki kritik nokta şu: commit'ler taşınmaz, yeniden yaratılır. Aynı değişikliği içeren yeni commit'lerin hash'leri farklıdır. Eskiler teknik olarak hâlâ ortada durur ama artık dalınız onlara işaret etmez.

Somut düşünelim. main'den ayrıldınız, üç commit attınız; bu sırada ekip main'e beş commit ekledi. Merge yaparsanız bu sekiz commit'in yanına bir de birleştirme commit'i eklenir ve dalınızın nereden çıktığı grafikte görünür kalır. Rebase yaparsanız sizin üç commit'iniz ekibin beş commit'inin üzerine taşınır; grafikte hiç çatal kalmaz, hepsi sıraya girmiş gibi olur.

**Asıl ayrım: geçmişi yeniden yazmak**

Merge geçmişe ekler, rebase geçmişi değiştirir. Buradan da altın kural doğar: paylaşılan dalları rebase etmeyin. Bir commit'i push ettiyseniz ve başkası onu almışsa, rebase sonrası herkesin geçmişi çatallanır; `--force` ile push etmek de arkadaşlarınızın çalışmasını uçurabilir. Rebase, henüz kimsenin görmediği kendi yerel dalınız için biçilmiş kaftandır.

Çakışmalar da farklı davranır. Merge'de tüm çakışmaları tek seferde çözersiniz. Rebase'de commit'ler sırayla uygulandığı için aynı dosya için birkaç kez çakışma çözmeniz gerekebilir; karşılığında her commit'in kendi başına anlamlı kalmasını sağlarsınız.

**Pratikte nasıl karar verilir?**

Yaygın yaklaşım ikisini birlikte kullanmaktır: özellik dalınızı güncel tutmak için `git rebase main` yapın, gözden geçirilmiş dalı ana dala katarken merge kullanın. Böylece hem temiz bir commit dizisi elde eder hem de özelliğin projeye ne zaman girdiğini geçmişte görünür bırakırsınız. Bazı ekipler bunu tek adıma indirger ve pull request'i squash ile birleştirip dalın tüm çalışmasını tek commit'e düşürür. Hangisini seçerseniz seçin, önemli olan ekibin aynı kuralı uygulaması; karışık kullanılan bir geçmiş her iki yöntemin de faydasını götürür.

Kısacası merge "ne oldu"yu, rebase "ne anlatmak istediğinizi" kaydeder. Doğru cevap, ekibinizin geçmişten ne beklediğine bağlıdır.
