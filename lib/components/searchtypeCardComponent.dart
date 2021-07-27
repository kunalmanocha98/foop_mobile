import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/models/global_search/globalsearchmodels.dart';
import 'package:oho_works_app/models/global_search/save_history.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
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
class SearchTypeCard extends StatefulWidget {
  String? title;
  List<SearchTypeItem>? typeList;
  SharedPreferences? prefs;
  String? type;
  Function(String?)? seeMoreCallback;
  SearchTypeCard({this.typeList, this.title,this.prefs,this.type,this.seeMoreCallback});

  SearchTypeCardState createState() =>
      SearchTypeCardState(typeList: typeList, title: title, prefs:prefs,type:type,seeMoreCallback: seeMoreCallback);
}

class SearchTypeCardState extends State<SearchTypeCard> {
  List<SearchTypeItem>? typeList;
  String? title;
  late TextStyleElements styleElements;
  SharedPreferences? prefs;
  String? type;
  Function(String?)? seeMoreCallback;
  SearchTypeCardState({this.typeList, this.title,this.prefs,this.type,this.seeMoreCallback});

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return appCard(
      padding: EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.only(
                    left: 16.0, right: 16, top: 12, bottom: 12),
                child: Text(
                  title ?? "",
                  style: styleElements
                      .headline6ThemeScalable(context)
                      .copyWith(
                      fontWeight: FontWeight.bold,
                      color: HexColor(AppColors.appColorBlack85)),
                  textAlign: TextAlign.left,
                ),
              )
          ),
          Container(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: typeList!.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return appUserListTile(
                  onPressed: (){
                    saveHistory(typeList![index],type);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfileCards(
                              userType: type=='person'?( typeList![index].id==prefs!.getInt(Strings.userId)?"person":"thirdPerson"):"institution",
                              userId: typeList![index].id==prefs!.getInt(Strings.userId)?null:typeList![index].id,
                              callback: () {},
                              currentPosition: 1,
                              type:null,
                            )
                        ));
                  },
                  imageUrl: typeList![index].avatar,
                  title:typeList![index].title,
                  subtitle1:typeList![index].subtitle1,
                  trailingWidget: Visibility(
                    visible: !(typeList![index].isFollowing??=false),
                    child: GenericFollowUnfollowButton(
                      isRoundedButton: true,
                      actionByObjectType: 'person',
                      actionByObjectId: prefs!.getInt(Strings.userId),
                      actionOnObjectType: type,
                      actionOnObjectId:  typeList![index].id,
                      engageFlag:  typeList![index].isFollowing!
                          ? AppLocalizations.of(context)!.translate('following')
                          : AppLocalizations.of(context)!.translate('follow'),
                      actionFlag:  typeList![index].isFollowing! ? "U" : "F",
                      actionDetails: [],
                      personName: "",
                      callback: (isCallSuccess) {
                        setState(() {
                          if(isCallSuccess)
                          typeList![index].isFollowing = true;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: ()  {
                  seeMoreCallback!(type);
                },
                child: Container(
                  margin:
                  EdgeInsets.only(right: 20, top: 20, bottom: 20),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child:Text(AppLocalizations.of(context)!.translate('see_more'),
                      style: styleElements.subtitle2ThemeScalable(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void saveHistory(SearchTypeItem typeList, String? entityType) {
    SaveHistoryRequest payload = SaveHistoryRequest(
      entityType: entityType,
      pageNumber: 1,
      pageSize: 10,
      institutionId: prefs!.getInt(Strings.instituteId),
      personId: prefs!.getInt(Strings.userId),
      searchPage: 'common',
      searchType: 'person',
      entityDetails: jsonDecode(jsonEncode(typeList))
    );
    Calls().call(jsonEncode(payload), context, Config.SAVE_HISTORY).then((value) {
      var res = SaveHistoryResponse.fromJson(value);
      if(res.statusCode == Strings.success_code){
      }
    });
  }
}
