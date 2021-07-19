
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/models/suggestion_data.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';




// ignore: must_be_immutable
class Suggestions extends StatefulWidget {
  _Suggestions createState() =>
      _Suggestions();
}

class _Suggestions extends State<Suggestions> with SingleTickerProviderStateMixin {
  List<CustomTabMaker> list = [];
  TabController _tabController;
  TextStyleElements styleElements;
  String type;
  int id;
  SharedPreferences prefs;
  String ownerType;
  int ownerId;
  String pageTitle;
  Null Function() callback;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  _Suggestions();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setSharedPreferences());
  }
  refresh() {
    paginatorKey.currentState.changeState(resetState: true);
  }
  onPositionChange() {
    if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
      });
    }
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    ownerType=prefs.getString("ownerType");
    ownerId=prefs.getInt("userId");

  }
BuildContext sctx;


  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: TricycleAppBar().getCustomAppBar(context,
              appBarTitle: AppLocalizations.of(context).translate('suggestions'),
              onBackButtonPress: () {
                Navigator.pop(context);

              }),
          body:

          new Builder(builder: (BuildContext context) {
            this.sctx = context;
            return
              new Container(
                child:  RefreshIndicator(
                  onRefresh: refreshList,
                  child: Paginator.listView(
                      key: paginatorKey,
                      padding: EdgeInsets.only(top: 16),
                      scrollPhysics: BouncingScrollPhysics(),
                      pageLoadFuture: getSuggestion,
                      pageItemsGetter: CustomPaginator(context).listItemsGetter,
                      listItemBuilder: listItemBuilder,
                      loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
                      errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                      emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
                      totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                      pageErrorChecker: CustomPaginator(context).pageErrorChecker),
                ),
              )
            ;
          })

      ),
    );
  }

  Future<SuggestionData> getSuggestion(int page) async {
    prefs = await SharedPreferences.getInstance();
    final body = jsonEncode({"type":"network","page_size":10,"page_number":page});
    var res = await Calls().call(body, context, Config.SUGGESTIONS);

    return SuggestionData.fromJson(res);
  }
  Future<Null> refreshList() async {
   refresh();
    await new Future.delayed(new Duration(seconds: 2));
    setState(() {

    });
    return null;
  }
  Widget listItemBuilder(value, int index) {
    Rows item = value;
    return
    ListTile(
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
                    if( callback!=null)
                      callback();
                  },
                  currentPosition: 1,
                  type: null,
                )));
      },
      tileColor: HexColor(AppColors.listBg),
      leading:TricycleAvatar(imageUrl: item.avatar,
        service_type: SERVICE_TYPE.PERSON,
        resolution_type: RESOLUTION_TYPE.R64,
        size: 56,
        key: UniqueKey(),
      ),
      title:  Text(item.title ?? "",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: styleElements
              .subtitle1ThemeScalable(context)),
      subtitle: Text(item.subtitle ?? "",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: styleElements
              .captionThemeScalable(context)),
      trailing: Visibility(
        visible: item.id != prefs.getInt(Strings.userId),
        child: GenericFollowUnfollowButton(
          actionByObjectType: prefs.getString("ownerType"),
          actionByObjectId: prefs.getInt("userId"),
          actionOnObjectType: "person",
          actionOnObjectId: item.id,
          engageFlag: AppLocalizations.of(context)
              .translate('follow'),
          actionFlag:  "F",
          actionDetails: [],
          personName: item.title ?? "",
          callback: (isCallSuccess) {

            refresh();
          },
        ),
      ),
    );
  }
}

