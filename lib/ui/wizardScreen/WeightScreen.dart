import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/custom/CustomRadioSelection.dart';
import 'package:run_tracker/custom/GradientButtonSmall.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Debug.dart';
import 'package:run_tracker/utils/Utils.dart';

class WeightScreen extends StatefulWidget {
  PageController? pageController;
  Function? updatevalue;
  bool? isBack;
  Function? pageNum;

  WeightScreen({this.pageController, this.updatevalue,this.isBack, this.pageNum}){
    isBack = true;
  }

  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {



  bool kgSelected = true;
  bool lbsSelected = false;

  String unit = "KG";
  var weightKG = 20;
  var weightLBS = 44;

  @override
  Widget build(BuildContext context) {
    var fullHeight =  MediaQuery.of(context).size.height;
    var fullWidth =  MediaQuery.of(context).size.width;
    return Container(
      height: fullHeight,
      width: fullWidth,
      color: Colur.common_bg_dark,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          //How much do you weigh?
          Container(
            margin: EdgeInsets.only(top: fullHeight*0.05),
            child: Text(
              Languages
                  .of(context)!
                  .txtHowMuchDoYouWeight,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colur.txt_white,
                  fontSize: 30),
            ),
          ),
          //To personalize your fitness goal
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              Languages
                  .of(context)!
                  .txtHeightDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colur.txt_grey,
                fontSize: 20,
              ),
            ),
          ),

          //Weight unit Picker===========================
          weightUnitPicker(fullHeight),

          //Weight selector
          weightSelector(fullHeight),

          //Next Step Button
          Container(
            margin: EdgeInsets.only(left: fullWidth*0.15, bottom: fullHeight*0.08, right: fullWidth*0.15),
            alignment: Alignment.bottomCenter,

            child: GradientButtonSmall(
              width: double.infinity,
              height: 60,
              radius: 50.0,
              child: Text(
                Languages
                    .of(context)!
                    .txtNextStep,
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
                  Colur.purple_gradient_color1,
                  Colur.purple_gradient_color2,
                ],
              ),
              onPressed: () {
                setState(() {
                  widget.updatevalue!(1.0);
                  widget.pageNum!(3);
                });
                if(unit == Languages.of(context)!.txtLBS) {
                  Utils.showToast(context, "$weightLBS $unit");
                } else{
                  Utils.showToast(context, "$weightKG $unit");
                }

                widget.pageController!.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  weightUnitPicker(double fullHeight) {
    return Container(
      margin: EdgeInsets.only(top: fullHeight*0.03),
      height: 60,
      width: 205,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colur.txt_grey, width: 1.5),
        color: Colur.progress_background_color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                kgSelected = true;
                lbsSelected = false;
                unit = Languages.of(context)!.txtKG;
              });
              Debug.printLog("$unit selected");
            },
            child: Container(
              width: 100,
              child: Center(
                child: Text(
                  Languages.of(context)!.txtKG,
                  style: TextStyle(
                      color: kgSelected ? Colur.txt_white: Colur.txt_grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ),
            ),
          ),
          Container(
            height: 23,
            child: VerticalDivider(
              color: Colur.txt_grey,
              width: 1,
              thickness: 1,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                kgSelected = false;
                lbsSelected = true;
                unit = Languages.of(context)!.txtLBS;
                Debug.printLog("$unit selected");
              });
            },
            child: Container(
              width: 100,
              child: Center(
                child: Text(
                  Languages.of(context)!.txtLBS,
                  style: TextStyle(
                      color: lbsSelected ? Colur.txt_white : Colur.txt_grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  weightSelector(double fullHeight) {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Padding(
                padding:  EdgeInsets.only(bottom: fullHeight*0.025),
                child: Image.asset(
                  "assets/icons/ic_select_pointer.png",
                ),
              ),
            ),
            Container(
              width: 125,
              height: fullHeight*0.32,
              child: CupertinoPicker(
                useMagnifier: true,
                magnification: 1.05,
                selectionOverlay: CupertinoPickerDefaultSelectionOverlay(background: Colur.transparent,),
                onSelectedItemChanged: (value) {
                  setState(() {
                    if (unit ==Languages.of(context)!.txtLBS) {
                      value+=44;
                      weightLBS = value;
                      Debug.printLog("$weightLBS $unit selected");
                    } else {
                      value+=20;
                      weightKG = value;
                      Debug.printLog("$weightKG $unit selected");
                    }
                  });

                },
                itemExtent: 75.0,
                children: unit == Languages.of(context)!.txtLBS ? List.generate(2155, (index) {
                  index+=44;
                  return Text(
                    "$index",
                    style: TextStyle(
                        color: Colur.txt_white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold
                    ),
                  );
                }) : List.generate(978, (index) {
                  index+=20;
                  return Text(
                    "$index",
                    style: TextStyle(
                        color: Colur.txt_white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

