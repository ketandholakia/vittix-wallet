from pathlib import Path
from PIL import Image, ImageOps, ImageFilter

ROOT = Path(r"D:\ketan\github\vittix_expense_tracker\expense_tracker")
SOURCE = ROOT / "assets" / "branding" / "vittix_logo.png"
ANDROID = ROOT / "android" / "app" / "src" / "main" / "res"
IOS_APPICON = ROOT / "ios" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"
IOS_LAUNCH = ROOT / "ios" / "Runner" / "Assets.xcassets" / "LaunchImage.imageset"

sizes = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

ios_icon_sizes = {
    "Icon-App-20x20@1x.png": 20,
    "Icon-App-20x20@2x.png": 40,
    "Icon-App-20x20@3x.png": 60,
    "Icon-App-29x29@1x.png": 29,
    "Icon-App-29x29@2x.png": 58,
    "Icon-App-29x29@3x.png": 87,
    "Icon-App-40x40@1x.png": 40,
    "Icon-App-40x40@2x.png": 80,
    "Icon-App-40x40@3x.png": 120,
    "Icon-App-60x60@2x.png": 120,
    "Icon-App-60x60@3x.png": 180,
    "Icon-App-76x76@1x.png": 76,
    "Icon-App-76x76@2x.png": 152,
    "Icon-App-83.5x83.5@2x.png": 167,
    "Icon-App-1024x1024@1x.png": 1024,
}

def square_logo(base, size, padding=0.12):
    img = Image.open(base).convert("RGBA")
    # keep composition centered and square
    side = max(img.size)
    canvas = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    canvas.paste(img, ((side - img.width) // 2, (side - img.height) // 2))
    target = int(size * (1 - padding * 2))
    scaled = ImageOps.contain(canvas, (target, target), Image.Resampling.LANCZOS)
    out = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    out.paste(scaled, ((size - scaled.width) // 2, (size - scaled.height) // 2), scaled)
    return out

def make_android_background(size):
    bg = Image.new("RGBA", (size, size), (7, 21, 36, 255))
    return bg

src = SOURCE
if not src.exists():
    raise SystemExit(f"Missing source logo: {src}")

for folder, px in sizes.items():
    out_dir = ANDROID / folder
    out_dir.mkdir(parents=True, exist_ok=True)
    square_logo(src, px).save(out_dir / "ic_launcher.png")

android_launch = ANDROID / "drawable"
android_launch.mkdir(parents=True, exist_ok=True)
square_logo(src, 192, padding=0.18).save(android_launch / "launch_logo.png")

for name, px in ios_icon_sizes.items():
    square_logo(src, px).save(IOS_APPICON / name)

launch_icon = square_logo(src, 180, padding=0.18)
launch_icon.save(IOS_LAUNCH / "LaunchLogo.png")
