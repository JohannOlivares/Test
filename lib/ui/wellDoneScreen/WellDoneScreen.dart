import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:run_tracker/common/commonTopBar/CommonTopBar.dart';
import 'package:run_tracker/common/ratingbottomsheetdialog/RatingDialog.dart';
import 'package:run_tracker/interfaces/TopBarClickListener.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/ui/home/HomeScreen.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Constant.dart';
import 'package:run_tracker/utils/Utils.dart';

import '../../custom/GradientButtonSmall.dart';
import '../../localization/language/languages.dart';
import '../../localization/language/languages.dart';
import '../../localization/language/languages.dart';

class WellDoneScreen extends StatefulWidget {
  const WellDoneScreen({Key key}) : super(key: key);

  @override
  _WellDoneScreenState createState() => _WellDoneScreenState();
}

class _WellDoneScreenState extends State<WellDoneScreen>
    implements TopBarClickListener {
  @override
  Widget build(BuildContext context) {
    var fullheight = MediaQuery.of(context).size.height;
    var fullwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colur.common_bg_dark,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: CommonTopBar(
                  "",
                  this,
                  isClose: true,
                  isDelete: true,
                ),
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: fullheight * 0.19,bottom: 25),
                        child: Text(
                          Languages.of(context).txtWellDone.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colur.txt_white,
                              fontSize: 30),
                        ),
                      ),
                      _mapScreenShot(fullheight, fullwidth),
                      _InformationViewOfDistance(fullheight, fullwidth),
                      _detailsAndShareButtonView(fullheight, fullwidth),
                      _satisfyListTile(fullheight, fullwidth),
                    ],
                  ),
                ),
                  Container(
                    width: fullwidth,
                    height: fullheight,
                    child: Lottie.asset(
                      'assets/animation/congratulation.json',
                      repeat: false,
                      alignment: Alignment.topCenter
                    ),
                  ),
                  Container(
                    child: Lottie.asset(
                      'assets/animation/thumbs_up.json',
                      width: 200,
                      height: 200,
                      repeat: true,
                    ),
                  ),

                ]
              ),
            ],
          ),
        ));
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.STR_DELETE) {
      Utils.showToast(context, "Delete Data");//TODO
    }
    if (name == Constant.STR_CLOSE) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/homeWizardScreen', (Route<dynamic> route) => false);
    }
  }

  _mapScreenShot(double fullheight, double fullwidth) {
    return Container(
      width: fullwidth,
      height: fullheight * 0.35,
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        child: Image.asset(
          'assets/images/dummy_map.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _InformationViewOfDistance(double fullheight, double fullwidth) {
    return Container(
      child: Column(
        children: [
          //THis ROW is For Duration and Distance Text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 2, bottom: 7),
                    child: Text(
                      Languages.of(context).txtDuration,
                      style: TextStyle(
                          color: Colur.txt_grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                  Container(
                    child: Text(
                      "00:40",
                      style: TextStyle(
                          color: Colur.txt_white,
                          fontWeight: FontWeight.w600,
                          fontSize: 35),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 2, bottom: 7),
                    child: Text(
                      Languages.of(context).txtDistanceKM,
                      style: TextStyle(
                          color: Colur.txt_grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                  Container(
                    child: Text(
                      "00:04",
                      style: TextStyle(
                          color: Colur.txt_white,
                          fontWeight: FontWeight.w600,
                          fontSize: 35),
                    ),
                  )
                ],
              )
            ],
          ),
          //This Row is For PAce || KCAL || MOVING TIME
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 2, bottom: 7),
                      child: Text(
                        Languages.of(context).txtPaceMinPerKM,
                        style: TextStyle(
                            color: Colur.txt_grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                    Container(
                      child: Text(
                        "00:00",
                        style: TextStyle(
                            color: Colur.txt_white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 2, bottom: 7),
                      child: Text(
                        Languages.of(context).txtKCAL,
                        style: TextStyle(
                            color: Colur.txt_grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                    Container(
                      child: Text(
                        "04",
                        style: TextStyle(
                            color: Colur.txt_white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 2, bottom: 7),
                      child: Text(
                        Languages.of(context).txtMovingTime,
                        style: TextStyle(
                            color: Colur.txt_grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                    Container(
                      child: Text(
                        "00:40",
                        style: TextStyle(
                            color: Colur.txt_white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _detailsAndShareButtonView(double fullheight, double fullwidth) {
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GradientButtonSmall(
            width: 160,
            height: 60,
            radius: 13.0,
            child: Text(
              Languages.of(context).txtDetails,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colur.txt_white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colur.progress_background_color,
                Colur.progress_background_color,
              ],
            ),
            isShadow: false,
            onPressed: () {},
          ),
          GradientButtonSmall(
            width: 160,
            height: 60,
            radius: 13.0,
            child: Text(
              Languages.of(context).txtShare,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colur.txt_white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0),
            ),
            isShadow: false,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colur.purple_gradient_color1,
                Colur.purple_gradient_color2,
              ],
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  _satisfyListTile(double fullheight, double fullwidth) {
    return Container(
      color: Colur.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colur.ligh_green_For_NotReally,
              borderRadius: BorderRadius.all(Radius.circular(13)),
            ),
            margin: EdgeInsets.only(top: 50.0),
            child: Padding(
              padding: EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Text(
                    Languages.of(context).txtAreYouSatisfiedWithDescription,
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colur.txt_white),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30,bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GradientButtonSmall(
                          width: 160,
                          height: 60,
                          radius: 10.0,
                          child: Text(
                            Languages.of(context).txtNotReally,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colur.txt_white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0),
                          ),
                          isShadow: false,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Colur.green_For_NotReally,
                              Colur.green_For_NotReally,
                            ],
                          ),
                          onPressed: () {},
                        ),
                        GradientButtonSmall(
                          width: 160,
                          height: 60,
                          radius: 10.0,
                          child: Text(
                            Languages.of(context).txtGood,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colur.txt_white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0),
                          ),
                          isShadow: false,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Colur.green_For_NotReally,
                              Colur.green_For_NotReally,
                            ],
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                isDismissible: false,
                                enableDrag: false,
                                builder: (context) {
                                  return Wrap(
                                    children: [
                                      RatingDialog(),
                                    ],
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                  )


                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
              width: 100.0,
              height: 100.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage("assets/images/dummy_girl.png")))),
      ]),
    );
  }
}
