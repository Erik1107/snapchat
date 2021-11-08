import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/check_internet.dart';
import 'package:snapchat/hhtp_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/model/country_code_class.dart';
import 'package:snapchat/model/user_class.dart';
import 'package:snapchat/remote_country_code_repository.dart';
import 'package:snapchat/user_repository.dart';
import 'package:snapchat/user_repository_mongo.dart';
import 'package:snapchat/validation_repository.dart';

import '../validation_type.dart';
import 'edit_user_event.dart';
import 'edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState>
    with CheckInternet {
  EditUserBloc(this.validationRepository, this.remoteCountyCodeRepository,
      this.userRepositoryMongo)
      : super(InitialState());
  final ValidationRepository validationRepository;
  final UserRepositoryMongo userRepositoryMongo;
  final UserRepository _userRepository = UserRepository();
  final RemoteCountyCodeRepository remoteCountyCodeRepository;
  HttpService httpService = HttpService();
  CountryCode? _userCountry;
  CountryCode? get userCountry => _userCountry;
  final List<String> _invalidValues = [];
  String _errorMessage = '';
  User? _editedUser;
  User? get editedUser => _editedUser;
  String? _serverErrorMessage;
  String? firstName = '';
  String? lastName = '';
  Object? birthDate;
  String? email = '';
  String? phone = '';
  String? name = '';
  String? password = '';
  @override
  Stream<EditUserState> mapEventToState(EditUserEvent event) async* {
    if (event is UserValidation) {
      switch (event.validation) {
        case Validation.FirstName:
          {
            if (!validationRepository.firstNameValidation(event.value)) {
              yield InfoInvalidState(Validation.FirstName);
            } else {
              yield InfoValidState(Validation.FirstName);
            }
          }
          break;

        case Validation.LastName:
          {
            if (!validationRepository.lastNameValidation(event.value)) {
              yield InfoInvalidState(Validation.LastName);
            } else {
              yield InfoValidState(Validation.LastName);
            }
          }
          break;

        case Validation.BirthDate:
          {
            if (!validationRepository.birthdayValidation(
                event.value, event.value2)) {
              yield InfoInvalidState(Validation.BirthDate);
            } else {
              yield InfoValidState(Validation.BirthDate);
            }
          }
          break;

        case Validation.Email:
          {
            if (!validationRepository.emailValidation(event.value)) {
              yield InfoInvalidState(Validation.Email);
            } else {
              yield InfoValidState(Validation.Email);
            }
          }
          break;

        case Validation.Phone:
          {
            if (!validationRepository.phoneNumberValidation(
                event.value2, event.value.length)) {
              yield InfoInvalidState(Validation.Phone);
            } else {
              yield InfoValidState(Validation.Phone);
            }
          }
          break;

        case Validation.UserName:
          {
            if (!validationRepository.userNameValidation(event.value.length)) {
              yield InfoInvalidState(Validation.UserName);
            } else {
              yield InfoValidState(Validation.UserName);
            }
          }
          break;

        case Validation.Password:
          {
            if (!validationRepository.passwordValidation(event.value.length)) {
              yield InfoInvalidState(Validation.Password);
            } else {
              yield InfoValidState(Validation.Password);
            }
          }
          break;
      }
    }
    if (event is SetCountryCode) {
      _userCountry = event.countryCode;
      yield UserCountryChangedState();
    }
    if (event is EditUserPageLoad) {
      if (event.isoCode != '') {
        _userCountry =
            await remoteCountyCodeRepository.searchLocaleCountry(event.isoCode);
      } else {
        _userCountry =
            await remoteCountyCodeRepository.searchLocaleCountry('AM');
      }

      yield EditUserLoadedState();
    }

    if (event is EditUser) {
      var internetConnected = await checkIntenet();
      if (internetConnected) {
        await _editUserInitialization(event);

        var object = await httpService.editAccount(
          event.token,
          event.country,
          firstName,
          password,
          email,
          lastName,
          phone,
          name,
          birthDate,
        );
        if (object is User) {
          _editedUser = object;

          var prefs = await SharedPreferences.getInstance();
          var name = prefs.get('name');
          userRepositoryMongo.editUser(object, name as String);
          prefs.setString('name', object.name);

          yield UserEditedValidState();
        } else {
          _serverErrorMessage = object as String;
          yield UserEditedInvalidState(_serverErrorMessage!);
        }
      }
      if (internetConnected = false) yield NoInternetConnectionState();
    }

    if (event is EditUserValidation) {
      if (await checkIntenet()) {
        await _editUserValidation(event);

        if (_invalidValues.isEmpty) {
          yield UserInfoValidState();
        } else {
          yield UserInfoInvalidState(_invalidValues);
        }
      } else {
        yield NoInternetConnectionState();
      }
    }
    if (event is ProgressIndicatorShowEvent) {
      yield ProgressIndicatorValidState();
    }
  }

  Future<void> _editUserValidation(EditUserValidation event) async {
    _invalidValues.clear();
    var _firstNameValidation =
        validationRepository.firstNameValidation(event.firstName);
    var _lastNameValidation =
        validationRepository.lastNameValidation(event.lastName);
    var _birthdayValidation = validationRepository.birthdayValidation(
        event.birthDate.millisecondsSinceEpoch,
        DateTime.now().millisecondsSinceEpoch);
    var _emailValidation = validationRepository.emailValidation(event.email);
    var _phoneNumberValidation = validationRepository.phoneNumberValidation(
        event.phone.length, event.phoneLength);

    var _userNameValidation =
        validationRepository.userNameValidation(event.name.length);
    var _passwordValidation =
        validationRepository.passwordValidation(event.password.length);

    if (event.firstName != event.initalFirstName) {
      if (!_firstNameValidation) {
        _invalidValues.add('Please enter your name(at least 3 symbol)');
      }
    }

    if (event.lastName != event.initalLastName) {
      if (!_lastNameValidation) {
        _invalidValues.add('Please enter your lastname(at least 2 symbol)');
      }
    }

    if (event.birthDate.compareTo(event.initalBirthDate) != 0) {
      if (!_birthdayValidation) {
        _invalidValues
            .add("Sorry, our users can't be younger than 16 years old.");
      }
    }
    if (event.email != event.initalEmail) {
      if ((event.email.isNotEmpty && _emailValidation == false) ||
          (event.email.isEmpty && _phoneNumberValidation == false)) {
        _invalidValues.add('Please enter correct email address');
      } else if (_emailValidation) {
        _errorMessage =
            await httpService.makeEmailCheckPostRequest(event.email);
        if (_errorMessage == 'This email address is already used.') {
          _invalidValues.add(_errorMessage);
        }
      }
    }

    if (event.phone != event.initalPhone) {
      if ((event.phone.isNotEmpty && _phoneNumberValidation == false) ||
          (event.phone.isEmpty && _emailValidation == false)) {
        _invalidValues.add('Please enter correct phone number');
      } else if (_phoneNumberValidation) {
        _errorMessage =
            await httpService.makePhoneCheckPostRequest(event.phone);
        if (_errorMessage == 'This phone is already used.') {
          _invalidValues.add(_errorMessage);
        }
      }
    }

    if (event.name != event.initalName) {
      if (!_userNameValidation) {
        _invalidValues.add('Username must be at least 5 charecters');
      } else if (_userNameValidation) {
        _errorMessage = await httpService.makeNameCheckPostRequest(event.name);
        if (_errorMessage == 'This name is already used.') {
          _invalidValues.add(_errorMessage);
        }
      }
    }

    if (event.password != event.initalPassword) {
      if (!_passwordValidation) {
        _invalidValues.add('Password must be at least 8 charecters');
      }
    }
  }

  Future<void> _editUserInitialization(EditUser event) async {
    if (event.firstName != event.initalFirstName) {
      firstName = event.firstName;
    }

    if (event.lastName != event.initalLastName) {
      lastName = event.lastName;
    }

    if (event.birthDate!.compareTo(event.initalBirthDate) != 0) {
      birthDate = event.birthDate;
    } else if (event.birthDate!.compareTo(event.initalBirthDate) == 0) {
      birthDate = '';
    }
    if (event.email != event.initalEmail) {
      email = event.email;
    }

    if (event.phone != event.initalPhone) {
      phone = event.phone;
    }

    if (event.name != event.initalName) {
      name = event.name;
    }
    if (event.password != event.initalPassword) {
      password = event.password;
    }
  }
}
