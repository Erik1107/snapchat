import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/app_localizations.dart';
import 'package:snapchat/model/app_bar.dart';
import 'package:snapchat/validation_repository.dart';
import 'package:snapchat/signupbloc/signup_bloc.dart';
import 'package:snapchat/signupbloc/signup_state.dart';
import 'birthday_page.dart';
import 'model/alert_message.dart';
import 'model/bottom_button.dart';
import 'model/user_class.dart';
import 'signupbloc/signup_event.dart';

class FirstnameLastnamePage extends StatefulWidget {
  const FirstnameLastnamePage({Key? key}) : super(key: key);

  @override
  _FirstnameLastnamepPageState createState() => _FirstnameLastnamepPageState();
}

class _FirstnameLastnamepPageState extends State<FirstnameLastnamePage> {
  TextEditingController firstNameTextEditingController =
      TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  final signbloc = SignupBloc(ValidationRepository());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => signbloc,
        child: BlocListener(
            bloc: signbloc,
            listener: (BuildContext context, SignupState state) {
              _listener(state);
            },
            child: BlocBuilder<SignupBloc, SignupState>(
                builder: (context, state) => GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      child: _renderFirstLastName(state),
                    ))));
  }

  Future<void> _listener(SignupState state) async {
    if (state is NoInternetConnectionState) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return showAlertDialog(
              context: context,
              onPressFunction: () {
                signbloc.add(ValidateChanges(true,
                    firstName: firstNameTextEditingController.text,
                    lastName: lastNameTextEditingController.text));
              },
              message: 'Connect to internet');
        },
      );
    }
    if (state is ValidState) _routeBirtday();
  }

  Widget _renderFirstLastName(SignupState state) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBarWidget(),
      body: Form(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Wrap(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Center(
                            child: Text(
                          AppLocalizationsJson.of(context)!
                              .translate('whatsYourName'),
                          style: TextStyle(color: Colors.black, fontSize: 25),
                          textAlign: TextAlign.center,
                        )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 50, right: 50),
                        child: _renderFirstNameField(),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 50, right: 50),
                          child: _renderLastNameField()),
                      Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: _renderPrivacyPolicyText()),
                    ],
                  ),
                ],
              ),
            ),
            Button(
              checkColor: state is LastFirstValidState,
              route: () {
                if (state is LastFirstValidState) {
                  signbloc.add(CheckInternetConnection());
                }
              },
              buttonText: AppLocalizationsJson.of(context)!
                  .translate('signUpAndAccept'),
            )
          ],
        ),
      ),
    );
  }

  void _routeBirtday() {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BirthdayPage(
                user: User(
                    firstName: firstNameTextEditingController.text,
                    lastName: lastNameTextEditingController.text))));
  }

  Widget _renderLastNameField() {
    return Center(
      child: TextFormField(
          controller: lastNameTextEditingController,
          textCapitalization: TextCapitalization.sentences,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (signbloc.state is LastNameInvalidState) {
              return 'Please enter your lastname(at least 2 symbol)';
            }

            return null;
          },
          onChanged: (value) {
            signbloc.add(ValidateChanges(false,
                firstName: firstNameTextEditingController.text,
                lastName: lastNameTextEditingController.text));
          },
          autocorrect: true,
          decoration: new InputDecoration(
            labelText: AppLocalizationsJson.of(context)!.translate('lastName'),
          )),
    );
  }

  Widget _renderFirstNameField() {
    return Center(
        child: TextFormField(
      controller: firstNameTextEditingController,
      textCapitalization: TextCapitalization.sentences,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (signbloc.state is FirstNameInvalidState) {
          return 'Please enter your name(at least 3 symbol)';
        }

        return null;
      },
      autofocus: true,
      onChanged: (value) {
        signbloc.add(ValidateChanges(true,
            firstName: firstNameTextEditingController.text,
            lastName: lastNameTextEditingController.text));
      },
      autocorrect: true,
      decoration: new InputDecoration(
        labelText: AppLocalizationsJson.of(context)!.translate('firstName'),
      ),
    ));
  }

  Widget _renderPrivacyPolicyText() {
    return Center(
      child: RichText(
          text: TextSpan(
              text:
                  ' By tapping Sign Up & Accept, you acknoledge\n that you have read the ',
              style: TextStyle(color: Colors.black),
              children: <TextSpan>[
            TextSpan(
                text: ' Privacy Policy',
                style: TextStyle(color: Colors.blueAccent),
                recognizer: TapGestureRecognizer()),
            TextSpan(
              text: ' and agree\n to the',
            ),
            TextSpan(
                text: ' Terms of Service',
                style: TextStyle(color: Colors.blueAccent),
                recognizer: TapGestureRecognizer()),
            TextSpan(
              text: ' .',
              style: TextStyle(color: Colors.black),
            ),
          ])),
    );
  }
}
