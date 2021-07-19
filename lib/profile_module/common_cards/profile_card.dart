import 'dart:convert';
import 'dart:developer';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_user_list_tile.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/components/tricycleemptywidget.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/regisration_module/welcomePage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Profiledetailcard extends StatelessWidget {
  final CommonCardData data;

  // int colorCode = 0xFFEF9A9A;
  Persondata persondata;
  Null Function() callback;
  BuildContext context;
  List<SubRow> listSubItems;
  TextStyleElements styleElements;
  String ownerType;
  String PersonType;
  int ownerId;
  SharedPreferences prefs = locator<SharedPreferences>();

  Profiledetailcard(
      {Key key, @required this.data, this.persondata, this.callback, this.ownerId, this.ownerType, this.PersonType})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);

    listSubItems = data.subRow;
    return TricycleListCard(
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
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate("my_roles"),
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
                        visible: PersonType == "person",
                        child: Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              WelComeScreen(),
                                        ));
                                  },
                                  child: Icon(
                                    Icons.add,
                                    size: 30,
                                    color: HexColor(AppColors.appColorBlack85),
                                  ),
                                )),
                          ),
                          flex: 1,
                        ))
                  ],
                )),
            listSubItems != null && listSubItems.length > 0 ? Container(
              margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0.0),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: listSubItems.length,
                  itemBuilder: (context, index) {
                    return
                      listSubItems[index].subRow != null &&
                          listSubItems[index].subRow.isNotEmpty ?
                      GestureDetector(
                          onTap: () {
                            if (listSubItems[index].subRow[0].childId != null &&
                                listSubItems[index].subRow[0].childId != "" &&
                                listSubItems[index].subRow[0].childId != "None")
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UserProfileCards(
                                            userType: int.parse(
                                                listSubItems[index].subRow[0]
                                                    .childId) == ownerId
                                                ? "person"
                                                : "thirdPerson",
                                            userId: int.parse(
                                                listSubItems[index].subRow[0]
                                                    .childId) != ownerId ? int
                                                .parse(
                                                listSubItems[index].subRow[0]
                                                    .childId) : null,
                                            callback: () {

                                            },
                                            currentPosition: 1,
                                            type: null,
                                          )));
                          },
                          child: TricycleUserListTile(
                            imageUrl: Config.BASE_URL +
                                listSubItems[index].subRow[0].urlOne ?? "",
                            isFullImageUrl: true,
                            title: listSubItems[index].textOne ?? "",
                            subtitleWidget: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  listSubItems[index].subRow[0].textOne ?? "",
                                  style: styleElements
                                      .subtitle1ThemeScalable(context)
                                      .copyWith(fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.left,
                                ),
                                Visibility(
                                  visible: listSubItems[index].subRow[0]
                                      .textThree != null,
                                  child: RichText(
                                    text: TextSpan(children: [

                                      TextSpan(
                                          text: listSubItems[index].subRow[0]
                                              .textThree ?? "",
                                          style: styleElements
                                              .overlineThemeScalable(context)
                                              .copyWith(color: HexColor(
                                              AppColors.appColorBlack35),
                                          )),
                                    ]),
                                  ),
                                )

                              ],
                            ),
                            trailingWidget: Visibility(
                              visible: !listSubItems[index].subRow[0].isFollow2,
                              child: GenericFollowUnfollowButton(
                                textColor: HexColor(AppColors.appColorWhite),
                                backGroundColor:
                                HexColor(AppColors.appMainColor),
                                actionByObjectType: ownerType,
                                actionByObjectId: ownerId,
                                actionOnObjectType: "person",
                                actionOnObjectId: int.parse(
                                    listSubItems[index].subRow[0].childId),
                                engageFlag: listSubItems[index].subRow[0]
                                    .isFollow2
                                    ? AppLocalizations.of(context)
                                    .translate('following')
                                    : AppLocalizations.of(context)
                                    .translate('follow'),
                                actionFlag: listSubItems[index].subRow[0]
                                    .isFollow2
                                    ? "U"
                                    : "F",
                                actionDetails: [],
                                personName: "",
                                callback: (isCallSuccess) {
                                  if (callback != null)
                                    callback();
                                },
                              ),
                            ),

                          )) : GestureDetector(
                          onTap: () {
                            if (listSubItems[index].institutionId != null &&
                                listSubItems[index].institutionId != "" &&
                                listSubItems[index].institutionId != "None")
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserProfileCards(
                                          callback: callback,
                                          currentPosition: 1,
                                          userType: "institution",
                                          userId: int.parse(listSubItems[index]
                                              .institutionId),
                                          type: null,
                                        ),
                                  ));
                          },
                          child: ListTile(
                              leading:
                              TricycleAvatar(
                                imageUrl: Config.BASE_URL +
                                    listSubItems[index].urlOne ?? "",
                                service_type: SERVICE_TYPE.INSTITUTION,
                                resolution_type: RESOLUTION_TYPE.R64,
                                isFullUrl: true,
                                size: 56,
                                isClickable: true,
                              )
                              ,
                              title: Text(
                                listSubItems[index].textOne ?? "",
                                style: styleElements
                                    .subtitle2ThemeScalable(context)
                                ,
                                textAlign: TextAlign.left,
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    listSubItems[index].textFour ?? "",
                                    style: styleElements
                                        .subtitle1ThemeScalable(context)
                                        .copyWith(fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.left,
                                  ),
                                  Visibility(
                                    visible: listSubItems[index].locality !=
                                        null,
                                    child: RichText(
                                      text: TextSpan(children: [
                                        WidgetSpan(
                                          child: Visibility(

                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Icon(
                                                Icons.location_on,
                                                size: 14,
                                                color: HexColor(
                                                    AppColors.appColorGrey500),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                            text: listSubItems[index]
                                                .locality ?? "",
                                            style: styleElements
                                                .overlineThemeScalable(context)
                                                .copyWith(color: HexColor(
                                                AppColors.appColorBlack35),
                                            )),
                                      ]),
                                    ),
                                  )

                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Visibility(
                                    visible: !listSubItems[index].isFollow2,
                                    child: GenericFollowUnfollowButton(
                                      textColor: HexColor(
                                          AppColors.appColorWhite),
                                      backGroundColor: HexColor(
                                          AppColors.appMainColor),
                                      actionByObjectType: ownerType,
                                      actionByObjectId: ownerId,
                                      actionOnObjectType: "institution",
                                      actionOnObjectId: listSubItems[index]
                                          .institutionId != null &&
                                          listSubItems[index].institutionId !=
                                              "None" ? int.parse(
                                          listSubItems[index].institutionId ??
                                              "0") : null,
                                      engageFlag: (listSubItems[index]
                                          .isFollow2 != null
                                          ? listSubItems[index].isFollow2
                                          : false)
                                          ? AppLocalizations.of(context)
                                          .translate('following')
                                          : AppLocalizations.of(context)
                                          .translate('follow'),
                                      actionFlag: (listSubItems[index]
                                          .isFollow2 != null
                                          ? listSubItems[index].isFollow2
                                          : false) ? "U" : "F",
                                      actionDetails: [],
                                      personName: "",
                                      callback: (isCallSuccess) {
                                        callback();
                                      },
                                    ),
                                  ),
                                  _simplePopup(index)
                                ],
                              )

                          ));
                  }),
            ) : TricycleEmptyWidget(message: "No data Found!!",),

          ],
        ));
  }

  Widget _simplePopup(int index) {
    // var name = headerData.title;
    return PopupMenuButton<String>(
      padding: EdgeInsets.only(right: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      itemBuilder: (context){
        return [
          PopupMenuItem(
            value: 'edit',
            child: Text(AppLocalizations.of(context).translate('edit'),
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Text(AppLocalizations.of(context).translate('delete'),
            ),
          ),
        ];
      },
      onSelected: (value) {
        switch (value) {
          case 'delete':
            {
              print('delete');
              deleteRole(listSubItems[index].institutionId,listSubItems[index].id);
              break;
            }
          case 'edit':
            {
              editRole(listSubItems[index].id);
              print('edit');
              break;
            }
        }
      },
      icon: Icon(
        Icons.more_vert,
        color: HexColor(AppColors.appColorBlack65),
      ),
    );
  }

  void deleteRole(String institutionId, String deleteUserId) {
    var body = {
      "institution_id" : int.parse(institutionId),
      "person_id": prefs.getInt(Strings.userId),
      "deleted_institution_user_id": int.parse(deleteUserId)
    };
    Calls().call(jsonEncode(body), context, Config.INSTITUTION_DELETE_ROLE).then((value) {
      log("delete role----------------------------"+jsonEncode(value));
      callback();
    });
  }

  void editRole(String id) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
      return WelComeScreen(
        institutionIdtoDelete: int.parse(id),
        isEdit: true,
      );
    })).then((value){
      if(value!=null && value){
        callback();
      }
    });
  }
}
