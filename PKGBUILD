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
  cd "usb-writer"
  # [cite_start]تثبيت مكتبة owlkettle المطلوبة للبناء [cite: 1]
  nimble install --extratree:off --accept owlkettle
  # تجميع الكود لإنتاج ملف تنفيذي باسم hel-usb-writer
  nim c -d:release --out:hel-usb-writer src/helwan_usb_writer.nim
}

package() {
  cd "usb-writer"
  
  # تثبيت الملف التنفيذي
  install -Dm755 hel-usb-writer "${pkgdir}/usr/bin/hel-usb-writer"
  
  # تثبيت ملف الديسك توب لظهور البرنامج في القائمة
  install -Dm644 helwan_usb_iso_writer.desktop "${pkgdir}/usr/share/applications/hel-usb-writer.desktop"
  
  # [cite_start]تثبيت الأيقونة في المسار المحدد في الكود [cite: 2]
  install -Dm644 assets/helwan-usb.png "${pkgdir}/usr/share/pixmaps/helwan-usb.png"
}
