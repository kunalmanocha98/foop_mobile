import 'dart:convert';


import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/tricycle_event_card.dart';
import 'package:oho_works_app/components/tricycleemptywidget.dart';
import 'package:oho_works_app/models/CalenderModule/calenderModels.dart';
import 'package:oho_works_app/models/CalenderModule/event_listings.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CalenderListPage extends StatefulWidget {
  DateTime? date;
  String? type;

  CalenderListPage({Key? key, this.date, this.type}) : super(key: key);

  @override
  CalenderListPageState createState() => CalenderListPageState(date: date);
}

class CalenderListPageState extends State<CalenderListPage> {
  DateTime? date;
  String? searchVal;
  final DateFormat formatter = DateFormat('MMMM yyyy');

  CalenderListPageState({this.date});

  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  SharedPreferences? prefs;
  int page = 1;
  List<EventListItem>? list;
  bool isEmpty = false;

  @override
  void initState() {
    list = [];
    super.initState();
    fetchList();
  }

  void refresh() {
    setState(() {
      list!.clear();
      page = 1;
    });
    fetchList();
  }

  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: SearchBox(
                hintText: AppLocalizations.of(context)!.translate('search'),
                onvalueChanged: (String value) {
                  setState(() {
                    page = 1;
                  });
                  update(date: date, searchVal: value);
                },
              ),
            )
          ];
        },
        body: isEmpty
            ? Center(
                child: TricycleEmptyWidget(
                message: AppLocalizations.of(context)!.translate('no_data'),
                assetImage: null,
              ))
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo is ScrollEndNotification &&
                      scrollInfo.metrics.extentAfter == 0) {
                    fetchList();
                    return true;
                  }
                  return false;
                },
                child: list!.isNotEmpty
                    ? GroupedListView<dynamic, String?>(
                        elements: list!,
                        groupBy: (element) => element.eventDate,
                        groupSeparatorBuilder: (String? groupByValue) => Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 4.0,
                                  bottom: 4.0),
                              child: Text(
                                Utility().getDateFormat('dd MMM yyyy', DateTime.parse(groupByValue!)),
                                style: styleElements
                                    .subtitle1ThemeScalable(context)
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        itemBuilder: (context, dynamic element) =>
                            listItemBuilder(element),
                        itemComparator: (item1, item2) =>
                            item1.title.compareTo(item2.title),
                        // optional
                        //useStickyGroupSeparators: true, // optional
                        floatingHeader: true,
                        // optional
                        order: GroupedListOrder.ASC, // optional
                      )
                    : Center(
                        child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator())),


              ));
  }

  Future<void> fetchList() async {
    prefs ??= await SharedPreferences.getInstance();
    CalenderEventListRequest payload = CalenderEventListRequest();
    payload.eventDate =
        date != null ? Utility().getDateFormat('yyyy-MM-dd', date!) : null;
    payload.eventOwnerId = prefs!.getInt(Strings.userId);
    payload.eventOwnerType = 'person';
    payload.searchVal = searchVal;
    payload.pageNumber = page;
    payload.pageSize = 10;
    payload.listType = widget.type;
    var res = await Calls()
        .call(jsonEncode(payload), context, Config.CALENDERS_EVENT_LIST);
    if (EventListResponse.fromJson(res).statusCode == Strings.success_code) {
      if (EventListResponse.fromJson(res).rows!.isNotEmpty) {
        setState(() {
          page = page + 1;
          list = [list, EventListResponse.fromJson(res).rows]
              .expand((x) => x!)
              .toList();
        });
      } else {
        setState(() {
          if (page == 1) isEmpty = true;
        });
      }
    } else {
      setState(() {
        if (page == 1) isEmpty = true;
      });
    }
  }

  Widget listItemBuilder(itemData) {
    EventListItem item = itemData;
    return TricycleEventCard(
      title: item.title,
      byImage: item.header!.avatar,
      description: item.subtitle,
      subjectId: item.id,
      dateVisible: true,
      isBellPressed: item.userReminderTime == null ? false : true,
      bellIconCallBack: () {
        setState(() {
          item.userReminderTime = DateTime.now().millisecondsSinceEpoch;
        });
      },
      isBellAvailable: true,
      date: DateTime.fromMillisecondsSinceEpoch(item.startTime!),
      byTitle: ' by ' + item.header!.title! + ', ' + item.header!.subtitle1!,
      cardRating: item.header!.rating ?? 0.0,
    );
  }

  Widget emptyListWidgetMaker(EventListResponse pageData) {
    return CustomPaginator(context).emptyListWidgetMaker(pageData,
        message: AppLocalizations.of(context)!.translate('no_activities_found'));
  }

  void update({DateTime? date, String? searchVal}) {
    this.date = date ?? this.date;
    this.searchVal = searchVal ?? this.searchVal;
    refresh();
  }
}
