import 'package:emoji_flag_converter/emoji_flag_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:snapchat/model/app_bar.dart';
import 'package:snapchat/country_code_bloc/country_code_event.dart';
import 'package:snapchat/model/country_code_class.dart';
import 'package:snapchat/remote_country_code_repository.dart';
import 'country_code_bloc/country_code_bloc.dart';
import 'country_code_bloc/country_code_state.dart';
import 'model/country_code_class.dart';
import 'model/country_notifier.dart';

//CALLBACK FUNCTIONOV
/* class CountryCodePage extends StatefulWidget {
  const CountryCodePage({Key? key, required this.onTapCountry})
      : super(key: key);

  final Function(CountryCode countryCode) onTapCountry;

  @override
  _CountryCodePageState createState() => _CountryCodePageState();
}

class _CountryCodePageState extends State<CountryCodePage> {
  final countryCodebloc = CountryCodeBloc(RemoteCountyCodeRepository());
  List<CountryCode> get countryCodeSearched => countryCodebloc.countries;
  @override
  initState() {
    super.initState();
    countryCodebloc.add(CountryCodePageReloadFinish());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => countryCodebloc,
      child: BlocBuilder<CountryCodeBloc, CountryCodeState>(
          builder: (context, state) => _renderCountryList()),
    );
  }

  Widget _renderCountryList() {
    return Scaffold(
      appBar: AppBarWidget(),
      body: Center(
          child: Column(children: [
        Padding(
          padding: EdgeInsets.only(right: 20, left: 20),
          child: TextField(
            onChanged: (value) {
              countryCodebloc.add(CountryCodeChanged(value));
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.search),
                hintText: 'Search'),
          ),
        ),
        Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                itemCount: countryCodeSearched.isEmpty
                    ? 0
                    : countryCodeSearched.length,
                itemBuilder: (BuildContext buildContext, int index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: GestureDetector(
                      onTap: () {
                        /* Provider.of<CountryNotifier>(context, listen: false)
                            .checkEquality(value, countryCode); */
                        widget.onTapCountry(countryCodeSearched[index]);
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Text(
                                EmojiConverter.fromAlpha2CountryCode(
                                    countryCodeSearched[index].isoCode),
                                style: TextStyle(fontSize: 20)),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                countryCodeSearched[index].name,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ]),
                          Text(countryCodeSearched[index].numberCode,
                              style: TextStyle(fontSize: 20))
                        ],
                      ),
                    ),
                  );
                })),
      ])),
    );
  }
}
 */
//CHANGE NOTIFIER,LISTENEROV
class CountryCodePage extends StatefulWidget {
  const CountryCodePage({
    Key? key,
    /* required this.onTapCountry */
  }) : super(key: key);

  // final Function(CountryCode countryCode) onTapCountry;

  @override
  _CountryCodePageState createState() => _CountryCodePageState();
}

class _CountryCodePageState extends State<CountryCodePage> {
  final countryCodebloc = CountryCodeBloc(RemoteCountyCodeRepository());
  List<CountryCode> get countryCodeSearched => countryCodebloc.countries;
  @override
  initState() {
    super.initState();
    countryCodebloc.add(CountryCodePageReloadFinish());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => countryCodebloc,
      child: BlocBuilder<CountryCodeBloc, CountryCodeState>(
          builder: (context, state) => _renderCountryList()),
    );
  }

  Widget _renderCountryList() {
    return Scaffold(
      appBar: AppBarWidget(),
      body: Center(
          child: Column(children: [
        Padding(
          padding: EdgeInsets.only(right: 20, left: 20),
          child: TextField(
            onChanged: (value) {
              countryCodebloc.add(CountryCodeChanged(value));
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.search),
                hintText: 'Search'),
          ),
        ),
        Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                itemCount: countryCodeSearched.isEmpty
                    ? 0
                    : countryCodeSearched.length,
                itemBuilder: (BuildContext buildContext, int index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<CountryNotifier>(context, listen: false)
                            .setCountry(countryCodeSearched[index]);
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Text(
                                EmojiConverter.fromAlpha2CountryCode(
                                    countryCodeSearched[index].isoCode),
                                style: TextStyle(fontSize: 20)),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                countryCodeSearched[index].name,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ]),
                          Text(countryCodeSearched[index].numberCode,
                              style: TextStyle(fontSize: 20))
                        ],
                      ),
                    ),
                  );
                })),
      ])),
    );
  }
}
