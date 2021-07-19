import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ArtAndPhotography extends StatelessWidget {
  final CommonCardData data;
  List<SubRow> listSubItems = [];
  TextStyleElements styleElements;
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

  ArtAndPhotography({Key key, @required this.data,this.styleElements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    listSubItems = data.subRow;
    styleElements = TextStyleElements(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = 250;
    final double itemWidth = size.width / 2;
    return TricycleListCard(
        child: Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16,top:12,bottom:12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Text(
                        data.title ?? "",
                        style: styleElements.headline6ThemeScalable(context),
                        textAlign: TextAlign.left,
                      ),
                    )),
                flex: 3,
              ),
              Flexible(
                child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.only(
                          right: 16, top: 24, left: 16),
                      child: Icon(
                        Icons.more_horiz,
                      ),
                    )),
                flex: 1,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: (itemWidth / itemHeight),
              children: listSubItems.map((SubRow data) {
                return Stack(children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                        left: 14, right: 14, top: 14, bottom: 40),
                    height: 200,
                    decoration: BoxDecoration(
                      color: HexColor(AppColors.appColorBlueAccent),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(data.urlOne),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: null /* add child content here */,
                  ),
                  Container(
                    height: 210,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/appimages/frame.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: null /* add child content here */,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      height: 30,
                      child: TricycleElevatedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: HexColor(AppColors.appMainColor))),
                        onPressed: () {},
                        color: HexColor(AppColors.appMainColor),
                        child: Text(
                            AppLocalizations.of(context)
                                .translate('shop')
                                .toUpperCase(),
                            style: styleElements.bodyText2ThemeScalable(context)),
                      ),
                    ),
                  )
                ]);
              }).toList()),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.only(right: 20, top: 8, bottom: 20),
            child: Visibility(
              visible: data.isShowMore ??= false,
              child: Align
                (
                alignment:  Alignment.bottomRight,
                child: Text(AppLocalizations.of(context).translate('see_more'),
                  style: styleElements.subtitle2ThemeScalable(context),
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
