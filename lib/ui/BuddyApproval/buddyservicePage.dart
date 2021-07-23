import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/tricycle_earn_card.dart';
import 'package:oho_works_app/models/buddyApprovalModels/buddyServiceList.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuddyServicesPage extends StatefulWidget {
  @override
  BuddyServicesPageState createState() => BuddyServicesPageState();
}

class BuddyServicesPageState extends State<BuddyServicesPage> {
  SharedPreferences? prefs;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();

  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBar(
          context,
          appBarTitle: AppLocalizations.of(context)!.translate('buddy_services'),
          onBackButtonPress: () {
            Navigator.pop(context);
          },
        ),
        body: Paginator.listView(
            key: paginatorKey,
            pageLoadFuture: fetchList,
            pageItemsGetter: pageItemGetter,
            listItemBuilder: listItemBuilder,
            loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
            errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
            emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
            totalItemsGetter: totalPageGettter,
            pageErrorChecker: CustomPaginator(context).pageErrorChecker),
      ),
    );
  }

  Future<BuddyServiceListResponse> fetchList(int page) async{
    prefs ??= await SharedPreferences.getInstance();
    BuddyServiceListRequest payload = BuddyServiceListRequest();
    payload.ownerId = prefs!.getInt(Strings.userId);
    payload.ownerType = 'person';
    var res  = await Calls().call(jsonEncode(payload), context, Config.BUDDY_SERVICE_LIST);
    var model =  BuddyServiceListResponse.fromJson(res);
    // model.rows.add(BuddyServiceListItem(
    //   cardName: 'Earn',
    //   heading: "Buddy Institute Registration",
    //   coins: "500",
    //   moneyVal: "50",
    // ));
    return model;
  }

  List<BuddyServiceListItem>? pageItemGetter(BuddyServiceListResponse? pageData) {
    return pageData!.rows;
  }

  Widget listItemBuilder(itemData, int index) {
    BuddyServiceListItem item = itemData;
    return TricycleEarnCard(
      title: item.heading,
      coinsValue: item.coins,
      imageUrl: Config.BASE_URL+ item.imageUrl!,
      quote: '',
      moneyVal: item.moneyVal,
      type: item.cardName,
    );
  }

  int totalPageGettter(BuddyServiceListResponse pageData) {
    return pageData.rows!.length;
  }
}
