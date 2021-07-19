import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/CommonListingModels/commonListingrequest.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CommonListingModule extends StatefulWidget {
  String listType;
  String requestedByType;
  List<String> personType;

  CommonListingModule(
      {@required this.listType,
      @required this.requestedByType,
      @required this.personType});

  @override
  _CommonListingModule createState() => _CommonListingModule(
      listType: listType,
      personType: personType,
      requestedByType: requestedByType);
}

class _CommonListingModule extends State<CommonListingModule> {
  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();
  String searchVal;
  SharedPreferences prefs;
  String listType;
  String requestedByType;
  List<String> personType;
  List<CommonListResponseItem> list = [];
  TextStyleElements styleElements;
  _CommonListingModule(
      {@required this.listType,
      @required this.requestedByType,
      @required this.personType});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setSharedPrefrences());
  }

  setSharedPrefrences() async {
    prefs = await SharedPreferences.getInstance();
    refresh();
  }

  refresh() {
    paginatorGlobalKey.currentState.changeState(resetState: true);
  }

  onSearchValueChanged(String value) {
    searchVal = value;
    paginatorGlobalKey.currentState.changeState(resetState: true);
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    // setSharedPrefrences();
    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBar(context, appBarTitle:   AppLocalizations.of(context).translate("listing"), onBackButtonPress: (){Navigator.pop(context);}),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: SearchBox(
                  onvalueChanged: onSearchValueChanged,
                  hintText: AppLocalizations.of(context).translate("search"),
                ),
              )
            ];
          },
          body: Container(
            margin: EdgeInsets.only(top: 24),
            child: Paginator.listView(
                key: paginatorGlobalKey,
                scrollPhysics: BouncingScrollPhysics(),
                pageLoadFuture: getUserList,
                pageItemsGetter: listItemsGetter,
                listItemBuilder: listItemBuilder,
                loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
                errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
                totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                pageErrorChecker: CustomPaginator(context).pageErrorChecker),
          ),
        ),
      ),
    );
  }

  List<CommonListResponseItem> listItemsGetter(dynamic response) {
    list.addAll(response.rows);
    return response.rows;
  }

  Future<CommonListResponse> getUserList(int page) async {
    CommonListRequestPayload payload = CommonListRequestPayload();
    payload.searchVal = searchVal;
    payload.personId = prefs.getInt(Strings.userId).toString();
    payload.pageNumber = page;
    payload.pageSize = 20;
    payload.listType = listType;
    payload.personType = personType;

    payload.requestedByType = requestedByType;
    payload.institutionId = 2 /*prefs.getInt(Strings.institutionId)*/;
    var data = jsonEncode(payload);
    try {
      var value = await Calls().call(data, context, Config.USER_LIST);
      return CommonListResponse.fromJson(value);
    } catch (e) {
      return null;
    }
  }

  Widget listItemBuilder(itemData, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () {},
          child: ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading:TricycleAvatar(
              size: 48,
              resolution_type: RESOLUTION_TYPE.R64,
              service_type: SERVICE_TYPE.PERSON,
              imageUrl: itemData.avatar
            ),
            title: Text(itemData.title,
                style: styleElements.subtitle1ThemeScalable(context)),
            subtitle: Text(itemData.subTitle1.contact,
                style: styleElements.captionThemeScalable(context)),
            trailing: getTrailing(itemData, index),
          ),
        ),
      ),
    );
  }

  Widget getTrailing(CommonListResponseItem item, int index) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        Visibility(
          visible: !item.isFollowing,
          child: GenericFollowUnfollowButton(
            actionByObjectType: "person",
            isRoundedButton: false,
            actionByObjectId: 107,
            actionOnObjectType: "person",
            actionOnObjectId: item.id,
            engageFlag: "Follow",
            actionFlag: "F",
            actionDetails: [""],
            personName: item.title,
            callback: (isCallSuccess) {
              ToastBuilder().showToast("success", context,HexColor(AppColors.information));
              setState(() {
                list[index].isFollowing = true;
              });
              // apiCallResponse(isCallSuccess);
            },
          ),
        ),
        _showPopupMenu(item.isFollowing, item.id, index)
      ],
    );
  }

  Widget _showPopupMenu(bool isFollowing, int id, int index) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => getPopups(isFollowing),
      onSelected: (value) {
        print(value);
        if (value == 4) {
          unfollow(id, index);
        }
      },
      icon: Icon(
        Icons.more_vert,
        size: 24,
        color: HexColor(AppColors.appColorBlack85),
      ),
    );
  }

  getPopups(bool isFollowing) {
    if (isFollowing) {
      return [
        PopupMenuItem(
          value: 1,
          child: Text(AppLocalizations.of(context).translate('view_details')),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(AppLocalizations.of(context).translate('bookmark')),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(AppLocalizations.of(context).translate('update_status')),
        ),
        PopupMenuItem(
          value: 4,
          child: Text(AppLocalizations.of(context).translate('unfollow')),
        ),
      ];
    } else {
      return [
        PopupMenuItem(
          value: 1,
          child: Text(AppLocalizations.of(context).translate('view_details')),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(AppLocalizations.of(context).translate('bookmark')),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(AppLocalizations.of(context).translate('update_status')),
        ),
      ];
    }
  }

  void unfollow(int id, int index) async {
    GenericFollowUnfollowButtonState().followUnfollowBlock(
      "person",
      107,
      "person",
      id,
      "U",
      [""],
      (isSuccess) {
        if (isSuccess) {
          list[index].isFollowing = false;
          setState(() {});
        }
      },
      context
    );
  }
}
