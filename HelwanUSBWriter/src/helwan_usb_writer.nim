import gintro/[gtk4, adw, gobject, gio]
import translations, tables, os, osproc

# هيكل البرنامج (Class-like structure)
type
  AppWindow = ref object of AdwApplicationWindow
    isoLabel: Label
    logBuffer: TextBuffer
    currentLang: string

proc t(lang: string, key: string): string =
  let l = if lang == "ar": ar else: en
  result = LangData[l][key]

proc updateUi(window: AppWindow) =
  # تحديث النصوص عند تغيير اللغة (يدوياً وبدون سحر)
  window.setProperty("title", window.currentLang.t("title"))
  # هنا يمكن إضافة تحديث بقية الأزرار لو لزم الأمر

proc activate(app: AdwApplication) =
  let window = newApplicationWindow(AppWindow, app)
  window.currentLang = "en"
  window.set_default_size(500, 450)
  
  let mainBox = newBox(Orientation.vertical, 12)
  mainBox.set_margin_all(12)

  # أزرار اللغة
  let langBox = newBox(Orientation.horizontal, 5)
  let btnEn = newButton("English")
  let btnAr = newButton("العربية")
  
  langBox.append(btnEn)
  langBox.append(btnAr)
  mainBox.append(langBox)

  # مسار الـ ISO
  window.isoLabel = newLabel("No ISO Selected")
  mainBox.append(window.isoLabel)

  let btnIso = newButton(window.currentLang.t("btn_iso"))
  mainBox.append(btnIso)

  # منطقة السجل (Log)
  let scroll = newScrolledWindow()
  let textView = newTextView()
  window.logBuffer = textView.get_buffer()
  textView.set_editable(false)
  scroll.set_child(textView)
  scroll.set_vexpand(true)
  mainBox.append(scroll)

  # العمليات (Actions)
  btnEn.connect("clicked", proc() = 
    window.currentLang = "en"
    window.updateUi()
  )

  btnAr.connect("clicked", proc() = 
    window.currentLang = "ar"
    window.updateUi()
  )

  btnIso.connect("clicked", proc() =
    let dialog = newFileDialog()
    dialog.open(window, nil, proc (res: gio.AsyncResult) =
      let file = dialog.open_finish(res)
      if file != nil:
        window.isoLabel.set_text(file.get_path())
    )
  )

  window.set_content(mainBox)
  window.show()

proc main() =
  let app = newApplication("org.helwan.usbwriter", gio.ApplicationFlags.flags_none)
  app.connect("activate", activate)
  discard app.run()

main()
