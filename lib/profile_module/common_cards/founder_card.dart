import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FounderCard extends StatelessWidget {
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

  FounderCard({Key? key, required this.data,this.styleElements}) : super(key: key);

  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return TricycleListCard(
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
                      data.title ?? "",
                      style: styleElements!.headline6ThemeScalable(context),
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
        Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 16, top: 20, right: 16),
              child: Text(
                data.textOne ??= "",
                style: styleElements!.subtitle1ThemeScalable(context),
                textAlign: TextAlign.left,
              ),
            )),
        Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 16, top: 20, right: 16),
              child: Text(
                data.textTwo ??= "",
                style: styleElements!.subtitle2ThemeScalable(context),
                textAlign: TextAlign.left,
              ),
            )),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.only(right: 20, top: 20, bottom: 20),
            child: Visibility(
              visible: data.isShowMore ??= false,
              child: Align
                (
                alignment:  Alignment.bottomRight,
                child: Text(AppLocalizations.of(context)!.translate('see_more'),
                  style: styleElements!.bodyText2ThemeScalable(context),
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
