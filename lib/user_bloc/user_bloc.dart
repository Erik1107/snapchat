import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/check_internet.dart';
import 'package:snapchat/hhtp_service.dart';
import 'package:snapchat/model/user_class.dart';
import 'package:snapchat/user_repository.dart';
import 'package:snapchat/user_bloc/user_event.dart';
import 'package:snapchat/user_bloc/user_state.dart';
import 'package:snapchat/user_repository_mongo.dart';

class UserBloc extends Bloc<UserEvent, UserState> with CheckInternet {
  UserBloc(this.userRepositoryMongo) : super(InitialState());

  final HttpService httpService = HttpService();
  final UserRepositoryMongo userRepositoryMongo;
  final UserRepository _userRepository = UserRepository();

  String? _errorMessage;
  User? _localUser;
  User? get localUser => _localUser;
  User? _mongoUser;
  User? get mongoUser => _mongoUser;
  User? _updatedUser;
  User? get updateduser => _updatedUser;
  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is DeleteUser) {
      if (await checkIntenet()) {
        var prefs = await SharedPreferences.getInstance();
        var token = prefs.get('createdTokenForUser');

        _errorMessage = await httpService.deleteUser(token!);
        if (_errorMessage != null) {
          yield UserDeletedInvalidState(_errorMessage!);
        } else {
          await _userRepository.deleteUserFromDataBase(token);

          var name = prefs.get('name');

          userRepositoryMongo.deleteUser(name as String);
          userRepositoryMongo.logOutMongo();
          prefs.clear();
          yield UserDeletedValidState();
        }
      } else {
        yield NoInternetConnectionState();
      }
    }
    if (event is LogOutUser) {
      if (await checkIntenet()) {
        var preferences = await SharedPreferences.getInstance();
        await userRepositoryMongo.logOutMongo();
        final appDir = Directory((await getTemporaryDirectory()).path);
        if (appDir.existsSync()) {
          appDir.deleteSync(recursive: true);
        }
        preferences.clear();
        yield UserLogOutValidState();
      } else {
        yield NoInternetConnectionState();
      }
    }

    if (event is GetUserMongo) {
      var prefs = await SharedPreferences.getInstance();
      var name = prefs.get('name');

      _mongoUser = await userRepositoryMongo.fetchData(name as String);

      if (_mongoUser == null) {
        yield MongoUserInvalidState();
      } else {
        yield MongoUserValidState();
      }
    }
    if (event is UpdateUserFromServer) {
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.get('createdTokenForUser');
      var name = prefs.get('name');

      var object = await httpService.getMe(token);
      if (object is User) {
        await userRepositoryMongo.editUser(object, name as String);
        prefs.setString('name', object.name);

        _updatedUser = object;
        yield UserUpdatedValidState();
      } else {
        yield UserUpdatedInvalidState(object as String);
      }
    }
  }
}
