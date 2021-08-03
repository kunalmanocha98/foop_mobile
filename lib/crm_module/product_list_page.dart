import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/row_cards_common.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/crm_module/create_customer_contact.dart';
import 'package:oho_works_app/crm_module/quantity_and_price_bottomSheet.dart';
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
import 'create_product.dart';
import 'create_product_sheet.dart';

// ignore: must_be_immutable
class ProductListPage extends StatefulWidget {

  final String type;
bool  isEdit=false;
  String? from;
  ProductListPage( this.type,this.isEdit,this.from,);

  @override
  _ProductListPage createState() =>
      _ProductListPage(type);
}

class _ProductListPage extends State<ProductListPage>
    with AutomaticKeepAliveClientMixin<ProductListPage> {
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
bool isAdded=false;
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
                              return CreateContactPage(
                                type: 'talk',

                                currentTab: 0,
                                title: "",
                              );
                            }));
                      },

                      child:  Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: InkWell(
                          onTap: (){
                            showModalBottomSheet<void>(
                              context: context,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                              ),

                              isScrollControlled: true,
                              builder: (context) {
                                return CreateProductSheet(
                                  prefs: prefs,
                                  onClickCallback: (value) {

                                  },
                                );
                                // return BottomSheetContent();
                              },
                            );
                          },
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
                      ),
                    )

                  ],
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child:    Visibility(

                    child:
                    AppRowCards(
                      subTitle1: "Item",
                      subTitle2: "8998",
                      subTitle3: "Inventory",
                      subTitle4: "9",
                      subTitle5: "Value",
                      subTitle6:"89"

                    ),



                  ),
                ),
              ),


              SliverToBoxAdapter(
                child: Visibility(
                  visible: isAdded||widget.isEdit,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: appCard(
                      color: HexColor(AppColors.cardBkg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          listItemBuilder2(),
                          listItemBuilder2()

                        ],
                      ),
                    ),
                  ),
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


  Widget listItemBuilder2() {


    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {

        },
        child:  appUserListTile(
          onPressed: (){

          },
          iconWidget: SizedBox(
              height: 30,width: 30,
              child: Image(image: AssetImage('assets/appimages/dice.png'),)),

          title: "Product Name",
          subtitle1: "ProductId",
          trailingWidget:  Row(children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8.0),
              child: Text("₹ 2000",    style: styleElements.bodyText2ThemeScalable(context),),
            ),
            Icon(Icons.cancel_outlined,color: HexColor(AppColors.appMainColor),)


          ],),
        )
    );
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
          iconWidget: SizedBox(
              height: 30,width: 30,
              child: Image(image: AssetImage('assets/appimages/award.png'),)),

          title: "Product Name",
          subtitle1: "ProductId",
          trailingWidget:widget.from!=null && widget.from=="home"? _simplePopup(): Checkbox(
            onChanged: (value) {
              showModalBottomSheet<void>(
                context: context,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                ),

                isScrollControlled: true,
                builder: (context) {
                  return QantityAndPriceSheet(
                    prefs: prefs,
                    onClickCallback: (value) {
setState(() {
  isAdded=true;
});
                    },
                  );
                  // return BottomSheetContent();
                },
              );
            },
            value: false,
          ),
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
            Text("Edit",
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
            Text("Deactivate",
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
              child: Icon(Icons.dashboard_outlined,color: HexColor(AppColors.appColorBlack35),),
            ),
            Text("WhatsApp",
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
      itemBuilder: (context) => getItems("O"),
      onSelected: (value) {
        switch (value) {
          case 'delete':
            {



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
  _ProductListPage(
      this.type,);
}
