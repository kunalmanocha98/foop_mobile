import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/crm_module/create_customer_contact.dart';
import 'package:oho_works_app/models/CommonListingModels/commonListingrequest.dart';
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

import 'createCompanyPage.dart';

// ignore: must_be_immutable
class CommonCompanyCustomerPage extends StatefulWidget {

  final String type;


  CommonCompanyCustomerPage( this.type,);

  @override
  _CommonCompanyCustomerPage createState() =>
      _CommonCompanyCustomerPage(type);
}

class _CommonCompanyCustomerPage extends State<CommonCompanyCustomerPage>
    with AutomaticKeepAliveClientMixin<CommonCompanyCustomerPage> {
  String? searchVal;
  String? personName;
  String type;
  int? id;
  String? ownerType;
  int? ownerId;
  late Null Function() callback;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  late SharedPreferences prefs;
  late TextStyleElements styleElements;

  @override
  bool get wantKeepAlive => true;

  void setSharedPreferences() async {
    refresh();
  }

  Future<void> _setPref() async {
    prefs = await SharedPreferences.getInstance();
    ownerId= prefs.getInt(Strings.userId);
  }

  @override
  void initState() {
    super.initState();

    _setPref();
  }

  void onsearchValueChanged(String text) {
    // print(text);
    searchVal = text;
    refresh();
  }

  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return Container(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: SearchBox(
                        onvalueChanged: onsearchValueChanged,
                        hintText: AppLocalizations.of(context)!.translate('search'),
                      ),
                    ),
                    InkWell(
                      onTap: (){

                        type=="S"?
            Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
            return CreateCompanyPage(
            type: 'talk',
            standardEventId: 5,
            title: "",
            );
            })):Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return CreateCustomerPage(
                                type: 'talk',
                                standardEventId: 5,
                                title: "",
                              );
                            }));
            },

                      child:  Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Row(
                          children: [

                            Icon(
                              Icons.add,
                              color: HexColor(AppColors.appColorBlack65),
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate('new'),
                              textAlign: TextAlign.center,
                              style: styleElements
                                  .subtitle1ThemeScalable(context)
                                  .copyWith(
                                  color: HexColor(AppColors.appColorBlack65)),
                            ),
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ),
            

            ];
          },
          body:RefreshIndicator(
            onRefresh: refreshList,
            child: appCard(
              child: Paginator.listView(
                  key: paginatorKey,
                  padding: EdgeInsets.only(top: 8),
                  scrollPhysics: BouncingScrollPhysics(),
                  pageLoadFuture: getFollowers,
                  pageItemsGetter: CustomPaginator(context).listItemsGetter,
                  listItemBuilder: listItemBuilder,
                  loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
                  errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                  emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
                  totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                  pageErrorChecker: CustomPaginator(context).pageErrorChecker),
            ),
          ),
        ));
  }
  Future<Null> refreshList() async {
    refresh();
    await new Future.delayed(new Duration(seconds: 2));

    return null;
  }
  Future<CommonListResponse> getFollowers(int page) async {
    prefs = await SharedPreferences.getInstance();
    final body = jsonEncode({
      "search_val": searchVal,
      "person_type": [type],
      "page_number": page,
      "page_size": 20,
      "requested_by_type": "institution",
      "list_type": null,
      "person_id": prefs.getInt(Strings.userId),
      "institution_id": null
    });

    var res = await Calls().call(body, context, Config.USER_LIST);

    return CommonListResponse.fromJson(res);
  }

  Widget listItemBuilder(value, int index) {
    CommonListResponseItem item = value;
    var schoolName=item.institutionName!=null?item.institutionName??"":"";
    var desig=item.subTitle1!.designation!=null ?item.subTitle1!.designation??"":"";
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
                      callback();
                    },
                    currentPosition: 1,
                    type: null,
                  )));
        },
        child:  appUserListTile(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfileCards(
                      userType: item.id == ownerId
                          ? "person"
                          : "thirdPerson",
                      userId: item.id != ownerId ? item.id : null,
                      callback: () {
                        callback();
                      },
                      currentPosition: 1,
                      type: null,
                    )));
          },
          imageUrl: item.avatar,
          title: item.title,
          subtitle1: '$desig , $schoolName',
          trailingWidget:  Checkbox(
            onChanged: (value) {

            },
            value: false,
          ),
        )
    );
  }

  _CommonCompanyCustomerPage(
      this.type,);
}
