import 'dart:async';

import 'package:path/path.dart';
import 'package:snapchat/hhtp_service.dart';
import 'package:sqflite/sqflite.dart';

import '../model/country_code_class.dart';

class RemoteCountyCodeRepository {
  HttpService httpService = HttpService();
  List<CountryCode> list = [];
  var databasesPath;
  var countriesDatabase;
  String path = '';
  Future _getDb() async {
    databasesPath = await getDatabasesPath();

    path = join(databasesPath, 'country.db');
    countriesDatabase =
        await openDatabase(path, version: 1, onCreate: _loadCountriesFromJson);
  }

  Future<List<CountryCode>> loadCountries() async {
    await _getDb();

    final List<Map<String, dynamic>> maps =
        await countriesDatabase.query('Country');
    return List.generate(maps.length, (i) {
      return CountryCode(
          isoCode: maps[i]['isoCode'],
          name: maps[i]['name'],
          numberCode: maps[i]['numberCode'],
          numberExample: maps[i]['numberExample']);
    });
  }

  Future<List<CountryCode>> searchCountry(String name) async {
    await _getDb();
    final List<Map<String, dynamic>> res = await countriesDatabase
        .query('Country', where: 'name LIKE ?', whereArgs: ['$name%']);
    return List.generate(res.length, (i) {
      return CountryCode(
          isoCode: res[i]['isoCode'],
          name: res[i]['name'],
          numberCode: res[i]['numberCode'],
          numberExample: res[i]['numberExample']);
    });
  }

  Future<CountryCode> searchLocaleCountry(String isoCode) async {
    await _getDb();

    final List<Map<String, dynamic>> res = await countriesDatabase
        .query('Country', where: 'isoCode LIKE ?', whereArgs: ['$isoCode']);

    return CountryCode(
        isoCode: res[0]['isoCode'],
        name: res[0]['name'],
        numberCode: res[0]['numberCode'],
        numberExample: res[0]['numberExample']);
  }

  FutureOr<void> _loadCountriesFromJson(Database db, int i) async {
    db.execute(
        'CREATE TABLE Country(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , name TEXT, isoCode TEXT, numberCode TEXT,numberExample TEXT )');
    //PETQAKAN KOD

    /* final response = await http.get(Uri.parse(
        'https://drive.google.com/uc?id=1SuvADk8EeyXU0vjQ159W9Kuxw4Mi_dGA&exprt=download'));
    if (response.statusCode == 200) {
      var jsonDecoded = json.decode(response.body);
      list = (jsonDecoded as List)
          .map((data) => new CountryCode.fromJson(data))
          .toList(); */
    list = await httpService.makeGetCountriesRequest();
    list.forEach((element) {
      var batch = db.batch();
      // ignore: cascade_invocations
      batch.insert('Country', {
        'name': element.name,
        'isoCode': element.isoCode,
        'numberCode': element.numberCode,
        'numberExample':
            element.numberExample != '' ? element.numberExample : '123456789'
      });
      // ignore: cascade_invocations
      batch.commit();
    });
  }
} 

//PETQAKAN KOD
/* Future<List<CountryCode>> _loadCountries() async {
    var json = await rootBundle.loadString('assets/country-codes.json');

    var jsonDecoded = jsonDecode(json.toString());
    return (jsonDecoded as List)
        .map((data) => new CountryCode.fromJson(data))
      
      .toList();
  }*/