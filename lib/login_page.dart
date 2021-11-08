import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/app_localizations.dart';
import 'package:snapchat/login_bloc/login_event.dart';
import 'package:snapchat/model/app_bar.dart';
import 'package:snapchat/user_page.dart';
import 'package:snapchat/user_repository_mongo.dart';
import 'package:snapchat/validation_repository.dart';

import 'login_bloc/login_bloc.dart';
import 'login_bloc/login_state.dart';
import 'model/alert_message.dart';
import 'model/bottom_button.dart';
import 'model/user_class.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool obscureTextBool = true;

  TextEditingController userNameOrEmailTextEditingController =
      TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  final loginbloc = LoginBloc(ValidationRepository(), UserRepositoryMongo());
  User? userFromResponse;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginbloc,
      child: BlocListener(
        bloc: loginbloc,
        listener: (BuildContext context, LoginState state) {
          _listener(state);
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) => _renderLoginPage(state),
        ),
      ),
    );
  }

  Future<void> _listener(LoginState state) async {
    if (state is NoInternetConnectionState) {
      if (state is NoInternetConnectionState) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return showAlertDialog(
                context: context,
                onPressFunction: () {
                  loginbloc.add(ValidateChanges(
                    null,
                    userNameOrEmail: userNameOrEmailTextEditingController.text,
                    password: passwordTextEditingController.text,
                  ));
                },
                message: 'Connect to internet');
          },
        );
      }
    }
    if (state is UserCheckValidState) {
      userFromResponse = loginbloc.user;

      await _routeUserPage();
    }
    if (state is UserCheckInvalidState) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return showAlertDialog(
              context: context,
              onPressFunction: () {
                loginbloc.add(ValidateChanges(
                  null,
                  userNameOrEmail: userNameOrEmailTextEditingController.text,
                  password: passwordTextEditingController.text,
                ));
              },
              message: state.errorMessage);
        },
      );
    }
  }

  Widget _renderLoginPage(LoginState state) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBarWidget(),
        body: Form(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                  child: Text(
                AppLocalizationsJson.of(context)!.translate('logIn'),
                style: TextStyle(color: Colors.black, fontSize: 25),
                textAlign: TextAlign.center,
              )),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10, left: 50, right: 50),
                child: _renderUsernameEmailField(state)),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 50, right: 50),
              child: _renderPasswordField(state),
            ),
            Padding(
                padding: EdgeInsets.only(top: 5),
                child: TextButton(
                    onPressed: null,
                    child: Text(
                      'Forgot your password?',
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ))),
            state is ProgressIndicatorValidState
                ? Expanded(
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        child: CircularProgressIndicator()),
                  )
                : Button(
                    checkColor: state is LoginValidState,
                    route: () {
                      loginbloc.add(ProgressIndicatorShowEvent());
                      if (state is LoginValidState) {
                        loginbloc.add(LogInEvent(
                            userNameOrEmailTextEditingController.text,
                            passwordTextEditingController.text));
                      }
                    },
                    buttonText:
                        AppLocalizationsJson.of(context)!.translate('logIn'))
          ]),
        ),
      ),
    );
  }

  Widget _renderPasswordField(LoginState state) {
    return TextFormField(
        controller: passwordTextEditingController,
        textCapitalization: TextCapitalization.sentences,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (state is PasswordInvalidState) {
            return 'Password must be at least 8 charecters';
          }

          return null;
        },
        onChanged: (value) {
          loginbloc.add(ValidateChanges(false,
              userNameOrEmail: userNameOrEmailTextEditingController.text,
              password: passwordTextEditingController.text));
        },
        obscureText: obscureTextBool,
        autocorrect: false,
        decoration: new InputDecoration(
            labelText: AppLocalizationsJson.of(context)!.translate('password'),
            suffixIcon: IconButton(
              icon: Icon(
                  obscureTextBool ? Icons.visibility_off : Icons.visibility),
              onPressed: () => _showHide(),
            )));
  }

  Widget _renderUsernameEmailField(LoginState state) {
    return TextFormField(
      controller: userNameOrEmailTextEditingController,
      textCapitalization: TextCapitalization.sentences,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (state is UsernameEmailInvalidState) {
          return 'Enter at least 1 charecter';
        }

        return null;
      },
      onChanged: (value) {
        loginbloc.add(ValidateChanges(true,
            userNameOrEmail: userNameOrEmailTextEditingController.text,
            password: passwordTextEditingController.text));
      },
      autofocus: true,
      decoration: new InputDecoration(labelText: 'USERNAME OR EMAIL'),
    );
  }

  void _showHide() {
    obscureTextBool = !obscureTextBool;
    setState(() {});
  }

  Future<void> _routeUserPage() async {
    FocusScope.of(context).requestFocus(FocusNode());
    var prefs = await SharedPreferences.getInstance();
    var createdToken = userFromResponse!.createdTokenForUser;
    prefs.setString('createdTokenForUser', createdToken);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => UserPage(
                  user: userFromResponse,
                )),
        (route) => false);
  }
}
