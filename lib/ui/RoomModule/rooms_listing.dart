import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/app_event_card.dart';
import 'package:oho_works_app/enums/create_deeplink.dart';
import 'package:oho_works_app/enums/member%20enums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/enums/share_item_type.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/Rooms/memberAdd.dart';
import 'package:oho_works_app/models/Rooms/membershipupdaterolestatus.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/ui/RoomModule/room_detail_page.dart';
import 'package:oho_works_app/ui/dialogs/exitRoomConfirmtionDilaog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'createRoomPage.dart';


// ignore: must_be_immutable
class AllRoomsListing extends StatefulWidget {
  int? id;
  int? instituteId;
  int? ownerId;
  String? userType;
  String? ownerType;
  Null Function()? callback;
  @override
  AllRoomsListingState createState() => AllRoomsListingState(id,instituteId,ownerId,ownerType,userType,callback);
  AllRoomsListing(Key key ,this.id, this.instituteId,this.ownerId,this.ownerType,this.userType,this.callback):super(key: key);
}

class AllRoomsListingState extends State<AllRoomsListing> {
  String? searchVal;
  int? id;
  Null Function()? callback;
  int? instituteId;
  int? ownerId;
  String? ownerType;
  String? userType;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  SharedPreferences? prefs;
  late TextStyleElements styleElements;
  List<RoomListItem> allRoomsList=[];
  AllRoomsListingState(this.id, this.instituteId,this.ownerId,this.ownerType,this.userType,this.callback);
  void setSharedPreferences() async {

    refresh();
  }

  @override
  void initState() {
    super.initState();
  }

  void onsearchValueChanged(String text) {
    // print(text);
    searchVal = text;
    refresh();
  }
  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
    if(callback!=null)
    callback!();
  }


  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return
     Container(
          child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: SearchBox(
                onvalueChanged: onsearchValueChanged,
                hintText: AppLocalizations.of(context)!.translate('search'),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
            margin: EdgeInsets.only(top: 2,left: 16,right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
                  color: HexColor(AppColors.appColorRed50)
                ),
                child: Padding(
                  padding: EdgeInsets.only(top:16,left: 16,right: 16,bottom: 8),
                  child:RichText(
                    text: TextSpan(
                      style: styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text:  userType=="person" ?'Rooms are groups. You can create rooms to engage with more than one person together. Please click ':'Only public rooms of this user are listed here. Private rooms are visible only to members of those rooms',
                        ),
                        userType=="person" ?  WidgetSpan(child: Icon(Icons.add,color: HexColor(AppColors.appColorBlack85),)):WidgetSpan(
                          child: SizedBox(height: 0,width: 0,)
                        ),
                        TextSpan(
                          text: userType=="person" ?' on the top of the page to create new rooms.':"",
                        ),
                      ]
                    ),
                  )
                  // child: Text('Rooms are groups. You can create rooms to engage with more than one person together. Please click + on the top of the page to create new rooms.',style:
                  //   styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),),
                ),
              )
            )
          ];
        },
        body:   RefreshIndicator(
          onRefresh: refreshList,
          child: Paginator.listView(
              key: paginatorKey,
              padding: EdgeInsets.only(top: 16),
              scrollPhysics: BouncingScrollPhysics(),
              pageLoadFuture: getRoomsList,
              pageItemsGetter: CustomPaginator(context).listItemsGetter,
              listItemBuilder: listItemBuilder,
              loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
              errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
              emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
              totalItemsGetter: CustomPaginator(context).totalPagesGetter,
              pageErrorChecker: CustomPaginator(context).pageErrorChecker),
        ),
      ),
    );
  }
  Future<Null> refreshList() async {
    await refresh();
    await new Future.delayed(new Duration(seconds: 2));
    setState(() {

    });
    return null;
  }
  Future<RoomListResponse> getRoomsList(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    RoomListPayload payload = RoomListPayload();
    payload.isPrivate = null;
    payload.roomInstitutionId = instituteId?? prefs!.getInt(Strings.instituteId);
    payload.memberId = id;
    payload.memberType = userType=="institution"?"institution":"person";
    payload.pageSize = 20;
    payload.requestedByType = ownerType=="institution"?"institution":"person";
    payload.requestedById = ownerId;
    payload.isOwn = id==ownerId;
    payload.pageNumber = page;
    payload.searchVal = searchVal;
    payload.institutionId = prefs!.getInt(Strings.instituteId);
    var data = jsonEncode(payload);
    var value = await Calls().call(data, context, Config.ROOMS_LIST);

    return RoomListResponse.fromJson(value);
  }

  List<RoomListItem>? listItemsGetter(RoomListResponse pageData) {
    allRoomsList.addAll(pageData.rows!);
    return pageData.rows;
  }


  Widget listItemBuilder(item, int index) {
    RoomListItem value = item;
    // print(Utility().getUrlForImage(value.roomProfileImageUrl, RESOLUTION_TYPE.R64,SERVICE_TYPE.ROOM));
    return Container(
      margin: EdgeInsets.only(top: 1, bottom: 1, left: 12, right: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RoomDetailPage(value,ownerId,ownerType,userType=="institution"?"institution":"person",instituteId,id,null))).then((value){
                    refresh();
          });
        },
        child: appEventCard(
          key: UniqueKey(),
          byTitle: RoomButtons(context: context).getByTitle(value.header!.title,value.header!.subtitle1),
          byImage: value.header!.avatar,
          cardImage: value.roomProfileImageUrl,
          serviceType: SERVICE_TYPE.ROOM,
          title: value.roomName,
          isPrivate: value.isPrivate ?? false,
          cardRating: value.otherDetails!.rating!=null?value.otherDetails!.rating:0.0,
          isModerator: value.memberRoleType == 'A',
          listofImages: List<String?>.generate(value.membersCount!, (index) {
            if(index<value.membersList!.length){
              return value.membersList![index].profileImage;
            }else{
              return "";
            }
          }),
          isRated: value.otherDetails!.isRated,
          ownerType: value.roomOwnerType,
          ownerId:  value.roomOwnerTypeId,
          totalRatedUsers: value.otherDetails!.totalRatedUsers,
          showRateCount: false,
          subjectId: value.id,
          subjectType: 'room',
          isShareVisible: true,
          isRoom: true,
          ratingCallback: (){},
          shareCallback: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            final CreateDeeplink createDeeplink = locator<CreateDeeplink>();
            createDeeplink.getDeeplink(
                SHAREITEMTYPE.DETAIL.type,
                prefs.getInt("userId").toString(),
                value.id,
                DEEPLINKTYPE.ROOMS.type,
                context);
          },
          averageRatingCallback: (value){
            setState(() {
              allRoomsList[index].otherDetails!.rating = value ;
              allRoomsList[index].otherDetails!.totalRatedUsers =
                  allRoomsList[index].otherDetails!.totalRatedUsers!+1;
              allRoomsList[index].otherDetails!.isRated = true;
            });
          },
            actionButton:
          id==ownerId?
                value.membershipStatus == 'A' ? value.memberRoleType=="A"?RoomButtons(context: context,onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreateRoomPage(
                                  value: value,isEdit: true,callback:(){}   ))).then((value){refresh();});
                }).editButton:RoomButtons(context: context,onPressed: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          ExitConfirmationDialog(
                              callback: (isSuccess) {
                                if (isSuccess) {
                                  exitRoom(value);
                                }
                              }));
                }).exitButton: RoomButtons(context: context,onPressed: (){
                  joingroup(value);
                }).joinButton:Visibility(
                  visible: !value.isRequestedByMember! ,
                  child: RoomButtons(context: context,onPressed: (){ if (!value.isRequestedByMember! ) {
                    joingroup(value);
                  }}).joinButton
        )))
    );
  }


  void exitRoom(RoomListItem value) {
    MembershipRoleStatusPayload payload = MembershipRoleStatusPayload();
    payload.roomId = value.id;
    payload.memberId = ownerId;
    payload.memberType = ownerType;
    payload.action = MEMBERSHIP_ROLE.remove.type;
    var body = jsonEncode(payload);
    Calls().call(body, context, Config.MEMBERSHIP_STATUS_UPDATE).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast("success", context,HexColor(AppColors.success));
        refresh();
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void joingroup(RoomListItem value) {
    MemberAddPayload payload = MemberAddPayload();
    payload.roomId = value.id;
    payload.roomInstitutionId = instituteId;
    payload.isAddAllMembers = false;
    List<MembersItem> list = [];
    MembersItem item = MembersItem();
    item.memberType = ownerType;
    item.memberId = ownerId;
    item.addMethod = MEMBER_ADD_METHOD.JOIN.type;
    list.add(item);
    payload.members = list;
    var data = jsonEncode(payload);
    Calls().call(data, context, Config.MEMBER_ADD).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast("successfully joined", context,HexColor(AppColors.success));
        refresh();

      }
    }).catchError((onError) {
      print(onError);
    });
  }
}

// ignore: must_be_immutable
class PublicRoomsListing extends StatefulWidget {
  int? id;
  int? instituteId;
  int? ownerId;
  String? userType;
  String? ownerType;
  @override
  PublicRoomsListingState createState() => PublicRoomsListingState(id,instituteId,ownerId,ownerType,userType);
  PublicRoomsListing(Key key,this.id, this.instituteId,this.ownerId,this.ownerType,this.userType):super(key: key);
}

class PublicRoomsListingState extends State<PublicRoomsListing> {
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  String? searchVal;
  SharedPreferences? prefs;
  int? id;
  int? instituteId;
  int? ownerId;
  String? userType;
  String? ownerType;
  List<RoomListItem> publicRoomListing = [];
  PublicRoomsListingState(
      this.id, this.instituteId, this.ownerId, this.userType, this.ownerType);
  void setSharedPreferences() async {
    // prefs = await SharedPreferences.getInstance();
    refresh();
  }

  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
  }

  @override
  void initState() {
    super.initState();
  }

  void onsearchValueChanged(String text) {
    searchVal = text;
    refresh();
  }
  TextStyleElements? styleElements;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    // setSharedPreferences();
    return Container(
        child: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: SearchBox(
              onvalueChanged: onsearchValueChanged,
              hintText: AppLocalizations.of(context)!.translate('search'),
            ),
          )
        ];
      },
      body:RefreshIndicator(
      onRefresh: refreshList,
      child: Paginator.listView(
          key: paginatorKey,
          scrollPhysics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 16),
          pageLoadFuture: getRoomsList,
          pageItemsGetter: listItemsGetter,
          listItemBuilder: listItemBuilder,
          loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
          errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
          emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
          totalItemsGetter: CustomPaginator(context).totalPagesGetter,
          pageErrorChecker: CustomPaginator(context).pageErrorChecker),
    )));
  }
  List<RoomListItem>? listItemsGetter(RoomListResponse? pageData){
    publicRoomListing.addAll(pageData!.rows!);
    return pageData.rows;
  }
  Future<Null> refreshList() async {
    await refresh();
    await new Future.delayed(new Duration(seconds: 2));

    return null;
  }

  Future<RoomListResponse> getRoomsList(int page) async {
    prefs ??= prefs = await SharedPreferences.getInstance();
    RoomListPayload payload = RoomListPayload();
    // payload.isPrivate = false;
    payload.roomInstitutionId = prefs!.getInt(Strings.instituteId);
    payload.memberId = prefs!.getInt(Strings.userId);
    payload.memberType = "person";
    payload.pageSize = 20;
    payload.pageNumber = page;
    payload.searchVal = searchVal;
    payload.roomPrivacyType = 'public';
    payload.institutionId = prefs!.getInt(Strings.instituteId);
    var data = jsonEncode(payload);
    var value = await Calls().call(data, context, Config.ROOMS_LIST);

    return RoomListResponse.fromJson(value);
  }

  Widget listItemBuilder(item, int index) {
    RoomListItem value  = item;
    return GestureDetector(
      onTap: () {},
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RoomDetailPage(value,ownerId,ownerType,userType,instituteId,id,null))).then((value){
                    refresh();
          });
        },
        child:
        appEventCard(
          key: UniqueKey(),
          byTitle: RoomButtons(context: context).getByTitle(value.header!.title,value.header!.subtitle1),
          byImage: value.header!.avatar,
          cardImage: value.roomProfileImageUrl,
          serviceType: SERVICE_TYPE.ROOM,
          title: value.roomName,
          isPrivate: value.isPrivate ?? false,
          cardRating: value.otherDetails!.rating!=null?value.otherDetails!.rating:0.0,
          isModerator: value.memberRoleType == 'A',
          listofImages: List<String?>.generate(value.membersCount!, (index) {
            if(index<value.membersList!.length){
              return value.membersList![index].profileImage;
            }else{
              return "";
            }
          }),
          isRated: value.otherDetails!.isRated,
          ownerType: value.roomOwnerType,
          ownerId:  value.roomOwnerTypeId,
          totalRatedUsers: value.otherDetails!.totalRatedUsers,
          showRateCount: false,
          subjectId: value.id,
          subjectType: 'room',
          isShareVisible: true,
          isRoom: true,
          ratingCallback: (){},
          shareCallback: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            final CreateDeeplink createDeeplink = locator<CreateDeeplink>();
            createDeeplink.getDeeplink(
                SHAREITEMTYPE.DETAIL.type,
                prefs.getInt("userId").toString(),
                value.id,
                DEEPLINKTYPE.ROOMS.type,
                context);
          },
          averageRatingCallback: (value){
            setState(() {
              publicRoomListing[index].otherDetails!.rating = value ;
              publicRoomListing[index].otherDetails!.totalRatedUsers =
                  publicRoomListing[index].otherDetails!.totalRatedUsers!+1;
              publicRoomListing[index].otherDetails!.isRated = true;
            });
          },
              actionButton:
            value.membershipStatus == 'A' ?value.memberRoleType=='A'? RoomButtons(context:context,onPressed:(){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateRoomPage(
                              value: value,isEdit: true,callback:(){}   ))).then((value){

              });
            }).editButton:RoomButtons(context:context,onPressed: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      ExitConfirmationDialog(callback: (isSuccess) {
                        if (isSuccess) {
                          exitRoom(value);
                        }
                      }));
            }).exitButton:RoomButtons(context:context,onPressed: (){
              joingroup(value);
            }).joinButton,)
      ),
    );
  }

  void exitRoom(RoomListItem value) {
    MembershipRoleStatusPayload payload = MembershipRoleStatusPayload();
    payload.roomId = value.id;
    payload.memberId = prefs!.getInt(Strings.userId);
    payload.memberType = "person";
    payload.action = MEMBERSHIP_ROLE.remove.type;
    var body = jsonEncode(payload);
    Calls().call(body, context, Config.MEMBERSHIP_STATUS_UPDATE).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast("success", context,HexColor(AppColors.information));
        refresh();
      } else {
        ToastBuilder().showToast(res.message!, context,HexColor(AppColors.information));
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void joingroup(RoomListItem value) {
    MemberAddPayload payload = MemberAddPayload();
    payload.roomId = value.id;
    payload.roomInstitutionId = instituteId;
    payload.isAddAllMembers = false;
    List<MembersItem> list = [];
    MembersItem item = MembersItem();
    item.memberType = 'person';
    item.memberId = prefs!.getInt(Strings.userId);
    item.addMethod = MEMBER_ADD_METHOD.JOIN.type;
    list.add(item);
    payload.members = list;
    var data = jsonEncode(payload);
    Calls().call(data, context, Config.MEMBER_ADD).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast("successfully joined", context,HexColor(AppColors.information));
        refresh();
      } else {
        ToastBuilder().showToast(res.message!, context,HexColor(AppColors.information));
      }
    }).catchError((onError) {
      print(onError);
    });
  }


}

// ignore: must_be_immutable
class PrivateRoomsListing extends StatefulWidget {
  int? id;
  int? instituteId;
  int? ownerId;
  String? userType;
  String? ownerType;
  @override
  PrivateRoomsListingState createState() => PrivateRoomsListingState(id,instituteId,ownerId,ownerType,userType);
  PrivateRoomsListing(Key key,this.id, this.instituteId,this.ownerId,this.ownerType,this.userType):super(key:key);
}

class PrivateRoomsListingState extends State<PrivateRoomsListing> {
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  String? searchVal;
  SharedPreferences? prefs;
  int? id;
  int? instituteId;
  int? ownerId;
  String? userType;
  String? ownerType;
  List<RoomListItem> privateRoomListing = [];
  PrivateRoomsListingState(
      this.id, this.instituteId, this.ownerId, this.userType, this.ownerType);
  void setSharedPreferences() async {
    // prefs = await SharedPreferences.getInstance();
    refresh();
  }

  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
  }
  Future<Null> refreshList() async {
    await refresh();
    await new Future.delayed(new Duration(seconds: 2));

    return null;
  }
  @override
  void initState() {
    super.initState();
  }


  void onsearchValueChanged(String text) {
    searchVal = text;
    refresh();
  }
  TextStyleElements? styleElements;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    // setSharedPreferences();
    return Container(
        child: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: SearchBox(
              onvalueChanged: onsearchValueChanged,
              hintText: AppLocalizations.of(context)!.translate('search'),
            ),
          ),
        ];
      },
      body: RefreshIndicator(
      onRefresh: refreshList,
      child:Paginator.listView(
          key: paginatorKey,
          scrollPhysics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 16),
          pageLoadFuture: getRoomsList,
          pageItemsGetter: listItemsGetter,
          listItemBuilder: listItemBuilder,
          loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
          errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
          emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
          totalItemsGetter: CustomPaginator(context).totalPagesGetter,
          pageErrorChecker: CustomPaginator(context).pageErrorChecker),
    )));
  }

  List<RoomListItem>? listItemsGetter(RoomListResponse ?pageData){
    privateRoomListing.addAll(pageData!.rows!);
    return pageData.rows;
  }

  Future<RoomListResponse> getRoomsList(int page) async {
    prefs ??= prefs = await SharedPreferences.getInstance();
    RoomListPayload payload = RoomListPayload();
    // payload.isPrivate = true;
    payload.roomPrivacyType ='private';
    payload.roomInstitutionId = instituteId;
    payload.memberId = ownerId;
    payload.memberType = ownerType ;
    payload.pageSize = 20;
    payload.pageNumber = page;
    payload.searchVal = searchVal;
    payload.institutionId = prefs!.getInt(Strings.instituteId);
    var data = jsonEncode(payload);
    var value = await Calls().call(data, context, Config.ROOMS_LIST);

    return RoomListResponse.fromJson(value);
  }

  Widget listItemBuilder(value, int index) {
    return GestureDetector(
      onTap: () {},
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RoomDetailPage(value,ownerId,ownerType,userType,instituteId,id,null))).then((value){
                    refresh();
          });
        },
        child:
        appEventCard(
          key: UniqueKey(),
          byTitle: RoomButtons(context: context).getByTitle(value.header.title,value.header.subtitle1),
          byImage: value.header.avatar,
          cardImage: value.roomProfileImageUrl,
          serviceType: SERVICE_TYPE.ROOM,
          title: value.roomName,
          isPrivate: value.isPrivate ?? false,
          cardRating: value.otherDetails.rating!=null?value.otherDetails.rating:0.0,
          isModerator: value.memberRoleType == 'A',
          listofImages: List<String?>.generate(value.membersCount, (index) {
            if(index<value.membersList.length){
              return value.membersList[index].profileImage;
            }else{
              return "";
            }
          }),
          isRated: value.otherDetails.isRated,
          ownerType: value.roomOwnerType,
          ownerId:  value.roomOwnerTypeId,
          totalRatedUsers: value.otherDetails.totalRatedUsers,
          showRateCount: false,
          subjectId: value.id,
          subjectType: 'room',
          isShareVisible: true,
          isRoom: true,
          ratingCallback: (){},
          shareCallback: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            final CreateDeeplink createDeeplink = locator<CreateDeeplink>();
            createDeeplink.getDeeplink(
                SHAREITEMTYPE.DETAIL.type,
                prefs.getInt("userId").toString(),
                value.id,
                DEEPLINKTYPE.ROOMS.type,
                context);
          },
          averageRatingCallback: (value){
            setState(() {
              privateRoomListing[index].otherDetails!.rating = value ;
              privateRoomListing[index].otherDetails!.totalRatedUsers =
                  privateRoomListing[index].otherDetails!.totalRatedUsers!+1;
              privateRoomListing[index].otherDetails!.isRated = true;
            });
          },
              actionButton: value.memberRoleType=='A'?RoomButtons(
                  context: context,
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateRoomPage(
                                    value: value,isEdit: true,callback:(){}   ))).then((value){
refresh();
                    });
                  }
              ).editButton:RoomButtons(
                  context: context,
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            ExitConfirmationDialog(callback: (isSuccess) {
                              if (isSuccess) {
                                exitRoom(value);
                              }
                            }));
                  }
              ).exitButton,
            )
      ),
    );
  }

  void exitRoom(RoomListItem value) {
    MembershipRoleStatusPayload payload = MembershipRoleStatusPayload();
    payload.roomId = value.id;
    payload.memberId = ownerId;
    payload.memberType = ownerType;
    payload.action = MEMBERSHIP_ROLE.remove.type;
    var body = jsonEncode(payload);
    Calls().call(body, context, Config.MEMBERSHIP_STATUS_UPDATE).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast("success", context,HexColor(AppColors.information));
        refresh();
      } else {
        ToastBuilder().showToast(res.message!, context,HexColor(AppColors.information));
      }
    }).catchError((onError) {
      print(onError);
    });
  }
}

// ignore: must_be_immutable
class SocialRoomsListing extends StatefulWidget {
  int? id;
  int? instituteId;
  int? ownerId;
  String? userType;
  String? ownerType;
  Null Function()? callback;
  SocialRoomsListing(Key key ,this.id, this.instituteId,this.ownerId,this.ownerType,this.userType,this.callback):super(key: key);
  @override
  SocialRoomsListingState createState() => SocialRoomsListingState(id,instituteId,ownerId,ownerType,userType,callback);
}

class SocialRoomsListingState extends State<SocialRoomsListing> {
  String? searchVal;
  int? id;
  Null Function()? callback;
  int? instituteId;
  int? ownerId;
  String? ownerType;
  String? userType;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  SharedPreferences? prefs;
  late TextStyleElements styleElements;
  List<RoomListItem> socialRoomListing = [];
  SocialRoomsListingState(this.id, this.instituteId,this.ownerId,this.ownerType,this.userType,this.callback);
  void setSharedPreferences() async {

    refresh();
  }

  @override
  void initState() {
    super.initState();
  }
  Future<Null> refreshList() async {
    await refresh();
    await new Future.delayed(new Duration(seconds: 2));

    return null;
  }
  void onsearchValueChanged(String text) {
    // print(text);
    searchVal = text;
    refresh();
  }
  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
    if(callback!=null)
      callback!();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return Container(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: SearchBox(
                  onvalueChanged: onsearchValueChanged,
                  hintText: AppLocalizations.of(context)!.translate('search'),
                ),
              ),
              SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(top: 2,left: 16,right: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
                        color: HexColor(AppColors.appColorRed50)
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(top:16,left: 16,right: 16,bottom: 8),
                        child:RichText(
                          text: TextSpan(
                              style: styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.w500),
                              children: [
                                TextSpan(
                                  text:  userType=="person" ?'Clubs are groups. You can create rooms to engage with more than one person together. Please click ':'Only public rooms of this user are listed here. Private clubs are visible only to members of those rooms',
                                ),
                                userType=="person" ?  WidgetSpan(child: Icon(Icons.add,color: HexColor(AppColors.appColorBlack85),)):WidgetSpan(
                                    child: SizedBox(height: 0,width: 0,)
                                ),
                                TextSpan(
                                  text: userType=="person" ?' on the top of the page to create new rooms.':"",
                                ),
                              ]
                          ),
                        )
                      // child: Text('Rooms are groups. You can create rooms to engage with more than one person together. Please click + on the top of the page to create new rooms.',style:
                      //   styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),),
                    ),
                  )
              )
            ];
          },
          body: RefreshIndicator(
          onRefresh: refreshList,
          child:Paginator.listView(
              key: paginatorKey,
              padding: EdgeInsets.only(top: 16),
              scrollPhysics: BouncingScrollPhysics(),
              pageLoadFuture: getRoomsList,
              pageItemsGetter: listItemsGetter,
              listItemBuilder: listItemBuilder,
              loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
              errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
              emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
              totalItemsGetter: CustomPaginator(context).totalPagesGetter,
              pageErrorChecker: CustomPaginator(context).pageErrorChecker),
        )));
  }

  Future<RoomListResponse> getRoomsList(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    RoomListPayload payload = RoomListPayload();
    // payload.isPrivate = null;
    payload.roomInstitutionId = instituteId?? prefs!.getInt(Strings.instituteId);
    payload.memberId = id;
    payload.memberType = userType=="institution"?"institution":"person";
    payload.pageSize = 20;
    payload.requestedByType = ownerType=="institution"?"institution":"person";
    payload.requestedById = ownerId;
    payload.isOwn = id==ownerId;
    payload.pageNumber = page;
    payload.searchVal = searchVal;
    // payload.roomType = ROOM_TYPE.COMMUNITYROOM.type;
    payload.roomPrivacyType ='social';
    payload.institutionId = prefs!.getInt(Strings.instituteId);
    var data = jsonEncode(payload);
    var value = await Calls().call(data, context, Config.ROOMS_LIST);

    return RoomListResponse.fromJson(value);
  }
  List<RoomListItem>? listItemsGetter(RoomListResponse? pageData){
    socialRoomListing.addAll(pageData!.rows!);
    return pageData.rows;
  }

  Widget listItemBuilder(item, int index) {
    RoomListItem value = item;
    // print(Utility().getUrlForImage(value.roomProfileImageUrl, RESOLUTION_TYPE.R64,SERVICE_TYPE.ROOM));
    return Container(
      margin: EdgeInsets.only(top: 1, bottom: 1, left: 12, right: 12),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RoomDetailPage(value,ownerId,ownerType,userType=="institution"?"institution":"person",instituteId,id,null))).then((value){
              refresh();
            });
          },
          child:appEventCard(
            key: UniqueKey(),
            byTitle: RoomButtons(context: context).getByTitle(value.header!.title,value.header!.subtitle1),
            byImage: value.header!.avatar,
            cardImage: value.roomProfileImageUrl,
            serviceType: SERVICE_TYPE.ROOM,
            title: value.roomName,
            isPrivate: value.isPrivate ?? false,
            cardRating: value.otherDetails!.rating!=null?value.otherDetails!.rating:0.0,
            isModerator: value.memberRoleType == 'A',
            listofImages: List<String?>.generate(value.membersCount!, (index) {
              if(index<value.membersList!.length){
                return value.membersList![index].profileImage;
              }else{
                return "";
              }
            }),
            isRated: value.otherDetails!.isRated,
            ownerType: value.roomOwnerType,
            ownerId:  value.roomOwnerTypeId,
            totalRatedUsers: value.otherDetails!.totalRatedUsers,
            showRateCount: false,
            subjectId: value.id,
            subjectType: 'room',
            isShareVisible: true,
            isRoom: true,
            ratingCallback: (){},
            shareCallback: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              final CreateDeeplink createDeeplink = locator<CreateDeeplink>();
              createDeeplink.getDeeplink(
                  SHAREITEMTYPE.DETAIL.type,
                  prefs.getInt("userId").toString(),
                  value.id,
                  DEEPLINKTYPE.ROOMS.type,
                  context);
            },
            averageRatingCallback: (value){
              setState(() {
                socialRoomListing[index].otherDetails!.rating = value ;
                socialRoomListing[index].otherDetails!.totalRatedUsers =
                    socialRoomListing[index].otherDetails!.totalRatedUsers!+1;
                socialRoomListing[index].otherDetails!.isRated = true;
              });
            },
            actionButton:
          id==ownerId?
          value.membershipStatus == 'A' ? value.memberRoleType=="A"?RoomButtons(context: context,onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CreateRoomPage(
                            value: value,isEdit: true,callback:(){}   ))).then((value){
refresh();
            });
          }).editButton:RoomButtons(context: context,onPressed: (){
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    ExitConfirmationDialog(
                        callback: (isSuccess) {
                          if (isSuccess) {
                            exitRoom(value);
                          }
                        }));
          }).exitButton: RoomButtons(context: context,onPressed: (){
            joingroup(value);
          }).joinButton:Visibility(
              visible: !value.isRequestedByMember! ,
              child: RoomButtons(context: context,onPressed: (){ if (!value.isRequestedByMember! ) {
                joingroup(value);
              }}).joinButton
          ),
          )

      ),
    );
  }
  void exitRoom(RoomListItem value) {
    MembershipRoleStatusPayload payload = MembershipRoleStatusPayload();
    payload.roomId = value.id;
    payload.memberId = ownerId;
    payload.memberType = ownerType;
    payload.action = MEMBERSHIP_ROLE.remove.type;
    var body = jsonEncode(payload);
    Calls().call(body, context, Config.MEMBERSHIP_STATUS_UPDATE).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast("success", context,HexColor(AppColors.success));
        refresh();
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void joingroup(RoomListItem value) {
    MemberAddPayload payload = MemberAddPayload();
    payload.roomId = value.id;
    payload.roomInstitutionId = instituteId;
    payload.isAddAllMembers = false;
    List<MembersItem> list = [];
    MembersItem item = MembersItem();
    item.memberType = ownerType;
    item.memberId = ownerId;
    item.addMethod = MEMBER_ADD_METHOD.JOIN.type;
    list.add(item);
    payload.members = list;
    var data = jsonEncode(payload);
    Calls().call(data, context, Config.MEMBER_ADD).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast("successfully joined", context,HexColor(AppColors.success));
        refresh();

      }
    }).catchError((onError) {
      print(onError);
    });
  }


}

// ignore: must_be_immutable
class CampusRoomsListing extends StatefulWidget {
  int? id;
  int? instituteId;
  int? ownerId;
  String? userType;
  String? ownerType;
  Null Function()? callback;
  CampusRoomsListing(Key key ,this.id, this.instituteId,this.ownerId,this.ownerType,this.userType,this.callback):super(key: key);
  @override
  CampusRoomsListingState createState() => CampusRoomsListingState(id,instituteId,ownerId,ownerType,userType,callback);
}

class CampusRoomsListingState extends State<CampusRoomsListing> {
  String? searchVal;
  int? id;
  Null Function()? callback;
  int? instituteId;
  int? ownerId;
  String? ownerType;
  String? userType;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  SharedPreferences? prefs;
  late TextStyleElements styleElements;
  List<RoomListItem> campusRoomListing = [];
  CampusRoomsListingState(this.id, this.instituteId,this.ownerId,this.ownerType,this.userType,this.callback);
  void setSharedPreferences() async {

    refresh();
  }

  @override
  void initState() {
    super.initState();
  }
  Future<Null> refreshList() async {
    await refresh();
    await new Future.delayed(new Duration(seconds: 2));
    setState(() {

    });
    return null;
  }
  void onsearchValueChanged(String text) {
    searchVal = text;
    refresh();
  }
  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
    if(callback!=null)
      callback!();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return Container(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: SearchBox(
                  onvalueChanged: onsearchValueChanged,
                  hintText: AppLocalizations.of(context)!.translate('search'),
                ),
              ),
              SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(top: 2,left: 16,right: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
                        color: HexColor(AppColors.appColorRed50)
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(top:16,left: 16,right: 16,bottom: 8),
                        child:RichText(
                          text: TextSpan(
                              style: styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.w500),
                              children: [
                                TextSpan(
                                  text:  userType=="person" ?'Clubs are groups. You can create rooms to engage with more than one person together. Please click ':'Only public rooms of this user are listed here. Private clubs are visible only to members of those rooms',
                                ),
                                userType=="person" ?  WidgetSpan(child: Icon(Icons.add,color: HexColor(AppColors.appColorBlack85),)):WidgetSpan(
                                    child: SizedBox(height: 0,width: 0,)
                                ),
                                TextSpan(
                                  text: userType=="person" ?' on the top of the page to create new rooms.':"",
                                ),
                              ]
                          ),
                        )
                      // child: Text('Rooms are groups. You can create rooms to engage with more than one person together. Please click + on the top of the page to create new rooms.',style:
                      //   styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),),
                    ),
                  )
              )
            ];
          },
          body: RefreshIndicator(
          onRefresh: refreshList,
          child:Paginator.listView(
              key: paginatorKey,
              padding: EdgeInsets.only(top: 16),
              scrollPhysics: BouncingScrollPhysics(),
              pageLoadFuture: getRoomsList,
              pageItemsGetter: listItemsGetter,
              listItemBuilder: listItemBuilder,
              loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
              errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
              emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
              totalItemsGetter: CustomPaginator(context).totalPagesGetter,
              pageErrorChecker: CustomPaginator(context).pageErrorChecker),
        )))
    ;
  }

  Future<RoomListResponse> getRoomsList(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    RoomListPayload payload = RoomListPayload();
    // payload.isPrivate = null;
    payload.roomInstitutionId = instituteId?? prefs!.getInt(Strings.instituteId);
    payload.memberId = id;
    payload.memberType = userType=="institution"?"institution":"person";
    payload.pageSize = 20;
    payload.requestedByType = ownerType=="institution"?"institution":"person";
    payload.requestedById = ownerId;
    payload.isOwn = id==ownerId;
    payload.pageNumber = page;
    payload.searchVal = searchVal;
    // payload.roomType = ROOM_TYPE.COMMUNITYROOM.type;
    payload.roomPrivacyType ='campus';
    payload.institutionId = prefs!.getInt(Strings.instituteId);
    var data = jsonEncode(payload);
    var value = await Calls().call(data, context, Config.ROOMS_LIST);

    return RoomListResponse.fromJson(value);
  }

  List<RoomListItem>? listItemsGetter(RoomListResponse? pageData) {
    campusRoomListing.addAll(pageData!.rows!);
    return pageData.rows;
  }


  Widget listItemBuilder(item, int index) {
    RoomListItem value = item;
    // print(Utility().getUrlForImage(value.roomProfileImageUrl, RESOLUTION_TYPE.R64,SERVICE_TYPE.ROOM));
    return Container(
      margin: EdgeInsets.only(top: 1, bottom: 1, left: 12, right: 12),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RoomDetailPage(value,ownerId,ownerType,userType=="institution"?"institution":"person",instituteId,id,null))).then((value){
              refresh();
            });
          },
          child:appEventCard(
            key: UniqueKey(),
            byTitle: RoomButtons(context: context).getByTitle(value.header!.title,value.header!.subtitle1),
            byImage: value.header!.avatar,
            cardImage: value.roomProfileImageUrl,
            serviceType: SERVICE_TYPE.ROOM,
            title: value.roomName,
            isPrivate: value.isPrivate ?? false,
            cardRating: value.otherDetails!.rating!=null?value.otherDetails!.rating:0.0,
            isModerator: value.memberRoleType == 'A',
            listofImages: List<String?>.generate(value.membersCount!, (index) {
              if(index<value.membersList!.length){
                return value.membersList![index].profileImage;
              }else{
                return "";
              }
            }),
            isRated: value.otherDetails!.isRated,
            ownerType: value.roomOwnerType,
            ownerId:  value.roomOwnerTypeId,
            totalRatedUsers: value.otherDetails!.totalRatedUsers,
            showRateCount: false,
            subjectId: value.id,
            subjectType: 'room',
            isShareVisible: true,
            isRoom: true,
            ratingCallback: (){},
            shareCallback: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              final CreateDeeplink createDeeplink = locator<CreateDeeplink>();
              createDeeplink.getDeeplink(
                  SHAREITEMTYPE.DETAIL.type,
                  prefs.getInt("userId").toString(),
                  value.id,
                  DEEPLINKTYPE.ROOMS.type,
                  context);
            },
            averageRatingCallback: (value){
              setState(() {
                campusRoomListing[index].otherDetails!.rating = value ;
                campusRoomListing[index].otherDetails!.totalRatedUsers =
                    campusRoomListing[index].otherDetails!.totalRatedUsers!+1;
                campusRoomListing[index].otherDetails!.isRated = true;
              });
            },
            actionButton:
          id==ownerId?
          value.membershipStatus == 'A' ? value.memberRoleType=="A"?RoomButtons(context: context,onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CreateRoomPage(
                            value: value,isEdit: true,callback:(){}   ))).then((value){
refresh();
            });
          }).editButton:RoomButtons(context: context,onPressed: (){
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    ExitConfirmationDialog(
                        callback: (isSuccess) {
                          if (isSuccess) {
                            exitRoom(value);
                          }
                        }));
          }).exitButton: RoomButtons(context: context,onPressed: (){
            joingroup(value);
          }).joinButton:Visibility(
              visible: !value.isRequestedByMember! ,
              child: RoomButtons(context: context,onPressed: (){ if (!value.isRequestedByMember! ) {
                joingroup(value);
              }}).joinButton
          ),
          )
      ),
    );
  }

  void exitRoom(RoomListItem value) {
    MembershipRoleStatusPayload payload = MembershipRoleStatusPayload();
    payload.roomId = value.id;
    payload.memberId = ownerId;
    payload.memberType = ownerType;
    payload.action = MEMBERSHIP_ROLE.remove.type;
    var body = jsonEncode(payload);
    Calls().call(body, context, Config.MEMBERSHIP_STATUS_UPDATE).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast("success", context,HexColor(AppColors.success));
        refresh();
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void joingroup(RoomListItem value) {
    MemberAddPayload payload = MemberAddPayload();
    payload.roomId = value.id;
    payload.roomInstitutionId = instituteId;
    payload.isAddAllMembers = false;
    List<MembersItem> list = [];
    MembersItem item = MembersItem();
    item.memberType = ownerType;
    item.memberId = ownerId;
    item.addMethod = MEMBER_ADD_METHOD.JOIN.type;
    list.add(item);
    payload.members = list;
    var data = jsonEncode(payload);
    Calls().call(data, context, Config.MEMBER_ADD).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast("successfully joined", context,HexColor(AppColors.success));
        refresh();

      }
    }).catchError((onError) {
      print(onError);
    });
  }
}

class
RoomButtons{
  Function? onPressed;
  BuildContext? context;
  late TextStyleElements styleElements;
  RoomButtons({this.onPressed,this.context}){
    styleElements = TextStyleElements(context);
  }

  String getByTitle(String? title, subtitle) {
    StringBuffer buff= StringBuffer();
    buff.write(' by ');
    buff.write(title ?? '');
    buff.write(', ');
    buff.write(subtitle ?? '');
    return buff.toString();
  }

  Widget get moderatorImage{
    return Image.asset('assets/appimages/moderator.png',width: 12,height: 12,);
  }
  Widget get verifiedImage{
    return Image.asset('assets/appimages/check.png',width: 16,height: 16,);
  }

  Widget getmoderatorImage(Size size){
    return Image.asset('assets/appimages/moderator.png',width: 12,height: 12,);
  }

   Widget get exitButton {
    return appTextButton(
      onPressed: onPressed,
      padding: EdgeInsets.all(0),
      child: Text(AppLocalizations.of(context!)!.translate('exit'), style: styleElements.captionThemeScalable(context!).copyWith(fontWeight: FontWeight.bold,color:HexColor(AppColors.appMainColor),)),
     );
    // return GestureDetector(
    //    onTap: onPressed,
    //   // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0),),
    //   // color: HexColor(AppColors.appMainColor),
    //  child: Padding(
    //    padding: const EdgeInsets.all(8.0),
    //    child: Text(AppLocalizations.of(context).translate('exit'), style: styleElements.captionThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color:HexColor(AppColors.appMainColor),)),
    //  ),
    //  );
   }

  Widget get joinButton {

    return appTextButton(
      onPressed: onPressed,
      color: HexColor(AppColors.appMainColor),
      child: Text(AppLocalizations.of(context!)!.translate('join'),
          style: styleElements.captionThemeScalable(context!).copyWith(fontWeight: FontWeight.bold,
            color:HexColor(AppColors.appColorWhite),)),
    );

    // return GestureDetector(
    //   onTap: onPressed,
    //   // shape:RoundedRectangleBorder(
    //   //     borderRadius: BorderRadius.circular(25.0),
    //   //     side: BorderSide(color: HexColor(AppColors.appMainColor))
    //   // ),
    //   // color: HexColor(AppColors.appColorTransparent),
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Text(AppLocalizations.of(context).translate('join'), style: styleElements.captionThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color:HexColor(AppColors.appMainColor),)),
    //   ),
    // );
  }

  Widget get editButton {
    return appTextButton(
      onPressed: onPressed,
      padding: EdgeInsets.all(0),
      shape: StadiumBorder(),
      child: Text(AppLocalizations.of(context!)!.translate('edit'), style: styleElements.captionThemeScalable(context!).copyWith(fontWeight: FontWeight.bold,color:HexColor(AppColors.appMainColor),)),
    );
    //
    // return GestureDetector(
    //   onTap: onPressed,
    //   // shape: RoundedRectangleBorder(),
    //   // color: HexColor(AppColors.appColorTransparent),
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Text(AppLocalizations.of(context).translate('edit'), style: styleElements.captionThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color:HexColor(AppColors.appMainColor),)),
    //   ),
    // );
  }

}
