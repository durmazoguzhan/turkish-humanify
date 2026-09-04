# turkish-humanify — logo guidelines

Every number below is derived from the drawing rather than chosen, and the
derivation is shown so you can check it or change the input and redo it.

---

## What the mark says

Two arms arrive and one body leaves. Each arm enters 56 units thick and meets
the body at 40; the body is 80, not 112. The missing 32 units are the
conjunction that Turkish does not need.

That is the skill's subject drawn once: English joins two clauses by putting a
word between them, Turkish fuses them with a suffix and the word disappears.
`Veriyi çektik **ve** işledik` becomes `veriyi çek**ip** işledik`.

The two arms are not equal partners and they are not drawn as equals. The ink
arm carries 16.84:1 against paper and the accent arm 4.52:1, so the upper one
reads as dominant. That is correct: in a converb construction the `-ip` clause
is subordinate and the final verb carries tense and person. The imbalance is
the claim, not a defect to be corrected.

**The mark reads left to right.** Two in, one out. Never mirror it — mirrored
it says one becomes two, which is the opposite claim.

---

## Files

    brand/
      logo.svg                 primary lockup, full colour, for light surfaces
      logo-reversed.svg        full colour for dark surfaces: the ink becomes
                               paper and the accent stays itself
      logo-mono-dark.svg       one ink, dark, single plate and engraving
      logo-mono-light.svg      one ink, reversed, for mid-tone surfaces
      icon.svg                 square icon, transparent, for favicons
      avatar.svg               square, full bleed on the plate, for a circle crop
      favicon.ico              7 resolutions, 16 to 256
      logo.png, logo-dark.png  1200px wide, for README embedding
      icon-256.png, avatar-512.png
      logo-master.svg          the editable master, live text, not for delivery

The print set (outlined SVG, PDF, EPS) is regenerated on demand rather than
committed, because it is derived and it is large. The commands are at the
bottom of this file.

The master keeps live text on purpose: a wordmark you cannot retype is a
wordmark you cannot fix. Everything shipped is outlined, and
`scripts/check.py` refuses any file where that is not true.

---

## Type

**Lato Bold (700)**, SIL Open Font License 1.1, which permits outlining and
embedding in a mark. On the machine that built this, `fc-match Lato` resolved
to Lato itself, so the outlined paths are Lato and not a substitute. Verify
that on any machine that regenerates the files: an outline freezes whatever
fontconfig resolved, not what you asked for.

Set at font-size 133.5 in a 1539.07-unit lockup, tracking unchanged.

**The hyphen is the only accent in the wordmark**, because the hyphen is the
join and the join is what the icon is about.

---

## Minimum size

Derived from the smallest element that has to survive, not guessed.

**Icon.** The thinnest element is an arm where it meets the body: 40 units of
the mark's 320 width, so exactly 1/8.

| | minimum | the arm lands at |
|---|---|---|
| screen | **20 px** wide | 2.5 px |
| print | **10 mm** wide | 1.25 mm |

Below 20px the fork softens. It is still legible at 16px — measured detail loss
0.089, which the favicon set clears — so 16px is allowed where a platform
forces it.

**Lockup.** Governed by the wordmark, not the icon. Cap height is 96.12 of the
lockup's 1539.07 width, which is 1/16.

| | minimum | cap height lands at |
|---|---|---|
| screen | **150 px** wide | 9.4 px |
| print | **32 mm** wide | 2 mm |

Checked by rendering, not by arithmetic alone: at 110px the fork breaks up and
the wordmark crowds. At 150px both hold.

**Below 240px, drop the accent hyphen and set the wordmark in one ink.** The
hyphen is 13.75 units tall against the lockup's 1539.07 width, so it falls
under one device pixel at 112px and stops reading as colour well before that.
A one-pixel red speck is noise; the all-ink wordmark is the correct small
variant.

---

## Clear space

Expressed as a ratio so it scales.

**Lockup:** one cap height on all four sides, which is 1/16 of the lockup's
width. At 800px wide that is 50px.

**Icon:** one quarter of the icon's width on all four sides.

Nothing enters that space. Not a border, not a tagline, not another logo.

---

## Colour

| role | hex | RGB | L\*a\*b\* | where it is authoritative |
|---|---|---|---|---|
| ink | `#14171A` | 20, 23, 26 | 7.52, −0.79, −2.64 | screen |
| accent | `#B7543C` | 183, 84, 60 | 48.46, 39.70, 33.93 | screen |
| paper | `#FAF7F2` | 250, 247, 242 | 97.36, 0.39, 2.78 | screen |

L\*a\*b\* measured through the sRGB profile, D50 PCS. The accent sits at
C\* 52.2 on hue 40.5°, which is the number the gamut work below moved.

### The accent was chosen by the press, not by the screen

The first version of this palette used `#C8442A`, picked on a monitor. It does
not print. Converted into a coated process profile and back it moves **ΔE2000
3.72**, with the yellow plate clipped at 100 — the separation had already
altered the colour before anyone saw a proof.

`#B7543C` is the same hue at lower chroma. Hue was held at 40.5° and chroma
walked down from 68.8 until the round trip closed, which is the difference
between finding the gamut boundary and desaturating until something works.

| | ΔE2000 round trip | contrast on paper |
|---|---|---|
| `#C8442A` rejected | **3.72** the press cannot reach it | 4.55:1 |
| `#B7543C` chosen | **0.52** prints as itself | 4.52:1 |

Lightness is unchanged at L\* 48.4, so the mark's optical balance is exactly
what it was. Dichromacy separation improved as a side effect, because the new
colour leans less on the red channel.

Measured against Ghostscript's *Artifex CMYK SWOP* profile, which represents
coated process printing but is not FOGRA39 and is not your printer's profile.
Re-run `gamut.py` with theirs when there is a job.

### The ink is a substrate limit, not a bad choice

`#14171A` round-trips at ΔE 6.32 and no adjustment fixes that honestly. SWOP
cannot reach L\* 8; its darkest point on this hue is near L\* 18. Bringing the
ink inside the gamut means `#28303A`, and there the ink-to-accent contrast
falls to **2.76:1**, under the 3:1 floor — the two arms of the mark stop being
separable. Chasing gamut here breaks the logo.

**No press reaches screen black.** The answer is the build, not the colour:

- **100% K alone** for the wordmark at small sizes and any thin element. Four
  plates on a hairline misregister and the edge goes fuzzy.
- **Rich black** for large solid areas, so the arms read as black rather than
  dark grey. Ask the printer for their house build; a common starting point is
  C60 M40 Y40 K100.

### Pantone

**None is specified, and one cannot be specified from here.** Pantone's colour
data is licensed and closed; any number written from memory would be a guess
dressed as a specification, and a wrong spot colour is more expensive than no
spot colour.

What has been done instead is the part that makes a Pantone match possible.
**A colour outside the CMYK gamut can never agree with its own process
build** — the spot version and the four-colour version will differ on every
job, forever. `#B7543C` is inside the gamut, so whichever Pantone is chosen for
it will hold across both.

To finish it: take `#B7543C` and its CMYK to a **Pantone Color Bridge** guide,
which prints each Pantone beside its process equivalent, and choose under the
printer's viewing light. Write the number into this table when it exists.

**CMYK is the printer's to derive.** SVG carries no colour space and every file
here is RGB. The SWOP separations measured above are ink `76/68/64/89` and
accent `21/83/98/10`; they are a ranking, not a specification.

### Which variant on which surface

Measured with WCAG contrast, floor 3:1 for a graphic.

| surface | `logo` | `logo-reversed` | `logo-mono-light` |
|---|---|---|---|
| paper `#FAF7F2` | **4.52:1** ✓ | 1.00 ✗ | 1.00 ✗ |
| white | **4.83:1** ✓ | 1.07 ✗ | 1.07 ✗ |
| brand plate `#14171A` | 1.00 ✗ | **3.72:1** ✓ | **16.84:1** ✓ |
| GitHub dark `#0D1117` | 1.05 ✗ | **3.92:1** ✓ | **17.71:1** ✓ |
| black | 1.17 ✗ | **4.35:1** ✓ | **19.65:1** ✓ |
| mid grey `#808080` | 1.22 ✗ | 1.22 ✗ | **3.70:1** ✓ |

**On dark, prefer `logo-reversed`.** It clears 3:1 on every dark surface
measured and it keeps the accent, which the one-ink version throws away. Fall
back to `logo-mono-light` for mid-tone surfaces, a single plate, and anywhere
the reproduction is one ink whatever you send.

The mid-grey row is a routing instruction and not a fault in the accent. To
clear 3:1 against `#808080` an ink must have relative luminance above 0.747 or
below 0.039, so **no saturated mid-tone can pass it**. The answer is the
reversed variant, never a desaturated brand colour.

### Colour vision

The two inks are separated by luminance rather than hue, so the mark survives
dichromacy: the closest pair keeps 67% of its separation under protanopia, 89%
under deuteranopia and 110% under tritanopia. It also holds in greyscale at
3.70:1, which is what a single plate, an engraving and a fax all see.

---

## Misuse

1. **Do not mirror or rotate it.** Two in and one out is the statement.
2. **Do not swap the arm colours.** The ink arm is the main clause. Accent on
   top inverts the grammar.
3. **Do not open a gap between the arms and the body.** The fusion is the idea;
   a gap says the two never joined.
4. **Do not put `logo.svg` on a dark or mid-tone surface.** Measured at 1.00:1
   and 1.22:1. Use `logo-reversed.svg` on dark, `logo-mono-light.svg` on
   mid-tone.
5. **Do not reset the wordmark in another face**, and do not add a tagline
   inside the clear space.
6. **Do not add a stroke, shadow, gradient or bevel.** The silhouette carries
   the mark in one ink, which is the property all of those destroy.
7. **Do not use the lockup where a square is wanted.** Squeezing 1539x352 into a
   256px avatar gives a 59px-tall smear. Use `avatar.svg`.

---

## Regenerating

`$S` is the `scripts/` directory of
[svg-logo-maker](https://github.com/durmazoguzhan/svg-logo-maker). Run this from
the repository root after editing `brand/logo-master.svg`.

    python3 $S/check.py --favicon-size 16 brand/logo-master.svg
    bash    $S/outline.sh brand/logo-master.svg /tmp/outlined.svg
    python3 $S/variants.py /tmp/outlined.svg /tmp/v \
            --dark '#14171A' --light '#FAF7F2'
    cp /tmp/v/outlined-full.svg       brand/logo.svg
    cp /tmp/v/outlined-mono-dark.svg  brand/logo-mono-dark.svg
    cp /tmp/v/outlined-mono-light.svg brand/logo-mono-light.svg
    python3 $S/icon-extract.py /tmp/outlined.svg brand/icon.svg
    bash    $S/ico.sh brand/icon.svg brand/favicon.ico

    # variants.py offers one ink or a plate and nothing between, so the
    # two-colour reversed lockup is made by swapping the ink for the paper.
    sed 's/#14171[Aa]/#FAF7F2/g' brand/logo.svg > brand/logo-reversed.svg

    resvg --width 1200 brand/logo.svg          brand/logo.png
    resvg --width 1200 brand/logo-reversed.svg brand/logo-dark.png
    resvg --width 512 --height 512 brand/avatar.svg brand/avatar-512.png
    resvg --width 256 --height 256 brand/icon.svg   brand/icon-256.png

Then re-run the gates, all three of which have to come back clean:

    python3 $S/check.py --favicon-size 16 brand/logo.svg brand/logo-reversed.svg \
            brand/logo-mono-*.svg brand/icon.svg brand/avatar.svg
    python3 $S/contrast.py brand/logo.svg --bg '#FAF7F2'
    python3 $S/contrast.py brand/logo-reversed.svg --bg '#14171A,#0D1117'
    python3 $S/gamut.py '#14171A' '#B7543C'

For print, which is derived and not committed:

    bash $S/print.sh brand/logo-master.svg out/print/

**Outline before variants, not after.** Running `variants.py` on the live-text
master puts live text in every delivered SVG, and `check.py` fails all of them.
The order above is the corrected one.

**`brand/logo-master.svg` is the only file that may fail the linter**, and it
fails on one rule for one reason: it keeps live `<text>` so the wordmark stays
editable. Everything shipped is outlined.
