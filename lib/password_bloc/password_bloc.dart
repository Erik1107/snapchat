import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/check_internet.dart';
import 'package:snapchat/hhtp_service.dart';
import 'package:snapchat/model/user_class.dart';
import 'package:snapchat/password_bloc/password_event.dart';
import 'package:snapchat/password_bloc/password_state.dart';
import 'package:snapchat/user_repository_mongo.dart';
import 'package:snapchat/validation_repository.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> with CheckInternet {
  PasswordBloc(this.validationRepository, this.userRepositoryMongo) : super(InitialState());
  final ValidationRepository validationRepository;
  final UserRepositoryMongo userRepositoryMongo; 
  final HttpService httpService = HttpService();

 
  User? _user;
  User? get user => _user;
  String? _errorMessage;
  @override
  Stream<PasswordState> mapEventToState(PasswordEvent event) async* {
    if (event is PasswordChange) {
      var passwordLength = event.password.length;
      if (validationRepository.passwordValidation(passwordLength)) {
        yield PasswordValidState();
      } else {
        yield PasswordInvalidState();
      }
    }
    if (event is SubmitUser) {
     
      if (await checkIntenet()) {
        Object? object = await httpService.makeUserPostRequest(
            event.firstName,
            event.lastName,
            event.password,
            event.email,
            event.phone,
            event.name,
            event.birthDate
            event.counrty);
        if (object is User) {
          _user = object;
           if(event.email!=''){
             await userRepositoryMongo.registerMongoUser(event.email ?? '',event.password ?? '');
              await userRepositoryMongo.loginMongo(event.email ?? '', event.password??'');
          }    
       else{
          await userRepositoryMongo.registerMongoUser(event.name ?? '',event.password ?? '');
           await userRepositoryMongo.loginMongo(event.name ?? '', event.password??'');
       } 
     
         await userRepositoryMongo.addUser(_user!);
         
         
          yield UserCreatedValidState();
        } else {
          _errorMessage = object as String;
          yield UserCreatedInvalidState(_errorMessage!);
        }
      }
     else{
yield NoInternetConnectionState();
     } 
    }
    if(event is ProgressIndicatorShowEvent) yield ProgressIndicatorValidState();
  }
}
