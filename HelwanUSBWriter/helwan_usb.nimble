# Package
version       = "1.0.0"
author        = "Helwan Linux Team"
description   = "Professional ISO to USB writer for Helwan Linux"
license       = "GPL-3.0"
srcDir        = "src"
bin           = @["helwan_usb_writer"] # اسم الملف التنفيذي الناتج

# Dependencies
requires "nim >= 1.6.0"
requires "owlkettle >= 2.0.0" # المكتبة التي تستخدمها في الواجهة