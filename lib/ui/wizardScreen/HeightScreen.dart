import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/custom/GradientButtonSmall.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/ui/weeklygoalSetScreen/WeeklyGoalSetScreenIntro.dart';
import 'package:run_tracker/ui/wizardScreen/WizardScreen.dart';
import 'package:run_tracker/utils/Color.dart';



class HeightScreen extends StatefulWidget {
  PageController? pageController;
  bool? isBack;

  WizardScreenState wizardScreenState;

  HeightScreen({this.isBack, required this.wizardScreenState,}){
    isBack = true;

  }

  @override
  _HeightScreenState createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  bool cmSelected = true;
  bool ftSelected = false;
  var ftHeight = 0;
  var inchHeight = 0;
  int? cmHeight = 20;
  bool unit = true; //true for cm and false for feet

  @override
  void initState() {
    super.initState();
  }


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
          //What is Your Gender Text
          Container(
            margin: EdgeInsets.only(top:fullHeight*0.05),
            child: Text(
              Languages.of(context)!.txtHowTallAreYou,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colur.txt_white,
                  fontSize: 30),
            ),
          ),
          //Gender Description
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              Languages.of(context)!.txtHeightDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colur.txt_grey,
                fontSize: 20,
              ),
            ),
          ),
          //height Picker===========================
          _heightUnitPicker(fullHeight),
          //Height Selector
          _heightSelector(fullHeight),




          //Next Step Button
          Container(
            margin: EdgeInsets.only(left: fullWidth*0.15, bottom: fullHeight*0.08, right: fullWidth*0.15),
            alignment: Alignment.bottomCenter,
            child: GradientButtonSmall(
              width: double.infinity,
              height: 60,
              radius: 50.0,
              child: Text(
                Languages.of(context)!.txtNextStep,
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
                /*unit == true ?
                Utils.showToast(context, "$cmHeight cm") :
                Utils.showToast(context, "$ftHeight' $inchHeight\" feet") ;*/

                convert();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WeeklyGoalSetScreen(
                        weight: widget.wizardScreenState.weightSelected,
                        height: cmHeight,
                        gender: widget.wizardScreenState.genderSelected,
                      )
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _heightUnitPicker(double fullHeight) {
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
                cmSelected = true;
                ftSelected = false;
                unit = true;
                //Debug.printLog("cm selected");
              });
            },
            child: Container(
              width: 100,
              child: Center(
                child: Text(
                  Languages.of(context)!.txtCM,
                  style: TextStyle(
                      color: cmSelected ? Colur.txt_white : Colur.txt_grey,
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
                cmSelected = false;
                ftSelected = true;
                unit = false;
                //Debug.printLog("feet selected");
              });
            },
            child: Container(
              width: 100,
              child: Center(
                child: Text(
                  Languages.of(context)!.txtFT,
                  style: TextStyle(
                      color: ftSelected ? Colur.txt_white : Colur.txt_grey,
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

  _heightSelector(double fullHeight) {
    if(unit == false) {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //FEET SELECTOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: fullHeight*0.025),
                    child: Image.asset(
                      "assets/icons/ic_select_pointer.png",
                    ),
                  ),
                ),
                Container(
                  width: 125,
                  height: 300,
                  child: CupertinoPicker(
                    backgroundColor: Colur.common_bg_dark,
                    useMagnifier: true,
                    magnification: 1.05,
                    selectionOverlay: CupertinoPickerDefaultSelectionOverlay(background: Colur.transparent,),
                    onSelectedItemChanged: (value) {
                      setState(() {
                        ftHeight = value;
                        //Debug.printLog("$ftHeight ft selected");
                      });
                    },
                    itemExtent: 75.0,
                    children: List.generate(14, (index) {
                      return Text(
                        "$index '",
                        style: TextStyle(
                            color: Colur.txt_white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold
                        ),
                      );
                    }),
                  ),
                ),
                Container(
                  width: 125,
                  height: 300,
                  child: CupertinoPicker(
                    backgroundColor:Colur.common_bg_dark,
                    useMagnifier: true,
                    magnification: 1.05,
                    selectionOverlay: CupertinoPickerDefaultSelectionOverlay(background: Colur.transparent,),
                    onSelectedItemChanged: (value) {
                      setState(() {
                        inchHeight = value;
                        //Debug.printLog("$inchHeight inch selected");
                      });

                    },
                    itemExtent: 75.0,
                    children: List.generate(12, (index) {
                      return Text(
                        "$index \"",
                        style: TextStyle(
                            color: Colur.txt_white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold
                        ),
                      );
                    }),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    } else {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.only(bottom: fullHeight*0.025),
                child: Image.asset(
                  "assets/icons/ic_select_pointer.png",
                ),
              ),
            ),
            Container(
              width: 125,
              height: 300,
              child: CupertinoPicker(
                backgroundColor: Colur.common_bg_dark,
                useMagnifier: true,
                magnification: 1.05,
                selectionOverlay: CupertinoPickerDefaultSelectionOverlay(background: Colur.transparent,),
                onSelectedItemChanged: (value) {
                  setState(() {
                    value+=20;
                    cmHeight = value;
                    //Debug.printLog("$cmHeight cm selected");
                  });
                },
                itemExtent: 75.0,
                children: List.generate(381, (index) {
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
      );
    }
  }

  //convert feet into cm
  convert() {
    if(unit == false) {
      var h = (ftHeight*30.48) + (inchHeight*2.59);
      cmHeight = h.toInt();
    }
  }

}


