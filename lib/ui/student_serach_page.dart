import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/components/appemptywidget.dart';
import 'package:oho_works_app/models/CommonListingModels/commonListingrequest.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/register_user_as_response.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:oho_works_app/regisration_module/verify_child.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'childDetailFormPage.dart';
import 'dialog_page.dart';

// ignore: must_be_immutable
class StudentsPageNew extends StatefulWidget {
  RegisterUserAs? registerUserAs;

  StudentsPageNew(this.registerUserAs);

  @override
  _StudentsPageNew createState() => _StudentsPageNew(registerUserAs);
}

class _StudentsPageNew extends State<StudentsPageNew>
    with AutomaticKeepAliveClientMixin<StudentsPageNew> {
  String? searchVal;
  RegisterUserAs? registerUserAs;
  String? personName;
  String type="parent";
  int? id;
  String? ownerType;
  int? ownerId;
  Null Function()? callback;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  late SharedPreferences prefs;
  late TextStyleElements styleElements;
  String pageTitle = "";
  ProgressDialog? pr;
  List<CommonListResponseItem> listInstitute = [];
  List<CommonListResponseItem> selectedL = [];
  CommonListResponseItem selectedItem = CommonListResponseItem();
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();

  @override
  bool get wantKeepAlive => true;
  int? idStudent;

  void setSharedPreferences() async {
    refresh();
  }

  List<CommonListResponseItem>? listItemsGetter(CommonListResponse? response) {
    for (int i = 0; i < response!.rows!.length; i++) {
      response.rows![i].isSelected = false;
    }
    listInstitute.addAll(response.rows!);
    return response.rows;
  }

  Future<void> _setPref() async {
    prefs = await SharedPreferences.getInstance();
    ownerId = prefs.getInt(Strings.userId);
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

  Future<bool> _onBackPressed() {
    Navigator.of(context).pop(true);
    return new Future(() => false);
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor(AppColors.appColorBackground),
        appBar: appAppBar().getCustomAppBar(context,
            appBarTitle: pageTitle, onBackButtonPress: () {
          _onBackPressed();
        }),
        body: Stack(
          children: [
            Container(
                child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: SearchBox(
                      onvalueChanged: onsearchValueChanged,
                      hintText: AppLocalizations.of(context)!.translate('search'),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Visibility(
                        visible: true,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            color: HexColor(AppColors.appColorWhite),
                            child: Card(
                                child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: HexColor(AppColors.appMainColor10),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(4.0),
                                      topLeft: Radius.circular(4.0))),
                              child: Container(
                                margin: const EdgeInsets.all(16),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate("selectChildInstruction"),
                                  textAlign: TextAlign.center,
                                  style: styleElements
                                      .captionThemeScalable(context)
                                      .copyWith(color: HexColor(AppColors.appColorBlack85)),
                                ),
                              ),
                            )),
                          ),
                        )),
                  )
                ];
              },
              body:searchVal!=null && searchVal!.trim().isNotEmpty?

              Paginator.listView(
                  key: paginatorKey,
                  padding: EdgeInsets.only(top: 16,bottom: 50),
                  scrollPhysics: BouncingScrollPhysics(),
                  pageLoadFuture: getChild,
                  pageItemsGetter: CustomPaginator(context).listItemsGetter,
                  listItemBuilder: listItemBuilder,
                  loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
                  errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                  emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
                  totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                  pageErrorChecker: CustomPaginator(context).pageErrorChecker):




              appEmptyWidget(message: "No data found !!",),
            )),
            Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  child: Container(
                    height: 60,
                    color: HexColor(AppColors.appColorWhite),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Visibility(
                                visible: true,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChildDetailFormPage(
                                                  registerUserAs),
                                        ));



                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(16),
                                    child: Text(AppLocalizations.of(context)!.translate('skip_this_now'),
                                      style: styleElements
                                          .bodyText2ThemeScalable(context)
                                          .copyWith(color: HexColor(AppColors.appMainColor)),
                                    ),
                                  ),
                                )),
                            Visibility(
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 60,
                                    color: HexColor(AppColors.appColorWhite),
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 16.0, right: 16.0),
                                          child: appProgressButton(
                                            key: progressButtonKey,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: HexColor(AppColors.appMainColor))),
                                            onPressed: () {
                                              var ids = isItemSelected();
                                              if (ids != null) {
                                                registerUserAs!.childId = ids;
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          VerifyChild(0,
                                                              registerUserAs),
                                                    ));
                                              } else {
                                                register(
                                                    prefs.getInt("userId"));
                                              }
                                            },
                                            color: HexColor(AppColors.appColorWhite),
                                            child: Text(
                                              AppLocalizations.of(context)!.translate('next'),
                                              style: styleElements
                                                  .subtitle2ThemeScalable(
                                                      context)
                                                  .copyWith(
                                                      color: HexColor(AppColors.appMainColor)),
                                            ),
                                          ),
                                        )),
                                  )),
                            )
                          ],
                        )),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  // ignore: missing_return
  Future<CommonListResponse?> getChild(int page) async {
    prefs = await SharedPreferences.getInstance();
    final body = jsonEncode({
      "page_number": page,
      "page_size": 20,
      "requested_by_type": "institution",
      "list_type": null,
      "business_id": registerUserAs!.institutionId,
      "search_val": searchVal,
      "person_type": ["S"],
      "person_id": prefs.getInt("userId").toString(),
      /*  "class_id": registerUserAs.personClasses[0].classId,
      "section_id": registerUserAs.personClasses[0]!=null && registerUserAs.personClasses[0].sections!=null &&
          registerUserAs.personClasses[0].sections.isNotEmpty?registerUserAs.personClasses[0].sections[0]:null*/
    });
    var res;

    res = await Calls().call(body, context, Config.USER_LIST);
    if (res != null) return CommonListResponse.fromJson(res);
  }

  Widget listItemBuilder(value, int index) {
    CommonListResponseItem item = value;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: Padding(
          padding: EdgeInsets.all(10),
          child: appUserListTile(
            imageUrl: item.avatar,
              title: item.title,
              trailingWidget: Checkbox(
                activeColor: HexColor(AppColors.appMainColor),
                value: item.isSelected,
                onChanged: (val) {
                  if (this.mounted) {
                    setState(() {
                      if (val!) {
                        for (int i = 0; i < listInstitute.length; i++) {
                          if (i == index) {
                            idStudent = listInstitute[i].id;
                            print(idStudent.toString() +
                                "00000000000000000000000000000000000000000000000000000000000000000000000000000000000");
                            listInstitute[i].isSelected = true;
                          } else
                            listInstitute[i].isSelected = false;
                        }
                      } else {
                        idStudent=null;
                        listInstitute[index].isSelected = false;
                      }
                    });
                  }
                },
              ))),
    );
  }

  int? isItemSelected() {
    for (var item in listInstitute) {
      if (item.isSelected!) {
        return item.id;
      }
    }
    return null;
  }

  void register(int? userId) async {
    registerUserAs!.dateOfBirth = null;
    registerUserAs!.personId = userId;

    final body = jsonEncode(registerUserAs);
    progressButtonKey.currentState!.show();
    Calls().call(body, context, Config.REGISTER_USER_AS).then((value) async {
      if (value != null) {
        progressButtonKey.currentState!.hide();
        var data = RegisterUserAsResponse.fromJson(value);
        print(data.toString());
        if (data.statusCode == "S10001") {
          prefs.setBool("isProfileCreated", true);


          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => DilaogPage(
                        type: type,
                        isVerified: data.rows!.isVerified,
                        title: AppLocalizations.of(context)!.translate('you_are_added_as') + type,
                        subtitle: "",
                      )),
              (Route<dynamic> route) => false);
        } else
          ToastBuilder().showToast(
              data.message!, context, HexColor(AppColors.information));
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
      progressButtonKey.currentState!.hide();
    });
  }

  _StudentsPageNew(
    this.registerUserAs,
  );
}
