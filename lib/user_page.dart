import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snapchat/app_localizations.dart';

import 'package:snapchat/edit_user_page.dart';
import 'package:snapchat/main.dart';
import 'package:snapchat/model/user_info_rows.dart';
import 'package:snapchat/model/user_manage_button.dart';
import 'package:snapchat/user_bloc/user_bloc.dart';
import 'package:snapchat/user_bloc/user_event.dart';
import 'package:snapchat/user_bloc/user_state.dart';
import 'package:snapchat/user_repository_mongo.dart';

import 'model/alert_message.dart';
import 'model/country_code_class.dart';
import 'model/country_notifier.dart';
import 'model/user_class.dart';

class UserPage extends StatefulWidget {
  const UserPage({
    Key? key,
    this.user,
  }) : super(key: key);
  final User? user;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  User? _mainUser;
  UserBloc userBloc = UserBloc(UserRepositoryMongo());

  User? get mongoUser => userBloc.mongoUser;
  User? get updatedUser => userBloc.updateduser;

  @override
  void initState() {
    super.initState();
    if (widget.user == null) {
      userBloc.add(GetUserMongo());
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return BlocListener(
      bloc: userBloc,
      listener: (BuildContext context, UserState state) {
        _listener(state);
      },
      child: BlocProvider(
          create: (context) => userBloc,
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) => _renderUserPage(state),
          )),
    );
  }

  Future<void> _listener(UserState state) async {
    if (state is MongoUserValidState) {
      _mainUser = mongoUser;

      userBloc.add(UpdateUserFromServer());
    }
    if (state is MongoUserInvalidState) {
      userBloc.add(UpdateUserFromServer());
    }
    if (state is UserUpdatedValidState) {
      _mainUser = updatedUser;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User information has been updated.'),
        ),
      );
    }
    if (state is UserUpdatedInvalidState) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return showAlertDialog(
              context: context,
              onPressFunction: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SnapChatApp()));
              },
              message: state.errorMessage);
        },
      );
    }
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
    if (state is UserDeletedValidState) await _logOut();
    if (state is UserDeletedInvalidState) {
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

  Widget _renderUserPage(UserState state) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: Column(children: [
          Expanded(
              child: Column(
            children: [
              userInfo(
                  40,
                  state is MongoUserValidState || state is UserUpdatedValidState
                      ? AppLocalizationsJson.of(context)!
                              .translate('firstName') +
                          ':' +
                          _mainUser!.firstName
                      : widget.user != null
                          ? AppLocalizationsJson.of(context)!
                                  .translate('firstName') +
                              ':' +
                              widget.user!.firstName
                          : 'Firstname:loading'),
              userInfo(
                  10,
                  state is MongoUserValidState || state is UserUpdatedValidState
                      ? AppLocalizationsJson.of(context)!
                              .translate('lastName') +
                          ':' +
                          _mainUser!.lastName
                      : widget.user != null
                          ? AppLocalizationsJson.of(context)!
                                  .translate('lastName') +
                              ':' +
                              widget.user!.lastName
                          : 'Lastname:loading'),
              userInfo(
                  10,
                  state is MongoUserValidState || state is UserUpdatedValidState
                      ? AppLocalizationsJson.of(context)!.translate('email') +
                          ':' +
                          _mainUser!.email
                      : widget.user != null
                          ? AppLocalizationsJson.of(context)!
                                  .translate('email') +
                              ':' +
                              widget.user!.email
                          : 'Email:loading'),
              userInfo(
                  10,
                  state is MongoUserValidState || state is UserUpdatedValidState
                      ? AppLocalizationsJson.of(context)!
                              .translate('mobileNumber') +
                          ':' +
                          _mainUser!.phone
                      : widget.user != null
                          ? AppLocalizationsJson.of(context)!
                                  .translate('mobileNumber') +
                              ':' +
                              widget.user!.phone
                          : 'Phone:loading'),
              userInfo(
                  10,
                  state is MongoUserValidState || state is UserUpdatedValidState
                      ? AppLocalizationsJson.of(context)!
                              .translate('userName') +
                          ':' +
                          _mainUser!.name
                      : widget.user != null
                          ? AppLocalizationsJson.of(context)!
                                  .translate('userName') +
                              ':' +
                              widget.user!.name
                          : 'Name:loading'),
              userInfo(
                  10,
                  state is MongoUserValidState || state is UserUpdatedValidState
                      ? AppLocalizationsJson.of(context)!
                              .translate('birthday') +
                          ':' +
                          DateFormat('dd MMMM yyyy')
                              .format(DateTime.parse(_mainUser!.birthDate))
                      : widget.user != null
                          ? AppLocalizationsJson.of(context)!
                                  .translate('birthday') +
                              ':' +
                              DateFormat('dd MMMM yyyy').format(
                                  DateTime.parse(widget.user!.birthDate))
                          : 'Birthdate:loading'),
              userInfo(
                  10,
                  state is MongoUserValidState || state is UserUpdatedValidState
                      ? AppLocalizationsJson.of(context)!
                              .translate('password') +
                          ':' +
                          _mainUser!.password
                      : widget.user != null
                          ? AppLocalizationsJson.of(context)!
                                  .translate('password') +
                              ':' +
                              widget.user!.password
                          : 'Password:loading'),
            ],
          )),
          Wrap(children: [
            Column(
              children: [
                UserButton(
                    buttonText:
                        AppLocalizationsJson.of(context)!.translate('editUser'),
                    color: Colors.blue,
                    function: _routeEditUserPage),
                UserButton(
                    buttonText: AppLocalizationsJson.of(context)!
                        .translate('deleteUser'),
                    color: Colors.red,
                    function: () {
                      userBloc.add(DeleteUser());
                    }),
                UserButton(
                    buttonText:
                        AppLocalizationsJson.of(context)!.translate('logOut'),
                    color: Colors.yellow,
                    function: () {
                      userBloc.add(LogOutUser());
                      _logOut();
                    }),
              ],
            ),
          ])
        ]),
      ),
    );
  }

  void _routeEditUserPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<CountryNotifier>(
                create: (context) => CountryNotifier(CountryCode(
                    isoCode: '', name: '', numberCode: '', numberExample: '')),
                child: EditUserPage(
                  user: _mainUser ?? widget.user,
                ))));
  }

  Future<void> _logOut() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SnapChatApp()),
        (route) => false);
  }
}
