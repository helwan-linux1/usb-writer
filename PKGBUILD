# Maintainer: Helwan Linux Team
pkgname=helwan-usb-writer
pkgver=1.0.0
pkgrel=1
pkgdesc="Professional ISO to USB writer tool for Helwan Linux"
arch=('x86_64')
url="https://github.com/helwan-linux1/usb-writer"
license=('GPL3')
depends=('gtk4' 'libadwaita' 'util-linux' 'polkit' 'coreutils')
makedepends=('nim' 'nimble')
source=("git+$url.git")
sha256sums=('SKIP')

build() {
  cd "usb-writer"
  # تثبيت المكتبة المطلوبة للتجميع
  nimble install --extratree:off --accept owlkettle 
  # تجميع البرنامج كملف تنفيذي Release
  nim c -d:release --out:helwan_usb_writer src/helwan_usb_writer.nim 
}

package() {
  cd "usb-writer"
  
  # 1. تثبيت الملف التنفيذي
  install -Dm755 helwan_usb_writer "${pkgdir}/usr/bin/helwan_usb_writer"
  
  # 2. تثبيت ملف الديسك توب (من المجلد الرئيسي حسب مخططك)
  install -Dm644 helwan_usb_iso_writer.desktop "${pkgdir}/usr/share/applications/helwan-usb-writer.desktop"
  
  # 3. تثبيت الأيقونة (من مجلد assets إلى مسار الأيقونات الرسمي)
  install -Dm644 assets/helwan-usb.png "${pkgdir}/usr/share/pixmaps/helwan-usb.png" 
}
