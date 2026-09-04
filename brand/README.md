# Brand files

The mark is two arms arriving and one body leaving. English joins two clauses
by putting a word between them; Turkish fuses them with a suffix and the word
disappears. `Veriyi çektik **ve** işledik` becomes `veriyi çek**ip** işledik`,
and that is what the drawing is of.

`guidelines.md` has the rest: what may not be done to it, minimum sizes, clear
space, the colour values and which variant belongs on which surface. Read it
before using any of these somewhere new.

## Which file

| File | For |
|---|---|
| `logo.svg` | the default. Full colour, on light surfaces |
| `logo-reversed.svg` | dark surfaces. Still two colours: the ink becomes paper and the accent stays itself, so the brand does not lose half of itself in dark mode. Measured at 3.92:1 on GitHub's dark background |
| `logo-mono-light.svg` | mid-tone surfaces, and anywhere the reproduction is one ink whatever you send |
| `logo-mono-dark.svg` | one plate, engraving, embossing, on a light surface |
| `icon.svg` | square, transparent. Favicons and anywhere the name is not needed |
| `avatar.svg` | square, full bleed on the plate. GitHub avatars, which are cropped to a circle |
| `favicon.ico` | seven resolutions, 16 to 256 |
| `logo.png`, `logo-dark.png` | README embedding, 1200px wide |
| `logo-master.svg` | **the editable master.** Live text, not for delivery |

`logo-master.svg` is the only file here that fails the linter, and it fails on
purpose: it keeps live `<text>` so the wordmark can be retyped. Everything else
is outlined. Edit the master, then regenerate — `guidelines.md` has the
commands.

## Regenerating

Made with [svg-logo-maker](https://github.com/durmazoguzhan/svg-logo-maker),
which needs no API key. Every claim in `guidelines.md` was measured by its
scripts rather than asserted, including the one that changed the accent colour:
the first version of this palette could not be printed.
