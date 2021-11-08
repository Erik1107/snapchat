import 'package:emoji_flag_converter/emoji_flag_converter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/app_localizations.dart';
import 'package:snapchat/edit_user_bloc/edit_user_bloc.dart';
import 'package:snapchat/edit_user_bloc/edit_user_event.dart';
import 'package:snapchat/edit_user_bloc/edit_user_state.dart';
import 'package:snapchat/model/alert_message.dart';
import 'package:snapchat/model/app_bar.dart';
import 'package:snapchat/remote_country_code_repository.dart';
import 'package:snapchat/user_page.dart';
import 'package:snapchat/user_repository_mongo.dart';
import 'package:snapchat/validation_repository.dart';
import 'package:snapchat/validation_type.dart';
import 'country_code_page.dart';
import 'model/country_code_class.dart';
import 'model/country_notifier.dart';
import 'model/user_class.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({
    required this.user,
    Key? key,
  }) : super(key: key);
  final User? user;

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  RemoteCountyCodeRepository remoteCountyCodeRepository =
      RemoteCountyCodeRepository();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  EditUserBloc editUserBloc = EditUserBloc(ValidationRepository(),
      RemoteCountyCodeRepository(), UserRepositoryMongo());
  CountryCode _countryForChangeNotifier =
      CountryCode(isoCode: '', name: '', numberCode: '', numberExample: '');
  String phoneNumber = '';
  CountryCode? get userCountry => editUserBloc.userCountry;
  DateTime _selectedDateTime = DateTime.now();

  User? get editedUser => editUserBloc.editedUser;
  String initalFirstName = '';
  String initalLastname = '';
  String initalEmail = '';
  String initalName = '';
  DateTime initalBirthDate = DateTime.now();
  String initalPassword = '';
  String initalPhone = '';
  String isoCode = '';

  @override
  void initState() {
    super.initState();
    editUserBloc.add(EditUserPageLoad(widget.user!.country));
    Provider.of<CountryNotifier>(context, listen: false)
        .addListener(_checkEquality);
    _initalization();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => editUserBloc,
      child: BlocListener(
        listener: (BuildContext context, EditUserState state) async {
          _listener(state);
        },
        bloc: editUserBloc,
        child: BlocBuilder<EditUserBloc, EditUserState>(
            builder: (context, state) => _renderEditUserPage(state)),
      ),
    );
  }

  Future<void> _listener(EditUserState state) async {
    if (state is UserCountryChangedState) {
      isoCode = userCountry!.isoCode;
    }
    if (state is EditUserLoadedState) {
      var phoneNumber;
      // if (widget.user != null) {
      phoneNumber = widget.user!.phone != ''
          ? widget.user!.phone.replaceAll('+' + userCountry!.numberCode, '')
          : '';
      //  }
      // phoneNumber = '';

      phoneController.text = phoneNumber;
      initalPhone = phoneNumber;
    }

    if (state is UserInfoValidState) {
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.get('createdTokenForUser');

      editUserBloc.add(EditUser(
        token!,
        initalFirstName,
        initalLastname,
        initalEmail,
        initalPhone,
        initalBirthDate,
        initalName,
        initalPassword,
        firstNameController.text,
        lastNameController.text,
        emailController.text,
        _countryForChangeNotifier.name == ''
            ? '+' + userCountry!.numberCode + phoneController.text
            : '+' + _countryForChangeNotifier.numberCode + phoneController.text,
        _selectedDateTime,
        nameController.text,
        passwordController.text,
        _countryForChangeNotifier.name == ''
            ? userCountry!.isoCode
            : _countryForChangeNotifier.isoCode,
      ));
      initalFirstName = firstNameController.text;
      initalLastname = lastNameController.text;
      initalEmail = emailController.text;
      initalPhone = phoneController.text;
      initalBirthDate = _selectedDateTime;
      initalName = nameController.text;
      initalPassword = passwordController.text;
    }

    if (state is NoInternetConnectionState) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return showAlertDialog(
                context: context,
                onPressFunction: () {},
                message: 'Connect to internet');
          });
    }
    if (state is UserInfoInvalidState) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return _renderErrors(state);
          });
    }
    if (state is UserEditedInvalidState) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return showAlertDialog(
                context: context,
                onPressFunction: () {},
                message: state.errorMessage);
          });
    }
    if (state is UserEditedValidState) {
      FocusScope.of(context).requestFocus(FocusNode());

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => UserPage(
                    user: editedUser,
                  )),
          (route) => false);
    }
  }

  Widget _renderEditUserPage(EditUserState state) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBarWidget(),
        backgroundColor: Colors.white,
        body: Column(children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                _renderEditField(
                    Validation.FirstName,
                    state,
                    firstNameController,
                    TextInputType.name,
                    AppLocalizationsJson.of(context)!.translate('firstName') +
                        ':',
                    30),
                _renderEditField(
                    Validation.LastName,
                    state,
                    lastNameController,
                    TextInputType.name,
                    AppLocalizationsJson.of(context)!.translate('lastName') +
                        ':',
                    7),
                _renderBirthDateField(state),
                _renderEditField(
                    Validation.Email,
                    state,
                    emailController,
                    TextInputType.emailAddress,
                    AppLocalizationsJson.of(context)!.translate('email') + ':',
                    7),
                _renderPhoneField(state),
                _renderEditField(
                    Validation.UserName,
                    state,
                    nameController,
                    TextInputType.name,
                    AppLocalizationsJson.of(context)!.translate('userName') +
                        ':',
                    7),
                _renderEditField(
                    Validation.Password,
                    state,
                    passwordController,
                    TextInputType.visiblePassword,
                    AppLocalizationsJson.of(context)!.translate('password') +
                        ':',
                    7),
              ],
            ),
          )),
          state is ProgressIndicatorValidState
              ? Wrap(children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  )
                ])
              : _renderEditButton(),
        ]),
      ),
    );
  }

  //ARANDZ CONSUMER
  /*  Widget _renderPhoneField(EditUserState state) {
    return Padding(
      padding: EdgeInsets.only(right: 30, left: 30, top: 7),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        maxLength: userCountry == null ? 5 : userCountry!.numberExample.length,
        controller: phoneController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (state is InfoInvalidState) {
            if (state.validation == Validation.Phone)
              return 'Please enter correct phone number';
            return null;
          }
        },
        onChanged: (String value) {
          editUserBloc.add(UserValidation(Validation.Phone,
              phoneController.text, userCountry!.numberExample.length));
        },
        decoration: InputDecoration(
          prefixIcon: Row(children: [
            Text(
              AppLocalizationsJson.of(context)!.translate('mobileNumber') + ':',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              child: Wrap(children: [
                Row(
                  children: [
                    Text(EmojiConverter.fromAlpha2CountryCode(isoCode),
                        style: TextStyle(fontSize: 17)),
                    Text(userCountry != null
                        ? '+' + userCountry!.numberCode
                        : '...'),
                    Text('|'),
                  ],
                )
              ]),
              onTap: () {
                _changeCountry();
              },
            ),
          ]),
          prefixIconConstraints: BoxConstraints(maxWidth: 190),
        ),
      ),
    );
  }
 */

//CONSUMER
  Widget _renderPhoneField(EditUserState state) {
    return Consumer<CountryNotifier>(
        builder: (BuildContext context, value, Widget? child) {
      return Padding(
        padding: EdgeInsets.only(right: 30, left: 30, top: 7),
        child: TextFormField(
          keyboardType: TextInputType.phone,
          maxLength: value.countryCode!.name == ''
              ? userCountry == null
                  ? 5
                  : userCountry!.numberExample.length
              : value.countryCode!.numberExample.length,
          controller: phoneController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (state is InfoInvalidState) {
              if (state.validation == Validation.Phone) {
                return 'Please enter correct phone number';
              }

              return null;
            }
          },
          onChanged: (String value2) {
            editUserBloc.add(UserValidation(
                Validation.Phone,
                phoneController.text,
                value.countryCode!.name == ''
                    ? userCountry!.numberExample.length
                    : value.countryCode!.numberExample.length));
          },
          decoration: InputDecoration(
            prefixIcon: Row(children: [
              Text(
                AppLocalizationsJson.of(context)!.translate('mobileNumber') +
                    ':',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                child: Wrap(children: [
                  Row(
                    children: [
                      Text(
                          EmojiConverter.fromAlpha2CountryCode(
                              value.countryCode!.name == ''
                                  ? isoCode
                                  : value.countryCode!.isoCode),
                          style: TextStyle(fontSize: 17)),
                      Text(value.countryCode!.name == ''
                          ? userCountry != null
                              ? '+' + userCountry!.numberCode
                              : '...'
                          : '+' + value.countryCode!.numberCode),
                      Text('|'),
                    ],
                  )
                ]),
                onTap: () {
                  _changeCountry();
                },
              ),
            ]),
            prefixIconConstraints: BoxConstraints(maxWidth: 190),
          ),
        ),
      );
    });
  }

  Widget _renderBirthDateField(EditUserState state) {
    return Padding(
      padding: EdgeInsets.only(right: 30, left: 30, top: 7),
      child: TextFormField(
        readOnly: true,
        controller: birthDateController,
        autovalidateMode: AutovalidateMode.always,
        validator: (value) {
          if (state is InfoInvalidState) {
            if (state.validation == Validation.BirthDate) {
              return 'Sorry,our users cant be elder than 16 years';
            }

            return null;
          }
        },
        onChanged: (String value) {},
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              AppLocalizationsJson.of(context)!.translate('birthday') + ':',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          suffixIcon: GestureDetector(
            child: Icon(Icons.calendar_today),
            onTap: _changeDate,
          ),
        ),
      ),
    );
  }

  void _initalization() {
    isoCode = widget.user!.country != '' ? widget.user!.country : 'AM';

    firstNameController.text = widget.user!.firstName;
    lastNameController.text = widget.user!.lastName;
    emailController.text = widget.user!.email;

    nameController.text = widget.user!.name;
    _selectedDateTime = DateTime.parse(widget.user!.birthDate);
    birthDateController.text = DateFormat('dd MMMM yyyy')
        .format(DateTime.parse(widget.user!.birthDate));
    passwordController.text = widget.user!.password;

    initalFirstName = widget.user!.firstName;
    initalLastname = widget.user!.lastName;

    initalEmail = widget.user!.email;
    initalName = widget.user!.name;
    initalBirthDate = DateTime.parse(widget.user!.birthDate);
    initalPassword = widget.user!.password;
  }

  Widget _renderEditField(
      var validationType,
      EditUserState state,
      TextEditingController controller,
      TextInputType inputType,
      String info,
      double a) {
    return Padding(
      padding: EdgeInsets.only(left: 30, top: a, right: 30),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (state is InfoInvalidState) {
            if (validationType == Validation.FirstName &&
                state.validation == Validation.FirstName) {
              return 'Please enter your name(at least 3 symbol)';
            }

            if (validationType == Validation.LastName &&
                state.validation == Validation.LastName) {
              return 'Please enter your lastname(at least 2 symbol)';
            }

            if (validationType == Validation.Email &&
                state.validation == Validation.Email) {
              return 'Please enter correct email address';
            }

            if (state.validation == Validation.UserName) {
              return 'Username must be at least 5 charecters';
            }

            if (state.validation == Validation.UserName) {
              return 'Your password should be at least 8\n charachters.';
            }
          }
          return null;
        },
        onChanged: (String value) {
          editUserBloc
              .add(UserValidation(validationType, controller.text, null));
        },
        keyboardType: inputType,
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            info,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        )),
      ),
    );
  }

  void _changeDate() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return _showCupertino(
            context: context,
          );
        });
  }

  //CALLBACK
  /* void _changeCountry() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CountryCodePage(
                  onTapCountry: (CountryCode countryCode) {
                    setState(() {
                      if (userCountry!.isoCode != countryCode.isoCode) {
                        editUserBloc.add(SetCountryCode(countryCode));
                        phoneController.text = '';
                      }
                    });
                  },
                )));
  } */
  //CHANGE NOTIFIER
  void _changeCountry() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context2) => ChangeNotifierProvider.value(
                value: Provider.of<CountryNotifier>(context, listen: false),
                child: CountryCodePage())));
  }

  ///
  Widget _showCupertino({
    required BuildContext context,
  }) {
    Widget okButton = TextButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.pop(context);
        birthDateController.text =
            DateFormat('dd MMMM yyyy').format(_selectedDateTime);
        editUserBloc.add(UserValidation(
            Validation.BirthDate,
            _selectedDateTime.millisecondsSinceEpoch,
            DateTime.now().millisecondsSinceEpoch));
      },
    );

    var alert = AlertDialog(
      title: Text(
          "Choose birthdate(our users can't be younger than 16 years old)."),
      content: Container(
        color: Colors.white,
        height: 250,
        width: 250,
        child: CupertinoDatePicker(
          backgroundColor: Colors.white,
          maximumDate: DateTime.now(),
          initialDateTime: _selectedDateTime,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (datetime) {
            _selectedDateTime = datetime;
          },
        ),
      ),
      actions: [
        okButton,
      ],
    );
    return alert;
  }

  Widget _renderEditButton() {
    return TextButton(
      style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(Size(200, 30)),
          backgroundColor: MaterialStateProperty.all(Colors.red),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ))),
      onPressed: () {
        editUserBloc.add(ProgressIndicatorShowEvent());
        // ignore: cascade_invocations
        editUserBloc.add(EditUserValidation(
            initalFirstName,
            initalLastname,
            initalEmail,
            initalName,
            initalBirthDate,
            initalPassword,
            initalPhone,
            firstNameController.text,
            lastNameController.text,
            emailController.text,
            nameController.text,
            _selectedDateTime,
            passwordController.text,
            phoneController.text,
            _countryForChangeNotifier.name == ''
                ? userCountry!.numberExample.length
                : _countryForChangeNotifier.numberExample.length));
      },
      child: FittedBox(
        fit: BoxFit.fill,
        child: Text(
          AppLocalizationsJson.of(context)!.translate('saveChanges'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _renderErrors(UserInfoInvalidState state) {
    Widget okButton = TextButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        birthDateController.text =
            DateFormat('dd MMMM yyyy').format(_selectedDateTime);
      },
    );

    var alert = AlertDialog(
      title: Text('Invalid values'),
      content: Container(
        width: 200,
        height: 200,
        child: ListView.builder(
            itemCount: state.errors.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(state.errors[index]),
              );
            }),
      ),
      actions: [
        okButton,
      ],
    );
    return alert;
  }

  void _checkEquality() {
    var selectedCountry =
        Provider.of<CountryNotifier>(context, listen: false).countryCode;

    if (_countryForChangeNotifier.name == '' &&
        userCountry!.name != selectedCountry!.name) {
      _countryForChangeNotifier = selectedCountry;
      phoneController.text = '';
    }
    if (_countryForChangeNotifier.name != '' &&
        _countryForChangeNotifier.name != selectedCountry!.name) {
      _countryForChangeNotifier = selectedCountry;
      phoneController.text = '';
    }
  }
}
