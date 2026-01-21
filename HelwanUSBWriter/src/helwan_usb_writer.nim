import owlkettle, osproc, os, strutils, translations

# الحل الوحيد والمضمون هو تعريف الـ State بمتغيرات أساسية 
# الماكرو أحياناً بيفشل في قراءة الـ Enums الخارجية كـ Default values
viewable AppState:
  currentLang: Language
  isoPath: string
  logContent: string
  selectedDevice: string

proc t(state: AppState, key: string): string =
  result = LangData[state.currentLang][key]

method view(view: AppView): Widget =
  # استخدام s للوصول للـ state بشكل مباشر ومعرف للمترجم
  let s = view.state
  result = gui:
    Window:
      title = s.t("title")
      default_width = 500
      default_height = 450
      icon = "/usr/share/pixmaps/helwan-usb.png"

      Box(orient = OrientVertical, margin = 12, spacing = 8):
        Box(orient = OrientHorizontal, spacing = 5):
          Button(text = "English"):
            proc clicked() = 
              view.state.currentLang = en
              view.app.redraw()
          Button(text = "العربية"):
            proc clicked() = 
              view.state.currentLang = ar
              view.app.redraw()

        Label(text = s.isoPath)
        Button(text = s.t("btn_iso")):
          proc clicked() =
            let res = view.app.openFileDialog("Select ISO Image")
            if res.kind == DialogAccept:
              view.state.isoPath = res.file
              view.app.redraw()

        Box(orient = OrientHorizontal, spacing = 6):
          Button(text = s.t("btn_refresh")):
            proc clicked() = 
              view.state.logContent &= "\n[🔍] Scanning devices..."
              let devices = execProcess("lsblk -o NAME,SIZE,MODEL -p -n -l")
              view.state.logContent &= "\n" & devices
              view.app.redraw()

        Box(orient = OrientHorizontal, spacing = 6):
          Button(text = s.t("btn_checksum")):
            proc clicked() =
              if fileExists(s.isoPath):
                view.state.logContent &= "\n[Wait] Checking SHA256..."
                let check = execProcess("sha256sum " & s.isoPath)
                view.state.logContent &= "\n" & check
                view.app.redraw()
          
          Button(text = s.t("btn_write")):
            style = [ButtonStyleDestructive]
            proc clicked() = 
              if s.isoPath != "No ISO Selected":
                view.state.logContent &= "\n[🚀] Starting Burning Process..."
                let cmd = "pkexec dd if=" & s.isoPath & " of=/dev/sdX bs=4M status=progress conv=fsync"
                view.state.logContent &= "\nCommand: " & cmd
                view.app.redraw()

        ScrolledWindow:
          expand = true
          TextView:
            text = s.logContent
            editable = false

adorn_flow(AppView, AppState)

when isMainModule:
  # تهيئة الـ State بشكل يدوي عند التشغيل لضمان تعريف الحقول
  let initialState = AppState(
    currentLang: en,
    isoPath: "No ISO Selected",
    logContent: LangData[en]["status_ready"],
    selectedDevice: ""
  )
  owlkettle.brew(gui(AppView(state = initialState)))
