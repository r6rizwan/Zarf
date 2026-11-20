import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocaleController extends ChangeNotifier {
  static final instance = LocaleController();

  LocaleController({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _localeKey = 'app_locale';
  final FlutterSecureStorage _storage;
  String _languageCode = 'en';

  String get languageCode => _languageCode;

  Future<void> load() async {
    final savedLocale = await _storage.read(key: _localeKey);
    if (savedLocale == 'ar' || savedLocale == 'en') {
      _languageCode = savedLocale!;
    }
  }

  Future<void> setLanguageCode(String languageCode) async {
    if (languageCode != 'ar' && languageCode != 'en') {
      throw ArgumentError.value(languageCode, 'languageCode');
    }
    if (_languageCode == languageCode) return;
    await _storage.write(key: _localeKey, value: languageCode);
    _languageCode = languageCode;
    notifyListeners();
  }
}
