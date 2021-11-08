import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:snapchat/app_localizations.dart';
import 'package:snapchat/model/alert_message.dart';
import 'package:snapchat/model/app_bar.dart';
import 'package:snapchat/model/bottom_button.dart';
import 'package:snapchat/model/country_code_class.dart';
import 'package:snapchat/country_code_page.dart';
import 'package:snapchat/model/country_notifier.dart';
import 'package:snapchat/remote_country_code_repository.dart';
import 'package:snapchat/validation_repository.dart';
import 'email_phone_bloc/email_phone_bloc.dart';
import 'email_phone_bloc/email_phone_event.dart';
import 'email_phone_bloc/email_phone_state.dart';
import 'model/user_class.dart';
import 'pickuser_name.dart';

class PhoneNumberEmailPage extends StatefulWidget {
  const PhoneNumberEmailPage({
    required this.user,
    Key? key,
  }) : super(key: key);
  final User user;
  @override
  _PhoneNumberEmailPageState createState() => _PhoneNumberEmailPageState();
}

class _PhoneNumberEmailPageState extends State<PhoneNumberEmailPage> {
  EmailNumberBloc emailNumberBloc =
      EmailNumberBloc(ValidationRepository(), RemoteCountyCodeRepository());
  CountryCode? get lastCountryCode => emailNumberBloc.selectedCountryCode;
  CountryCode _countryForChangeNotifier =
      CountryCode(isoCode: '', name: '', numberCode: '', numberExample: '');

  // ignore: unused_field
  // ignore: prefer_final_fields
  // ignore: unused_field
  final ValueNotifier<CountryCode> _countryValueNotifier = ValueNotifier(
      CountryCode(isoCode: '', name: '', numberCode: '', numberExample: ''));
  final FocusNode _emailFocusNode = new FocusNode();
  final FocusNode _numberFocusNode = new FocusNode();
  final numberTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final isoCodeEditController = TextEditingController();
  final dialCodeEditController = TextEditingController();
  bool email = true;
  @override
  void initState() {
    super.initState();
    emailNumberBloc.add(PhoneNumberPageReload());
    Provider.of<CountryNotifier>(context, listen: false)
        .addListener(_checkEquality);
  }

//ARANDZ CONSUMER WIDGET
  /*  @override
  Widget build(BuildContext context) {
    return Provider<CountryCode>(
      create: (_)=>CountryCode(isoCode: '', name: '', numberCode: '', numberExample: '',),
      builder:(context){} BlocProvider(
        create: (context) => emailNumberBloc,
        child: BlocListener(
          bloc: emailNumberBloc,
          listener: (BuildContext context, state) {
            if (state is NoInternetConnectionState) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return showAlertDialog(
                      context: context,
                      onPressFunction: () {
                        emailNumberBloc
                            .add(EmailChange(emailTextEditingController.text));
                      },
                      message: 'Connect to internet');
                },
              );
            }
            if (state is EmailCheckValidState) {
              _routeusernameFromEmail();
            }
            if (state is NumberCheckValidState) {
              _routeusernameFromPhone();
            }
            if (state is EmailCheckInvalidState) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return showAlertDialog(
                      context: context,
                      onPressFunction: () {
                        emailNumberBloc
                            .add(EmailChange(emailTextEditingController.text));
                      },
                      message: state.errorMessage);
                },
              );
            }
            if (state is NumberCheckInvalidState) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return showAlertDialog(
                      context: context,
                      onPressFunction: () {
                        emailNumberBloc.add(
                            NumberChange(numberTextEditingController.text, 5));
                      },
                      message: state.errorMessage);
                },
              );
            }
          },
          child: BlocBuilder<EmailNumberBloc, EmailNumberState>(
              builder: (context, state) => _renderEmailPhoneWidget(state)),
        ),
      ),
    );
  }
 */
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => emailNumberBloc,
      child: BlocListener(
        bloc: emailNumberBloc,
        listener: (BuildContext context, EmailNumberState state) {
          _listener(state);
        },
        child: BlocBuilder<EmailNumberBloc, EmailNumberState>(
            builder: (context, state) => _renderEmailPhoneWidget(state)),
      ),
    );
  }

  Future<void> _listener(EmailNumberState state) async {
    if (state is NoInternetConnectionState) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return showAlertDialog(
              context: context,
              onPressFunction: () {
                emailNumberBloc
                    .add(EmailChange(emailTextEditingController.text));
              },
              message: 'Connect to internet');
        },
      );
    }
    if (state is EmailCheckValidState) {
      _routeusernameFromEmail();
    }
    if (state is NumberCheckValidState) {
      _routeusernameFromPhone();
    }
    if (state is EmailCheckInvalidState) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return showAlertDialog(
              context: context,
              onPressFunction: () {
                emailNumberBloc
                    .add(EmailChange(emailTextEditingController.text));
              },
              message: state.errorMessage);
        },
      );
    }
    if (state is NumberCheckInvalidState) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return showAlertDialog(
              context: context,
              onPressFunction: () {
                emailNumberBloc
                    .add(NumberChange(numberTextEditingController.text, 5));
              },
              message: state.errorMessage);
        },
      );
    }
  }

  Widget _renderEmailPhoneWidget(EmailNumberState state) {
    return GestureDetector(
        onTap: () => {
              FocusScope.of(context).requestFocus(new FocusNode()),
            },
        child: Scaffold(
          body: Stack(
            children: [
              Visibility(
                child: _renderemailWidget(state),
                visible: email,
                maintainState: true,
                maintainAnimation: false,
              ),
              Visibility(
                child: _renderphoneNumberWidget(state),
                visible: email == false,
                maintainState: true,
                maintainAnimation: false,
              ),
            ],
          ),
        ));
  }

//ARANDZ CONSUMER
  /* Widget _renderphoneNumberWidget(EmailNumberState state) {
    return Scaffold(
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
                    .translate('whatsYourMobileNumber'),
                style: TextStyle(color: Colors.black, fontSize: 25),
                textAlign: TextAlign.center,
              )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 50, right: 50),
              child: Center(child: _renderSignUpWithEmailButton()),
            ),
            Padding(
                padding: EdgeInsets.only(left: 40, right: 40, top: 10),
                child: _renderNumberField(state)),
            Padding(
              padding: EdgeInsets.only(top: 20, right: 50, left: 50),
              child: Text(
                "We'll send you SMS verification code",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            state is ProgressIndicatorValidState
                ? Expanded(
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        child: CircularProgressIndicator()),
                  )
                : Button(
                    checkColor: state is NumberValidState,
                    route: () {
                      emailNumberBloc.add(ProgressIndicatorShowEvent());
                      if (state is NumberValidState)
                        emailNumberBloc.add(NumberCheck('+' +
                            lastCountryCode!.numberCode +
                            numberTextEditingController.text));
                    },
                    buttonText: AppLocalizationsJson.of(context)!
                        .translate('continueAction')),
          ],
        ),
      ),
    );
  } */
  Widget _renderphoneNumberWidget(EmailNumberState state) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget(),
      body: Form(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    AppLocalizationsJson.of(context)!
                        .translate('whatsYourMobileNumber'),
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    textAlign: TextAlign.center,
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 50, right: 50),
              child: Center(child: _renderSignUpWithEmailButton()),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, right: 170),
              child: Text(
                  AppLocalizationsJson.of(context)!.translate('mobileNumber')),
            ),
            Padding(
                padding: EdgeInsets.only(left: 40, right: 40, top: 0),
                child: lastCountryCode != null
                    ? _renderNumberField(state)
                    : Container()),
            Padding(
              padding: EdgeInsets.only(top: 20, right: 50, left: 50),
              child: Text(
                "We'll send you SMS verification code",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            state is ProgressIndicatorValidState
                ? Expanded(
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        child: CircularProgressIndicator()),
                  )
                : Button(
                    checkColor: state is NumberValidState,
                    route: () {
                      if (state is NumberValidState) {
                        emailNumberBloc.add(ProgressIndicatorShowEvent());
                        // ignore: cascade_invocations
                        emailNumberBloc.add(NumberCheck('+' +
                            lastCountryCode!.numberCode +
                            numberTextEditingController.text));
                      }
                    },
                    buttonText: AppLocalizationsJson.of(context)!
                        .translate('continueAction')),
          ],
        ),
      ),
    );
  }

  Widget _renderSignUpWithEmailButton() {
    return TextButton(
        onPressed: _changeWidget,
        child: Text(
          AppLocalizationsJson.of(context)!.translate('signUpWithEmailInstead'),
          style: TextStyle(color: Colors.blue, fontSize: 14),
        ));
  }

//ARANDZ CONSUMER
  /*  Widget _renderNumberField(EmailNumberState state) {
    return TextFormField(
      autofocus: true,
      focusNode: _numberFocusNode,
      controller: numberTextEditingController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (state is NumberInvalidState)
          return 'Please enter correct phone number';
        return null;
      },
      onChanged: (value) {
        emailNumberBloc
            .add(NumberChange(value, lastCountryCode!.numberExample.length));
      },
      maxLength:
          lastCountryCode == null ? 5 : lastCountryCode!.numberExample.length,
      keyboardType: TextInputType.phone,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
          labelText: /*  Text( */
              AppLocalizationsJson.of(context)!.translate('mobileNumber'),
          /* style: TextStyle(
                    color: Colors.blue,
                  ),
                ),, */
          prefixIcon: GestureDetector(
            onTap: _routeCountryCode,
            child: Text(
              lastCountryCode == null
                  ? 'Loading'
                  : lastCountryCode!.isoCode +
                      '  +' +
                      lastCountryCode!.numberCode,
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
          prefixIconConstraints: BoxConstraints(maxWidth: 85),
          prefix: GestureDetector(
            onTap: _routeCountryCode,
            child:
                Text('|', style: TextStyle(color: Colors.blue, fontSize: 16)),
          )),
    );
  }
 */
//
//
//
  //CHANGE NOTIFIER
  Widget _renderNumberField(EmailNumberState state) {
    return Consumer<CountryNotifier>(
        builder: (BuildContext context, value, Widget? child) {
      return TextFormField(
        autofocus: true,
        focusNode: _numberFocusNode,
        controller: numberTextEditingController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (state is NumberInvalidState) {
            return 'Please enter correct phone number';
          }

          return null;
        },
        onChanged: (textValue) {
          emailNumberBloc.add(NumberChange(
              textValue,
              value.countryCode!.name == ''
                  ? lastCountryCode!.numberExample.length
                  : value.countryCode!.numberExample.length));
        },
        maxLength: value.countryCode!.name == ''
            ? /* lastCountryCode == null
                ? 5 */
            lastCountryCode!.numberExample.length
            : value.countryCode!.numberExample.length,
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          /*  labelText:
              AppLocalizationsJson.of(context)!.translate('mobileNumber'), */
          prefixIcon: GestureDetector(
            onTap: () {
              _routeCountryCode(value);
            },
            child: Text(
              value.countryCode!.name == ''
                  ? /* /* lastCountryCode == null
                      ? 'Loading' */
                      : */
                  lastCountryCode!.isoCode + '  +' + lastCountryCode!.numberCode
                  : value.countryCode!.isoCode +
                      '  +' +
                      value.countryCode!.numberCode,
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
          prefixIconConstraints: BoxConstraints(maxWidth: 70),
          prefix: Text('|', style: TextStyle(color: Colors.blue, fontSize: 16)),
        ),
      );
    });
  }

  //
  //
  //
  //VALUE NOTIFIER
  /* Widget _renderNumberField(EmailNumberState state) {
    return ValueListenableBuilder(
        valueListenable: _countryValueNotifier,
        builder: (BuildContext context, CountryCode value, Widget? child) {
          return TextFormField(
            autofocus: true,
            focusNode: _numberFocusNode,
            controller: numberTextEditingController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (state is NumberInvalidState)
                return 'Please enter correct phone number';
              return null;
            },
            onChanged: (value) {
              emailNumberBloc.add(NumberChange(
                  value,
                  _countryValueNotifier.value.name == ''
                      ? lastCountryCode!.numberExample.length
                      : _countryValueNotifier.value.numberExample.length));
            },
            maxLength: value.name == ''
                ? lastCountryCode == null
                    ? 5
                    : lastCountryCode!.numberExample.length
                : value.numberExample.length,
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              labelText:
                  AppLocalizationsJson.of(context)!.translate('mobileNumber'),
              prefixIcon: GestureDetector(
                onTap: () {
                  _routeCountryCode(value);
                },
                child: Text(
                  value.name == ''
                      ? lastCountryCode == null
                          ? 'Loading'
                          : lastCountryCode!.isoCode +
                              '  +' +
                              lastCountryCode!.numberCode
                      : value.isoCode + '  +' + value.numberCode,
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
              prefixIconConstraints: BoxConstraints(maxWidth: 85),
              prefix:
                  Text('|', style: TextStyle(color: Colors.blue, fontSize: 16)),
            ),
          );
        });
  } */

  Widget _renderemailWidget(EmailNumberState state) {
    return Scaffold(
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
                  AppLocalizationsJson.of(context)!.translate('whatsYourEmail'),
                  style: TextStyle(color: Colors.black, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 50, right: 50),
              child: Center(child: _renderSignUpWithPhoneButton()),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 50, right: 50),
              child: _renderEmailField(state),
            ),
            state is ProgressIndicatorValidState
                ? Expanded(
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        child: CircularProgressIndicator()),
                  )
                : Button(
                    checkColor: state is EmailValidState,
                    route: () {
                      if (state is EmailValidState) {
                        emailNumberBloc.add(ProgressIndicatorShowEvent());
                        // ignore: cascade_invocations
                        emailNumberBloc
                            .add(EmailCheck(emailTextEditingController.text));
                      }
                    },
                    buttonText: AppLocalizationsJson.of(context)!
                        .translate('continueAction')),
          ],
        ),
      ),
    );
  }

  Widget _renderEmailField(EmailNumberState state) {
    return TextFormField(
        focusNode: _emailFocusNode,
        controller: emailTextEditingController,
        validator: (value) {
          if (state is EmailInvalidState) {
            return 'Please enter correct email address';
          } else {
            return null;
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: true,
        onChanged: (value) {
          emailNumberBloc.add(EmailChange(value));
        },
        autocorrect: true,
        decoration: new InputDecoration(
          labelText: AppLocalizationsJson.of(context)!.translate('email'),
        ));
  }

  Widget _renderSignUpWithPhoneButton() {
    return TextButton(
        onPressed: _changeWidget,
        child: Text(
          AppLocalizationsJson.of(context)!.translate('signUpWithPhoneInstead'),
          style: TextStyle(color: Colors.blue, fontSize: 14),
        ));
  }

  void _changeWidget() {
    setState(() {
      email = !email;

      if (email) {
        FocusScope.of(context).requestFocus(_emailFocusNode);
        emailNumberBloc.add(EmailChange(emailTextEditingController.text));
      } else {
        FocusScope.of(context).requestFocus(_numberFocusNode);
        emailNumberBloc.add(NumberChange(
            numberTextEditingController.text,
            lastCountryCode == null
                ? 8
                : lastCountryCode!.numberExample.length));
      }
    });
  }

  void _routeusernameFromEmail() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PickUsernamePage(
                  user: User(
                      firstName: widget.user.firstName,
                      lastName: widget.user.lastName,
                      birthDate: widget.user.birthDate,
                      email: emailTextEditingController.text,
                      phone: '',
                      country: ''),
                )));
  }

  //ROUTE USERNAME CHANGE NOTIFIER
  void _routeusernameFromPhone() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PickUsernamePage(
                  user: User(
                      firstName: widget.user.firstName,
                      lastName: widget.user.lastName,
                      birthDate: widget.user.birthDate,
                      country: _countryForChangeNotifier.name == ''
                          ? lastCountryCode!.isoCode
                          : _countryForChangeNotifier.isoCode,
                      phone: _countryForChangeNotifier.name == ''
                          ? '+' +
                              lastCountryCode!.numberCode +
                              numberTextEditingController.text
                          : '+' +
                              _countryForChangeNotifier.numberCode +
                              numberTextEditingController.text,
                      email: ''),
                )));
  }

  //
  //
  //ROUTE USER NAME VALUE NOTIFIER
  /*  void _routeusernameFromPhone() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PickUsernamePage(
                  user: User(
                      firstName: widget.user.firstName,
                      lastName: widget.user.lastName,
                      birthDate: widget.user.birthDate,
                      country: lastCountryCode!.isoCode,
                      phone: _countryValueNotifier.value.name == ''
                          ? '+' +
                              lastCountryCode!.numberCode +
                              numberTextEditingController.text
                          : '+' +
                              _countryValueNotifier.value.name +
                              numberTextEditingController.text,
                      email: ''),
                )));
  }
 */
//ROUTE COUNTRY CALLBAKC FUNCTIONOV
/*   void _routeCountryCode() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CountryCodePage(
                onTapCountry: (CountryCode countryCode) {
                  setState(() {
                    if (lastCountryCode!.name != countryCode.name)
                      numberTextEditingController.text = '';
                    emailNumberBloc.add(SetCountryCode(countryCode));

                    emailNumberBloc.add(NumberChange(
                        numberTextEditingController.text,
                        lastCountryCode!.numberExample.length));
                  });
                },
              )),
    );
  } */
  //ROUTE CHANGE NOTIFIEROV
  void _routeCountryCode(CountryNotifier value) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context2) => ChangeNotifierProvider.value(
              value: Provider.of<CountryNotifier>(context, listen: false),
              child: CountryCodePage()),
        ));
  }

//ROUTE VALUE NOTIFIER
  /* void _routeCountryCode(CountryCode value) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context2) =>
              CountryCodePage(onTapCountry: (CountryCode countryCode) {
                if (value.name != countryCode.name) {
                  _countryValueNotifier.value = countryCode;
                  numberTextEditingController.text = '';
                  emailNumberBloc.add(NumberChange(
                      numberTextEditingController.text,
                      countryCode.numberExample.length));
                }
              })),
    );
  } */
  void _checkEquality() {
    var selectedCountry =
        Provider.of<CountryNotifier>(context, listen: false).countryCode;
    if (_countryForChangeNotifier.name == '' &&
        lastCountryCode!.name != selectedCountry!.name) {
      _countryForChangeNotifier = selectedCountry;
      numberTextEditingController.text = '';
      emailNumberBloc.add(NumberChange(numberTextEditingController.text,
          selectedCountry.numberExample.length));
    }
    if (_countryForChangeNotifier.name != '' &&
        _countryForChangeNotifier.name == selectedCountry!.name) {
      _countryForChangeNotifier = selectedCountry;
      numberTextEditingController.text = '';
      emailNumberBloc.add(NumberChange(numberTextEditingController.text,
          selectedCountry.numberExample.length));
    }
  }
}
//CALLBACK FUNCTION
/* CountryCodePage(onTapCountry: (CountryCode countryCode) {
                if (Provider.of<CountryNotifier>(context, listen: false)
                    .checkEquality(value, countryCode)) {
                  _countryForChangeNotifier = value.countryCode!;
                  numberTextEditingController.text = '';
                  emailNumberBloc.add(NumberChange(
                      numberTextEditingController.text,
                      countryCode.numberExample.length));
                }
              })), */