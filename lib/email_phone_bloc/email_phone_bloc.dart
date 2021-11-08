import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/check_internet.dart';
import 'package:snapchat/hhtp_service.dart';
import 'package:snapchat/remote_country_code_repository.dart';
import 'package:snapchat/validation_repository.dart';
import '../model/country_code_class.dart';
import 'email_phone_event.dart';
import 'email_phone_state.dart';

class EmailNumberBloc extends Bloc<EmailNumberEvent, EmailNumberState>
    with CheckInternet {
  EmailNumberBloc(this.validationRepository, this.remoteCountyCodeRepository)
      : super(InitialState());

  final ValidationRepository validationRepository;
  final RemoteCountyCodeRepository remoteCountyCodeRepository;

  CountryCode? _selectedCountryCode;
  CountryCode? get selectedCountryCode => _selectedCountryCode;
  List<CountryCode> _all = [];
  List<CountryCode> get all => _all;
  String _message = '';
  final HttpService httpService = HttpService();
  @override
  Stream<EmailNumberState> mapEventToState(EmailNumberEvent event) async* {
    if (event is EmailChange) {
      if (validationRepository.emailValidation(event.email)) {
        yield EmailValidState();
      } else {
        yield EmailInvalidState();
      }
    }
    if (event is EmailCheck) {
      if (await checkIntenet()) {
        _message = await httpService.makeEmailCheckPostRequest(event.email);

        if (_message == 'Done') {
          yield EmailCheckValidState();
        } else if (_message == 'This email address is already used.') {
          yield EmailCheckInvalidState(_message);
        }
      } else {
        yield NoInternetConnectionState();
      }
    }
    if (event is NumberChange) {
      var length = event.number.length;
      var phoneNumberLength = event.phoneNumberLength;
      if (validationRepository.phoneNumberValidation(
          length, phoneNumberLength)) {
        yield NumberValidState();
      } else {
        yield NumberInvalidState();
      }
    }
    if (event is NumberCheck) {
      if (await checkIntenet()) {
        _message = await httpService.makePhoneCheckPostRequest(event.number);
        if (_message == 'Done') yield NumberCheckValidState();
        if (_message == 'This phone is already used.') {
          yield NumberCheckInvalidState(_message);
        }
      } else {
        yield NoInternetConnectionState();
      }
    }
    if (event is PhoneNumberPageReload) {
      _all = await remoteCountyCodeRepository.loadCountries();

      _selectedCountryCode = await _searchLocaleCountryCode();
      yield PhoneNumberPageLoadedState();
    }
    if (event is SetCountryCode) {
      _selectedCountryCode = event.countryCode;
    }
    if (event is ProgressIndicatorShowEvent) {
      yield ProgressIndicatorValidState();
    }
  }

  Future<CountryCode?> _searchLocaleCountryCode() async {
    var localeIsoCode = await testAsLocale();
    return remoteCountyCodeRepository.searchLocaleCountry(localeIsoCode);
  }

  Future<String> testAsLocale() async {
    var currentLocale = '';
    try {
      currentLocale = (await Devicelocale.currentLocale)!;

      currentLocale = currentLocale.substring(currentLocale.indexOf('_') + 1);
    } on PlatformException {}

    return currentLocale;
  }
}
