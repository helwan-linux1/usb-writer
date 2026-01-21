import gintro/[gtk4, adw, gobject, gio]
import translations, tables, os, osproc, strutils

type
  AppWindow = ref object of AdwApplicationWindow
    isoLabel: Label
    logBuffer: TextBuffer
    currentLang: string
    btnIso, btnRefresh, btnWrite, btnChecksum: Button # لتسهيل تحديث النصوص

# دالة لجلب الترجمة بناءً على اللغة الحالية
proc t(window: AppWindow, key: string): string =
  let l = if window.currentLang == "ar": ar else: en
  result = LangData[l][key]

# دالة لتحديث نصوص الواجهة عند تغيير اللغة
proc updateUi(window: AppWindow) =
  window.set_title(window.t("title"))
  window.btnIso.set_label(window.t("btn_iso"))
  window.btnRefresh.set_label(window.t("btn_refresh"))
  window.btnWrite.set_label(window.t("btn_write"))
  window.btnChecksum.set_label(window.t("btn_checksum"))

proc activate(app: AdwApplication) =
  let window = newApplicationWindow(AppWindow, app)
  window.currentLang = "en"
  window.set_default_size(550, 500)
  
  let mainBox = newBox(Orientation.vertical, 12)
  mainBox.set_margin_all(12)

  # --- شريط تبديل اللغة ---
  let langBox = newBox(Orientation.horizontal, 6)
  let btnEn = newButton("English")
  let btnAr = newButton("العربية")
  langBox.append(btnEn)
  langBox.append(btnAr)
  mainBox.append(langBox)

  # --- مسار الـ ISO ---
  window.isoLabel = newLabel(window.t("status_ready"))
  window.isoLabel.set_margin_top(10)
  mainBox.append(window.isoLabel)

  window.btnIso = newButton(window.t("btn_iso"))
  window.btnIso.add_css_class("suggested-action")
  mainBox.append(window.btnIso)

  # --- أزرار العمليات ---
  let actionBox = newBox(Orientation.horizontal, 6)
  window.btnRefresh = newButton(window.t("btn_refresh"))
  window.btnChecksum = newButton(window.t("btn_checksum"))
  window.btnWrite = newButton(window.t("btn_write"))
  window.btnWrite.add_css_class("destructive-action")
  
  actionBox.append(window.btnRefresh)
  actionBox.append(window.btnChecksum)
  actionBox.append(window.btnWrite)
  mainBox.append(actionBox)

  # --- منطقة السجل (Log) ---
  let scroll = newScrolledWindow()
  let textView = newTextView()
  window.logBuffer = textView.get_buffer()
  textView.set_editable(false)
  scroll.set_child(textView)
  scroll.set_vexpand(true)
  mainBox.append(scroll)

  # --- وظائف الأزرار (Callbacks) ---

  btnEn.connect("clicked", proc() = 
    window.currentLang = "en"
    window.updateUi()
  )

  btnAr.connect("clicked", proc() = 
    window.currentLang = "ar"
    window.updateUi()
  )

  window.btnIso.connect("clicked", proc() =
    let dialog = newFileDialog()
    dialog.open(window, nil, proc (res: gio.AsyncResult) =
      let file = dialog.open_finish(res)
      if file != nil:
        window.isoLabel.set_text(file.get_path())
    )
  )

  window.btnRefresh.connect("clicked", proc() =
    let devices = execProcess("lsblk -o NAME,SIZE,MODEL -p -n -l")
    window.logBuffer.set_text("[🔍] Devices Found:\n" & devices)
  )

  window.btnChecksum.connect("clicked", proc() =
    let path = window.isoLabel.get_text()
    if fileExists(path):
      window.logBuffer.set_text("[Wait] Calculating SHA256...")
      let check = execProcess("sha256sum " & path)
      window.logBuffer.set_text(check)

  )

  window.set_content(mainBox)
  window.show()

proc main() =
  # معرف البرنامج لـ حلوان لينكس
  let app = newApplication("org.helwan.usbwriter", gio.ApplicationFlags.flags_none)
  app.connect("activate", activate)
  discard app.run()

main()
