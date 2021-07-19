
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/common/commonTopBar/CommonTopBar.dart';
import 'package:run_tracker/interfaces/TopBarClickListener.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Constant.dart';

class RecentActivitiesScreen extends StatefulWidget {
  @override
  _RecentActivitiesScreenState createState() => _RecentActivitiesScreenState();
}

class _RecentActivitiesScreenState extends State<RecentActivitiesScreen> implements TopBarClickListener{
  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                child: CommonTopBar(
                  Languages.of(context)!.txtRecentActivities,
                  this,
                  isShowBack: true,
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: 20,
                itemBuilder: (BuildContext context, int ) {
                  return recentActivitiesListTile(
                    fullHeight: fullHeight,
                    fullWidth: fullWidth,
                    img: "ic_route_map.png",
                    date: "Jun 3",
                    distance: "0.00 mile",
                    time: "00:00:00",
                    pace: "00.00 min/mi",
                    calories: "1 Kcal"

                  );
              })
            ],
          ),
        ),
      ),
    );
  }

  recentActivitiesListTile({
    required double fullHeight,
    required double fullWidth,
    String? img,
    required String date,
    required String distance,
    required String time,
    required String pace,
    required String calories
  }) {
    return Padding(
      padding:  EdgeInsets.only(bottom: fullHeight*0.015),
      child: Container(
        margin: EdgeInsets.only( left: fullWidth*0.02,right: fullWidth*0.02),
        decoration: BoxDecoration(
          color: Colur.progress_background_color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(13.0),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                child: Image.asset(
                  "assets/icons/$img",
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colur.txt_white
                        ),
                      ),
                      Text(
                        distance,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            color: Colur.txt_white
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top: fullHeight*0.01),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              time,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                  color: Colur.txt_grey
                              ),
                            ),
                            Text(
                              pace,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                  color: Colur.txt_grey
                              ),
                            ),
                            Text(
                              calories,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                  color: Colur.txt_grey
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if(name== Constant.STR_BACK) {
      Navigator.pop(context);
    }
  }

  
}
