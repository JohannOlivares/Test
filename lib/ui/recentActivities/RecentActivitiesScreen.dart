import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/common/commonTopBar/CommonTopBar.dart';
import 'package:run_tracker/dbhelper/DataBaseHelper.dart';
import 'package:run_tracker/dbhelper/datamodel/RunningData.dart';
import 'package:run_tracker/interfaces/TopBarClickListener.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/ui/runhistorydetails/RunHistoryDetailScreen.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Constant.dart';
import 'package:intl/intl.dart';

class RecentActivitiesScreen extends StatefulWidget {
  @override
  _RecentActivitiesScreenState createState() => _RecentActivitiesScreenState();
}

class _RecentActivitiesScreenState extends State<RecentActivitiesScreen>
    implements TopBarClickListener {


  List<RunningData> activityList = [];
  bool ActiivityShow = false;

  @override
  void initState() {
    _checkData();
  }

  _checkData() async {
    final result = await DataBaseHelper().selectMapHistory();
    activityList.addAll(result);


    //print(result[0].eLong);

    if (result.isEmpty || result.length == 0) {
      setState(() {
        ActiivityShow = false;
      });
    } else {
      setState(() {
        ActiivityShow = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery
        .of(context)
        .size
        .height;
    var fullWidth = MediaQuery
        .of(context)
        .size
        .width;
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
              Visibility(
                visible: ActiivityShow,
                child: recentActivitiesList(fullHeight),
              ),
              Visibility(visible: !ActiivityShow,
                child: Container(
                  child:Text("No Data Found",style: TextStyle(color: Colur.purple_gradient_color2,fontSize: 20,fontWeight: FontWeight.w500),),
                ),)
            ],
          ),
        ),
      ),
    );
  }

  recentActivitiesList(double fullHeight) {
    return Container(
      child: ListView.builder(
          itemCount: activityList.length,
          padding: EdgeInsets.only(
              bottom: MediaQuery
                  .of(context)
                  .size
                  .height *
                  0.05),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          reverse: true,
          itemBuilder:
              (BuildContext context, int index) {
            return _activitiesView(context, index, fullHeight);
          }),
    );
  }

  _activitiesView(BuildContext context, int index, double fullheight) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RunHistoryDetailScreen(activityList[index])));
      },
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
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
                child: (activityList[index].getImage() == null) ? Image.asset(
                  "assets/icons/ic_route_map.png",
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                ) : Image.file(activityList[index].getImage()!, height: 90,
                  width: 90,
                  fit: BoxFit.fill,),
                borderRadius: BorderRadius.circular(10),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMd().format(DateTime.now()),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colur.txt_white
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            activityList[index].distance!.toString(),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 21,
                                color: Colur.txt_white
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 4),
                            child: Text(
                              Languages.of(context)!.txtMile,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colur.txt_white
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: fullheight * 0.01),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              activityList[index].duration!.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Colur.txt_grey
                              ),
                            ),
                            Text(
                              activityList[index].speed!.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Colur.txt_grey
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  activityList[index].cal!.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      color: Colur.txt_grey
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
                                  child: Text(
                                    Languages.of(context)!.txtKcal,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11,
                                        color: Colur.txt_grey
                                    ),
                                  ),
                                ),
                              ],
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
    if (name == Constant.STR_BACK) {
      Navigator.pop(context);
    }
  }


}
