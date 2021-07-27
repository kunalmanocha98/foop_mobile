import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'overlaped_circular_images.dart';

// ignore: must_be_immutable
class LiteratureAndCompositions extends StatelessWidget {
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

  LiteratureAndCompositions({Key? key, required this.data,this.styleElements}) : super(key: key);

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
        Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            children: <Widget>[
              new Flexible(
                child: Container(
                    height: 250,
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(data.urlOne ??= ""),
                                  fit: BoxFit.fill),
                              border: new Border(
                                  top: BorderSide(
                                color: HexColor(AppColors.appMainColor),
                                width: 3.0,
                              )),
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(8.0),
                                  topRight: const Radius.circular(8.0)),
                            ),
                            height: 100,
                          ),
                          Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, top: 4.0),
                                  child: Text(
                                    data.textOne ??= "",
                                    style:styleElements!.headline5ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, top: 8.0),
                                  child: Text(
                                    data.textTwo ??= "",
                                    style: styleElements!.subtitle1ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 8.0,
                                      bottom: 16),
                                  child: Text(
                                    data.textThree ??= "",
                                    maxLines: 5,
                                    style: styleElements!.subtitle1ThemeScalable(context),
                                    textAlign: TextAlign.left,
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
                    height: 250,
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(data.urlOne ??= ""),
                                  fit: BoxFit.fill),
                              border: new Border(
                                  top: BorderSide(
                                color: HexColor(AppColors.appMainColor),
                                width: 3.0,
                              )),
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(8.0),
                                  topRight: const Radius.circular(8.0)),
                            ),
                            height: 100,
                          ),
                          Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, top: 4.0),
                                  child: Text(
                                    data.textFour ??= "",
                                    style: styleElements!.headline5ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, top: 8.0),
                                  child: Text(
                                    data.textFive ??= "",
                                    style:styleElements!.headline6ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 8.0,
                                      bottom: 16),
                                  child: Text(
                                    data.textSix ??= "",
                                    maxLines: 5,
                                    style:styleElements!.subtitle1ThemeScalable(context),
                                    textAlign: TextAlign.left,
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
