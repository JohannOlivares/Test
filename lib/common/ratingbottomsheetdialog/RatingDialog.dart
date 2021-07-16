import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:run_tracker/utils/Utils.dart';

import '../../custom/GradientButtonSmall.dart';
import '../../localization/language/languages.dart';
import '../../utils/Color.dart';
import '../../utils/Color.dart';
import '../../utils/Color.dart';
import '../../utils/Debug.dart';

class RatingDialog extends StatefulWidget {
  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double rating;
  String emoji;
  String emojiTitle;

  @override
  void initState() {
    rating = 4.0;
    emoji = 'assets/icons/ic_emoji_good.webp';
    super.initState();
  }

  //Use this code for show dialog
  /*showModalBottomSheet(
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
  */

  @override
  Widget build(BuildContext context) {
    if (emoji == 'assets/icons/ic_emoji_good.webp')
      emojiTitle = Languages.of(context).txtGood;
    return Container(
      color: Colur.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colur.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            margin: EdgeInsets.only(top: 60.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 80.0, left: 20.0, right: 20.0),
                    child: Text(
                      emojiTitle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          letterSpacing: 0,
                          color: Colur.txt_black,
                          fontWeight: FontWeight.w700,
                          fontSize: 28),
                      //maxLines: 1,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 35),
                    child: RatingBar.builder(
                      initialRating: rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 50.0,
                      glowRadius: 0.1,
                      glowColor: Colur.txt_grey,
                      itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
                      unratedColor: Colur.unselected_star,
                      /*itemBuilder: (context, _) => Icon(
                        Icons.star_border,
                        color: Color(0xffFFC804),
                      ),*/
                      itemBuilder: (context, _) => Image.asset(
                        "assets/icons/ic_star.webp",
                        color: Colur.selected_star,
                      ),
                      onRatingUpdate: (rating) {
                        Debug.printLog("Rating ==>" + rating.toString());
                        setState(() {
                          if (rating <= 1.0) {
                            emoji = 'assets/icons/ic_emoji_terrible.webp';
                            emojiTitle = Languages.of(context).txtTerrible;
                          } else if (rating <= 2.0) {
                            emoji = 'assets/icons/ic_emoji_bad.webp';
                            emojiTitle = Languages.of(context).txtBad;
                          } else if (rating <= 3.0) {
                            emoji = 'assets/icons/ic_emoji_okay.webp';
                            emojiTitle = Languages.of(context).txtOkay;
                          } else if (rating <= 4.0) {
                            emoji = 'assets/icons/ic_emoji_good.webp';
                            emojiTitle = Languages.of(context).txtGood;
                          } else if (rating <= 5.0) {
                            emoji = 'assets/icons/ic_emoji_great.webp';
                            emojiTitle = Languages.of(context).txtGreat;
                          }
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                    child: Text(
                      Languages.of(context).txtBestWeCanGet + " :)",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colur.txt_grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                      //maxLines: 1,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 40.0, left: 80.0, right: 80.0, bottom: 60.0),
                    child: GradientButtonSmall(
                      width: double.infinity,
                      height: 55,
                      radius: 50.0,
                      child: Text(
                        Languages.of(context).txtRate.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colur.white,
                            fontWeight: FontWeight.w700,
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
                        Utils.showToast(context, "Rating Completed");
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 120.0,
            width: 120.0,
            child: Image.asset(
              emoji,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
