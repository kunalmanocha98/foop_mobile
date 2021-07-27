import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'overlaped_circular_images.dart';
// ignore: must_be_immutable
class ScienceAndTechnology extends StatelessWidget {
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

  ScienceAndTechnology({Key? key, required this.data,this.styleElements}) : super(key: key);

  @override
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
        Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            children: <Widget>[
              new Flexible(
                child: Container(
                    height: 210,
                    child: Card(
                      color: HexColor(AppColors.appColorBlueGrey),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              data.urlOne ??= ""),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, left: 16, right: 16.0),
                                  child: Text(
                                    data.textOne ??= "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: styleElements!.headline5ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  child: Text(
                                    data.textTwo ??= "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: styleElements!.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      bottom: 16.0,
                                      top: 30.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(child: OverlappedImages(null)),
                                      Flexible(
                                          child: Text(
                                        data.textThree ??= "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: styleElements!.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),
                                        textAlign: TextAlign.left,
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
                flex: 1,
              ),
              new Flexible(
                child: Container(
                    height: 210,
                    child: Card(
                      color: HexColor(AppColors.appColorOrangeAccent),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              data.urlOne ??= ""),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, left: 16, right: 16.0),
                                  child: Text(
                                    data.textFour ??= "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: styleElements!.headline6ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  child: Text(
                                    data.textFive ??= "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: styleElements!.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      bottom: 16.0,
                                      top: 30.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(child: OverlappedImages(null)),
                                      Flexible(
                                          child: Text(
                                        data.textSix ??= "",
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        maxLines: 2,
                                        style: styleElements!.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),
                                        textAlign: TextAlign.left,
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
                flex: 1,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.only(right: 20, top: 20, bottom: 20),
            child: Visibility(
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
