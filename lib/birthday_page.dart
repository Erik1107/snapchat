import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snapchat/app_localizations.dart';
import 'package:snapchat/model/app_bar.dart';
import 'package:snapchat/email_phone_page.dart';
import 'package:snapchat/model/country_notifier.dart';
import 'package:snapchat/validation_repository.dart';
import 'birthday_bloc/birthday_bloc.dart';
import 'birthday_bloc/birthday_event.dart';
import 'birthday_bloc/birthday_state.dart';
import 'model/country_code_class.dart';
import 'model/user_class.dart';

class BirthdayPage extends StatefulWidget {
  const BirthdayPage({
    required this.user,
    Key? key,
  }) : super(key: key);
  final User user;
  @override
  _BirthdayPageState createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  DateTime validDate = DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch - (16 * 36525 * 24 * 60 * 60 * 10));
  DateTime dateTimeSelectedNow = DateTime.now();
  final textfieldcontroller = TextEditingController();

  String? selectedDateTime;
  bool changeButtonColor = false;
  final birthDaybloc = BirthdayBloc(ValidationRepository());
  DateTime _pickDateTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    textfieldcontroller.text = DateFormat('dd MMMM yyyy').format(validDate);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => birthDaybloc,
      child: BlocListener(
        bloc: birthDaybloc,
        listener: (BuildContext context, state) {
          if (state is BirthdayStateInvalid) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return _showAlertDialog(context: context);
              },
            );
          }
        },
        child: BlocBuilder<BirthdayBloc, BirthdayState>(
            builder: (context, state) => _renderBirthDatePage(state)),
      ),
    );
  }

  Widget _renderBirthDatePage(BirthdayState state) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                AppLocalizationsJson.of(context)!
                    .translate('whensYourBirthday'),
                style: TextStyle(color: Colors.black, fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 50, right: 50),
            child: TextFormField(
              readOnly: true,
              enabled: false,
              controller: textfieldcontroller,
              decoration: new InputDecoration(
                  labelText:
                      AppLocalizationsJson.of(context)!.translate('birthday')),
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (state is BirthdayStateInvalid) {
                  return 'Sorry,our users cant be elder than 16 years';
                }
                return null;
              },
            ),
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: _renderButton(state)),
              _renderDatePicker(state)
            ],
          ))
        ],
      ),
    );
  }

  Widget _renderDatePicker(BirthdayState state) {
    return Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.bottomCenter,
        color: Colors.white,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              _dateChanged(_pickDateTime);
              birthDaybloc
                  .add(BirthdayDateChanged(_pickDateTime, dateTimeSelectedNow));

              return true;
            } else {
              return false;
            }
          },
          child: CupertinoDatePicker(
            maximumDate: dateTimeSelectedNow,
            initialDateTime: validDate,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (datetime) {
              _pickDateTime = datetime;
            },
          ),
        ));
  }

  Widget _renderButton(BirthdayState state) {
    return TextButton(
      style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(Size(200, 30)),
          backgroundColor: state is BirthdayStateValid
              ? MaterialStateProperty.all(Colors.blue)
              : MaterialStateProperty.all(Colors.grey),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ))),
      onPressed: state is BirthdayStateValid ? _routeEmail : null,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Text(
          AppLocalizationsJson.of(context)!.translate('continueAction'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  void _dateChanged(dateTime) {
    selectedDateTime = DateFormat('dd MMMM yyyy').format(dateTime);
    textfieldcontroller.text = selectedDateTime!;
  }

  void _routeEmail() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ChangeNotifierProvider<CountryNotifier>(
                    create: (context) => CountryNotifier(CountryCode(
                        isoCode: '',
                        name: '',
                        numberCode: '',
                        numberExample: '')),
                    child: PhoneNumberEmailPage(
                      user: User(
                          firstName: widget.user.firstName,
                          lastName: widget.user.lastName,
                          birthDate: textfieldcontroller.text),
                    ))));
  }

  Widget _showAlertDialog({required BuildContext context}) {
    Widget okButton = TextButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    var alert = AlertDialog(
      title: Text('Warning'),
      content: Text("Sorry, our users can't be younger than 16 years old."),
      actions: [
        okButton,
      ],
    );
    return alert;
  }
}
