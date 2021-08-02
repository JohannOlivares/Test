import 'package:flutter/material.dart';
import 'package:run_tracker/common/commonTopBar/CommonTopBar.dart';
import 'package:run_tracker/interfaces/TopBarClickListener.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Constant.dart';
import 'package:run_tracker/utils/Preference.dart';

class ProfileSettingScreen extends StatefulWidget {
  @override
  _ProfileSettingScreenState createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen>
    implements TopBarClickListener {
  List<String>? units;
  String? _unitsChosenValue;
  List<String>? languages;
  String? _languagesChosenValue;
  List<String>? days;
  String? _daysChosenValue;
  String? prefDays, prefLanguage, prefUnits;

  _getPreference() {
    prefUnits = Preference.shared.getString(Preference.METRIC_IMPERIAL_UNITS);
    if (prefUnits == null) {
      _unitsChosenValue = units![0];
    } else {
      _unitsChosenValue = prefUnits;
    }
    prefLanguage = Preference.shared.getString(Preference.LANGUAGE);
    if (prefLanguage == null) {
      _languagesChosenValue = languages![0];
    } else {
      _languagesChosenValue = prefLanguage;
    }
    prefDays = Preference.shared.getString(Preference.FIRST_DAY_OF_WEEK);
    if (prefDays == null) {
      _daysChosenValue = days![0];
    } else {
      _daysChosenValue = prefDays;
    }
  }

  @override
  Widget build(BuildContext context) {
    units = [Languages.of(context)!.txtKM, Languages.of(context)!.txtMILE];
    if (_unitsChosenValue == null) _unitsChosenValue = units![0];
    languages = [Languages.of(context)!.txtKM, Languages.of(context)!.txtMILE];
    if (_languagesChosenValue == null) _languagesChosenValue = languages![0];
    days = [
      Languages.of(context)!.txtSunday,
      Languages.of(context)!.txtMonday,
      Languages.of(context)!.txtSaturday
    ];
    if (_daysChosenValue == null) _daysChosenValue = days![0];
    _getPreference();

    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                child: CommonTopBar(
                  Languages.of(context)!.txtSettings,
                  this,
                  isShowBack: true,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/reminder');
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/ic_notification_white.webp",
                                scale: 4,
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Text(
                                    Languages.of(context)!.txtReminder,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colur.txt_white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colur.txt_grey,
                        indent: 20.0,
                        height: 40.0,
                        endIndent: 20.0,
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          Languages.of(context)!.txtUnitSettings.toUpperCase(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colur.txt_grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/ic_units.webp",
                              scale: 4,
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Text(
                                  Languages.of(context)!
                                      .txtMetricAndImperialUnits,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colur.txt_white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            DropdownButton<String>(
                              value: _unitsChosenValue,
                              elevation: 2,
                              style: TextStyle(
                                  color: Colur.txt_purple,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                              iconEnabledColor: Colur.white,
                              iconDisabledColor: Colur.white,
                              dropdownColor: Colur.progress_background_color,
                              underline: Container(
                                color: Colur.transparent,
                              ),
                              isDense: true,
                              items: units!.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _unitsChosenValue = value;
                                  Preference.clearMetricAndImperialUnits();
                                  Preference.shared.setString(
                                      Preference.METRIC_IMPERIAL_UNITS,
                                      _unitsChosenValue.toString());
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colur.txt_grey,
                        indent: 20.0,
                        height: 40.0,
                        endIndent: 20.0,
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          Languages.of(context)!
                              .txtGeneralSettings
                              .toUpperCase(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colur.txt_grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/icons/ic_languages.webp",
                                  scale: 4,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: Text(
                                      Languages.of(context)!.txtLanguageOptions,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colur.txt_white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: _languagesChosenValue,
                                  elevation: 2,
                                  style: TextStyle(
                                      color: Colur.txt_purple,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                  iconEnabledColor: Colur.white,
                                  iconDisabledColor: Colur.white,
                                  dropdownColor:
                                      Colur.progress_background_color,
                                  underline: Container(
                                    color: Colur.transparent,
                                  ),
                                  isDense: true,
                                  items: languages!
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      _languagesChosenValue = value;
                                      Preference.clearLanguage();
                                      Preference.shared.setString(
                                          Preference.LANGUAGE,
                                          _languagesChosenValue.toString());
                                    });
                                  },
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 30.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/ic_calender.webp",
                                    scale: 4,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Text(
                                        Languages.of(context)!
                                            .txtFirstDayOfWeek,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colur.txt_white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    value: _daysChosenValue,
                                    elevation: 2,
                                    style: TextStyle(
                                        color: Colur.txt_purple,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                    iconEnabledColor: Colur.white,
                                    iconDisabledColor: Colur.white,
                                    dropdownColor:
                                        Colur.progress_background_color,
                                    underline: Container(
                                      color: Colur.transparent,
                                    ),
                                    isDense: true,
                                    items: days!.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        _daysChosenValue = value;
                                        Preference.clearFirstDayOfWeek();
                                        Preference.shared.setString(
                                            Preference.FIRST_DAY_OF_WEEK,
                                            _daysChosenValue.toString());
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colur.txt_grey,
                        indent: 20.0,
                        height: 40.0,
                        endIndent: 20.0,
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          Languages.of(context)!.txtSupportUs.toUpperCase(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colur.txt_grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/ic_email.webp",
                              scale: 4,
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Text(
                                  Languages.of(context)!.txtFeedback,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colur.txt_white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/ic_star_white.webp",
                              scale: 4,
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Text(
                                  Languages.of(context)!.txtRateUs,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colur.txt_white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/ic_privacy_policy.webp",
                              scale: 4,
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Text(
                                  Languages.of(context)!.txtPrivacyPolicy,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colur.txt_white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.STR_BACK) {
      Navigator.pop(context);
    }
  }
}
