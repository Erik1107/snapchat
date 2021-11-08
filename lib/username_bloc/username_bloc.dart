import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/check_internet.dart';
import 'package:snapchat/username_bloc/username_event.dart';
import 'package:snapchat/username_bloc/username_state.dart';
import 'package:snapchat/validation_repository.dart';
import '../hhtp_service.dart';

class UsernameBloc extends Bloc<UsernameEvent, UsernameState>
    with CheckInternet {
  UsernameBloc(this.validationRepository) : super(InitialState());
  final ValidationRepository validationRepository;

  String _message = '';
  final HttpService httpService = HttpService();
  @override
  Stream<UsernameState> mapEventToState(UsernameEvent event) async* {
    if (event is UsernameChange) {
      var usernameLength = event.username.length;
      if (validationRepository.userNameValidation(usernameLength)) {
        yield UsernameValidState();
      } else {
        yield UsernameInvalidState();
      }
    }
    if (event is UsernameCheck) {
      if (await checkIntenet()) {
        _message = await httpService.makeNameCheckPostRequest(event.username);
        if (_message == 'Done') yield UsernameCheckValidState();
        if (_message == 'This name is already used.') {
          yield UsernameCheckInvalidState(_message);
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
