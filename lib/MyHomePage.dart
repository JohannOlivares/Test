import 'package:flutter/material.dart';

import 'localization/language/languages.dart';
import 'localization/language_data.dart';
import 'localization/locale_constant.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);





  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedLanguage;



  @override
  void initState() {
    getLocale().then((locale) {
      setState(() {
        selectedLanguage = locale.languageCode;
      });
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.language,

            color: Colors.white,
          ),
          title: Text(Languages
              .of(context)
              .appName),
        ),
        body: Container(
          margin: EdgeInsets.all(30),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 80,
                ),
                Text(
                  Languages
                      .of(context)
                      .labelWelcome,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  Languages
                      .of(context)
                      .labelInfo,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                  textAlign: TextAlign.center,

                ),
                SizedBox(
                  height: 70,
                ),
                _createLanguageDropDown(),
              /*  TextButton(onPressed: () {
                },
                  child: Text("Play Sound"),
                  style: TextButton.styleFrom(
                      primary: Colors.purple,
                      backgroundColor: Colors.amber,
                      textStyle: TextStyle(fontSize: 24, fontStyle: FontStyle.italic)),
                )*/
              ],
            ),
          ),
        ),
      );

  _createLanguageDropDown() {
    return DropdownButton<LanguageData>(
      iconSize: 30,
      hint: Text(Languages
          .of(context)
          .labelSelectLanguage),
      onChanged: (LanguageData language) {
        selectedLanguage = language.languageCode;
        changeLanguage(context, language.languageCode);
      },
      items: LanguageData.languageList()
          .map<DropdownMenuItem<LanguageData>>(
            (e) =>
            DropdownMenuItem<LanguageData>(
              value: e,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    e.flag,
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(e.name)
                ],
              ),
            ),
      )
          .toList(),
    );
  }
}
