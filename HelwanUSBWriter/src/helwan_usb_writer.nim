import owlkettle, osproc, os, strutils, translations

# الحل هو التأكد من أن AppState يرى الـ Enum بشكل كامل
viewable AppState:
  currentLang: translations.Language = translations.en # تحديد المسار الكامل للـ Enum
  isoPath: string = "No ISO Selected"
  logContent: string = ""
  selectedDevice: string = ""

proc t(state: AppState, key: string): string =
  result = LangData[state.currentLang][key]

method view(view: AppView): Widget =
  result = gui:
    Window:
      title = view.state.t("title")
      default_width = 500
      default_height = 450
      icon = "/usr/share/pixmaps/helwan-usb.png"

      Box(orient = OrientVertical, margin = 12, spacing = 8):
        Box(orient = OrientHorizontal, spacing = 5):
          Button(text = "English"):
            proc clicked() = 
              view.state.currentLang = translations.en
              view.app.redraw() # تحديث الواجهة عشان الترجمة تسمع
          Button(text = "العربية"):
            proc clicked() = 
              view.state.currentLang = translations.ar
              view.app.redraw()

        Label(text = view.state.isoPath)
        Button(text = view.state.t("btn_iso")):
          proc clicked() =
            let res = view.app.openFileDialog("Select ISO Image")
            if res.kind == DialogAccept:
              view.state.isoPath = res.file
              view.app.redraw()

        Box(orient = OrientHorizontal, spacing = 6):
          Button(text = view.state.t("btn_refresh")):
            proc clicked() = 
              view.state.logContent &= "\n[🔍] Scanning devices..."
              let devices = execProcess("lsblk -o NAME,SIZE,MODEL -p -n -l")
              view.state.logContent &= "\n" & devices
              view.app.redraw()

        Box(orient = OrientHorizontal, spacing = 6):
          Button(text = view.state.t("btn_checksum")):
            proc clicked() =
              if fileExists(view.state.isoPath):
                view.state.logContent &= "\n[Wait] Checking SHA256..."
                let check = execProcess("sha256sum " & view.state.isoPath)
                view.state.logContent &= "\n" & check
                view.app.redraw()
          
          Button(text = view.state.t("btn_write")):
            style = [ButtonStyleDestructive]
            proc clicked() = 
              if view.state.isoPath != "No ISO Selected":
                view.state.logContent &= "\n[🚀] Starting Burning Process..."
                # هنا مفروض نستخدم متغير الـ Device المختار بدل sdX
                let cmd = "pkexec dd if=" & view.state.isoPath & " of=/dev/sdX bs=4M status=progress conv=fsync"
                view.state.logContent &= "\nCommand: " & cmd
                view.app.redraw()

        ScrolledWindow:
          expand = true
          TextView:
            text = view.state.logContent
            editable = false

adorn_flow(AppView, AppState)

when isMainModule:
  owlkettle.brew(gui(AppView(state = AppState(logContent = LangData[en]["status_ready"]))))
