import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/tricycle_event_card.dart';
import 'package:oho_works_app/models/CalenderModule/calenderModels.dart';
import 'package:oho_works_app/models/CalenderModule/event_listings.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ignore: must_be_immutable
class EventListPage extends StatefulWidget {
  DateTime date;
  EventListPage({Key key,this.date}):super(key: key);

  @override
  EventListState createState() => EventListState(date: date);
}

class EventListState extends State<EventListPage> {
  DateTime date;
  String searchVal;
  EventListState({this.date});
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  SharedPreferences prefs;

  void refresh(){
    paginatorKey.currentState.changeState(resetState: true);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: SearchBox(
                hintText: AppLocalizations.of(context).translate('search'),
                onvalueChanged: (String value) {
                },
              ),
            )
          ];
        },
        body: Paginator.listView(
            key: paginatorKey,
            pageLoadFuture: fetchList,
            pageItemsGetter: CustomPaginator(context).listItemsGetter,
            listItemBuilder: listItemBuilder,
            loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
            errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
            emptyListWidgetBuilder:emptyListWidgetMaker,
            totalItemsGetter: CustomPaginator(context).totalPagesGetter,
            pageErrorChecker: CustomPaginator(context).pageErrorChecker
        )
    );
  }

  Future<EventListResponse> fetchList(int page) async{
    prefs??= await SharedPreferences.getInstance();
    CalenderEventListRequest payload = CalenderEventListRequest();
    payload.eventDate= Utility().getDateFormat('yyyy-MM-dd',date);
    payload.eventOwnerId = prefs.getInt(Strings.userId);
    payload.eventOwnerType = 'person';
    payload.pageNumber = page;
    payload.pageSize = 10;
    var res = await Calls().call(jsonEncode(payload), context, Config.CALENDERS_EVENT_LIST);
    return  EventListResponse.fromJson(res);
  }

  Widget listItemBuilder(itemData, int index) {
    EventListItem item= itemData;
    return TricycleEventCard(
      title: item.title,
      listofImages: List<String>.generate(item.participantList.length, (index) { return item.participantList[index].profileImage;}),
      description: item.subtitle,
      dateVisible: true,
      date: DateTime.fromMillisecondsSinceEpoch(item.startTime),
      byTitle: ' by '+item.header.title+', '+item.header.subtitle1,
      byImage: item.header.avatar,
      onlyHeader: false,
      isShareVisible: true,
      isModerator: item.eventRoleType == 'admin',
    );
  }

  Widget emptyListWidgetMaker(EventListResponse pageData) {
    return CustomPaginator(context).emptyListWidgetMaker(pageData,message: AppLocalizations.of(context).translate('no_events_found'),assetImage: 'assets/appimages/event.png');
  }

  void update({DateTime date,String searchVal}){
    this.date  = date ?? this.date;
    this.searchVal = searchVal ?? this.searchVal;
    refresh();
  }

}
