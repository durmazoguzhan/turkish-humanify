# Git'te merge ile rebase arasındaki fark

Bir dalda çalışırken ana dal ilerlemeye devam eder. Er ya da geç bu iki çizgiyi birleştirmeniz gerekir; Git bunun için iki yol sunar: merge ve rebase. İkisi de sonuçta aynı kodu bir araya getirir. Ayrıştıkları yer commit geçmişi; oraya taban tabana zıt iki iz bırakırlar.

## Merge ne yapar?

`git merge`, iki dalın uçlarını alıp iki ebeveyni olan yeni bir commit oluşturur. Mevcut commit'lerin hiçbirine dokunmaz; hepsi kimliğiyle, yani hash'iyle olduğu gibi kalır. Geçmiş, dalların nerede ayrılıp nerede yeniden buluştuğunu gösteren bir grafiğe dönüşür.

Bunun en büyük avantajı dürüstlüğü: projede gerçekte ne olduysa geçmişte de o görünür. Kimin ne zaman hangi daldan ayrıldığı kaybolmaz.

Dezavantajı ise kalabalık. Onlarca kişinin çalıştığı bir depoda log çıktısı, birbirine giren çizgiler yüzünden okunmaz hâle gelebilir. "Merge branch 'main' into feature" commit'leri de bilgi taşımadan yer kaplar.

## Rebase ne yapar?

`git rebase`, dalınızdaki commit'leri toplayıp hedef dalın en son hâlinin üzerine tek tek yeniden uygular. Yani commit'leriniz sanki baştan beri güncel main üzerinde yazılmış gibi görünür. Ortaya düz, doğrusal, yukarıdan aşağıya okunan bir geçmiş çıkar.

Ama rebase commit'leri taşımaz; yeniden yaratır. Aynı değişikliği içeren yeni commit'lerin hash'leri farklı olur. Eskiler teknik olarak hâlâ ortada durur, sadece dalınız artık onlara işaret etmez.

Somut düşünelim. main'den ayrıldınız, üç commit attınız; bu sırada ekip main'e beş commit ekledi. Merge yaparsanız bu sekiz commit'in yanına bir de birleştirme commit'i eklenir; dalınızın nereden çıktığı grafikte görünür kalır. Rebase yaparsanız sizin üç commit'iniz ekibin beş commit'inin üzerine taşınır; grafikte hiç çatal kalmaz, hepsi sıraya girmiş gibi olur.

## Asıl ayrım: geçmişi yeniden yazmak

Merge geçmişe ekler, rebase geçmişi değiştirir. Altın kural da buradan doğar: paylaşılan dalları rebase etmeyin.

Bir commit'i push ettiyseniz ve başkası onu almışsa rebase sonrası herkesin geçmişi çatallanır; `--force` ile push etmek de arkadaşlarınızın çalışmasını uçurabilir. Rebase, henüz kimsenin görmediği kendi yerel dalınız için biçilmiş kaftan.

Çakışmalar da farklı davranır. Merge'de hepsini tek seferde çözersiniz. Rebase'te commit'ler sırayla uygulandığından aynı dosyadaki çakışmayı birkaç kez çözmeniz gerekebilir; karşılığında her commit kendi başına anlamlı kalır.

## Pratikte nasıl karar verilir?

Yaygın yaklaşım ikisini birlikte kullanmak: özellik dalınızı güncel tutmak için `git rebase main` yapın, gözden geçirilmiş dalı ana dala katarken merge kullanın. Böylece hem temiz bir commit dizisi elde eder hem de özelliğin projeye ne zaman girdiğini geçmişte görünür bırakırsınız.

Bazı ekipler bunu tek adıma indirir: pull request'i squash ile birleştirip dalın tüm çalışmasını tek commit'e düşürür. Hangisini seçerseniz seçin, önemli olan ekibin aynı kuralı uygulaması; karışık kullanılan bir geçmiş her iki yöntemin de faydasını götürür.

Merge geçmişe ne olduğunu kaydeder. Rebase'in kaydettiği şey ise ne anlatmak istediğiniz. Doğru cevap ekibinizin geçmişten ne beklediğine bağlı.
