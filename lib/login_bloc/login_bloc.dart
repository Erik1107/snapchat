import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/check_internet.dart';
import 'package:snapchat/hhtp_service.dart';
import 'package:snapchat/login_bloc/login_event.dart';
import 'package:snapchat/login_bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/model/user_class.dart';
import 'package:snapchat/user_repository.dart';
import 'package:snapchat/user_repository_mongo.dart';
import 'package:snapchat/validation_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with CheckInternet {
  LoginBloc(this.validationRepository, this.userRepositoryMongo)
      : super(InitialState());

  final ValidationRepository validationRepository;
  final UserRepositoryMongo userRepositoryMongo;
  final HttpService httpService = HttpService();
  final UserRepository userRepository = UserRepository();

  User? _user;
  User? get user => _user;
  String? _errorMessage;
  List<User>? userFromDataBase;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is ValidateChanges) {
      var userNameOrEmail = event.userNameOrEmail;
      var passwordLength = event.password.length;

      if (event.userNameOrEmailChanged == true) {
        if (validationRepository.userNameValidation(userNameOrEmail.length) ||
            validationRepository.emailValidation(userNameOrEmail)) {
          yield UsernameEmailValidState();
        } else {
          yield UsernameEmailInvalidState();
        }
      }

      if (event.userNameOrEmailChanged == false) {
        if (validationRepository.passwordValidation(passwordLength)) {
          yield PasswordValidState();
        } else {
          yield PasswordInvalidState();
        }
      }

      if ((validationRepository.userNameValidation(userNameOrEmail.length) &&
              validationRepository.passwordValidation(passwordLength)) ||
          (validationRepository.emailValidation(userNameOrEmail) &&
              validationRepository.passwordValidation(passwordLength))) {
        yield LoginValidState();
      }
    }
    if (event is LogInEvent) {
      if (await checkIntenet()) {
        var object = (await httpService.makeSignInPostRequest(
            event.login, event.password));

        if (object is User) {
          var prefs = await SharedPreferences.getInstance();
          prefs.setString('name', object.name);

          _user = object;
          if (object.email != '') {
            await userRepositoryMongo.loginMongo(object.email, object.password);
          } else {
            await userRepositoryMongo.loginMongo(object.name, object.password);
          }

          yield UserCheckValidState();
        } else {
          _errorMessage = object as String;
          yield UserCheckInvalidState(_errorMessage!);
        }
      } else {
        yield NoInternetConnectionState();
      }
    }
    if (event is ProgressIndicatorShowEvent) {
      yield ProgressIndicatorValidState();
    }
  }
}
