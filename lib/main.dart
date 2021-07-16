import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:run_tracker/MyHomePage.dart';
import 'package:run_tracker/common/bottombar/BottomBar.dart';
import 'package:run_tracker/ui/countdowntimer/CountdownTimerScreen.dart';
import 'package:run_tracker/ui/home/HomeScreen.dart';
import 'package:run_tracker/ui/home/HomeWizardScreen.dart';
import 'package:run_tracker/ui/profile/ProfileScreen.dart';
import 'package:run_tracker/ui/drinkWaterScreen/DrinkWaterLevelScreen.dart';
import 'package:run_tracker/ui/settings/SettingScreen.dart';
import 'package:run_tracker/ui/startRun/PausePopupScreen.dart';
import 'package:run_tracker/ui/startRun/StartRunScreen.dart';
import 'package:run_tracker/ui/useLocation/UseLocationScreen.dart';
import 'package:run_tracker/ui/weeklygoalSetScreen/WeeklyGoalSetScreen.dart';
import 'package:run_tracker/ui/wellDoneScreen/WellDoneScreen.dart';
import 'package:run_tracker/ui/wizardScreen/GenderScreen.dart';
import 'package:run_tracker/ui/WelcomeDialogScreen.dart';
import 'package:run_tracker/ui/wizardScreen/WizardScreen.dart';
import 'package:run_tracker/utils/Color.dart';

import 'localization/locale_constant.dart';
import 'localization/localizations_delegate.dart';
import 'ui/wizardScreen/GenderScreen.dart';
import 'ui/wizardScreen/WizardScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            child: child,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
        theme: ThemeData(
          splashColor: Colur.transparent,
          highlightColor: Colur.transparent,
          fontFamily: 'Roboto',
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        locale: _locale,
        supportedLocales: [
          Locale('en', ''),
          Locale('ar', ''),
          Locale('hi', '')
        ],
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale?.languageCode == locale?.languageCode &&
                supportedLocale?.countryCode == locale?.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales?.first;
        },
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Colur.white,
          accentIconTheme: IconThemeData(color: Colur.white),
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            backgroundColor: Colur.transparent,
          ),
        ),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colur.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colur.common_bg_dark,
          ),
          // child: WeeklyGoalSetScreen(),
          // child: CountdownTimerScreen(isGreen: false),
          child: WizardScreen(),
          //child: RegistrationScreen(),
        ),
        routes: <String, WidgetBuilder>{
           '/settingScreen': (BuildContext context) => SettingScreen(),
           '/startrunScreen': (BuildContext context) => StartRunScreen(),
           '/wellDoneScreen': (BuildContext context) => WellDoneScreen(),
           '/profileScreen': (BuildContext context) => ProfileScreen(),
           '/homeWizardScreen': (BuildContext context) => HomeWizardScreen(),
           '/uselocationScreen': (BuildContext context) => UseLocationScreen(),
      /*'/changeusername': (BuildContext context) =>
          ChangeUsernameScreen(),
      '/changepassword': (BuildContext context) =>
          ChangePasswordScreen(),*/
        });
  }
}
