import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/app_localizations.dart';
import 'package:snapchat/model/app_bar.dart';
import 'package:snapchat/username_bloc/username_bloc.dart';
import 'package:snapchat/username_bloc/username_event.dart';
import 'package:snapchat/username_bloc/username_state.dart';
import 'package:snapchat/validation_repository.dart';

import 'model/alert_message.dart';
import 'model/bottom_button.dart';
import 'model/user_class.dart';
import 'password_page.dart';

class PickUsernamePage extends StatefulWidget {
  const PickUsernamePage({required this.user, Key? key}) : super(key: key);
  final User user;
  @override
  _PickUsernamePageState createState() => _PickUsernamePageState();
}

class _PickUsernamePageState extends State<PickUsernamePage> {
  final userNamebloc = UsernameBloc(ValidationRepository());
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => userNamebloc,
      child: BlocListener(
        bloc: userNamebloc,
        listener: (BuildContext context, UsernameState state) {
          _listener(state);
        },
        child: BlocBuilder<UsernameBloc, UsernameState>(
            builder: (context, state) => _renderUserNamePage(state)),
      ),
    );
  }

  Future<void> _listener(UsernameState state) async {
    if (state is NoInternetConnectionState) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return showAlertDialog(
              context: context,
              onPressFunction: () {
                userNamebloc.add(UsernameChange(textEditingController.text));
              },
              message: 'Connect to internet');
        },
      );
    }
    if (state is UsernameCheckValidState) _routePassword();
    if (state is UsernameCheckInvalidState) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return showAlertDialog(
              context: context,
              onPressFunction: () {
                userNamebloc.add(UsernameChange(textEditingController.text));
              },
              message: state.errorMessage);
        },
      );
    }
  }

  Widget _renderUserNamePage(UsernameState state) {
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
                      AppLocalizationsJson.of(context)!
                          .translate('pickAUserName'),
                      style: TextStyle(color: Colors.black, fontSize: 25),
                      textAlign: TextAlign.center,
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 50, right: 50),
                    child: Text(
                        'Your username is how freins add you\n on Snapchat.'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 50, right: 50),
                    child: _renderUsernameField(state),
                  ),
                  state is ProgressIndicatorValidState
                      ? Expanded(
                          child: Container(
                              alignment: Alignment.bottomCenter,
                              child: CircularProgressIndicator()),
                        )
                      : Button(
                          checkColor: state is UsernameValidState,
                          route: () {
                            if (state is UsernameValidState) {
                              userNamebloc.add(ProgressIndicatorShowEvent());
                              // ignore: cascade_invocations
                              userNamebloc.add(
                                  UsernameCheck(textEditingController.text));
                            }
                          },
                          buttonText: AppLocalizationsJson.of(context)!
                              .translate('continueAction'),
                        ),
                ],
              ),
            )));
  }

  Widget _renderUsernameField(UsernameState state) {
    return TextFormField(
        controller: textEditingController,
        textCapitalization: TextCapitalization.sentences,
        autofocus: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (state is UsernameInvalidState) {
            return 'Username must be at least 5 charecters';
          }

          return null;
        },
        onChanged: (value) {
          userNamebloc.add(UsernameChange(value));
        },
        autocorrect: true,
        decoration: new InputDecoration(
          labelText: AppLocalizationsJson.of(context)!.translate('userName'),
          helperText: state is UsernameValidState ? 'Username available' : null,
        ));
  }

  void _routePassword() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PasswordPage(
                  user: User(
                      country: widget.user.country,
                      firstName: widget.user.firstName,
                      lastName: widget.user.lastName,
                      birthDate: widget.user.birthDate,
                      email: widget.user.email,
                      phone: widget.user.phone,
                      name: textEditingController.text),
                )));
  }
}
