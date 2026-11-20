// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get home => 'الرئيسية';

  @override
  String get approvals => 'الموافقات';

  @override
  String get expenses => 'المصروفات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String updateAvailable(String version) {
    return 'يتوفر تحديث: الإصدار $version';
  }

  @override
  String currentVersionUpdate(String version) {
    return 'إصدارك الحالي هو $version. نزّل أحدث إصدار من GitHub Releases.';
  }

  @override
  String get update => 'تحديث';

  @override
  String get dismiss => 'إغلاق';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get signInToManageExpenses => 'سجّل الدخول لإدارة مصروفاتك';

  @override
  String get wakingServer => 'جارٍ تشغيل الخادم...';

  @override
  String get serverSleepNotice =>
      'واجهة الخادم في وضع السكون ضمن الخطة المجانية من Render. قد يستغرق التشغيل حتى 60 ثانية.';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get loginFailed => 'تعذّر تسجيل الدخول';

  @override
  String get failedToLoadData =>
      'تعذّر تحميل البيانات. يُرجى التحقق من الاتصال.';

  @override
  String goodMorning(String name) {
    return 'صباح الخير، $name';
  }

  @override
  String get user => 'مستخدم';

  @override
  String get myExpensesThisMonth => 'مصروفاتي هذا الشهر';

  @override
  String get totalCount => 'الإجمالي';

  @override
  String get tapToViewDetails => 'اضغط لعرض التفاصيل';

  @override
  String get pendingApprovals => 'موافقات معلّقة';

  @override
  String get awaitingReview => 'بانتظار المراجعة';

  @override
  String get tapToReview => 'اضغط للمراجعة';

  @override
  String get recentExpenses => 'أحدث المصروفات';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get noRecentExpenses => 'لا توجد مصروفات حديثة.';

  @override
  String get approved => 'تمت الموافقة';

  @override
  String get rejected => 'مرفوض';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get myExpenses => 'مصروفاتي';

  @override
  String get all => 'الكل';

  @override
  String get sortBy => 'ترتيب حسب:';

  @override
  String get date => 'التاريخ';

  @override
  String get amount => 'المبلغ';

  @override
  String get status => 'الحالة';

  @override
  String get category => 'الفئة';

  @override
  String get clearFilter => 'مسح التصفية';

  @override
  String get noExpensesYet => 'لا توجد مصروفات بعد';

  @override
  String get noExpensesMatchFilter => 'لا توجد مصروفات تطابق هذه التصفية';

  @override
  String get failedToLoadExpenses =>
      'تعذّر تحميل المصروفات. يُرجى التحقق من الاتصال.';

  @override
  String get allCaughtUp => 'أنت على اطلاع بكل شيء!';

  @override
  String get refresh => 'تحديث';

  @override
  String get employee => 'موظف';

  @override
  String get review => 'مراجعة';

  @override
  String get failedToLoadApprovals => 'تعذّر تحميل الموافقات المعلّقة.';

  @override
  String get expenseDetail => 'تفاصيل المصروف';

  @override
  String get failedToLoadExpense =>
      'تعذّر تحميل المصروف. يُرجى المحاولة مجددًا.';

  @override
  String get failedToLoadExpenseDetails => 'تعذّر تحميل تفاصيل المصروف.';

  @override
  String get expenseApprovedSuccessfully => 'تمت الموافقة على المصروف بنجاح.';

  @override
  String get expenseRejectedSuccessfully => 'تم رفض المصروف بنجاح.';

  @override
  String get failedToUpdateStatus => 'تعذّر تحديث الحالة.';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get baseAmount => 'المبلغ الأساسي';

  @override
  String get vatAmount => 'مبلغ ضريبة القيمة المضافة';

  @override
  String vatIncluded(String amount) {
    return 'ضريبة القيمة المضافة مشمولة: $amount';
  }

  @override
  String get notes => 'ملاحظات';

  @override
  String get notesField => 'ملاحظات';

  @override
  String get viewReceipt => 'عرض الإيصال';

  @override
  String get addCommentOptional => 'أضف تعليقًا (اختياري)';

  @override
  String get reject => 'رفض';

  @override
  String get approve => 'موافقة';

  @override
  String get addExpense => 'إضافة مصروف';

  @override
  String get scanReceipt => 'مسح الإيصال';

  @override
  String get currencyAutoFilled => 'تم ملء العملة تلقائيًا';

  @override
  String get dateAutoFilled => 'تم ملء التاريخ تلقائيًا';

  @override
  String get merchantAutoFilled => 'تم ملء اسم التاجر تلقائيًا';

  @override
  String get vendorTrnAutoFilled => 'تم ملء الرقم الضريبي للبائع تلقائيًا';

  @override
  String get details => 'التفاصيل';

  @override
  String get currency => 'العملة';

  @override
  String get vendorTrnOptional => 'الرقم الضريبي للبائع (اختياري)';

  @override
  String get payment => 'الدفع';

  @override
  String vatRate(String rate) {
    return 'ضريبة القيمة المضافة ($rate٪)';
  }

  @override
  String vatValue(String amount) {
    return 'الضريبة: $amount';
  }

  @override
  String get submitExpense => 'إرسال المصروف';

  @override
  String get failedToSaveExpense => 'تعذّر حفظ المصروف.';

  @override
  String get failedToFetchVat => 'تعذّر جلب معلومات ضريبة القيمة المضافة.';

  @override
  String get scanReceiptTitle => 'مسح الإيصال';

  @override
  String get aiReceiptScanner => 'ماسح الإيصالات بالذكاء الاصطناعي';

  @override
  String get receiptScannerDescription =>
      'التقط صورة للإيصال أو حمّل صورة من معرضك لملء تفاصيل المصروف تلقائيًا.';

  @override
  String get couldNotParseReceipt =>
      'تعذّر تحليل الإيصال. جرّب صورة أوضح أو صورة أخرى.';

  @override
  String get retryScan => 'إعادة المسح';

  @override
  String get aiParsingReceipt => 'يجري الذكاء الاصطناعي تحليل الإيصال...';

  @override
  String get takePhoto => 'التقط صورة';

  @override
  String get uploadFromGallery => 'تحميل من المعرض';

  @override
  String get skipEnterManually => 'تخطٍّ وأدخل البيانات يدويًا';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get failedToSaveLanguage => 'تعذّر حفظ إعداد اللغة.';

  @override
  String get roleAdmin => 'مسؤول';

  @override
  String get roleManager => 'مدير';

  @override
  String get roleEmployee => 'موظف';

  @override
  String get travel => 'السفر';

  @override
  String get meals => 'الوجبات';

  @override
  String get accommodation => 'الإقامة';

  @override
  String get officeSupplies => 'مستلزمات المكتب';

  @override
  String get clientEntertainment => 'ضيافة العملاء';

  @override
  String get other => 'أخرى';

  @override
  String get cash => 'نقدًا';

  @override
  String get card => 'بطاقة';

  @override
  String get bankTransfer => 'تحويل بنكي';
}
