// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get home => 'Home';

  @override
  String get approvals => 'Approvals';

  @override
  String get expenses => 'Expenses';

  @override
  String get profile => 'Profile';

  @override
  String updateAvailable(String version) {
    return 'Update available: v$version';
  }

  @override
  String currentVersionUpdate(String version) {
    return 'You are on v$version. Download the latest build from GitHub Releases.';
  }

  @override
  String get update => 'Update';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signInToManageExpenses => 'Sign in to manage your expenses';

  @override
  String get wakingServer => 'Waking up server...';

  @override
  String get serverSleepNotice =>
      'The backend API is sleeping on Render\'s free tier. Spin-up may take up to 60 seconds.';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get failedToLoadData =>
      'Failed to load data. Please check your connection.';

  @override
  String goodMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String get user => 'User';

  @override
  String get myExpensesThisMonth => 'My Expenses This Month';

  @override
  String get totalCount => 'Total count';

  @override
  String get tapToViewDetails => 'Tap to view details';

  @override
  String get pendingApprovals => 'Pending Approvals';

  @override
  String get awaitingReview => 'Awaiting review';

  @override
  String get tapToReview => 'Tap to review';

  @override
  String get recentExpenses => 'RECENT EXPENSES';

  @override
  String get viewAll => 'View All';

  @override
  String get noRecentExpenses => 'No recent expenses.';

  @override
  String get approved => 'Approved';

  @override
  String get rejected => 'Rejected';

  @override
  String get pending => 'Pending';

  @override
  String get myExpenses => 'My Expenses';

  @override
  String get all => 'All';

  @override
  String get sortBy => 'Sort by:';

  @override
  String get date => 'Date';

  @override
  String get amount => 'Amount';

  @override
  String get status => 'Status';

  @override
  String get category => 'Category';

  @override
  String get clearFilter => 'Clear filter';

  @override
  String get noExpensesYet => 'No expenses yet';

  @override
  String get noExpensesMatchFilter => 'No expenses match this filter';

  @override
  String get failedToLoadExpenses =>
      'Failed to load expenses. Please check your connection.';

  @override
  String get allCaughtUp => 'All caught up!';

  @override
  String get refresh => 'Refresh';

  @override
  String get employee => 'Employee';

  @override
  String get review => 'Review';

  @override
  String get failedToLoadApprovals => 'Failed to load pending approvals.';

  @override
  String get expenseDetail => 'Expense Detail';

  @override
  String get failedToLoadExpense => 'Failed to load expense. Please try again.';

  @override
  String get failedToLoadExpenseDetails => 'Failed to load expense details.';

  @override
  String get expenseApprovedSuccessfully => 'Expense approved successfully.';

  @override
  String get expenseRejectedSuccessfully => 'Expense rejected successfully.';

  @override
  String get failedToUpdateStatus => 'Failed to update status.';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get notAvailable => 'N/A';

  @override
  String get baseAmount => 'Base Amount';

  @override
  String get vatAmount => 'VAT Amount';

  @override
  String vatIncluded(String amount) {
    return 'VAT Included: $amount';
  }

  @override
  String get notes => 'NOTES';

  @override
  String get notesField => 'Notes';

  @override
  String get viewReceipt => 'View Receipt';

  @override
  String get addCommentOptional => 'Add a comment (optional)';

  @override
  String get reject => 'Reject';

  @override
  String get approve => 'Approve';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get scanReceipt => 'Scan Receipt';

  @override
  String get currencyAutoFilled => 'Currency auto-filled';

  @override
  String get dateAutoFilled => 'Date auto-filled';

  @override
  String get merchantAutoFilled => 'Merchant auto-filled';

  @override
  String get vendorTrnAutoFilled => 'Vendor TRN auto-filled';

  @override
  String get details => 'DETAILS';

  @override
  String get currency => 'Currency';

  @override
  String get vendorTrnOptional => 'Vendor TRN (Optional)';

  @override
  String get payment => 'PAYMENT';

  @override
  String vatRate(String rate) {
    return 'VAT ($rate%)';
  }

  @override
  String vatValue(String amount) {
    return 'VAT: $amount';
  }

  @override
  String get submitExpense => 'Submit Expense';

  @override
  String get failedToSaveExpense => 'Failed to save expense.';

  @override
  String get failedToFetchVat => 'Failed to fetch VAT info.';

  @override
  String get scanReceiptTitle => 'Scan Receipt';

  @override
  String get aiReceiptScanner => 'AI Receipt Scanner';

  @override
  String get receiptScannerDescription =>
      'Snap a photo of your receipt or upload an image from your gallery to auto-fill expense details instantly.';

  @override
  String get couldNotParseReceipt =>
      'Could not parse receipt. Try a clearer photo or a different image.';

  @override
  String get retryScan => 'Retry Scan';

  @override
  String get aiParsingReceipt => 'AI is parsing your receipt...';

  @override
  String get takePhoto => 'Take a Photo';

  @override
  String get uploadFromGallery => 'Upload from Gallery';

  @override
  String get skipEnterManually => 'Skip & Enter Manually';

  @override
  String get logout => 'Logout';

  @override
  String get failedToSaveLanguage => 'Could not save your language preference.';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleManager => 'Manager';

  @override
  String get roleEmployee => 'Employee';

  @override
  String get travel => 'Travel';

  @override
  String get meals => 'Meals';

  @override
  String get accommodation => 'Accommodation';

  @override
  String get officeSupplies => 'Office Supplies';

  @override
  String get clientEntertainment => 'Client Entertainment';

  @override
  String get other => 'Other';

  @override
  String get cash => 'Cash';

  @override
  String get card => 'Card';

  @override
  String get bankTransfer => 'Bank Transfer';
}
