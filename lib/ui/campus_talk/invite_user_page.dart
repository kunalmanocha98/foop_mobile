import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycleProgressButton.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/components/tricycle_user_list_tile.dart';
import 'package:oho_works_app/enums/member%20enums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/CalenderModule/event_create_models.dart';
import 'package:oho_works_app/models/Rooms/memberAdd.dart';
import 'package:oho_works_app/models/Rooms/memberlistResponse.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InviteTalkParticipants extends StatefulWidget{
  final String? privacyType;
  final int? eventId;
  InviteTalkParticipants({this.privacyType,this.eventId});
  @override
  InviteTalkParticipantsState createState() => InviteTalkParticipantsState();
}

class InviteTalkParticipantsState extends State<InviteTalkParticipants>{
  String? searchVal;
  SharedPreferences? prefs = locator<SharedPreferences>();
  late TextStyleElements styleElements;
  List<MemberListItem> memberItemList = [];
  List<MembersItem> selectedList = [];
  GlobalKey<TricycleProgressButtonState> progressButtonState = GlobalKey();
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  bool isAddAll = false;

  void refresh(){
    memberItemList.clear();
    paginatorKey.currentState!.changeState(resetState: true);
  }
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
        child:
        Scaffold(
          appBar: TricycleAppBar().getCustomAppBarWithSearch(context,
              onSearchValueChanged: (value) {
                searchVal = value;
                refresh();
              },
              appBarTitle: AppLocalizations.of(context)!.translate('invite_participants'),
              onBackButtonPress: () {
                Navigator.pop(context);
              },
              actions: [
                TricycleProgressButton(
                  key: progressButtonState,
                  onPressed: () {
                    inviteUsers();
                  },
                  elevation: 0,
                  color: HexColor(AppColors.appColorBackground),
                  shape: StadiumBorder(),
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('next'),
                        style: styleElements
                            .subtitle2ThemeScalable(context)
                            .copyWith(color: HexColor(AppColors.appMainColor)),
                      ),
                      Icon(Icons.keyboard_arrow_right,
                          color: HexColor(AppColors.appMainColor))
                    ],
                  ),
                ),
              ]

          ),
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 2,left: 16,right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
                    color: HexColor(AppColors.appColorRed50)
                ),
                child: Padding(
                    padding: EdgeInsets.only(top:16,left: 16,right: 16,bottom: 8),
                    child:Text(AppLocalizations.of(context)!.translate('invite_talk_des'),
                      style: styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.w500),
                    )
                  // child: Text('Rooms are groups. You can create rooms to engage with more than one person together. Please click + on the top of the page to create new rooms.',style:
                  //   styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),),
                ),
              ),
              Expanded(
                child: TricycleListCard(
                  child: Paginator.listView(
                    key: paginatorKey,
                      pageLoadFuture: fetchList,
                      pageItemsGetter: listItemsGetter,
                      listItemBuilder: listItemBuilder,
                      loadingWidgetBuilder: CustomPaginator(context)
                          .loadingWidgetMaker,
                      errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                      emptyListWidgetBuilder: CustomPaginator(context)
                          .emptyListWidgetMaker,
                      totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                      pageErrorChecker: CustomPaginator(context).pageErrorChecker),
                ),
              ),
            ],
          ),
        ));
  }

  Future<MemberListResponse> fetchList(int page) async {
    MemberListPayload payload = MemberListPayload();
    payload.pageSize = 10;
    payload.pageNumber = page;
    payload.searchVal = searchVal ;
    payload.privacyType = widget.privacyType;
    payload.personId = prefs!.getInt(Strings.userId);
    var res = await Calls().call(jsonEncode(payload), context, Config.EVENT_MEMBER_SELECT_LIST);
    return MemberListResponse.fromJson(res);
  }
  List<MemberListItem>? listItemsGetter(MemberListResponse? response) {
    memberItemList.addAll(response!.rows!);
    if (!isAddAll) {
      for (int i = 0; i < memberItemList.length; i++) {
        for (int j = 0; j < selectedList.length; j++) {
          if (memberItemList[i].id == selectedList[j].memberId) {
            memberItemList[i].isSelected = true;
            break;
          }
        }
      }
    } else {
      for (int i = 0; i < memberItemList.length; i++) {
        memberItemList[i].isSelected = true;
      }
    }
    return response.rows;
  }


  Widget listItemBuilder(itemData, int index) {
    MemberListItem value = itemData;
    return Container(
      margin: EdgeInsets.only(top: 1, bottom: 1, left: 12, right: 12),
      child: InkWell(
        onTap: () {},
        child: TricycleUserListTile(
          imageUrl: value.profileImage,
            title:
              (value.firstName != null && value.lastName != null)
                  ? value.firstName! + " " + value.lastName!
                  : "",
            subtitle1:value.isFollowing! ? "Following" : "",
            trailingWidget: (value.isSelected != null && value.isSelected!)
                ? Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: HexColor(AppColors.appMainColor))
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    memberItemList[index].isSelected = false;
                    selectedList.removeWhere((element){
                      return element.memberId == memberItemList[index].id;
                    });
                  });
                },
                color: HexColor(AppColors.appMainColor),
                icon: Icon(Icons.close),
              ),
            )
                : TricycleElevatedButton(
              onPressed: () {
                // if (value.isFollowing) {
                MembersItem item = MembersItem();
                item.memberType = "person";
                item.memberId = value.id;
                item.addMethod = MEMBER_ADD_METHOD.DIRECT.type;
                item.profileImage = value.profileImage;
                item.memberName = value.firstName;
                selectedList.add(item);
                // } else {
                //   MembersItem item = MembersItem();
                //   item.memberType = 'person';
                //   item.memberId = value.id;
                //   item.addMethod = MEMBER_ADD_METHOD.INVITE.type;
                //   _selectedList.add(item);
                // }
                memberItemList[index].isSelected = true;
                setState(() {});
              },
              child: Text(
                AppLocalizations.of(context)!.translate('invite'),
                style: styleElements
                    .captionThemeScalable(context)
                    .copyWith(
                    color: HexColor(AppColors.appMainColor),
                    fontWeight: FontWeight.bold),
              ),
              color: HexColor(AppColors.appColorWhite),
              shape: StadiumBorder(
                  side: BorderSide(
                      color: HexColor(AppColors.appMainColor))),
            )),
      ),
    );
  }

  void inviteUsers() async{
    progressButtonState.currentState!.show();
    EventCreateRequest payload =EventCreateRequest();
    payload.eventId = widget.eventId;
    payload.eventOwnerId = prefs!.getInt(Strings.userId);
    payload.eventOwnerType = 'person';
    payload.recipientType =['person'];
    payload.recipientDetails =  List<RecipientDetails>.generate(selectedList.length, (index){
      return RecipientDetails(
        type: selectedList[index].memberType,
        id: selectedList[index].memberId,
      );
    });
    Calls().call(jsonEncode(payload), context, Config.TALK_EVENT_INVITEE_ADD).then((value){
      progressButtonState.currentState!.hide();
      Navigator.pop(context);
    }).catchError((onError){
      print(onError);
      progressButtonState.currentState!.hide();
      Navigator.pop(context);
    });
  }


}