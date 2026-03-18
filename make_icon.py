import sys, subprocess

try:
    from PIL import Image, ImageDraw
except ImportError:
    subprocess.check_call([sys.executable, "-m", "pip", "install", "Pillow",
                           "--quiet", "--break-system-packages"], capture_output=True)
    from PIL import Image, ImageDraw


def make(size=512):
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    def s(v): return max(1, int(v * size / 512))

    r = s(112)

    def rr(x1, y1, x2, y2, rad, fill):
        d.rectangle([x1+rad, y1, x2-rad, y2], fill=fill)
        d.rectangle([x1, y1+rad, x2, y2-rad], fill=fill)
        for cx, cy in [(x1,y1),(x2-2*rad,y1),(x1,y2-2*rad),(x2-2*rad,y2-2*rad)]:
            d.ellipse([cx, cy, cx+2*rad, cy+2*rad], fill=fill)

    rr(0, 0, size-1, size-1, r, (10, 10, 10, 255))

    bx1, by1 = s(100), s(230)
    bx2, by2 = s(412), s(440)
    br = s(36)
    for i in range(s(12), 0, -1):
        a = int(55 * (1 - i/s(12)))
        rr(bx1+i, by1+i, bx2+i, by2+i, br, (0, 0, 0, a))
    rr(bx1, by1, bx2, by2, br, (255, 255, 255, 252))

    cx = size // 2
    cy = (by1 + by2) // 2 - s(8)
    cr = s(40)
    d.ellipse([cx-cr, cy-cr, cx+cr, cy+cr], fill=(225, 29, 72, 255))

    tw, th = s(21), s(54)
    d.rounded_rectangle([cx-tw//2, cy+s(10), cx+tw//2, cy+s(10)+th],
                        radius=s(10), fill=(225, 29, 72, 255))

    dr = s(14)
    d.ellipse([cx-dr, cy-dr, cx+dr, cy+dr], fill=(255, 255, 255, 255))

    aw, sw = s(124), s(28)
    at = s(60); ab = at + s(250)
    d.arc([cx-aw, at, cx+aw, ab], start=212, end=328,
          fill=(225, 29, 72, 255), width=sw)
    ecr = sw // 2
    for ax, ay in [
        (cx - int(aw*0.64), at + int((ab-at)*0.085)),
        (cx + int(aw*0.64), at + int((ab-at)*0.085)),
    ]:
        d.ellipse([ax-ecr, ay-ecr, ax+ecr, ay+ecr], fill=(225, 29, 72, 255))

    return img


def main():
    print("Generating icon...")
    img512 = make(512)
    img512.save("icon.png", "PNG", optimize=True)
    print("icon.png  512x512")

    sizes = [16, 24, 32, 48, 64, 128, 256]
    imgs = [make(s) for s in sizes]
    imgs[0].save("icon.ico", format="ICO",
                 sizes=[(s,s) for s in sizes],
                 append_images=imgs[1:])
    print("icon.ico  16-256px")
    print("\nDone. Place icon.png next to nullpass.py")
    print()
    print("AI image prompt:")
    print("-" * 60)
    print(
        "App icon for a password manager called NullPass.\n"
        "Rounded square, pure black background.\n"
        "White padlock body centered, red shackle arc at top (#e11d48).\n"
        "Circular keyhole, small rectangular slot below.\n"
        "Flat, minimal, no gradients, no shadows.\n"
        "Style: modern macOS/iOS app icon. 1024x1024px."
    )


if __name__ == "__main__":
    main()
