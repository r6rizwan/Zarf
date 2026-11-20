import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

extension AppLocalizationsFormatting on AppLocalizations {
  String categoryName(String value) {
    switch (value.toLowerCase()) {
      case 'travel':
        return travel;
      case 'meals':
        return meals;
      case 'accommodation':
        return accommodation;
      case 'office supplies':
        return officeSupplies;
      case 'client entertainment':
        return clientEntertainment;
      case 'other':
        return other;
      default:
        return value;
    }
  }

  String paymentMethodName(String value) {
    switch (value.toLowerCase()) {
      case 'cash':
        return cash;
      case 'card':
        return card;
      case 'bank transfer':
        return bankTransfer;
      default:
        return value;
    }
  }

  String statusName(String value) {
    switch (value.toLowerCase()) {
      case 'approved':
        return approved;
      case 'rejected':
        return rejected;
      case 'pending':
        return pending;
      default:
        return value;
    }
  }

  String roleName(String value) {
    switch (value.toLowerCase()) {
      case 'admin':
        return roleAdmin;
      case 'manager':
        return roleManager;
      case 'employee':
        return roleEmployee;
      default:
        return value;
    }
  }

  String formatDate(DateTime value) =>
      DateFormat.yMMMd(localeName).format(value);
}
