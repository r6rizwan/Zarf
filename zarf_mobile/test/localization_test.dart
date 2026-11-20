import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zarf_mobile/l10n/app_localizations.dart';

void main() {
  testWidgets('Arabic translations apply RTL text direction', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) => Text(
            AppLocalizations.of(context)!.home,
            key: const ValueKey('localized-home'),
          ),
        ),
      ),
    );

    expect(find.text('الرئيسية'), findsOneWidget);
    expect(
      Directionality.of(
          tester.element(find.byKey(const ValueKey('localized-home')))),
      TextDirection.rtl,
    );
  });

  testWidgets('English remains the default language', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context)!.home),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(Directionality.of(tester.element(find.text('Home'))),
        TextDirection.ltr);
  });
}
