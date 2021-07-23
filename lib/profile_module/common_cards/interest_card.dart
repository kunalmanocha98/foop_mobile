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
/*class InterestCard extends StatelessWidget {
  final CommonCardData data;
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

  InterestCard({Key key, @required this.data,this.styleElements}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
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
                      data.title??""??="",
                      style: TextStyle(
                        fontFamily: 'bold',
                        fontSize:
                        ScreenUtil().setSp(48, ),
                        color: const Color(0xd9000000),
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  )),
              flex: 3,
            ),
            Flexible(
              child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.only(right: 16, top: 24, left: 16),
                    child: Icon(
                      Icons.more_horiz,
                    ),
                  )),
              flex: 1,),
          ],
        ),
        Align(
          alignment: Alignment.center,
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 210,

                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(
                        data.urlOne??="",
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                    ),
                  ),
                  Positioned(
                    bottom: 4.0,
                    left: 4.0,
                    right: 4.0,
                    child: Container(
                      width: 150,
                        color: HexColor(AppColors.appColorTransparent),
                        child: Column(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  child: Text(
                                    data.textOne??="",
                                    style: TextStyle(
                                      fontFamily: 'Source Sans Pro',
                                      fontSize: ScreenUtil().setSp(50,
                                          ),
                                      color: HexColor(AppColors.appColorWhite),
                                      fontWeight: FontWeight.w700,
                                      height: 1,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0,bottom: 16.0,top: 4.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(child: OverlappedImages()),
                                  Flexible(child: Text(
                                      data.textTwo??="",
                                      style: TextStyle(
                                        fontFamily: 'Source Sans Pro',
                                        fontSize: ScreenUtil().setSp(36,
                                            ),
                                        color: HexColor(AppColors.appColorWhite),
                                        fontWeight: FontWeight.w500,
                                        height: 1,
                                      ),
                                      textAlign: TextAlign.left,
                                    )),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            new Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 210,

                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(
                        data.urlTwo??="",
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                    ),
                  ),
                  Positioned(
                    bottom: 4.0,
                    left: 4.0,
                    right: 4.0,
                    child: Container(
                      width: 150,
                        color: HexColor(AppColors.appColorTransparent),
                        child: Column(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  child: Text(
                                    data.textThree??="",
                                    style: TextStyle(
                                      fontFamily: 'Source Sans Pro',
                                      fontSize: ScreenUtil().setSp(50,
                                          ),
                                      color: HexColor(AppColors.appColorWhite),
                                      fontWeight: FontWeight.w700,
                                      height: 1,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0,bottom: 16.0,top: 4.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(child: OverlappedImages()),
                                  Flexible(child: Text(
                                    data.textFour??="",
                                    style: TextStyle(
                                      fontFamily: 'Source Sans Pro',
                                      fontSize: ScreenUtil().setSp(36,
                                          ),
                                      color: HexColor(AppColors.appColorWhite),
                                      fontWeight: FontWeight.w500,
                                      height: 1,
                                    ),
                                    textAlign: TextAlign.left,
                                  )),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),

          ],
        )),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.only(right: 20, top: 20, bottom: 20),
            child: Visibility(
              visible: data.isShowMore??=false,
              child: Positioned(
                bottom: 20,
                right: 20,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: 77.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        color: const HexColor(AppColors.appColorGrey50),
                      ),
                    ),
                    Positioned.fill(
                        child: Align(
                      alignment: Alignment.center,
                      child:Text(AppLocalizations.of(context).translate('see_more'),
                        style: TextStyle(
                          fontFamily: 'Source Sans Pro',
                          fontSize: ScreenUtil()
                              .setSp(36, ),
                          color: const Color(0xd9000000),
                          height: 1.4285714285714286,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}*/
// ignore: must_be_immutable
class InterestCard extends StatelessWidget {
  final CommonCardData data;
  List<SubRow>? listSubItems = [];

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
  TextStyleElements? styleElements;
  InterestCard({Key? key, required this.data,this.styleElements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    listSubItems = data.subRow;
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
                      style:styleElements!.headline5ThemeScalable(context),
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
          margin: const EdgeInsets.only(left: 12, right: 12, top: 8),
          child: SizedBox(
            height: 200,
            child: new Expanded(
                child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    children: listSubItems!.map((SubRow data) {
                      return Container(
                        margin: const EdgeInsets.only(
                            left: 4.0, right: 4.0, top: 4.0),
                        child: Card(
                          color: HexColor(AppColors.appColorOrangeAccent),
                          child: Stack(children: <Widget>[
                            Container(
                              height: 220,
                              decoration: BoxDecoration(
                                color: HexColor(AppColors.appColorBlueAccent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(data.urlOne!),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: null /* add child content here */,
                            ),
                            Positioned(
                              bottom: 4.0,
                              left: 4.0,
                              right: 4.0,
                              child: Container(
                                  width: 150,
                                  color: HexColor(AppColors.appColorTransparent),
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, right: 16.0),
                                            child: Text(
                                              data.textOne ??= "",
                                              style: styleElements!.headline5ThemeScalable(context),
                                              textAlign: TextAlign.left,
                                            ),
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0,
                                            right: 16.0,
                                            bottom: 16.0,
                                            top: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                                child: OverlappedImages(null)),
                                            Flexible(
                                                child: Text(
                                              data.textTwo ??= "",
                                              style:styleElements!.subtitle1ThemeScalable(context),
                                              textAlign: TextAlign.left,
                                            )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ]),
                        ),
                      );
                    }).toList())),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.only(right: 16, bottom: 16),
            child: Visibility(
              visible: data.isShowMore ??= false,
              child: Align
                (
                alignment:  Alignment.bottomRight,
                child: Text(AppLocalizations.of(context)!.translate('see_more'),
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
