import 'package:flutter/cupertino.dart';
import 'package:snapchat/model/country_code_class.dart';

class CountryNotifier with ChangeNotifier {
  CountryCode? _countryCode;

  CountryCode? get countryCode => _countryCode;

  void setCountry(CountryCode countryCodeSelected) {
    _countryCode = countryCodeSelected;
    notifyListeners();
  }

  CountryNotifier(this._countryCode);
}
