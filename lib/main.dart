import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/app_localizations.dart';
import 'package:snapchat/user_page.dart';
import 'package:snapchat/user_repository_mongo.dart';
import 'firstname_lastname_page.dart';
import 'login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /* await RealmApp.init('snapchatapplication-eydlf');
  var app = RealmApp();

  try {
    await app.login(Credentials.anonymous());
  } on PlatformException catch (err) {} catch (error) {} */

  await UserRepositoryMongo().initialization();

  var prefs = await SharedPreferences.getInstance();
  var token = prefs.get('createdTokenForUser');

  if (token != null) {
    runApp(MaterialApp(
      localizationsDelegates: [
        AppLocalizationsJson.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('ru', ''),
      ],
      home: UserPage(),
    ));
  } else {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((value) => runApp(SnapChatApp()));
  }
}

class SnapChatApp extends StatelessWidget {
  const SnapChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsJson.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('ru', ''),
      ],
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SignUpLogInPage(),
      ),
    );
  }
}

class SignUpLogInPage extends StatefulWidget {
  SignUpLogInPage({Key? key}) : super(key: key);

  @override
  _SignUpLogInPageState createState() => _SignUpLogInPageState();
}

class _SignUpLogInPageState extends State<SignUpLogInPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(true);
      },
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: <Widget>[
            Expanded(
                flex: 5,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromRGBO(254, 252, 0, 1),
                    child: new Image.asset('assets/snapchatPhoto.png'))),
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: _renderLoginButton(),
                  ),
                  Expanded(
                    flex: 1,
                    child: _renderSignupButton(),
                  )
                ],
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget _renderSignupButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: _routeSignup,
        child: FittedBox(
          fit: BoxFit.fill,
          child: Text(
            AppLocalizationsJson.of(context)!.translate('signUp'),
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        style: TextButton.styleFrom(backgroundColor: Colors.blue),
      ),
    );
  }

  Widget _renderLoginButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: _routeLogin,
        child: FittedBox(
          fit: BoxFit.fill,
          child: Text(
            AppLocalizationsJson.of(context)!.translate('logIn'),
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.red.shade400,
        ),
      ),
    );
  }

  void _routeLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LogInPage()),
    );
  }

  void _routeSignup() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => FirstnameLastnamePage()));
  }
}
