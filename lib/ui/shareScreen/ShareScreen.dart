import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:run_tracker/common/commonTopBar/CommonTopBar.dart';
import 'package:run_tracker/dbhelper/datamodel/RunningData.dart';
import 'package:run_tracker/interfaces/TopBarClickListener.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Constant.dart';
import 'package:run_tracker/utils/Preference.dart';
import 'package:run_tracker/utils/Utils.dart';
import 'dart:ui' as ui;

import 'package:share/share.dart';

class ShareScreen extends StatefulWidget {
  final RunningData? runningData;

  ShareScreen(this.runningData);

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> implements TopBarClickListener {

  GlobalKey previewContainer = new GlobalKey();
  int originalSize = 800;
  bool kmSelected = true;


  @override
  void initState() {
    super.initState();
    _getPreferences();
  }

  _getPreferences(){
    setState(() {
      kmSelected =
          Preference.shared.getBool(Preference.IS_KM_SELECTED) ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                child: CommonTopBar(
                  Languages.of(context)!.txtShare,
                  this,
                  isShowBack: true,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 15,horizontal: 30
                ),
                child: RepaintBoundary(
                  key: previewContainer,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            (widget.runningData!.image != null)?Image.file(
                              File(widget.runningData!.image!),fit: BoxFit.contain,): Image.asset(
                              'assets/images/dummy_map.png',
                              fit: BoxFit.cover,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Image.asset(
                                'assets/icons/ic_share_watermark.png',
                                scale: 3.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 25, bottom: 20),
                          color: Colur.blue_gredient_1,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        Utils.secToString(widget.runningData!.duration!),
                                        //widget.runningData!.duration.toString(),
                                        style: TextStyle(
                                            color: Colur.txt_white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        Languages.of(context)!.txtTime.toUpperCase() +
                                            " (${Languages.of(context)!.txtMin.toUpperCase()})",
                                        style: TextStyle(
                                            color: Colur.txt_white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                    (kmSelected)? widget.runningData!.speed!.toStringAsFixed(2):Utils.minPerKmToMinPerMile(widget.runningData!.speed!).toStringAsFixed(2), //widget.runningData!.speed.toString(),
                                        style: TextStyle(
                                            color: Colur.txt_white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        (kmSelected)?Languages.of(context)!.txtPaceMinPer+Languages.of(context)!.txtKM.toUpperCase()+")":Languages.of(context)!.txtPaceMinPer+Languages.of(context)!.txtMile.toUpperCase()+")",
                                        style: TextStyle(
                                            color: Colur.txt_white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        widget.runningData!.cal.toString(), //widget.runningData!.cal.toString(),
                                        style: TextStyle(
                                            color: Colur.txt_white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        Languages.of(context)!.txtKCAL,
                                        style: TextStyle(
                                            color: Colur.txt_white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  screenShotAndShare();
                },
                child: Container(
                  height: 90,
                  width: 90,
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(shape: BoxShape.circle,gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colur.purple_gradient_color1,
                      Colur.purple_gradient_color2,
                    ],
                  ), ),
                  child: Icon(Icons.share,size: 40,color: Colur.white,),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> screenShotAndShare() async {

    try {
      RenderRepaintBoundary boundary = previewContainer.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      final directory = (await getExternalStorageDirectory())!.path;
      ByteData byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      Uint8List pngBytes = byteData.buffer.asUint8List();
      File imgFile = new File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);
      // print('Screenshot Path:' + imgFile.path);
      final RenderBox box = context.findRenderObject() as RenderBox;
      Share.shareFiles(['$directory/screenshot.png'],
          subject: Languages.of(context)!.appName,
          text: Languages.of(context)!.txtShareMapMsg,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
      );
    } on PlatformException catch (e) {
      print("Exception while taking screenshot:" + e.toString());
    }

  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.STR_BACK) {
      Navigator.of(context).pop();
    }
  }
}
