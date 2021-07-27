import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:flutter/material.dart';

import 'overlaped_circular_images.dart';
// ignore: must_be_immutable
class StaffAndStudentsCard extends StatelessWidget {
  final CommonCardData data;
  TextStyleElements? styleElements;
  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }

  StaffAndStudentsCard({Key? key, required this.data,this.styleElements}) : super(key: key);

  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return appListCard(
        child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16,top:12,bottom:12),
                    child: Text(
                      data.title ?? "Staffs",
                      style: styleElements!.headline5ThemeScalable(context),
                      textAlign: TextAlign.left,
                    ),
                  )),
              flex: 3,
            ),
            Flexible(
              child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin:
                        const EdgeInsets.only(right: 16, top: 24, left: 16),
                    child: Icon(
                      Icons.more_horiz,
                    ),
                  )),
              flex: 1,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: const EdgeInsets.only(left: 16, top: 20),
                        child: Text(
                          data.textOne ??= "Staffs",
                          style: styleElements!.subtitle2ThemeScalable(context),
                          textAlign: TextAlign.left,
                        ),
                      )),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 16, top: 8, right: 16),
                        child: Text(
                          data.textTwo ??= "234",
                          style: styleElements!.bodyText1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 20, top: 20, right: 20),
                        child: Text(
                          data.textThree ??= "Student-Staff Ratio",
                          style: styleElements!.subtitle2ThemeScalable(context),
                          textAlign: TextAlign.right,
                        ),
                      )),
                  Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 20, top: 8, right: 20),
                        child: Text(
                          data.textFour ??= "26",
                          style: styleElements!.bodyText1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.right,
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
        Visibility(

          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(child: OverlappedImages(null)),
                  Flexible(
                      child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      data.textFive ??= "2 techer 7 students",
                      style: styleElements!.subtitle2ThemeScalable(context),
                      textAlign: TextAlign.left,
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.only(right: 20, top: 20, bottom: 20),
            child:Visibility(
              visible: data.isShowMore ??= false,
              child: Align
                (
                alignment:  Alignment.bottomRight,
                child:Text(AppLocalizations.of(context)!.translate('see_more'),
                  style: styleElements!.subtitle2ThemeScalable(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
