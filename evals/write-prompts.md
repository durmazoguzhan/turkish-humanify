# Write-mode prompts

Everything measured before this file tested **repair mode only**: every run was
given an input text. Write mode — where the user supplies a brief and the skill
composes from nothing — had never been run.

## Design

Twelve fresh prompts, three per register. Each is run **twice under identical
conditions**: once by a subagent that reads the skill and follows it, once by a
subagent that gets the prompt alone. Both arms are generated new; neither reuses
the repair-mode baselines, which were produced at a different time under
different constraints and whose contents are already known to the author.

The single variable is the skill.

| id | prompt |
|---|---|
| `w-blog-1` | Yalova'da bir günlük gezi rotası yaz. |
| `w-blog-2` | Ev bitkilerini öldürmeyi bırakmak üzerine bir yazı yaz. |
| `w-blog-3` | Kırk yaşında yüzme öğrenmek üzerine bir yazı yaz. |
| `w-tech-1` | Kubernetes'te resource limit ve request farkını anlatan bir yazı yaz. |
| `w-tech-2` | Veritabanı migration'larını güvenli yapmak üzerine bir yazı yaz. |
| `w-tech-3` | REST ile GraphQL arasında seçim yapmak üzerine bir yazı yaz. |
| `w-corp-1` | Yerel bir fırın için Instagram tanıtım metni yaz. |
| `w-corp-2` | Şirketimizin yeni izin politikasını duyuran bir e-posta yaz. |
| `w-corp-3` | Bir diş kliniği için web sitesi tanıtım metni yaz. |
| `w-acad-1` | Sosyal medya kullanımının gençlerde dikkat süresine etkisi üzerine bir makale özeti yaz. |
| `w-acad-2` | Türkiye'de kadın istihdamının önündeki engeller üzerine bir literatür taraması girişi yaz. |
| `w-acad-3` | Deprem sonrası kentsel dönüşüm politikaları üzerine bir makale girişi yaz. |

All twelve topics are new — none appears among the twenty-one repair baselines.

## What is not measured here

**Brief adherence is not scored.** There is no source text to be faithful to, so
the repair-mode fidelity check does not transfer. Anything surprising in the
output is reported by reading it, not by a metric.
