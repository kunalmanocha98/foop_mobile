import 'dart:convert';


import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appemptywidget.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/crm_module/grouped_list.dart';
import 'package:oho_works_app/models/CommonListingModels/commonListingrequest.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/CalenderModule/calender_view_page.dart';
import 'package:oho_works_app/ui/dialogs/delete_confirmation_dilog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/Transitions/transitions.dart';
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

import 'confirmed_order_page.dart';

// ignore: must_be_immutable
class CrmPageList extends StatefulWidget {
  final String type;
  final String from;

  CrmPageList(
    this.type,
      this.from,
  );

  @override
  _CrmPageList createState() => _CrmPageList(type);
}

class _CrmPageList extends State<CrmPageList>
    with AutomaticKeepAliveClientMixin<CrmPageList> {
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
  late Map mapList=Map();
  @override
  bool get wantKeepAlive => true;

  void setSharedPreferences() async {
    refresh();
  }

  Future<void> _setPref() async {
    prefs = await SharedPreferences.getInstance();
    ownerId = prefs.getInt(Strings.userId);
  }

  @override
  void initState() {
    super.initState();
    _setPref();
    _getSortedList();
  }

  void _getSortedList()
  {
    var uniqueList=[];
    for(var item in _elements)
    {
      uniqueList.add(item['group']);
    }



    for(var item in uniqueList.toSet().toList())
    {
      mapList.putIfAbsent(item, () => _elements.where((element) => element['group'] == item).toList());

    }




  }


  void onsearchValueChanged(String text) {
    // print(text);
    searchVal = text;
    refresh();
  }

  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
  }
  List _elements = [
    {'name': 'John', 'group': 'Today'},
    {'name': 'Will', 'group': 'Today'},
    {'name': 'John', 'group': '2 Jul 2021'},
    {'name': 'Will', 'group': '2 Jul 2021'},
    {'name': 'Beth', 'group': '2 Jul 2021'},

    {'name': 'Beth', 'group': 'Sunday'},
    {'name': 'Miranda', 'group': 'Sunday'},
    {'name': 'Beth', 'group': 'Sunday'},
    {'name': 'Miranda', 'group': 'Sunday'},
    {'name': 'Beth', 'group': 'Sunday'},
    {'name': 'Miranda', 'group': 'Sunday'},



  ];

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

                    Navigator.push(context, appRouteSlideRight(page: CalenderViewPage(selectedDate: DateTime.now(),))).then((value){
                      if(value!=null){
                        setState(() {

                        });
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate('today'),
                          textAlign: TextAlign.center,
                          style: styleElements
                              .subtitle1ThemeScalable(context)
                              .copyWith(
                                  color: HexColor(AppColors.appColorBlack65)),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: HexColor(AppColors.appColorBlack65),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Expanded(
                  child: Card(
                    child:
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8,bottom: 8),
                      child: Column(
                       children: [
                         Align(
                           alignment: Alignment.topLeft,
                           child: Text(
                             type=="P"? (widget.from=="sales"? AppLocalizations.of(context)!.translate("_pending_pay"):AppLocalizations.of(context)!.translate("to_pay")):AppLocalizations.of(context)!.translate("amount"),style: styleElements
                               .subtitle2ThemeScalable(
                               context)
                               .copyWith(
                               color: HexColor(
                                   AppColors
                                       .appColorBlack35),
                               fontWeight:
                               FontWeight
                                   .bold),),
                         ),
                         Align(
                           alignment: Alignment.bottomRight,
                           child: Text("200",style: styleElements
                               .headlinecustomThemeScalable(
                               context)
                               .copyWith(
                               color: HexColor(
                                   AppColors
                                       .appColorBlack85),
                               fontWeight:
                               FontWeight
                                   .bold),),
                         )
                       ],

                      ),
                    )
                  ),
                ),

                  Expanded(
                    child: Card(
                        child:
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8,bottom: 8),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(type=="I"?AppLocalizations.of(context)!.translate("_invoice"):
                                type=="P"?(widget.from=="sales"? AppLocalizations.of(context)!.translate("_open_pay"):AppLocalizations.of(context)!.translate("payout")):
                                AppLocalizations.of(context)!.translate("crm_title"),style: styleElements
                                    .subtitle2ThemeScalable(
                                    context)
                                    .copyWith(
                                    color: HexColor(
                                        AppColors
                                            .appColorBlack35),
                                    fontWeight:
                                    FontWeight
                                        .bold),),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text("200",style: styleElements
                                    .headlinecustomThemeScalable(
                                    context)
                                    .copyWith(
                                    color: HexColor(
                                        AppColors
                                            .appColorBlack85),
                                    fontWeight:
                                    FontWeight
                                        .bold),),
                              )
                            ],

                          ),
                        )
                    ),
                  ),

                  Expanded(
                    child: Card(
                        child:
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8,bottom: 8),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(widget.from=="sales"?AppLocalizations.of(context)!.translate("customer"):AppLocalizations.of(context)!.translate("suppliers"),style: styleElements
                                    .subtitle2ThemeScalable(
                                    context)
                                    .copyWith(
                                    color: HexColor(
                                        AppColors
                                            .appColorBlack35),
                                    fontWeight:
                                    FontWeight
                                        .bold),),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text("200",style: styleElements
                                    .headlinecustomThemeScalable(
                                    context)
                                    .copyWith(
                                    color: HexColor(
                                        AppColors
                                            .appColorBlack85),
                                    fontWeight:
                                    FontWeight
                                        .bold),),
                              )
                            ],

                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      body:mapList .isNotEmpty
          ?  NotificationListener<ScrollNotification>(
          onNotification:
              (ScrollNotification scrollInfo) {
            if (scrollInfo is ScrollEndNotification &&
                scrollInfo.metrics.extentAfter == 0) {
              //loadmore();
              return true;
            }
            return false;
          },
          child: ListView.builder(
            shrinkWrap: true,
              padding: EdgeInsets.only(
                  left: 8, right: 8, bottom: 4, top: 8),
              itemCount:mapList.length,
              itemBuilder:
                  (BuildContext context, int index) {
                return listItemBuilder(mapList[mapList.keys.elementAt(index)]);
              }),
        )

          : ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: appEmptyWidget(
                    message: AppLocalizations.of(context)!
                        .translate('no_data'),
                  ),
                )
              // EmptyWidget(AppLocalizations.of(context)
              //     .translate('no_data'),

            );
          })
    ));
  }
  Widget listItemBuilder(value) {
var header=value[0]['group'];
    return  GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfileCards(
                      userType: "person",
                      userId: 2,
                      callback: () {
                        callback();
                      },
                      currentPosition: 1,
                      type: null,
                    )));
          },
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(left:8.0,right:16,bottom: 8,top: 8),
                child: Text(header??"",  style: styleElements
                    .subtitle1ThemeScalable(context)
                    .copyWith(
                  fontWeight:FontWeight.bold ,
                    color: HexColor(AppColors.appColorBlack35)),),
              ),

              appCard(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:value.length,
                    itemBuilder:
                        (BuildContext context, int index) {
                      return   appUserListTile(
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConfirmedOrderPage(
                                    selectedTab:type=="O"?1:type=="L"?0:type=="I"?2:3,

                                    type: "person", standardEventId: 2,
                                  ),
                                ));
                          },
                          imageUrl: null,
                          title: "Savil kumar",
                          subtitle1: "Android Developer",
                          trailingWidget: Visibility(

                            child: _simplePopup(),
                          ),
                        )
                    ;
                    }),
              ),

            ],
          )
      );

  }
  List<PopupMenuEntry<String>> getItems(String? name) {
    List<PopupMenuEntry<String>> popupmenuList = [];


    popupmenuList.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 16),
              child: Icon(Icons.dashboard_outlined,color: HexColor(AppColors.appColorBlack35),),
            ),
            Text(name=="P"?"Edit Payment":"Edit",
            ),
          ],
        ),
      ),
    );

    if(name!="O" && name!="I")
    popupmenuList.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 16),
              child: Icon(Icons.face,color: HexColor(AppColors.appColorBlack35),),
            ),
            Text(name=="P"?"Receive Payment":"Convert to order",
            ),
          ],
        ),
      ),
    );
    if(name!="I" && name!="P")
    popupmenuList.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 16),
              child: Icon(Icons.family_restroom_rounded,color: HexColor(AppColors.appColorBlack35),),
            ),
            Text(name=="O"?"Bill":"Bill the lead",
            ),
          ],
        ),
      ),
    );
    popupmenuList.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 16),
              child: Icon(Icons.dashboard_outlined,color: HexColor(AppColors.appColorBlack35),),
            ),
            Text("Print",
            ),
          ],
        ),
      ),
    );
    popupmenuList.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 16),
              child: Icon(Icons.sanitizer,color: HexColor(AppColors.appColorBlack35),),
            ),
            Text("Email",
            ),
          ],
        ),
      ),
    );

    popupmenuList.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 16),
              child: Icon(Icons.alternate_email,color: HexColor(AppColors.appColorBlack35),),
            ),
            Text("Whatsapp",
            ),
          ],
        ),
      ),
    );
    return popupmenuList;
  }
  Widget _simplePopup() {
    // var name = headerData.title;
    return PopupMenuButton<String>(
      padding: EdgeInsets.only(right: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      itemBuilder: (context) => getItems(widget.type),
      onSelected: (value) {
        switch (value) {
          case 'delete':
            {


              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return DeleteConfirmationDilog(
                      showCancelButton: true,
                      // note: model.androidNotes,
                      note: AppLocalizations.of(context)!.translate("delete_confirmation"),
                      cancelButton: () {
                        Navigator.pop(context);
                      },
                      updateButton: () {

                      },
                    );
                  });

              break;
            }
          case 'edit':
            {

              break;
            }
          case 'hide':
            {

              break;
            }
          case 'unfollow':
            {

              break;
            }
          case 'block':
            {

              break;
            }
          case 'topic':{

            break;
          }
          case 'report':
            {

              break;
            }
        }
      },
      icon: Icon(
        Icons.more_vert,
        color:  HexColor(AppColors.appColorBlack65),
      ),
    );
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



  _CrmPageList(
    this.type,
  );
}
