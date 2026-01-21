# Package
version       = "0.1.0"
author        = "Helwan Linux Team"
description   = "USB Writer for Helwan Linux"
license       = "GPL-3.0"
srcDir        = "src"
bin           = @["helwan_usb_writer"]

# Dependencies
requires "nim >= 2.0.0"
requires "gintro >= 0.10.0" # بدلاً من owlkettle
