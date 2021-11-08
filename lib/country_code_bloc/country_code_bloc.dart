import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/country_code_bloc/country_code_event.dart';
import 'package:snapchat/model/country_code_class.dart';
import 'package:snapchat/remote_country_code_repository.dart';
import 'country_code_state.dart';

class CountryCodeBloc extends Bloc<CountryCodeEvent, CountryCodeState> {
  CountryCodeBloc(this.remoteCountyCodeRepository) : super(InitialState());

  RemoteCountyCodeRepository remoteCountyCodeRepository;

  List<CountryCode> get countries => _countries;
  List<CountryCode> _countries = [];

  @override
  Stream<CountryCodeState> mapEventToState(CountryCodeEvent event) async* {
    if (event is CountryCodePageReloadFinish) {
      _countries = await remoteCountyCodeRepository.searchCountry('');
      yield CountryCodePageLoaded();
    }

    if (event is CountryCodeChanged) {
      _countries =
          await remoteCountyCodeRepository.searchCountry(event.countryCode);

      yield CountryCodeSpecificState();
    }
  }
}

  /* Future<List<CountryCode>> _loadCountries() async {
    var json = await rootBundle.loadString('assets/country-codes.json');

    var jsonDecoded = jsonDecode(json.toString());
    return (jsonDecoded as List)
        .map((data) => new CountryCode.fromJson(data))
        .toList();
  } */

  /* Future<String> testAsLocale() async {
    String currentLocale = '';
    try {
      currentLocale = (await Devicelocale.currentLocale)!;
      print(currentLocale.substring(currentLocale.indexOf('_') + 1));
    } on PlatformException {
      print("Error obtaining current locale");
    }
    return currentLocale;
  } */

