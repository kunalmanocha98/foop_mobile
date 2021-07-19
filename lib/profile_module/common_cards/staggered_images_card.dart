import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
// ignore: must_be_immutable

import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


// ignore: must_be_immutable
class StaggeredImagesCard extends StatelessWidget {
  final CommonCardData data;
  List<SubRow> listSubItems = [];
  BuildContext context;
  final String instId;
  TextStyleElements styleElements;
  Null Function() callbackPicker;
  int id;

  String personType;
  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  Widget _simplePopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child:
                Text(AppLocalizations.of(context).translate('add_new_subject')),
          ),
        ],
        onSelected: (value) async {

        },
        icon: Icon(
          Icons.more_horiz,
          size: 30,
          color: HexColor(AppColors.appColorBlack85),
        ),
      );

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }

  StaggeredImagesCard(
      {Key key,
      @required this.data,
      this.styleElements,
      this.callbackPicker,
        this.personType,
        this.id,
      this.instId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    listSubItems = data.subRow;
    styleElements = TextStyleElements(context);
    this.context = context;

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
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 12, bottom: 12),
                    child: Text(
                      data.title ?? "",
                      style: styleElements
                          .headline6ThemeScalable(context)
                          .copyWith(
                              fontWeight: FontWeight.bold,
                              color: HexColor(AppColors.appColorBlack85)),
                      textAlign: TextAlign.left,
                    ),
                  )),
              flex: 3,
            ),
            Visibility(
                visible: data.type == "person",
                child: Flexible(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _simplePopup()),
                  flex: 1,
                )),
          ],
        ),

        Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 12, bottom: 12),
              child: Text(AppLocalizations.of(context).translate('photos'),
                style: styleElements
                    .subtitle1ThemeScalable(context)
                    .copyWith(
                    fontWeight: FontWeight.bold,
                    color: HexColor(AppColors.appColorBlack85)),
                textAlign: TextAlign.left,
              ),
            )),

        listSubItems.isNotEmpty
            ? Container(
                margin: const EdgeInsets.only(left: 12, right: 12, top: 8),
                child:  StaggeredGridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0.0),
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 2.0,
                  staggeredTiles: [
                    StaggeredTile.count(2, 2),
                    StaggeredTile.count(1, 1),
                    StaggeredTile.count(1, 1),
                    StaggeredTile.count(2, 2),
                    StaggeredTile.count(1, 1),
                    StaggeredTile.count(1, 1)
                  ],
                  children: [
                    tile(listSubItems.length>0?Config.BASE_URL+listSubItems[0].textOne??"":""),
                    tile(listSubItems.length>1?Config.BASE_URL+listSubItems[1].textOne??"":""),
                    tile(listSubItems.length>2?Config.BASE_URL+listSubItems[2].textOne??"":""),
                    tile(listSubItems.length>3?Config.BASE_URL+listSubItems[3].textOne??"":""),
                    tile(listSubItems.length>4?Config.BASE_URL+listSubItems[4].textOne??"":""),
                    tile(listSubItems.length>5?Config.BASE_URL+listSubItems[5].textOne??"":""),
                  ],
                ))
            : GestureDetector(
                onTap: () async {

                },
                child: Container(
                    height: 150,
                    width: 200,
                    margin: const EdgeInsets.only(bottom: 20, top: 20),
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      color: HexColor(AppColors.appColorWhite),
                    ),
                    child:CustomPaginator(context).emptyListWidgetMaker(null)),
              ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
              onTap: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileCards(
                        type: "Campus & Facilities",
                        currentPosition: 2,
                        userType: personType,
                        userId: id,
                        isUserExist:data.isUserExist,
                      ),
                    ));
                if (result != null && result['result'] == "update") {
                /*  callbackPicker();*/
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 16, bottom: 16,top: 16),
                child: Visibility(
                  visible: listSubItems.isNotEmpty,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child:Text(AppLocalizations.of(context).translate('see_more'),
                      style: styleElements.subtitle2ThemeScalable(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )),
        ),
      ],
    ));
  }
}

Widget tile(String url)
{

return  Card(

  child: GestureDetector(
    onTap: () {},
    child: Container(
      child:
      CachedNetworkImage(
        imageUrl: url ?? "",
        placeholder: (context, url) => Center(
            child:  Image.asset(
              'assets/appimages/image_place.png',

            )),
        fit: BoxFit.fill,
      )

    ),
  ),
);

}
