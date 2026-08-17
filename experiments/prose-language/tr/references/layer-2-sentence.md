# Katman 2 — Cümle mimarisi

Türkçenin, başka kelimelerle yazılmış İngilizce olmaktan çıktığı yer burası.

İki dilin gerçekten ayrıldığı ve ağırlıklı olarak İngilizce yapı üzerine
eğitilmiş bir modelin düzenli olarak "ayrışan ama okunmayan" Türkçe ürettiği
on dört nokta. Her madde önce karşıtlığı koyar, sonra işlenmiş çiftleri
gösterir ve — bu kısım kural kadar önemli — kuralın nerede bittiğini söyler.
Sınırı olmadan uygulanan bir kural yeni bir tike dönüşür; devrik cümleyle dolu
bir metin, hiç devriği olmayandan daha insani değildir.

Etiketler: `AI:` yardımsız çıkan şey. `İnsan:` Türkçe yazan birinin oraya
koyacağı şey.

---

## 1. Dallanma yönü

İngilizce baş-başta bir dildir: isim önce gelir, niteleyenleri arkasından
sürüklenir; ilgi zamirleri, tireler ve ara sözlerle iliştirilir. Türkçe
baş-sonda bir dildir. Bir ismi niteleyen her şey onun **önünde** durur ve
ortaçlarla kurulur — `-en/-an`, `-dığı/-diği`, `-acak/-ecek`.

En büyük yapısal fark budur ve makine Türkçesindeki o inkâr edilemez
"arkadan eklenen yan cümle" ritmini üreten şey de budur.

> AI: Bir kural motoru geliştirdim — 55'ten fazla kural tipi içeren; bunu bir veri modeli üzerine kurdum.
> İnsan: Dinamik ve statik segmentler için 55'ten fazla kural tipi destekleyen bir segmentasyon modülünü uçtan uca geliştirdim.

> AI: Bir sistem kurduk, bu sistem her gece verileri tarayıp raporluyor.
> İnsan: Her gece verileri tarayıp raporlayan bir sistem kurduk.

> AI: Bir özellik ekledik ki kullanıcılar artık kendi şablonlarını kaydedebiliyor.
> İnsan: Kullanıcıların kendi şablonlarını kaydedebildiği bir özellik ekledik.

**Nerede biter.** Türkçenin sola dallanması, İngilizcenin sağa dallanmasında
olmayan bir yük sınırı taşır. Başın önündeki niteleyici yığın kabaca on-on iki
kelimeyi geçtiğinde okur açık tuttuğu şeyi taşıyamaz ve baş çok geç gelir. O
noktada çözüm daha uzun bir ön yığın değil, iki cümledir. Bu genellikle bir
ortacın içine başka bir ortaç yerleştirildiğinde (`...eden ...dığı ...`) bozulur.

---

## 2. Ulaç sistemi

İngilizce cümlecikleri *and*, *when*, *while*, *because* ile bağlar. Türkçe
bunları bir ekle tek bir yüklem zincirine kaynatabilir; dolayısıyla iki yüklem
arasında duran `ve` çoğunlukla kaçırılmış bir ulaçtır.

`-ip` aynı özne, ardışık · `-erek/-arak` tarz · `-ince/-ınca` -dığında ·
`-dikçe` oldukça · `-meden` -meksizin · `-ken` iken · `-diğinde` -dığı zaman ·
`-eli` -dığından beri

> AI: Sistemleri kurar **ve** ölçeklerim.
> İnsan: Sistemleri kur**up** ölçeklerim.

> AI: Veriyi çektik **ve** sonra işledik.
> İnsan: Veriyi çek**ip** işledik.

> AI: Cache doldu **ve** istekler yavaşladı.
> İnsan: Cache dol**unca** istekler yavaşladı.

> AI: Trafik arttı **ve** buna bağlı olarak hatalar da arttı.
> İnsan: Trafik art**tıkça** hatalar da arttı.

**Nerede biter.** `-ip` iki yarıda da aynı özneyi ister: *Ben geldim ve o
gitti* cümlesi *gelip gitti* olamaz. Tek cümlede zincirlenen üç ulaç, kimsenin
sesli okuyamayacağı bir şey üretir. Ve iki cümlecik gerçekten koşutsa ve
aradaki duraklamayı istiyorsan `ve` doğrudur — amaç refleksle ona uzanmayı
bırakmak, onu yasaklamak değil.

---

## 3. Odak konumu

Türkçe vurguyu **konumla** işaretler. Yükleme bitişik yuva odağı taşır. Bir
kelimeyi oraya taşıdığında, tek bir kelimeyi değiştirmeden cümlenin neyle
ilgili olduğunu değiştirmiş olursun.

> Ben dün İzmir'e gittim. — nötr
> İzmir'e dün **ben** gittim. — giden *bendim*
> Ben İzmir'e **dün** gittim. — *dün* gittim

> AI: Sıfırdan, AI destekli bir mikroservis tasarladım.
> İnsan: AI destekli bir mikroservisi **sıfırdan** tasarladım.

> AI: Hızlıca bu sorunu çözdük.
> İnsan: Bu sorunu **hızlıca** çözdük.

**Nerede biter.** Her zarfı mekanik olarak yükleme bitişik yuvaya itme. Cümlenin
hangi soruyu yanıtladığını sor; oraya o yanıt girer, başka bir şey girmez.
Vurguyu taşımadığı hâlde yüklemin önüne park etmiş bir zarf okuru fiilen
yanlış yönlendirir.

---

## 4. Tanıklık — `-mIş`

Türkçe, konuşanın olaya tanık olup olmadığını dilbilgisiyle işaretler. `-DI`
doğrudandır: gördüm, oldu, ben yaptım. `-mIş` geri kalan her şeydir — duyulan,
çıkarsanan, sonradan öğrenilen ya da hikâye olarak anlatılan. İngilizcede
karşılığı yoktur; bu yüzden yardımsız LLM Türkçesi her şeye `-DI` koyar ve
anlatı bir tutanak gibi okunur.

> AI: Kahinler kehanette bulundu.
> İnsan: Kahinler kehanette bulun**muş**.

> AI: O dönemde krallar Gordios olarak biliniyordu.
> İnsan: O dönemde krallar Gordios olarak bilin**ir**miş.

> AI: Sunucu gece yeniden başladı. — ama bunu hatırlamıyorsun, log'dan okuyorsun
> İnsan: Sunucu gece yeniden başla**mış**.

> AI: Bütün gece çalıştılar. — ertesi sabah öğrendin
> İnsan: Meğer bütün gece çalış**mışlar**.

**Nerede biter.** Yazan oradaysa `-DI` doğrudur ve `-mIş` bilginin kaynağı
hakkında yalan söyler. Kendi işini anlatmak `-DI` alır: *Servisi .NET 8'e
taşıdım*, asla *taşımışım* değil. Hukuki ve resmi metinler kayda geçmiş
olayları `-mIş` ile anlatmaz.

---

## 5. Geniş zaman ve `-yor`

İngilizce geniş zaman hem alışkanlığı hem şu anı kapsar. Türkçe bunları ayırır:
`geniş zaman` (`-Ir/-Ar`) özellik, alışkanlık ve genel doğrular için; `-yor`
şu an olan ya da sınırlı bir güncel dönemi kapsayan şey için. İngilizce geniş
zamanı varsayılan olarak `-yor`a eşlemek, bir şeyin nasıl çalıştığını anlatan
metni canlı maç anlatımına çevirir.

> AI: Bu servis istekleri işl**iyor**. — servisin ne yaptığını anlatıyor
> İnsan: Bu servis istekleri işl**er**.

> AI: Redis veriyi bellekte tut**uyor**. — Redis hakkında genel bir olgu
> İnsan: Redis veriyi bellekte tut**ar**.

> AI: Yeni özellikler geliştir**iyor**, mimariye katkı ver**iyor**um. — süregelen bir rol
> İnsan: Yeni özellikler geliştir**ir**, mimariye katkı ver**ir**im.

**Nerede biter.** `-yor` gerçekten süregiden bir durum için doğrudur ve blog
register'ında çoğu zaman geniş zamandan daha sıcak, daha az ders verir tonda
okunur: *Son dönemde AI tarafına yöneliyorum* olduğu gibi doğrudur. Her `-yor`u
geniş zamana çevirmek, kendine özgü bir yapaylığı olan ansiklopedik bir katılık
üretir.

---

## 6. `-DIr` enflasyonu

`-DIr` Türkçenin koşacı değildir. Türkçede geniş zamanda normalde **hiç** koşaç
yoktur. `-DIr` genelleme, varsayım ya da resmî bir iddia işaretler; onu
varsayılan cümle bitirici olarak kullanmak teknik ve akademik Türkçedeki en
güçlü ölçülebilir makine sinyallerinden biridir.

> AI: Bu yöntem etkili**dir**.
> İnsan: Bu yöntem etkili.

> AI: Cache invalidation zor**dur**.
> İnsan: Cache invalidation zor iş.

> AI: Silme işlemi idempotent**tir**.
> İnsan: Silme işlemi idempotent.

> AI: Bu, sistemin en kritik parçası**dır**.
> İnsan: Burası sistemin en kritik parçası.

**Nerede biter.** `-DIr` tanımlarda, standartlarda, şartnamelerde ve hukuki
metinde doğrudur ve gereklidir — *Bu sözleşme iki nüsha olarak düzenlenmiştir* —
ayrıca "muhtemelen" anlamındaki gerçek varsayımda: *Şimdi evdedir.* Bir
şartnameden onu ayıklamak şartnameyi yanlış hale getirir.

---

## 7. `-mektedir` enflasyonu

`-mektedir` biçimi bürokratik şimdiki zamandır. Akademik ve resmi register'a
aittir, başka hiçbir yere değil; ama LLM Türkçesi konu ciddi göründüğü anda ona
uzanır.

> AI: Kullanım art**maktadır**.
> İnsan: Kullanım artıyor.

> AI: Bu çalışma, kentleşmenin etkilerini incele**mektedir**.
> İnsan (blog): Bu yazı kentleşmenin etkilerine bakıyor.

**Nerede biter.** Akademik Türkçe onu gerçekten kullanır ve bir makaleden
çıkarmak makaleyi blog yazısı gibi okutur — bu bir düzeltme değil, başka bir
hatadır. Akademik register'da kalsın, başka her yerde çıksın.

---

## 8. Devrik cümle

Türkçenin varsayılan dizilişi yüklem-sonludur, ama konuşma, blog yazısı ve
edebi nesir bunu sürekli bozar; yüklemi öne çeker ve bir öbeği arkasından
bırakır. Yüzde yüz yüklem-sonlu nesir üretilmiş gibi okunur, çünkü hiçbir Türk
bir sayfa boyunca öyle yazmaz.

> AI: Kimse bu yazıları okumuyor.
> İnsan: Kimse okumuyor bu yazıları.

> AI: Orası gerçekten güzeldi.
> İnsan: Güzeldi orası, gerçekten.

> AI: Bunu daha sonra konuşuruz.
> İnsan: Konuşuruz bunu sonra.

**Nerede biter.** Devrik cümle teknik dokümantasyonda, hukuki metinde ve
akademik nesirde yanlıştır; oralarda ses değil özensizlik olarak okunur. Blog
register'ında bile bir baharattır: bütün bir yazıda iki ya da üç tane. Vurgu
taşımayan devrik cümle yalnızca bir söz dizimi hatasıdır.

---

## 9. Tonlama parçacıkları

`de/da` · `ise` · `ki` · `işte` · `zaten` · `hani` · `bir de` · `yani` · `ya` ·
`canım`

Bunlar tonu taşır ve makine Türkçesinde hiçbiri yoktur. Bir metnin tamamen
doğru olup yine de arkasında kimsenin bulunmamasının sebebi budur.

> AI: Bu yöntem işe yaramıyor. Başka bir yol denemeliyiz.
> İnsan: Bu yöntem işe yaramıyor işte. Başka bir yol denemek lazım.

> AI: Birinci grup hızlı, ikinci grup yavaş.
> İnsan: Birinci grup hızlı, ikincisi ise yavaş.

> AI: Bu arada bir konu daha var.
> İnsan: Bir de şu var.

**Nerede biter.** Parçacıklar register'a bağlıdır. Bir hukuki bildirimde ya da
akademik özette `işte`, `hani`, `canım` düpedüz yanlıştır. Kota tutturmak için
de serpiştirilemezler — tonal bir iş yapmayan parçacık gürültüdür ve gürültü
*insan gibi görünmeye çalışmak* olarak okunur, ki bu nötr durmaktan kötüdür.

---

## 10. Öznenin düşmesi

Türkçede kişi ekleri özneyi zaten taşır; bu yüzden bir iş yapmadıkça zamir
düşer. İngilizce zamiri zorunlu kılar ve bu zorunluluk metne sızar.

> AI: **Ben** bunu yaptım, sonra **ben** şunu ekledim.
> İnsan: Bunu yaptım, sonra şunu ekledim.

> AI: **Siz** eğer isterseniz **siz** bunu değiştirebilirsiniz.
> İnsan: İsterseniz değiştirebilirsiniz.

**Nerede biter.** Zamir karşıtlık kurduğunda kalır — *Ben gittim, o kaldı* — ve
odağı taşıdığında kalır, ki §3'teki durum budur: *İzmir'e dün ben gittim.*

---

## 11. Ad tamlaması zincirleri

Türkçe birleşik adları iyelik ekiyle üst üste yığarak kurar ve bu yığının
tavanı İngilizcenin isim istiflemesinden çok daha düşüktür. Arka arkaya dört
isim öbeği boğar.

> AI: müşteri segmentasyon modülü performans iyileştirme çalışması
> İnsan: müşteri segmentasyon modülünde yaptığımız performans çalışması

> AI: kullanıcı davranış analiz raporu hazırlama süreci
> İnsan: kullanıcı davranışlarını analiz eden raporları nasıl hazırladığımız

Pratik tavan üç bağlı isimdir. Daha uzun zincirleri `-de` / `-deki`, `için`,
`ile` ya da bir ortaçla kır.

**Nerede biter.** Yerleşik çok sözcüklü terimler tek bir birimdir ve
parçalanamaz: *bilgi işlem daire başkanlığı*, *gelir vergisi beyannamesi*,
*kurumlar vergisi oranı*. Bunları kırmak hiçbir şeyi sadeleştirmez; yalnızca
hiçbir şeyi adlandırmayan bir öbek üretir.

---

## 12. `ki` yan cümleleri

Türkçede yerli bir `ki` vardır, ama sağa dallanan ilgi `ki`si — İngilizce
*that* ya da *which* yerine geçen — bir calque'tır. Türkçe ilgi cümlelerini
§1'deki gibi, ismin önünde, ortaçla kurar.

> AI: Bir sistem kurduk **ki** bu sistem her gece çalışıyor.
> İnsan: Her gece çalışan bir sistem kurduk.

> AI: Düşünüyorum **ki** bu doğru değil.
> İnsan: Bence bu doğru değil. / Bunun doğru olmadığını düşünüyorum.

**Nerede biter.** Birkaç `ki` yapısı tümüyle yerlidir ve çıkarmak deyimi bozar:
pekiştirme (*Öyle yoruldum ki*) ve kalıplaşmış biçimler *belli ki*, *demek ki*,
*ne var ki*, *oysa ki*, *sanmam ki*. Yalnızca bir ortacın yerini alabileceği
ilgi `ki`si hedeftir.

---

## 13. Uzunluk varyansı

Türkçenin eklemeli yapısı tek bir kelimenin bütün bir cümlecik olmasına izin
verir — *Olmadı.* *Gidebilseydik.* *Bilmiyorum.* — bu yüzden Türkçe nesir en
kısa ve en uzun cümlesi arasında İngilizceden daha geniş salınabilir. Makine
Türkçesi tersini yapar: her cümle aynı banda düşer ve ortaya çıkan düzlük,
okurun adını koyamadan ilk fark ettiği izdir.

> AI: Bu yaklaşımı denedik ancak beklediğimiz sonucu alamadık ve bir süre sonra tamamen farklı bir yöntem üzerinde çalışmaya başladık. Ekip olarak bu kararın doğru olduğunu düşünüyoruz çünkü yeni yöntem hem daha hızlı hem de bakımı daha kolay bir çözüm sunuyor.
>
> İnsan: Bu yaklaşımı denedik. Olmadı. Bir süre sonra bambaşka bir yöntemin üzerine oturduk — ekip olarak da doğru karar olduğunu düşünüyoruz, çünkü yenisi hem daha hızlı çalışıyor hem de bakımı bizi daha az yoruyor.

**Nerede biter.** Akademik ya da hukuki register'da kesik kesik bir ritim imal
etme. Orada varyans tek kelimelik cümlelerden değil, cümlecik yapısından gelir;
bir makalenin ortasındaki yalnız bir *Olmadı.* register hatasıdır.

---

## 14. Edilgen çatı sızıntısı

Akademik Türkçe edilgen çatıyı yeğler ve bu yeğleme diğer bütün register'lara
sızarak özneye ihtiyaç duyan cümlelerden özneyi boşaltır.

> AI: Cache temizlenmeli ve veri yeniden yüklenmelidir.
> İnsan: Cache'i temizleyin, veriyi yeniden yükleyin.

> AI: Bu sorun tarafımızdan çözülmüştür.
> İnsan: Bu sorunu çözdük.

> AI: Segmentasyon modülü geliştirilmiştir.
> İnsan: Segmentasyon modülünü geliştirdim.

**Nerede biter.** Akademik ve resmi Türkçe edilgen çatıyı türün bir kuralı
olarak gerçekten kullanır; bir yöntem bölümünü etken çatıya çevirmek onu
yayımlanamaz bir taslak gibi okutur.

---

## Katmanı bütün olarak okumak

Bu on dört madde yukarıdan aşağı işaretlenecek bir liste değildir. İkisi —
dallanma yönü ve ulaç sistemi — makine Türkçesini makine yapımı hissettiren
şeyin çoğunu tek başına açıklar, çünkü ikisi de cümleciklerin birbirine nasıl
tutunduğuyla ilgilidir ve İngilizce yapı en inatçı biçimde tam o düzeyde
çeviriden sağ çıkar. Bu ikisini onar, paragraf zaten başka türlü nefes alır.

Geri kalanlar düzeltmedir; devrik cümle, tanıklık kipi ve parçacıklar
söz konusu olduğunda ise izinlerdir: Türkçe yazan birinin yaptığı ama bir LLM'in
yapabileceği söylenmedikçe yapmayacağı şeyler.
