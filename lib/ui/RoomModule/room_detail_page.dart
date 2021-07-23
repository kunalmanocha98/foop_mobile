import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/enums/room_type.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/messenger_module/screens/chat_history_page.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/models/post/postreceiver.dart';
import 'package:oho_works_app/models/rooms_details_data.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/services/socket_service.dart';
import 'package:oho_works_app/ui/BottomSheets/CreateNewSheet.dart';
import 'package:oho_works_app/ui/CalenderModule/create_event_page.dart';
import 'package:oho_works_app/ui/RoomModule/room_about_page.dart';
import 'package:oho_works_app/ui/postModule/selectedPostListPage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../postcreatepage.dart';

class RoomDetailPage extends StatefulWidget {
  final RoomListItem? value;
  final int? id;
  final int? instituteId;
  final int? ownerId;
  final String? userType;
  final String? ownerType;
  final String? nameOfRoom;

  RoomDetailPage(this.value, this.ownerId, this.ownerType, this.userType,
      this.instituteId, this.id, this.nameOfRoom);

  @override
  _RoomDetailPage createState() => _RoomDetailPage(
      value: value,
      ownerId: ownerId,
      ownerType: ownerType,
      userType: userType,
      instituteId: instituteId,
      id: id,
      nameOfRoom: nameOfRoom);
}

class _RoomDetailPage extends State<RoomDetailPage>
    with SingleTickerProviderStateMixin {
  List<CustomTabMaker> list = [];
  int _currentPosition = 0;
  late TabController _tabController;
  TextStyleElements? styleElements;
  SharedPreferences? prefs;
  late bool hasData;
  RoomListItem? value;
  int? id;
  int? instituteId;
  int? ownerId;
  String? userType;
  String? ownerType;
  String? nameOfRoom;
  int initialIndex = 0;

  _RoomDetailPage(
      {this.value,
        this.ownerId,
        this.ownerType,
        this.userType,
        this.instituteId,
        this.id,
        this.nameOfRoom});
  GlobalKey<ChatHistoryPageState> ch = GlobalKey();
  GlobalKey<SelectedFeedPageState> selectedFeedListKey = GlobalKey();
  SocketService? socketService = locator<SocketService>();

  @override
  void initState() {
    hasData = value != null;
    initialIndex = value != null ? 0 : 1;
    _currentPosition = value != null ? 0 : 1;
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadPages());
  }

  onPositionChange() {
    if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
        _currentPosition = _tabController.index;
      });
    }
  }

  void loadPages() async {
    prefs ??= await SharedPreferences.getInstance();
    if (hasData) {
      list.add(CustomTabMaker(
          statelessWidget: SelectedFeedListPage(
            key: selectedFeedListKey,
            appBarTitle: "",
            isOthersPostList: true,
            isFromProfile: true,
            postOwnerTypeId: ownerId,
            postOwnerType: userType,
            isRoomPost: true,
            roomId: value!.id,
          ),
          tabName: AppLocalizations.of(context)!.translate('timeline')));
      list.add(CustomTabMaker(
          statelessWidget: RoomAboutPage(
              value, ownerId, ownerType, userType, instituteId, id, nameOfRoom),
          tabName: AppLocalizations.of(context)!.translate('about')));
      Future(() {
        setState(() {
          _tabController = TabController(vsync: this, length: list.length);
          _tabController.addListener(onPositionChange);
        });
      });
    } else {
      getRoomsDetails();
    }
  }

  void getRoomsDetails() async {
    final body = jsonEncode({
      "id": id,
    });

    Calls().call(body, context, Config.ROOM_DETAILS).then((v) {
      var res = RoomsDetailData.fromJson(v);
      if (res.statusCode == Strings.success_code) {
        if (res.rows != null) {
          value = res.rows;
          hasData = true;
          ownerId ??= prefs!.getInt("userId");
          instituteId ??= prefs!.getInt(Strings.instituteId);
          ownerType ??= prefs!.getString("ownerType");
          userType ??= prefs!.getString("ownerType");
          loadPages();
        }
      } else {
        ToastBuilder().showToast(
            AppLocalizations.of(context)!.translate('no_data_found_room'),
            context,
            HexColor(AppColors.failure));
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
          appBar: TricycleAppBar().getCustomAppBar(context,
              // appBarTitle: AppLocalizations.of(context)
              //     .translate("room_details"),
              appBarTitle: hasData
                  ? value!.roomName
                  : AppLocalizations.of(context)!.translate('room_details'),
              onBackButtonPress: () {
                Navigator.pop(context);
              }),
          body: hasData
              ? Stack(
                children: [
                  DefaultTabController(
            length: list.length,
            initialIndex: initialIndex,
            child: CustomTabView(
                  marginTop: const EdgeInsets.all(16.0),
                  currentPosition: _currentPosition,
                  itemCount:
                  list != null && list.isNotEmpty ? list.length : 0,
                  tabBuilder: (context, index) => TricycleTabButton(
                    onPressed: () {
                      setState(() {
                        _currentPosition = index;
                      });
                    },
                    tabName: list[index].tabName,
                    isActive: index == _currentPosition,
                  ),
                  pageBuilder: (context, index) =>
                      Center(child: list[index].statelessWidget),
                  onPositionChange: (index) {
                    setState(() {
                      _currentPosition = index!;
                    });
                  },
                  onScroll: (position) => print('$position'),
            ),
          ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child:_RoomDetailsButtonWidget(
                      talkButtonClick: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return CreateEventPage(
                                type: 'talk',
                                standardEventId: 5,
                                ownerId: value!.id,
                                ownerImage: value!.roomProfileImageUrl,
                                ownerName: value!.roomName,
                                ownerType: 'room',
                                roomItem: value,
                              );
                            }));
                      },
                      createButtonClick: (){
                        if (prefs!.getBool(Strings.isVerified) != null &&
                            prefs!.getBool(Strings.isVerified)!) {
                          _showModalSelectorSheet(context);
                        } else {
                          ToastBuilder().showSnackBar(
                              AppLocalizations.of(context)!
                                  .translate("only_verirfied"),
                              context,
                              HexColor(AppColors.information));
                        }},
                      chatButtonClick: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new ChatHistoryPage(
                                  key:ch,
                                    roomListItem: value,
                                    conversationItem: null,
                                    connectionItem: null,
                                    isVisible: true,
                                    type:"normal",
                                    socket: socketService!.getSocket(),
                                    callBack: (){},
                                    callBackNew: (){})));
                      },
                    ) ,
                  )
                ],
              )
              : CustomPaginator(context).loadingWidgetMaker()),
    );
  }

  void _showModalSelectorSheet(BuildContext context) async {
    prefs ??= await SharedPreferences.getInstance();
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      builder: (context) {
        var postRecieverListItem = PostReceiverListItem(
          allowedMsg: "",
          isAllowed: true,
          isSelected: true,
          recipientTypeReferenceId: value!.id,
          recipientTypeDescription: "",
          recipientType: value!.roomName,
          recipientTypeCode: ROOM_TYPES_HELPER().roomTypeNamebasedonType(
              ROOM_TYPES_HELPER()
                  .getRoomTypeBasedOnRoomTypeCode(value!.roomType)),
        );
        return CreateNewBottomSheet(
          isRoomsVisible: false,
          prefs: prefs,
          onClickCallback: (value) {
            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(
                builder: (context) => PostCreatePage(
                  type: value,
                  selectedReceiverData: postRecieverListItem,
                )))
                .then((value) {
              if (value != null) {
                if (_tabController.index == 0) {
                  selectedFeedListKey.currentState!.refresh();
                }
              }
            });
          },
        );
      },
    );
  }
}

class _RoomDetailsButtonWidget extends StatelessWidget {
  final Function talkButtonClick;
  final Function createButtonClick;
  final Function chatButtonClick;

  _RoomDetailsButtonWidget({
    required this.talkButtonClick,
    required this.createButtonClick,
    required this.chatButtonClick,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.only(top:6,bottom: 6,left:16,right:16 ),
          decoration: BoxDecoration(
              color: HexColor(AppColors.appMainColor),
              borderRadius: BorderRadius.circular(45),
              boxShadow: [CommonComponents().getShadowforBox_01_3()]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.mic_none_rounded,
                  size: 30,
                  color: HexColor(AppColors.appColorWhite),
                ),
                onPressed: talkButtonClick as void Function()?,
              ),
              SizedBox(width: 16,),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline_rounded,
                  size: 30,
                  color: HexColor(AppColors.appColorWhite),
                ),
                onPressed: createButtonClick as void Function()?,
              ),
              SizedBox(width: 16,),
              IconButton(
                icon: Icon(
                  Icons.message_outlined,
                  size: 30,
                  color: HexColor(AppColors.appColorWhite),
                ),
                onPressed: chatButtonClick as void Function()?,
              )
            ],
          ),
        ),
      ],
    );
  }
}
