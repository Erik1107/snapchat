import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model/user_class.dart';

class UserRepository {
  var databasesPath;
  var userDatabase;
  String path = '';
  Future _getDb() async {
    databasesPath = await getDatabasesPath();

    path = join(databasesPath, 'user.db');
    userDatabase =
        await openDatabase(path, version: 1, onCreate: _createUserDataBase);
  }

  Future addUser(User user) async {
    await _getDb();

    Batch batch = userDatabase.batch();
    // ignore: cascade_invocations
    batch.insert('User', {
      'token': user.createdTokenForUser,
      'country': user.country,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'password': user.password,
      'email': user.email,
      'phone': user.phone,
      'name': user.name,
      'birthDate': user.birthDate,
    });
    // ignore: cascade_invocations
    batch.commit();
  }

  Future editUser(User user, Object? token) async {
    await _getDb();
    final data = {
      'country': user.country,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'password': user.password,
      'email': user.email,
      'phone': user.phone,
      'name': user.name,
      'birthDate': user.birthDate,
    };
    await userDatabase
        .update('User', data, where: 'token = ?', whereArgs: [token]);
  }

  Future deleteUserFromDataBase(Object token) async {
    await _getDb();
    await userDatabase
        .rawDelete('DELETE FROM User WHERE token = ?', ['$token']);
  }

  Future<List<User>?> getLogedUser(Object? token) async {
    await _getDb();
    final List<Map<String, dynamic>> maps = await userDatabase.query('User',
        where: 'token =?', whereArgs: [token], limit: 1);
    if (maps.isEmpty) {
      return null;
    } else {
      return List.generate(maps.length, (i) {
        return User(
            country: maps[i]['country'],
            firstName: maps[i]['firstName'],
            lastName: maps[i]['lastName'],
            password: maps[i]['password'],
            email: maps[i]['email'],
            phone: maps[i]['phone'],
            name: maps[i]['name'],
            birthDate: maps[i]['birthDate']);
      });
    }
  }

  Future<List<User>> checkUser(
      String? name, String? email, String password) async {
    await _getDb();
    var result = <Map>[];
    if (email == null) {
      result = await userDatabase.rawQuery(
          'SELECT * FROM User WHERE name=? and password=?',
          ['$name', '$password']);
    } else {
      result = await userDatabase.rawQuery(
          'SELECT * FROM User WHERE email=? and password=?',
          ['$email', '$password']);
    }

    return List.generate(result.length, (i) {
      return User(
          createdTokenForUser: result[i]['token'],
          country: result[i]['country'],
          firstName: result[i]['firstName'],
          lastName: result[i]['lastName'],
          password: result[i]['password'],
          email: result[i]['email'],
          phone: result[i]['phone'],
          name: result[i]['name'],
          birthDate: result[i]['birthDate']);
    });
  }

  Future<List<User>> loadUsers() async {
    await _getDb();

    final List<Map<String, dynamic>> maps = await userDatabase.query('User');
    return List.generate(maps.length, (i) {
      return User(
          country: maps[i]['country'],
          firstName: maps[i]['firstName'],
          lastName: maps[i]['lastName'],
          password: maps[i]['password'],
          email: maps[i]['email'],
          phone: maps[i]['phone'],
          name: maps[i]['name'],
          birthDate: maps[i]['birthDate']);
    });
  }

  FutureOr<void> _createUserDataBase(Database db, int i) async {
    db.execute(
        'CREATE TABLE User(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,token TEXT,country TEXT,firstName TEXT, lastName TEXT, password TEXT,email TEXT,phone TEXT,name TEXT,birthDate TEXT)');
  }
}
