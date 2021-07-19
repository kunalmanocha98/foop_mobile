
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/postcardactionbuttons.dart';
import 'package:oho_works_app/components/tricycle_user_images_list.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/create_deeplink.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/enums/share_item_type.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/Rooms/rooms_view.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/ui/RoomModule/rooms_listing.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TricycleRoomCalenderCard extends StatefulWidget {
  final dynamic calenderData;
  final RoomListItem roomData ;
  final bool isRooms;
  final bool isCalender;
  final Widget actionButton;
  final bool isSmallCard ;
  final Function ratingCallback;
  TricycleRoomCalenderCard({Key key, this.roomData,this.calenderData,this.isCalender= false,this.isRooms= false,this.actionButton,this.isSmallCard = false,this.ratingCallback}):super(key: key);

  @override
  TricycleRoomCalenderCardState createState() =>
      TricycleRoomCalenderCardState(calenderData: calenderData,roomData: roomData,isCalender: isCalender,isRooms: isRooms,actionButton: actionButton);
}

class TricycleRoomCalenderCardState extends State<TricycleRoomCalenderCard> {
  dynamic calenderData ;
  RoomListItem roomData ;
  bool isRooms;
  bool isCalender;
  final Widget actionButton;
  TricycleRoomCalenderCardState({this.roomData,this.calenderData,this.isCalender= false,this.isRooms= false,this.actionButton});
  TextStyleElements styleElements;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return widget.isSmallCard?getSmallCard():TricycleListCard(
        child: Container(
          margin: EdgeInsets.only(top: 12, left: 12, right: 12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                     TricycleAvatar(
                       key: UniqueKey(),
                     withBorder: true,
                     size: 56,
                     resolution_type: RESOLUTION_TYPE.R64,
                     service_type: SERVICE_TYPE.ROOM,
                     imageUrl: roomData.roomProfileImageUrl,)
                    ],
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 8, bottom: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TricycleAvatar(
                                size: 16,
                                resolution_type: RESOLUTION_TYPE.R64,
                                service_type:   roomData.roomOwnerType=='person'?SERVICE_TYPE.PERSON:SERVICE_TYPE.INSTITUTION,
                                imageUrl: roomData.header.avatar,
                                shouldPrintLog: false,
                                key: UniqueKey(),
                              ),
                              Flexible(
                                  child:
                                      Text(
                                          AppLocalizations.of(context).translate('room_card_header',arguments:{"name":roomData.header.title, "role":roomData.header.subtitle1}),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                              )
                            ],
                          ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                     roomData.roomName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: styleElements
                                        .subtitle1ThemeScalable(context)
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ), Visibility(
                                    visible: roomData.isPrivate ??  false,
                                    child: Icon(
                                      Icons.lock,
                                      color: HexColor(AppColors.appColorBlack65),
                                      size: 16,
                                    ),
                                  )
                              ]
                          ),
                          // Text(
                          //   roomData.roomName,
                          //   maxLines: 3,
                          //   overflow: TextOverflow.ellipsis,
                          //   style: styleElements
                          //       .subtitle1ThemeScalable(context)
                          //       .copyWith(fontWeight: FontWeight.bold),
                          // ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${roomData.otherDetails.rating} ',style: styleElements.subtitle1ThemeScalable(context).copyWith(
                                color: HexColor(AppColors.appMainColor),
                                fontWeight: FontWeight.bold
                              ),),
                              Visibility(
                                visible: true,
                                child:  RatingBar(
                                  initialRating: roomData.otherDetails.rating!=null?roomData.otherDetails.rating:0.0,
                                  ignoreGestures: true,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 15.0,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                  ratingWidget: RatingWidget(
                                    empty: Icon(
                                      Icons.star_outline,
                                      color: HexColor(AppColors.appMainColor),
                                    ),
                                    half:  Icon(
                                      Icons.star_half_outlined,
                                      color: HexColor(AppColors.appMainColor),
                                    ),
                                    full:  Icon(
                                      Icons.star_outlined,
                                      color: HexColor(AppColors.appMainColor),
                                    ),
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(left: 8,right: 8),
                              child: Container(width: 1,height: 16,
                              color: HexColor(AppColors.appColorBlack35),),),
                              Visibility(
                                visible: roomData.memberRoleType == 'A',
                                child: Padding(
                                  padding: EdgeInsets.only(top:4,left: 2),
                                  child: Container(
                                    child: RoomButtons(context: context).moderatorImage,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          roomData.roomDescription!=null && roomData.roomDescription.isNotEmpty?Text(
                            roomData.roomDescription,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: styleElements.bodyText2ThemeScalable(context),
                          ):Container(),
                          SizedBox(
                            height: 8,
                          ),
                          TricycleUserImageList(
                            listOfImages: List.generate(roomData.membersCount,(index){
                              if(index<roomData.membersList.length){
                                return roomData.membersList[index].profileImage;
                              }else{
                                return "";
                              }
                            }),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: actionButton,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding:  EdgeInsets.only(left:60.0),
                child: PostCardActionButtons(
                  isCommentVisible: false,
                  isBookMarkVisible: false,
                  isShareVisible: roomData.roomPrivacyType =='public',
                  sharecallBack: _shareCallback,
                  subjectId: roomData.id,
                  subjectType: 'room',
                  stats: Statistics(
                    starRating: roomData.otherDetails.totalRatedUsers,
                  ),
                  isRated: roomData.otherDetails.isRated ?? false,
                  ownerId: roomData.roomOwnerTypeId,
                  ownerType: roomData.roomOwnerType,
                  ratingCallback: (){
                    if(!roomData.otherDetails.isRated) roomData.otherDetails.totalRatedUsers++;
                    roomData.otherDetails.isRated = true;
                    Future.delayed(Duration(milliseconds: 600),(){
                      refreshCard();
                    });
                  },
                ),
              )
            ],
          ),
        ));
  }

  void _shareCallback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final CreateDeeplink createDeeplink = locator<CreateDeeplink>();
    createDeeplink.getDeeplink(
        SHAREITEMTYPE.DETAIL.type,
        prefs.getInt("userId").toString(),
        roomData.id,
        DEEPLINKTYPE.ROOMS.type,
        context);
  }


  Widget getSmallCard(){
    return TricycleListCard(
        child: Container(
          margin: EdgeInsets.only(top: 4,),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TricycleAvatar(
                key: UniqueKey(),
                withBorder: false,
                size: 64,
                resolution_type: RESOLUTION_TYPE.R64,
                service_type: SERVICE_TYPE.ROOM,
                imageUrl:roomData.roomProfileImageUrl),
              SizedBox(height: 4,),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TricycleAvatar(
                    size: 16,
                    resolution_type: RESOLUTION_TYPE.R64,
                    service_type:   roomData.roomOwnerType=='person'?SERVICE_TYPE.PERSON:SERVICE_TYPE.INSTITUTION,
                    imageUrl: roomData.header.avatar,
                    key: UniqueKey(),
                  ),
                  Flexible(
                    child:
                    Text(
                      AppLocalizations.of(context).translate('room_card_header',arguments:{"name":roomData.header.title, "role":roomData.header.subtitle1}),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        roomData.roomName,
                        // "ldlflsdlfkjsdl lkdsflksd  lksdflkdsjf lsdjfldsj f lsdjflsd fl sldfjsld f",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: styleElements
                            .subtitle1ThemeScalable(context)
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ), Visibility(
                      visible: roomData.isPrivate ?? false,
                      child: Icon(
                        Icons.lock,
                        color: HexColor(AppColors.appColorBlack65),
                        size: 16,
                      ),
                    )
                  ]
              ),
              roomData.roomDescription!=null && roomData.roomDescription.isNotEmpty?
              Expanded(
                child: Text(
                  roomData.roomDescription,
                  style: styleElements.bodyText2ThemeScalable(context),
                ),
              )
                  :Expanded(child: Container())
              ,
              TricycleUserImageList(
                listOfImages: List.generate(roomData.membersCount,(index){
                  if(index<roomData.membersList.length){
                    return roomData.membersList[index].profileImage;
                  }else{
                    return "";
                  }
                }),
              ),
            ],
          ),
        ));
  }

  void refreshCard() {
    RoomViewRequest payload  = RoomViewRequest();
    payload.id = roomData.id;
    Calls().call(jsonEncode(payload), context, Config.ROOM_VIEW).then((value){
      var response = RoomViewResponse.fromJson(value);
      if(response.statusCode == Strings.success_code){
        setState(() {
          roomData.otherDetails = response.rows.otherDetails;
        });
      }
    });
  }

}
