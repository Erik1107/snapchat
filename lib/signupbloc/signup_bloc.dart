import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/check_internet.dart';
import 'package:snapchat/hhtp_service.dart';
import 'package:snapchat/validation_repository.dart';
import 'package:snapchat/signupbloc/signup_event.dart';
import 'package:snapchat/signupbloc/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> with CheckInternet {
  SignupBloc(this.validationRepository) : super(InitialState());
  final ValidationRepository validationRepository;
  HttpService httpService = HttpService();

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is ValidateChanges) {
      var firstName = event.firstName;
      var lastName = event.lastName;
      if (event.firstNameChanged == true) {
        if (validationRepository.firstNameValidation(firstName)) {
          yield FirstNameValidState();
        } else {
          yield FirstNameInvalidState();
        }
      }
      if (event.firstNameChanged == false) {
        if (validationRepository.lastNameValidation(lastName)) {
          yield LastNameValidState();
        } else {
          yield LastNameInvalidState();
        }
      }
      if (validationRepository.firstNameValidation(firstName) &&
          validationRepository.lastNameValidation(lastName)) {
        yield LastFirstValidState();
      }
    }
    if (event is CheckInternetConnection) {
      if (!await checkIntenet()) {
        yield NoInternetConnectionState();
      } else {
        yield ValidState();
      }
    }
  }
}
