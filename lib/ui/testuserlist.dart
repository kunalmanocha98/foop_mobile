import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/testuserlistresponse.dart';
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

class TestUserList extends StatefulWidget {
  @override
  _TestUserList createState() => _TestUserList();
}

class _TestUserList extends State<TestUserList> {
  List<UserListResponseItem> list = [];
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  TextStyleElements? styleElements;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: OhoAppBar().getCustomAppBar(context,
            appBarTitle:AppLocalizations.of(context)!.translate('users_list'),
            onBackButtonPress: (){
          Navigator.pop(context);
            }),
        body: Paginator.listView(
            key: paginatorKey,
            pageLoadFuture: getUserList,
            pageItemsGetter: CustomPaginator(context).listItemsGetter,
            listItemBuilder: listItemBuilder,
            loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
            errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
            emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
            totalItemsGetter: totalPagesGetter,
            pageErrorChecker: CustomPaginator(context).pageErrorChecker),
      ),
    );
  }

  Future<UserListResponse> getUserList(int page) async {
    UserListRequest payload = UserListRequest();
    payload.pageNumber = page;
    payload.pageSize = 5;
    payload.searchVal = null;
    var data = jsonEncode(payload);
    var value = await Calls().call(data, context, Config.ALLUSERLIST);
    return UserListResponse.fromJson(value);
    // await Future.delayed(Duration(milliseconds: 5000));
    // var res = await rootBundle.loadString('assets/testusers.json');
    // final Map parsed = json.decode(res);
    // return BaseResponses.fromJson(parsed);
  }

  List<UserListResponseItem>? listItemsGetter(
      UserListResponse userListResponse) {
    list.addAll(userListResponse.rows!);
    return userListResponse.rows;
  }

  Widget listItemBuilder(value, int index) {
    return InkWell(
      onTap: () {
        changeselected(index);
      },
      child: ListTile(

        leading: appAvatar(
          size: 48,
          resolution_type: RESOLUTION_TYPE.R64,
          service_type: SERVICE_TYPE.PERSON,
          imageUrl: value.profileImage,
        ),
        title: Text((value.firstName != null && value.lastName != null)
            ? value.firstName + " " + value.lastName
            : ""),
        subtitle: Text(value.mobile != null ? value.mobile : ""),
        trailing: (value.selected != null && value.selected == true)
            ? Icon(Icons.add)
            : GenericFollowUnfollowButton(
                actionByObjectType: "person",
                actionByObjectId: 107,
                actionOnObjectType: "person",
                actionOnObjectId: value.id,
                engageFlag: "Follow",
                actionFlag: "F",
                actionDetails: [""],
                personName: (value.firstName != null && value.lastName != null)
                    ? value.firstName + " " + value.lastName
                    : "",
                callback: (isCallSuccess) {
                  ToastBuilder().showToast("success", context,HexColor(AppColors.information));
                  // apiCallResponse(isCallSuccess);
                },
              ),
      ),
    );
  }

  Widget loadingWidgetMaker() {
    return Container(
      alignment: Alignment.center,
      height: 160.0,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(HexColor(AppColors.appMainColor)),
      ),
    );
  }

  Widget errorWidgetMaker(UserListResponse userListResponse, retryListener) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(userListResponse.message!),
        ),
        appTextButton(
          onPressed: retryListener,
          child: Text(AppLocalizations.of(context)!.translate('retry')),
        )
      ],
    );
  }

  Widget emptyListWidgetMaker(UserListResponse userListResponse) {
    return Center(
      child: Text(AppLocalizations.of(context)!.translate('no_user')),
    );
  }

  int totalPagesGetter(UserListResponse userListResponse) {
    return 10;
  }

  bool pageErrorChecker(UserListResponse userListResponse) {
    if (userListResponse.statusCode == Strings.success_code) {
      return false;
    } else {
      return true;
    }
  }

  void changeselected(int index) {
    list[index].selected = true;
    setState(() {});
  }
}
