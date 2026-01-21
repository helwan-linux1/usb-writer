# Maintainer: Helwan Linux Team
pkgname=hel-usb-writer
pkgver=1.0.0
pkgrel=1
pkgdesc="Professional ISO to USB writer tool for Helwan Linux"
arch=('x86_64')
url="https://github.com/helwan-linux1/usb-writer"
license=('GPL3')
depends=('gtk4' 'libadwaita' 'util-linux' 'polkit' 'coreutils')
makedepends=('git' 'nim' 'nimble')
source=("git+https://github.com/helwan-linux1/usb-writer.git")
sha256sums=('SKIP')

build() {
  cd "${srcdir}/usb-writer/HelwanUSBWriter"
  # تثبيت المكتبة الصحيحة gintro التي يستدعيها الكود
  nimble install --extratree:off --accept gintro
  # بناء البرنامج باستخدام Nim من ملف src/helwan_usb_writer.nim
  nim c -d:release --out:hel-usb-writer src/helwan_usb_writer.nim
}

package() {
  cd "${srcdir}/usb-writer/HelwanUSBWriter"
  
  # 1. تثبيت الملف التنفيذي
  install -Dm755 hel-usb-writer "${pkgdir}/usr/bin/hel-usb-writer"
  
  # 2. ملف الديسك توب
  install -Dm644 helwan_usb_iso_writer.desktop "${pkgdir}/usr/share/applications/helwan-usb-writer.desktop"
  
  # 3. الأيقونة من مجلد assets
  install -Dm644 assets/helwan-usb.png "${pkgdir}/usr/share/pixmaps/helwan-usb.png"
  
  # 4. ملف الـ Polkit Policy
  install -Dm644 org.helwan.pkexec.hel-usb-writer.policy "${pkgdir}/usr/share/polkit-1/actions/org.helwan.pkexec.hel-usb-writer.policy"
}
