import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_user_list_tile.dart';
import 'package:oho_works_app/models/raters_data.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class RatersListPage extends StatefulWidget {

  final int type;
  final String userType;
  final int? userId;
  final  Null Function()? callback;
  final int? ownerId;
  final String? ownerType;
  final bool isProfile;
  RatersListPage( this.type,this.userId,this.userType,this.callback,{this.ownerId,this.ownerType,this.isProfile = true});

  @override
  _RatersListPage createState() =>
      _RatersListPage(type,userId,userType,callback);
}

class _RatersListPage extends State<RatersListPage>
    with AutomaticKeepAliveClientMixin<RatersListPage> {
  String? searchVal;
  String? personName;

  int type;
  int? id;
   String userType;
   int? userId;
  String? ownerType;
  int? ownerId;
  Null Function()? callback;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  SharedPreferences? prefs;
  TextStyleElements? styleElements;

  @override
  bool get wantKeepAlive => true;


  @override
  void initState() {
    super.initState();
  }

  void onsearchValueChanged(String text) {
    searchVal = text;
    refresh();
  }

  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    styleElements = TextStyleElements(context);

    return TricycleListCard(
            child: Paginator.listView(
                key: paginatorKey,
                padding: EdgeInsets.only(top: 16),
                pageLoadFuture: getFollowers,
                pageItemsGetter: CustomPaginator(context).listItemsGetter,
                listItemBuilder: listItemBuilder,
                loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
                errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
                totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                pageErrorChecker: CustomPaginator(context).pageErrorChecker),
          );
  }

  Future<RatersData> getFollowers(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    ownerId= widget.ownerId!=null ? widget.ownerId :prefs!.getInt(Strings.userId);
    ownerType=widget.ownerType!=null?widget.ownerType:prefs!.getString(Strings.ownerType);
    final body = jsonEncode(
        {
          "rating_subject_type": widget.isProfile?null:userType,
          "rating_subject_id": widget.isProfile?null:userId,
          "rating_context_type":ownerType,
          "rating_context_id": ownerId,
          "rating_given": type,
          "object_type": userType,
          "object_id":userId,
          "page_number": page,
          "page_size": 20,
        }
);

    var res = await Calls().call(body, context, Config.RATERS_LIST);
    return RatersData.fromJson(res);
  }

  Widget listItemBuilder(value, int index) {
    RatersItem item = value;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserProfileCards(
                  userType: item.id == ownerId
                      ? "person"
                      : "thirdPerson",
                  userId: item.id != ownerId ? item.id : null,
                  callback: () {
                    callback!();
                  },
                  currentPosition: 1,
                  type: null,
                )));
      },
      child: TricycleUserListTile(
        imageUrl: item.profileImage,
        title:  item.name ?? "",
        trailingWidget:    Visibility(
          visible: item.id != prefs!.getInt(Strings.userId) && !item.isObjectFollowing!,
          child: GenericFollowUnfollowButton(
            actionByObjectType: prefs!.getString("ownerType"),
            actionByObjectId: prefs!.getInt("userId"),
            actionOnObjectType: "person",
            actionOnObjectId: item.id,
            engageFlag: item.isObjectFollowing ?? false
                ? AppLocalizations.of(context)!
                .translate('following')
                : AppLocalizations.of(context)!
                .translate('follow'),
            actionFlag: item.isObjectFollowing ?? false ? "U" : "F",
            actionDetails: [],
            personName: item.name ?? "",
            callback: (isCallSuccess) {
              callback!();
             refresh();
            },
          ),
        ),
      )
    );
  }

  _RatersListPage(
      this.type,this.userId,this.userType,this.callback);
}
