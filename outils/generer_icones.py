"""Logo Pense-Bail : post-it jaune en forme de maison, coin plié, coche bleu
canard, sur une tuile bleu canard (docs/decisions.md, « Publication »).

Génère les images : icône et image de lancement iOS, icônes Android
anciennes (mipmap-*dpi), icône et bannière du Play Store. Les vecteurs
Android (drawable/ic_launcher_foreground.xml, ic_launcher_monochrome.xml,
ic_notification.xml, logo_lancement.xml) et le logo de l'application
(LogoPenseBail, lib/core/widgets/composants.dart) sont écrits à la main
avec la même géométrie : la changer partout à la fois.

Géométrie dans une tuile de 100 unités. Couleurs : primary, logoNote et
logoPli (docs/design-system.md).

Usage, depuis la racine du projet (Pillow requis) :
    python outils/generer_icones.py
"""

import json
import pathlib
import sys

from PIL import Image, ImageDraw

BLEU = (0x0E, 0x4F, 0x58)
JAUNE = (0xFF, 0xD9, 0x5A)
PLI = (0xE3, 0xB5, 0x30)
GRAND = 4096

NOTE = [(50, 16), (82, 44), (82, 70), (68, 84), (18, 84), (18, 44)]
COIN = [(82, 70), (68, 70), (68, 84)]
COCHE = [(35, 63), (45, 72), (64, 53)]


def trait(d, pts, couleur, largeur, ferme=False):
    """Trait à extrémités et angles arrondis."""
    if ferme:
        pts = pts + [pts[0]]
    d.line(pts, fill=couleur, width=round(largeur))
    r = largeur / 2
    for x, y in pts:
        d.ellipse([x - r, y - r, x + r, y + r], fill=couleur)


def note(d, x0, y0, unite):
    """Dessine le post-it ; (x0, y0) = coin de la tuile de 100 unités."""

    def p(pts):
        return [(x0 + x * unite, y0 + y * unite) for x, y in pts]

    d.polygon(p(NOTE), fill=JAUNE)
    trait(d, p(NOTE), JAUNE, 4 * unite, ferme=True)
    d.polygon(p(COIN), fill=PLI)
    trait(d, p(COIN), PLI, 3 * unite, ferme=True)
    trait(d, p(COCHE), BLEU, 7 * unite)


def carre():
    """Carré plein sans transparence (App Store, Play Store)."""
    img = Image.new("RGB", (GRAND, GRAND), BLEU)
    note(ImageDraw.Draw(img), 0, 0, GRAND / 100)
    return img


def tuile(marge=0.0):
    """Tuile arrondie (rayon 24/108) sur fond transparent ; `marge` en
    fraction du côté (icônes Android anciennes)."""
    img = Image.new("RGBA", (GRAND, GRAND), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    m = GRAND * marge
    cote = GRAND - 2 * m
    d.rounded_rectangle([m, m, m + cote - 1, m + cote - 1], radius=cote * 24 / 108, fill=BLEU + (255,))
    note(d, m, m, cote / 100)
    return img


def banniere(chemin):
    """Dessine le post-it seul, sur le fond bleu canard, à gauche du texte
    de la bannière (le texte n'est pas regénéré)."""
    img = Image.open(chemin).convert("RGB")
    f = 4
    grande = img.resize((img.width * f, img.height * f), Image.NEAREST)
    d = ImageDraw.Draw(grande)
    # Emplacement du logo : x 96..227, y 184..315 (132 px).
    d.rectangle([90 * f, 178 * f, 234 * f, 322 * f], fill=BLEU)
    unite = 132 / 68 * f  # le post-it (68 unités de haut) occupe 132 px
    cx, cy = 162 * f, 250 * f
    note(d, cx - 50 * unite, cy - 50 * unite, unite)
    zone = (88, 176, 236, 324)
    morceau = grande.crop(tuple(v * f for v in zone)).resize((zone[2] - zone[0], zone[3] - zone[1]), Image.LANCZOS)
    img.paste(morceau, zone[:2])
    img.save(chemin)


def main(racine):
    racine = pathlib.Path(racine)
    plein = carre()

    assets = racine / "ios/Runner/Assets.xcassets"
    dossier = assets / "AppIcon.appiconset"
    contenu = json.loads((dossier / "Contents.json").read_text(encoding="utf-8"))
    for image in contenu["images"]:
        px = round(float(image["size"].split("x")[0]) * int(image["scale"][:-1]))
        plein.resize((px, px), Image.LANCZOS).save(dossier / image["filename"])
    lancement = tuile()
    for nom, px in [("LaunchImage.png", 96), ("LaunchImage@2x.png", 192), ("LaunchImage@3x.png", 288)]:
        lancement.resize((px, px), Image.LANCZOS).save(assets / "LaunchImage.imageset" / nom)

    # Icônes Android anciennes (avant Android 8) : tuile de 174/192.
    ancienne = tuile(marge=9 / 192)
    res = racine / "android/app/src/main/res"
    for densite, px in [("mdpi", 48), ("hdpi", 72), ("xhdpi", 96), ("xxhdpi", 144), ("xxxhdpi", 192)]:
        ancienne.resize((px, px), Image.LANCZOS).save(res / f"mipmap-{densite}" / "ic_launcher.png")

    pub = racine / "docs/publication"
    plein.resize((512, 512), Image.LANCZOS).save(pub / "icone-512.png")
    banniere(pub / "banniere-1024x500.png")


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else pathlib.Path(__file__).resolve().parent.parent)
