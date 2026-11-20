import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @approvals.
  ///
  /// In en, this message translates to:
  /// **'Approvals'**
  String get approvals;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update available: v{version}'**
  String updateAvailable(String version);

  /// No description provided for @currentVersionUpdate.
  ///
  /// In en, this message translates to:
  /// **'You are on v{version}. Download the latest build from GitHub Releases.'**
  String currentVersionUpdate(String version);

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInToManageExpenses.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your expenses'**
  String get signInToManageExpenses;

  /// No description provided for @wakingServer.
  ///
  /// In en, this message translates to:
  /// **'Waking up server...'**
  String get wakingServer;

  /// No description provided for @serverSleepNotice.
  ///
  /// In en, this message translates to:
  /// **'The backend API is sleeping on Render\'s free tier. Spin-up may take up to 60 seconds.'**
  String get serverSleepNotice;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @failedToLoadData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data. Please check your connection.'**
  String get failedToLoadData;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String goodMorning(String name);

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @myExpensesThisMonth.
  ///
  /// In en, this message translates to:
  /// **'My Expenses This Month'**
  String get myExpensesThisMonth;

  /// No description provided for @totalCount.
  ///
  /// In en, this message translates to:
  /// **'Total count'**
  String get totalCount;

  /// No description provided for @tapToViewDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap to view details'**
  String get tapToViewDetails;

  /// No description provided for @pendingApprovals.
  ///
  /// In en, this message translates to:
  /// **'Pending Approvals'**
  String get pendingApprovals;

  /// No description provided for @awaitingReview.
  ///
  /// In en, this message translates to:
  /// **'Awaiting review'**
  String get awaitingReview;

  /// No description provided for @tapToReview.
  ///
  /// In en, this message translates to:
  /// **'Tap to review'**
  String get tapToReview;

  /// No description provided for @recentExpenses.
  ///
  /// In en, this message translates to:
  /// **'RECENT EXPENSES'**
  String get recentExpenses;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noRecentExpenses.
  ///
  /// In en, this message translates to:
  /// **'No recent expenses.'**
  String get noRecentExpenses;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @myExpenses.
  ///
  /// In en, this message translates to:
  /// **'My Expenses'**
  String get myExpenses;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by:'**
  String get sortBy;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @clearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get clearFilter;

  /// No description provided for @noExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get noExpensesYet;

  /// No description provided for @noExpensesMatchFilter.
  ///
  /// In en, this message translates to:
  /// **'No expenses match this filter'**
  String get noExpensesMatchFilter;

  /// No description provided for @failedToLoadExpenses.
  ///
  /// In en, this message translates to:
  /// **'Failed to load expenses. Please check your connection.'**
  String get failedToLoadExpenses;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get allCaughtUp;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @failedToLoadApprovals.
  ///
  /// In en, this message translates to:
  /// **'Failed to load pending approvals.'**
  String get failedToLoadApprovals;

  /// No description provided for @expenseDetail.
  ///
  /// In en, this message translates to:
  /// **'Expense Detail'**
  String get expenseDetail;

  /// No description provided for @failedToLoadExpense.
  ///
  /// In en, this message translates to:
  /// **'Failed to load expense. Please try again.'**
  String get failedToLoadExpense;

  /// No description provided for @failedToLoadExpenseDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load expense details.'**
  String get failedToLoadExpenseDetails;

  /// No description provided for @expenseApprovedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Expense approved successfully.'**
  String get expenseApprovedSuccessfully;

  /// No description provided for @expenseRejectedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Expense rejected successfully.'**
  String get expenseRejectedSuccessfully;

  /// No description provided for @failedToUpdateStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update status.'**
  String get failedToUpdateStatus;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @baseAmount.
  ///
  /// In en, this message translates to:
  /// **'Base Amount'**
  String get baseAmount;

  /// No description provided for @vatAmount.
  ///
  /// In en, this message translates to:
  /// **'VAT Amount'**
  String get vatAmount;

  /// No description provided for @vatIncluded.
  ///
  /// In en, this message translates to:
  /// **'VAT Included: {amount}'**
  String vatIncluded(String amount);

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'NOTES'**
  String get notes;

  /// No description provided for @notesField.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesField;

  /// No description provided for @viewReceipt.
  ///
  /// In en, this message translates to:
  /// **'View Receipt'**
  String get viewReceipt;

  /// No description provided for @addCommentOptional.
  ///
  /// In en, this message translates to:
  /// **'Add a comment (optional)'**
  String get addCommentOptional;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @scanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan Receipt'**
  String get scanReceipt;

  /// No description provided for @currencyAutoFilled.
  ///
  /// In en, this message translates to:
  /// **'Currency auto-filled'**
  String get currencyAutoFilled;

  /// No description provided for @dateAutoFilled.
  ///
  /// In en, this message translates to:
  /// **'Date auto-filled'**
  String get dateAutoFilled;

  /// No description provided for @merchantAutoFilled.
  ///
  /// In en, this message translates to:
  /// **'Merchant auto-filled'**
  String get merchantAutoFilled;

  /// No description provided for @vendorTrnAutoFilled.
  ///
  /// In en, this message translates to:
  /// **'Vendor TRN auto-filled'**
  String get vendorTrnAutoFilled;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'DETAILS'**
  String get details;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @vendorTrnOptional.
  ///
  /// In en, this message translates to:
  /// **'Vendor TRN (Optional)'**
  String get vendorTrnOptional;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT'**
  String get payment;

  /// No description provided for @vatRate.
  ///
  /// In en, this message translates to:
  /// **'VAT ({rate}%)'**
  String vatRate(String rate);

  /// No description provided for @vatValue.
  ///
  /// In en, this message translates to:
  /// **'VAT: {amount}'**
  String vatValue(String amount);

  /// No description provided for @submitExpense.
  ///
  /// In en, this message translates to:
  /// **'Submit Expense'**
  String get submitExpense;

  /// No description provided for @failedToSaveExpense.
  ///
  /// In en, this message translates to:
  /// **'Failed to save expense.'**
  String get failedToSaveExpense;

  /// No description provided for @failedToFetchVat.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch VAT info.'**
  String get failedToFetchVat;

  /// No description provided for @scanReceiptTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Receipt'**
  String get scanReceiptTitle;

  /// No description provided for @aiReceiptScanner.
  ///
  /// In en, this message translates to:
  /// **'AI Receipt Scanner'**
  String get aiReceiptScanner;

  /// No description provided for @receiptScannerDescription.
  ///
  /// In en, this message translates to:
  /// **'Snap a photo of your receipt or upload an image from your gallery to auto-fill expense details instantly.'**
  String get receiptScannerDescription;

  /// No description provided for @couldNotParseReceipt.
  ///
  /// In en, this message translates to:
  /// **'Could not parse receipt. Try a clearer photo or a different image.'**
  String get couldNotParseReceipt;

  /// No description provided for @retryScan.
  ///
  /// In en, this message translates to:
  /// **'Retry Scan'**
  String get retryScan;

  /// No description provided for @aiParsingReceipt.
  ///
  /// In en, this message translates to:
  /// **'AI is parsing your receipt...'**
  String get aiParsingReceipt;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takePhoto;

  /// No description provided for @uploadFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Upload from Gallery'**
  String get uploadFromGallery;

  /// No description provided for @skipEnterManually.
  ///
  /// In en, this message translates to:
  /// **'Skip & Enter Manually'**
  String get skipEnterManually;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @failedToSaveLanguage.
  ///
  /// In en, this message translates to:
  /// **'Could not save your language preference.'**
  String get failedToSaveLanguage;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get roleManager;

  /// No description provided for @roleEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get roleEmployee;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get meals;

  /// No description provided for @accommodation.
  ///
  /// In en, this message translates to:
  /// **'Accommodation'**
  String get accommodation;

  /// No description provided for @officeSupplies.
  ///
  /// In en, this message translates to:
  /// **'Office Supplies'**
  String get officeSupplies;

  /// No description provided for @clientEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Client Entertainment'**
  String get clientEntertainment;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bankTransfer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
