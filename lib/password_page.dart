import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/app_localizations.dart';
import 'package:snapchat/model/alert_message.dart';
import 'package:snapchat/model/app_bar.dart';
import 'package:snapchat/password_bloc/password_bloc.dart';
import 'package:snapchat/password_bloc/password_event.dart';
import 'package:snapchat/password_bloc/password_state.dart';
import 'package:snapchat/user_page.dart';
import 'package:snapchat/user_repository_mongo.dart';
import 'package:snapchat/validation_repository.dart';
import 'model/bottom_button.dart';
import 'model/user_class.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({
    required this.user,
    Key? key,
  }) : super(key: key);
  final User user;

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  bool obscureTextBool = true;
  String password = '';
  final passwordbloc =
      PasswordBloc(ValidationRepository(), UserRepositoryMongo());
  User? userFromResponse;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => passwordbloc,
      child: BlocListener(
        bloc: passwordbloc,
        listener: (BuildContext context, PasswordState state) {
          _listener(state);
        },
        child: BlocBuilder<PasswordBloc, PasswordState>(
            builder: (context, state) => _renderPasswordPage(state)),
      ),
    );
  }

  Future<void> _listener(PasswordState state) async {
    if (state is NoInternetConnectionState) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return showAlertDialog(
              context: context,
              onPressFunction: () {},
              message: 'Connect to internet');
        },
      );
    }
    if (state is UserCreatedValidState) {
      userFromResponse = passwordbloc.user;
      await _routeUserPage();
    }
    if (state is UserCreatedInvalidState) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return showAlertDialog(
              context: context,
              onPressFunction: () {},
              message: state.errorMessage);
        },
      );
    }
  }

  Widget _renderPasswordPage(PasswordState state) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBarWidget(),
          body: Form(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                      child: Text(
                    AppLocalizationsJson.of(context)!.translate('setAPassword'),
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    textAlign: TextAlign.center,
                  )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 50, right: 50),
                  child:
                      Text('Your password should be at least 8\n charachters.'),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 50, right: 50),
                    child: _renderPasswordField(state)),
                state is ProgressIndicatorValidState
                    ? Expanded(
                        child: Container(
                        alignment: Alignment.bottomCenter,
                        child: CircularProgressIndicator(),
                      ))
                    : Button(
                        checkColor: state is PasswordValidState,
                        route: () {
                          if (state is PasswordValidState) {
                            passwordbloc.add(ProgressIndicatorShowEvent());
                            // ignore: cascade_invocations
                            passwordbloc.add(SubmitUser(
                                widget.user.firstName,
                                widget.user.lastName,
                                widget.user.name,
                                widget.user.email,
                                widget.user.phone,
                                widget.user.birthDate,
                                password,
                                widget.user.country));
                          }
                        },
                        buttonText: AppLocalizationsJson.of(context)!
                            .translate('continueAction')),
              ],
            ),
          ),
        ));
  }

  Widget _renderPasswordField(PasswordState state) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofocus: true,
      onChanged: (value) {
        password = value;
        passwordbloc.add(PasswordChange(value));
      },
      validator: (value) {
        if (state is PasswordInvalidState) {
          return ('Password must be at least 8 characters');
        }

        return null;
      },
      obscureText: obscureTextBool,
      autocorrect: false,
      decoration: new InputDecoration(
        suffixIcon: obscureTextBool
            ? TextButton(
                child: Text('Show'),
                onPressed: _hideShowPassword,
              )
            : TextButton(
                child: Text('Hide'),
                onPressed: _hideShowPassword,
              ),
        labelText: AppLocalizationsJson.of(context)!.translate('password'),
      ),
    );
  }

  void _hideShowPassword() {
    if (password.length > 0) obscureTextBool = !obscureTextBool;
    setState(() {});
  }

  Future<void> _routeUserPage() async {
    FocusScope.of(context).requestFocus(FocusNode());
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'createdTokenForUser', userFromResponse!.createdTokenForUser);
    // ignore: cascade_invocations
    prefs.setString('name', userFromResponse!.name);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => UserPage(
                  user: userFromResponse,
                )),
        (route) => false);
  }
}
