import tables

type Language* = enum en, ar

const LangData* = {
  en: {
    "title": "Helwan USB Writer",
    "btn_iso": "Choose ISO File",
    "btn_refresh": "Refresh Devices",
    "btn_write": "Write ISO to USB",
    "btn_checksum": "Checksum ISO",
    "status_ready": "[✔] Ready to work",
    "confirm_msg": "Warning: All data on the USB will be lost! Proceed?"
  }.toTable,
  ar: {
    "title": "حارق اليو إس بي - حلوان",
    "btn_iso": "اختر ملف ISO",
    "btn_refresh": "تحديث الأجهزة",
    "btn_write": "بدء الحرق",
    "btn_checksum": "فحص الملف",
    "status_ready": "[✔] البرنامج جاهز للعمل",
    "confirm_msg": "تحذير: سيتم مسح جميع بيانات الفلاشة! هل تريد الاستمرار؟"
  }.toTable
}.toTable