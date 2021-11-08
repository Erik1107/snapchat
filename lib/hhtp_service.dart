import 'dart:convert';
import 'package:http/http.dart';
import 'package:snapchat/model/country_code_class.dart';
import 'model/user_class.dart';

class HttpService {
  List<CountryCode> countryObjects = [];
  var uri = 'https://parentstree-server.herokuapp.com';
  Future<void> makeGetRequest() async {
    final url = Uri.parse('$uri/checkConnection');
    // ignore: unused_local_variable
    var response = await get(url);
  }

  Future<String> makeNameCheckPostRequest(String name) async {
    final url = Uri.parse('$uri/check/name');
    final headers = {'content-type': 'application/json'};
    final response = await post(
      url,
      headers: headers,
      body: jsonEncode(<String, String>{
        'name': '$name',
      }),
    );
    Map jsonDecoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      String message = jsonDecoded['info'];
      return message;
    } else {
      var message = jsonDecoded['error'].toString();
      return message;
    }
  }

  Future<String> makeEmailCheckPostRequest(String email) async {
    final url = Uri.parse('$uri/check/email');
    final headers = {'content-type': 'application/json'};

    final response = await post(
      url,
      headers: headers,
      body: jsonEncode(<String, String>{
        'email': '$email',
      }),
    );
    Map jsonDecoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      String message = jsonDecoded['info'];
      return message;
    } else {
      var message = jsonDecoded['error'].toString();
      return message;
    }
  }

  Future<String> makePhoneCheckPostRequest(String phone) async {
    final url = Uri.parse('$uri/check/phone');
    final headers = {'content-type': 'application/json'};
    final response = await post(
      url,
      headers: headers,
      body: jsonEncode(<String, String>{
        'phone': '$phone',
      }),
    );
    Map jsonDecoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      String message = jsonDecoded['info'];

      return message;
    } else {
      var message = jsonDecoded['error'].toString();

      return message;
    }
  }

  Future<Object> makeUserPostRequest(
      String? firstName,
      String? lastName,
      String? password,
      String? email,
      String? phone,
      String? name,
      String? birthDate,
      String? country) async {
    final url = Uri.parse('$uri/addUser');
    final headers = {'content-type': 'application/json'};
    final response = await post(
      url,
      headers: headers,
      body: jsonEncode(<String, String>{
        'country': '$country',
        'firstName': '$firstName',
        'lastName': '$lastName',
        'email': '$email',
        'birthDate': '$birthDate',
        'name': '$name',
        'password': '$password',
        'phone': '$phone',
      }),
    );

    Map jsonDecoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // print(response.body);
      Map user = jsonDecoded['user'];

      return (User(
          createdTokenForUser: jsonDecoded['createdTokenForUser'],
          country: user['country'].toString(),
          firstName: user['firstName'].toString(),
          lastName: user['lastName'].toString(),
          password: user['password'].toString(),
          name: user['name'].toString(),
          email: user['email'].toString(),
          phone: user['phone'].toString(),
          birthDate: user['birthDate'].toString()));
    } else {
      String message = jsonDecoded['error'];

      return message;
    }
  }

  Future<Object> makeSignInPostRequest(String login, String password) async {
    final url = Uri.parse('$uri/signIn');
    final headers = {'content-type': 'application/json'};
    final response = await post(
      url,
      headers: headers,
      body: jsonEncode(
          <String, String>{'login': '$login', 'password': '$password'}),
    );
    Map jsonDecoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      //print(response.body);
      Map user = jsonDecoded['user'];
      return (User(
          createdTokenForUser: jsonDecoded['createdTokenForUser'].toString(),
          country: user['country'].toString(),
          firstName: user['firstName'].toString(),
          lastName: user['lastName'].toString(),
          password: user['password'].toString(),
          name: user['name'].toString(),
          email: user['email'].toString(),
          phone: user['phone'].toString(),
          birthDate: user['birthDate'].toString()));
    } else {
      String message = jsonDecoded['error'];
      return message;
    }
  }

  Future<List<CountryCode>> makeGetCountriesRequest() async {
    final url = Uri.parse('$uri/countries');
    var response = await get(url);
    if (response.statusCode == 200) {
      var countriesJson = jsonDecode(response.body)['countries'] as List;
      countryObjects = countriesJson
          .map((countryJson) => CountryCode.fromJson(countryJson))
          .toList();
    }
    return countryObjects;
  }

  Future<Object> getMe(Object? token) async {
    final url = Uri.parse('$uri/me/');
    final response = await get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'token': '$token',
    });

    Map jsonDecoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Map? userMap = jsonDecoded['user'];
      if (userMap != null) {
        return User(
            country: userMap['country'],
            firstName: userMap['firstName'],
            lastName: userMap['lastName'],
            password: userMap['password'],
            name: userMap['name'],
            email: userMap['email'],
            phone: userMap['phone'],
            birthDate: userMap['birthDate']);
      } else {
        return 'User has been deleted';
      }
    } else {
      String message = jsonDecoded['error'];
      return message;
    }
  }

  Future<String?> deleteUser(Object token) async {
    final url = Uri.parse('$uri/delete/user');

    final response = await delete(url, headers: {
      'token': '$token',
    });

    if (response.statusCode != 200) {
      Map jsonDecoded = jsonDecode(response.body.toString());
      String message = jsonDecoded['error'];

      return message;
    }
    return null;
  }

  Future<Object> editAccount(
      Object token,
      String? country,
      String? firstName,
      String? password,
      String? email,
      String? lastName,
      String? phone,
      String? name,
      Object? birthDate) async {
    final url = Uri.parse('$uri/editAccount');
    final response = await post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'token': '$token',
      },
      body: jsonEncode(<String, Object?>{
        'country': '$country',
        'firstName': '$firstName',
        'password': '$password',
        'email': '$email',
        'lastName': '$lastName',
        'phone': '$phone',
        'name': '$name',
        'birthDate': '$birthDate',
      }),
    );

    Map jsonDecoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Map user = jsonDecoded['user'];

      return (User(
          country: user['country'].toString(),
          firstName: user['firstName'].toString(),
          lastName: user['lastName'].toString(),
          password: user['password'].toString(),
          name: user['name'].toString(),
          email: user['email'].toString(),
          phone: user['phone'].toString(),
          birthDate: user['birthDate'].toString()));
    } else {
      String message = jsonDecoded['error'];
      return message;
    }
  }
}
