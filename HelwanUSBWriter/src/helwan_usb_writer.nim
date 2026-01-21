import owlkettle, osproc, os, strutils, translations, tables

# نقل التعريف هنا عشان الماكرو يشوفه وما يطلعش undeclared field
type LocalLanguage = enum en, ar

viewable AppState:
  currentLang: LocalLanguage = en
  isoPath: string = "No ISO Selected"
  logContent: string = ""
  selectedDevice: string = ""

proc t(state: AppState, key: string): string =
  # تحويل النوع المحلي لنوع ملف الترجمة عشان الجدول يفتح
  let lang = case state.currentLang:
    of en: translations.en
    of ar: translations.ar
  result = translations.LangData[lang][key] [cite: 1, 2, 3]

method view(view: AppView): Widget =
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
  owlkettle.brew(gui(AppView(state = AppState(
    currentLang: en,
    isoPath: "No ISO Selected",
    logContent: translations.LangData[translations.en]["status_ready"] [cite: 1]
  ))))
