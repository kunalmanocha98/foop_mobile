import 'dart:convert';
import 'dart:developer';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/models/buddyApprovalModels/buddyListModels.dart';
import 'package:oho_works_app/ui/BuddyApproval/approvalDetailsPage.dart';
import 'package:oho_works_app/ui/BuddyApproval/tricycleRequestCard.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApprovalListPage extends StatefulWidget {
  @override
  ApprovalListPageState createState() => ApprovalListPageState();
}

class ApprovalListPageState extends State<ApprovalListPage> {
  String searchVal;
  SharedPreferences prefs;
  List<RequestListItem> requestList = [];
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  int total;


  @override
  Widget build(BuildContext context) {
    return
     SafeArea(
          child: Scaffold(
            appBar: TricycleAppBar().getCustomAppBarWithSearch(context,
                appBarTitle: AppLocalizations.of(context).translate('buddy_approval'),
                onBackButtonPress: () {
                  Navigator.pop(context);
                }, onSearchValueChanged: (String value) {
                  if (value.isNotEmpty) {
                    searchVal = value;
                    refresh();
                  }
                }),
            body:  Container(
                child:Paginator.gridView(
                    key: paginatorKey,
                    pageLoadFuture: fetchList,
                    pageItemsGetter: pageItemGetter,
                    listItemBuilder: listItemBuilder,
                    loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
                    errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                    emptyListWidgetBuilder:
                    CustomPaginator(context).emptyListWidgetMaker,
                    totalItemsGetter:totalPagesGetter,
                    pageErrorChecker: CustomPaginator(context).pageErrorChecker,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7)),
              ),

          ),
    );
  }

  refresh() {
    requestList.clear();
    paginatorKey.currentState.changeState(resetState: true);
    setState(() {

    });
  }

  Future<RequestListResponse> fetchList(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    RequestListRequest payload = RequestListRequest();
    payload.searchVal = searchVal;
    payload.pageSize = 20;
    payload.pageNumber = page;
    payload.approvedByPersonId = prefs.getInt(Strings.userId);
    // payload.institutionId = prefs.getInt(Strings.instituteId);
    var res = await Calls().call(jsonEncode(payload), context, Config.REQUEST_LIST);
    
    return RequestListResponse.fromJson(res);
  }

  List<RequestListItem> pageItemGetter(RequestListResponse pageData) {
    requestList.addAll(pageData.rows);
    return pageData.rows;
  }

  Widget listItemBuilder(itemData, int index) {
    RequestListItem item = itemData;
    return TricycleRequestCard(
      imageUrl: item.profileImage,
      buttonTitle: 'Verify',
      onButtonClickCallback: () {
        log("approval person" + jsonEncode(item));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ApprovalDetailsPage(
                  data: item,
                      callbackPicker: (){

                      },
                ))).then((value){
                  if(value!=null) {
                    Map<String, int> map = value;
                    if (map['value'] == 1) {
                      refresh();
                    }
                  }
        });
      },
    );
  }

  int totalPagesGetter(RequestListResponse pageData) {
    total = pageData.total;
    return total;
  }
}
