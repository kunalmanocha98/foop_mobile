import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:oho_works_app/components/tricycle_user_list_tile.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'institute_admin_list.dart';
import 'staff_list.dart';

class AddInstituteAdminPage extends StatefulWidget {
  final int selectedInstituteId;
  AddInstituteAdminPage({this.selectedInstituteId});
  @override
  AddInstituteAdminPageState createState() => AddInstituteAdminPageState();
}

class AddInstituteAdminPageState extends State<AddInstituteAdminPage> {
  SharedPreferences prefs = locator<SharedPreferences>();
  String searchVal = "";
  bool isSearching = false;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  TextEditingController searchController = TextEditingController();
  BuildContext sctx;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.sctx = context;
    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBarWithSearch(context,
            controller: searchController,
            appBarTitle:
            AppLocalizations.of(context).translate('add_institute_admin'),
            onBackButtonPress: () {
              Navigator.pop(context);
            },
            actions: [],
            onSearchValueChanged: (value) {
              setState(() {
                searchVal = value;
                isSearching = searchVal.isNotEmpty;
                if (paginatorKey.currentState != null) {
                  paginatorKey.currentState.changeState(resetState: true);
                }
              });
            }),
        body: isSearching
            ? TricycleListCard(
          child: Paginator<StaffListResponse>.listView(
            key: paginatorKey,
            pageLoadFuture: fetchList,
            pageItemsGetter: CustomPaginator(context).listItemsGetter,
            listItemBuilder: listItemGetter,
            loadingWidgetBuilder:
            CustomPaginator(context).loadingWidgetMaker,
            errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
            emptyListWidgetBuilder:
            CustomPaginator(context).emptyListWidgetMaker,
            totalItemsGetter: CustomPaginator(context).totalPagesGetter,
            pageErrorChecker: CustomPaginator(context).pageErrorChecker,
          ),
        )
            : Container(),
      ),
    );
  }

  Future<StaffListResponse> fetchList(int page) async {
    StaffListRequest payload = StaffListRequest();
    payload.searchVal = searchVal;
    payload.pageNumber = page;
    payload.pageSize = 10;
    payload.institutionId = widget.selectedInstituteId;
    var value = await Calls().call(jsonEncode(payload), context, Config.ADMIN_STAFF_LIST);
    return StaffListResponse.fromJson(value);
  }

  Widget listItemGetter(itemData, int index) {
    StaffListMember member = itemData;
    return InkWell(
      onTap: () {
        assignRole(member);
      },
      child: TricycleUserListTile(
        imageUrl: member.profileImage,
        title: member.personName,
        subtitle1: member.institutionName,
      ),
    );
  }

  void assignRole(StaffListMember member) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AdminAddRemoveDialog(
            okCallback: () {
              var body = jsonEncode({
                "institution_id": member.institutionId,
                "person_id": member.personId,
                "role_id": 9
              });
              Calls().call(body, context, Config.ADMIN_ASSIGN_ROLE).then((value) {
                var response = AssignRoleResponse.fromJson(value);
                if (response.statusCode == Strings.success_code) {
                  var string = response.rows is String;
                  if (string) {
                    ToastBuilder()
                        .showToast(response.rows, sctx, HexColor(AppColors.failure));
                  } else {
                    ToastBuilder().showToast(
                        AppLocalizations.of(context).translate('add_admin'),
                        sctx,
                        HexColor(AppColors.information));
                    setState(() {
                      searchController.text = "";
                      isSearching = false;
                    });
                  }
                }
              });
            },
            cancelCallback: () {},
            message: AppLocalizations.of(context).translate('add_admin_message',arguments: {"name":member.personName}),
          );
        });

  }
}

