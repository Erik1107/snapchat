import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class AppLocalizationsJson {
  final Locale locale;

  AppLocalizationsJson(this.locale);

  static const LocalizationsDelegate<AppLocalizationsJson> delegate =
      _AppLocalizationsDelegate();
  static AppLocalizationsJson? of(BuildContext context) {
    return Localizations.of<AppLocalizationsJson>(
        context, AppLocalizationsJson);
  }

  Map<String, String> _localizedStrings = {};

  Future<bool> load() async {
    var jsonString =
        await rootBundle.loadString('assets/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    var translated = _localizedStrings[key].toString();
    return translated;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizationsJson> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizationsJson> load(Locale locale) async {
    var localizations = new AppLocalizationsJson(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
