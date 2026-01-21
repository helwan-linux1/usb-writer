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
  cd "usb-writer/HelwanUSBWriter"
  nimble install --extratree:off --accept owlkettle
  # بناء البرنامج
  nim c -d:release --out:hel-usb-writer src/helwan_usb_writer.nim
}

package() {
  cd "usb-writer/HelwanUSBWriter"
  
  # 1. الملف التنفيذي
  install -Dm755 hel-usb-writer "${pkgdir}/usr/bin/hel-usb-writer"
  
  # 2. ملف الديسك توب
  install -Dm644 helwan_usb_iso_writer.desktop "${pkgdir}/usr/share/applications/hel-usb-writer.desktop"
  
  # 3. الأيقونة
  install -Dm644 assets/helwan-usb.png "${pkgdir}/usr/share/pixmaps/helwan-usb.png"
  
  # 4. ملف الـ Polkit Policy (المكان الذي سألت عنه)
  install -Dm644 org.helwan.pkexec.hel-usb-writer.policy "${pkgdir}/usr/share/polkit-1/actions/org.helwan.pkexec.hel-usb-writer.policy"
}
