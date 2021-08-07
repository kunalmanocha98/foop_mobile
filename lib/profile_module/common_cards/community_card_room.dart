import 'package:oho_works_app/components/customgridDelegate.dart';
import 'package:oho_works_app/components/app_rooms_card.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/ui/RoomModule/room_detail_page.dart';
import 'package:oho_works_app/ui/RoomModule/roomsPage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ignore: must_be_immutable
class CommunityRoomCard extends StatelessWidget {
  final CommonCardData data;
  List<Data>? listSubItems = [];

  late TextStyleElements styleElements;
  BuildContext? context;
  SharedPreferences? prefs;


  CommunityRoomCard(
      {Key? key,
        required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    listSubItems = data.data;
    return listSubItems!.isNotEmpty
        ? Container(
        child: Column(
          children: <Widget>[
            Visibility(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 12, bottom: 12),
                            child: Text(AppLocalizations.of(context)!.translate('communityroom'),
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
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                               Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                 return RoomsPage(currentPosition: 3,);
                               }));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    right: 16, bottom: 16, top: 16),
                                child: Visibility(
                                  /*visible: data.isShowMore ??= false,*/
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(AppLocalizations.of(context)!.translate('see_more'),
                                      style: styleElements
                                          .subtitle2ThemeScalable(context)
                                          .copyWith(
                                          color: HexColor(AppColors.orangeText)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )),
                        ))
                  ],
                )),
            Container(
              height: listSubItems!.length>2?520:260,
              child: GridView.builder(
                  padding: const EdgeInsets.all(0.0),
                  physics: ClampingScrollPhysics(),
                  itemCount: listSubItems!.length>4?4:listSubItems!.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  dragStartBehavior: DragStartBehavior.start,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                  height: 260, crossAxisCount: 2
                ),
                  // itemExtent: 0.5.sw,
                  itemBuilder: (context, index) {
                    var roomData = RoomListItem.fromJson(listSubItems![index].toJson());
                    return GestureDetector(
                      onTap: () async{
                        prefs ??= await SharedPreferences.getInstance();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RoomDetailPage(
                                      roomData,prefs!.getInt(Strings.userId),prefs!.getString(Strings.ownerType),prefs!.getString(Strings.ownerType)=="institution"?"institution":"person",prefs!.getInt(Strings.instituteId),roomData.id,null
                                  )));
                      },
                      child: appRoomCalenderCard(
                        isSmallCard: true,
                        roomData: roomData,
                      ),
                    );
                  },),
            ),
          ],
        ))
        : Container();
  }
}
