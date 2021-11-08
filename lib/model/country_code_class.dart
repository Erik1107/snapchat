import 'package:flutter/cupertino.dart';

class CountryCode with ChangeNotifier {
  final String isoCode;
  final String name;
  final String numberCode;
  final String numberExample;

  CountryCode({
    required this.isoCode,
    required this.name,
    required this.numberCode,
    required this.numberExample,
  });

  factory CountryCode.fromJson(dynamic parsedJson) {
    return CountryCode(
        isoCode: parsedJson['iso2_cc'].toString(),
        name: parsedJson['name'].toString(),
        numberCode: parsedJson['e164_cc'].toString(),
        numberExample: parsedJson['example'].toString());
  }

  bool checkEquality(CountryCode lastCountry, CountryCode selectedCountry) {
    if (lastCountry.name != selectedCountry.name) {
      lastCountry = selectedCountry;
      notifyListeners();
      return true;
    }
    return false;
  }
}
