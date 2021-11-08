import 'package:flutter_mongodb_realm/auth/auth.dart';
import 'package:flutter_mongodb_realm/auth/credentials/credentials.dart';
import 'package:flutter_mongodb_realm/database/mongo_collection.dart';
import 'package:flutter_mongodb_realm/database/mongo_document.dart';
import 'package:flutter_mongodb_realm/database/update_operator.dart';
import 'package:flutter_mongodb_realm/mongo_realm_client.dart';
import 'package:flutter_mongodb_realm/realm_app.dart';
import 'package:objectid/objectid.dart';

import 'model/user_class.dart';

class UserRepositoryMongo {
  static final UserRepositoryMongo _repositoryMongo =
      UserRepositoryMongo._internal();
  factory UserRepositoryMongo() {
    return _repositoryMongo;
  }
  UserRepositoryMongo._internal();
  late MongoCollection collection;
  late MongoRealmClient client = MongoRealmClient();
  Future<void> initialization() async {
    await RealmApp.init('snapchatapplication-eydlf');
  }

  Future<void> registerMongoUser(String email, String password) async {
    var app = RealmApp();
    await app.registerUser(email, password);
  }

  Future<void> loginMongo(String email, String password) async {
    var app = RealmApp();

    await app.login(Credentials.emailPassword(email, password));
  }

  /* // Future<void> loginWithJwt(String token) async {
    var app = RealmApp();
    var mongoUser = await app.login(Credentials.jwt(token));
  } */

  Future<void> logOutMongo() async {
    var app = RealmApp();

    await app.logout();
  }

  Future<void> addUser(User user) async {
    collection =
        client.getDatabase('snapchatdb').getCollection('snapchatcollection');
    final id = ObjectId();
    var document = MongoDocument({
      '_id': '$id',
      '_partition': 'snapchat',
      'firstName': user.firstName,
      'lastName': user.lastName,
      'password': user.password,
      'email': user.email,
      'phone': user.phone,
      'name': user.name,
      'birthDate': user.birthDate,
      'country': user.country,
    });
    await collection.insertOne(document);
  }

  Future<void> editUser(User user, String name) async {
    collection =
        client.getDatabase('snapchatdb').getCollection('snapchatcollection');
    await collection.updateMany(
        filter: {
          'name': name,
        },
        update: UpdateOperator.set({
          'firstName': user.firstName,
          'lastName': user.lastName,
          'password': user.password,
          'email': user.email,
          'phone': user.phone,
          'birthDate': user.birthDate,
          'country': user.country,
          'name': user.name,
        }));
  }

  Future<void> deleteUser(String name) async {
    collection =
        client.getDatabase('snapchatdb').getCollection('snapchatcollection');
    await collection.deleteOne({'name': name});
  }

  Future<User?> fetchData(String name) async {
    collection =
        client.getDatabase('snapchatdb').getCollection('snapchatcollection');
    var doc = await collection.findOne(
      filter: {
        'name': name,
      },
      projection: {
        'firstName': ProjectionValue.INCLUDE,
        'lastName': ProjectionValue.INCLUDE,
        'password': ProjectionValue.INCLUDE,
        'email': ProjectionValue.INCLUDE,
        'phone': ProjectionValue.INCLUDE,
        'name': ProjectionValue.INCLUDE,
        'birthDate': ProjectionValue.INCLUDE,
        'country': ProjectionValue.INCLUDE,
      },
    );

    if (doc != null) {
      var user = User(
          firstName: doc.map['firstName'] as String,
          lastName: doc.map['lastName'] as String,
          password: doc.map['password'] as String,
          email: doc.map['email'] as String,
          phone: doc.map['phone'] as String,
          name: doc.map['name'] as String,
          birthDate: doc.map['birthDate'] as String,
          country: doc.map['country'] as String);
      return user;
    }
    return null;
  }
}
