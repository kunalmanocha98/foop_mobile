import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/api_calls/logout_api.dart';
import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/customgridDelegate.dart';
import 'package:oho_works_app/components/app_bottom_selector.dart';
import 'package:oho_works_app/components/appmenuitem.dart';
import 'package:oho_works_app/crm_module/CompanyAndCustomerPage.dart';
import 'package:oho_works_app/crm_module/SuppliersPage.dart';
import 'package:oho_works_app/crm_module/crm_page.dart';
import 'package:oho_works_app/crm_module/product/product_inventry_services_page.dart';
import 'package:oho_works_app/crm_module/purchase_order.dart';
import 'package:oho_works_app/enums/post_enums.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/home/home.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/messenger_module/screens/chat_list_page.dart';
import 'package:oho_works_app/models/common_response.dart';
import 'package:oho_works_app/models/device_info.dart';
import 'package:oho_works_app/models/followers_following_count.dart';
import 'package:oho_works_app/models/menu/menulistmodels.dart';
import 'package:oho_works_app/models/menu/profile_models.dart';
import 'package:oho_works_app/models/notification_count_response.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/profile_module/common_cards/user_name_with_image_card.dart';
import 'package:oho_works_app/profile_module/pages/network_page.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/services/audio_socket_service.dart';
import 'package:oho_works_app/services/deeplinking_service.dart';
import 'package:oho_works_app/services/share_data_service.dart';
import 'package:oho_works_app/services/socket_service.dart';
import 'package:oho_works_app/app_database/data_base_helper.dart';
import 'package:oho_works_app/ui/BottomSheets/CreateNewSheet.dart';
import 'package:oho_works_app/ui/EdufluencerTutorModule/become_edufluencer_tutor_page.dart';
import 'package:oho_works_app/ui/EdufluencerTutorModule/edufluencer_tutor_list.dart';
import 'package:oho_works_app/ui/RoomModule/roomsPage.dart';
import 'package:oho_works_app/ui/campus_talk/campus_talk_list.dart';
import 'package:oho_works_app/ui/dialogs/logout_dialog.dart';
import 'package:oho_works_app/ui/postModule/CampusNewsListPage.dart';
import 'package:oho_works_app/ui/postModule/pollsListPage.dart';
import 'package:oho_works_app/ui/postModule/postListPage.dart';
import 'package:oho_works_app/ui/postModule/selectedPostListPage.dart';
import 'package:oho_works_app/ui/postcreatepage.dart';
import 'package:oho_works_app/ui/settings.dart';
import 'package:oho_works_app/ui/testlistingpage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/datasave.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'BuddyApproval/buddyservicePage.dart';
import 'CalenderModule/calender_list_page.dart';
import 'CouponsModule/couponsPage.dart';
import 'EdufluencerTutorModule/edufluencer_tutor_list.dart';
import 'LearningModule/lessons_list_page.dart';
import 'RoomModule/createRoomPage.dart';
import 'appmenupage.dart';
import 'campus_talk/test_video/home_screen.dart';
import 'community_page.dart';
import 'dialogs/logout_dialog.dart';
import 'email_module/email_home_page.dart';
import 'email_module/email_login_page.dart';
import 'homepage.dart';
import 'invitations/invitation_page.dart';
import 'menu_user_popularity_card.dart';

class DashboardPage extends StatefulWidget {
  final int? index;
  final int? id;
  final Null Function(String)? newMessageCallBack;
  DashboardPage({this.index, this.id,this.newMessageCallBack});

  @override
  _DashBoardPage createState() => _DashBoardPage(index: index, id: id);
}

class _DashBoardPage extends State<DashboardPage> {
  final int? index;
  final int? id;
  final db = DatabaseHelper.instance;
  _DashBoardPage({this.index, this.id});
  // final double _initFabHeight = 120.0;
  // double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 48.0;
  double _panelHeightClosedFirstTime = 350.0;
  SharedPreferences? prefs;
  late TextStyleElements styleElements;
  GlobalKey<AppMenuPageState> appMenuKey = GlobalKey();
  GlobalKey<appBottomSelectorState> bottomSelectorKey = GlobalKey();
  final DynamicLinkService? dynamicLinkService = locator<DynamicLinkService>();
  var followers = 0;
  var following = 0;
  var roomsCount = 0;
  var postCount = 0;
  int? notificationCount;
  AudioSocketService? audioSocketService = locator<AudioSocketService>();
  SocketService? socketService = locator<SocketService>();
  int i = 0;
  int chatCount = 0;
  int nCount = 0;
  int? progress;
  Persondata? rows;
  GlobalKey<CampusTalkPageState> talkPage = GlobalKey();
  GlobalKey<HomePageState> homePageState = GlobalKey();
  GlobalKey<PostListState> postListKey = GlobalKey();
  List<Institutions> institutionList = [];
  final SharedDataService? sharedDataService = locator<SharedDataService>();
BuildContext? dgsContext;
  bool isLoading=false;
  bool seeMore = false;

  // static const double minExtent = 0.05;
  // static const double maxExtent = 0.8;

  bool isExpanded = true;
  double initialExtent =0.42;
  BuildContext? draggableSheetContext;
  PanelController drageScrollController=new PanelController();


  getPersonProfile(BuildContext context) async {
    fetchMenuListData();
    prefs ??= await SharedPreferences.getInstance();
    if (prefs!.getString("basicData") != null) {
      Map<String, dynamic> map =
      json.decode(prefs!.getString("basicData") ?? "");
      rows = Persondata.fromJson(map);
      followersCountApi(context);

      if (rows != null) {
        if (i == 0) {
          i = 1;
          institutionList.clear();
          if (rows != null) {
            for (int i = 0; i < rows!.institutions!.length; i++) {
              if (institutionList.any((element) {
                return element.name == rows!.institutions![i].name;
              })) {
                Institutions institutions = institutionList.firstWhere((element) {
                  return element.name == rows!.institutions![i].name;
                });
                var index = institutionList.indexOf(institutions);
                if (institutionList[index].role != rows!.institutions![i].role) {
                  institutionList[index].role = institutionList[index].role! +
                      ', ' +
                      rows!.institutions![i].role!;
                }
              } else {
                institutionList.add(rows!.institutions![i]);
              }
            }
          }
        }
        setState(() {

        });
      }
    }
  }
  @override
  void initState() {
    super.initState();
    setPrefs();
    // _fabHeight = _initFabHeight;
    sharedDataService!.handleReceivedData(context);


    DataSaveUtils().getUserData(context, prefs);

    dynamicLinkService!.handleDynamicLinks(context, prefs);


    WidgetsBinding.instance!
        .addPostFrameCallback((_) => getPersonProfile(context));
  }

  @override
  void dispose() {
    super.dispose();
  }

  PackageInfo? packageInfo;
  void setPrefs() async {
    prefs = await SharedPreferences.getInstance();

  }
  void logout() async {
    setState(() {
      isLoading = true;
    });

    DeviceInfo deviceInfo = DeviceInfo();
    if (prefs!.getString("DeviceInfo") != null) {
      Map<String, dynamic> map =
      json.decode(prefs!.getString("DeviceInfo") ?? "");
      deviceInfo = DeviceInfo.fromJson(map);
    }
    if (prefs!.getDouble("lat") != null)
      deviceInfo.gpsInfo = "Latitude :" +
          prefs!.getDouble("lat").toString() +
          ", Longitude : " +
          prefs!.getDouble("longi").toString();
    deviceInfo.fcmId = prefs!.getString("fcmId");

    LogOutApi().logOut(context, jsonEncode(deviceInfo)).then((value) async {
      if (value != null) {
        await db.deleteConversations();
        await db.deleteMessages();
        await db.deleteParticipants();
        prefs = await SharedPreferences.getInstance();
        var data = CommonBasicResponse.fromJson(value);
        if (data.statusCode == Strings.success_code) {
          prefs!.clear();
          prefs!.setBool("isLogout", true);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false);
        } else {
          setState(() {
            isLoading = false;
          });
          ToastBuilder().showToast(
              "Please try Again", context, HexColor(AppColors.information));
        }
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
      setState(() {
        isLoading = false;
      });
    });
    /*    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectLanguage(true),
        ));*/
  }

  void menuitemClick(String? code) {
    switch (code) {

      case 'parentalcontrol':
        {
          break;
        }
      case 'business':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserProfileCards(
                    userType: 'business',
                    userId: prefs!.getInt(Strings.instituteId),
                    callback: () {},
                    currentPosition: 1,
                    type: null,
                  )));
          break;
        }

      case 'myteam':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CommunityPage(

                  )));
          break;
        }
      case 'email':
        {
          if(prefs!.containsKey(Strings.mailUsername)){
            Navigator.push(context, MaterialPageRoute(
                builder: (context){
                  return EmailHomePage();
                }
            ));
          }else {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmailLoginPage()));
          }
          break;
        }
      case 'network':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NetworkPage(
                      id: prefs!.getInt("userId"),
                      imageUrl: Utility().getUrlForImage(
                          prefs!.getString(Strings.profileImage),
                          RESOLUTION_TYPE.R64,
                          prefs!.getString("ownerType") == "institution"
                              ? SERVICE_TYPE.INSTITUTION
                              : SERVICE_TYPE.PERSON),
                      type: prefs!.getString("ownerType") == "institution"
                          ? "institution"
                          : "person",
                      currentTab: 0,
                      pageTitle: prefs!.getString(Strings.firstName),
                      callback: () {})));
          break;
        }
      case 'room':
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RoomsPage()));
          break;
        }
      case 'chat':
        {
          Navigator.of(context)
              .push(MaterialPageRoute(
              builder: (context) =>  ChatListsPage(
                conversationId: " ",

              )));
          break;
        }
      case 'talks':
        {
          Navigator.of(context)
              .push(MaterialPageRoute(
              builder: (context) =>   CampusTalkListPage(
                key: talkPage,
              ),));
          break;
        }

      case 'learning':
        {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) =>   LessonsListPage(

            ),));
          break;
        }


      case 'reward':
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CouponsPage()));
          break;
        }
      case 'notice':
        {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SelectedFeedListPage(
                isFromProfile: false,
                appBarTitle:
                AppLocalizations.of(context)!.translate('notice_board'),
                postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
                postType: POST_TYPE.NOTICE.status,
              )));
          break;
        }
      case 'expert':
        {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SelectedFeedListPage(
                isFromProfile: false,
                appBarTitle:
                AppLocalizations.of(context)!.translate('ask_expert'),
                postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
                postType: POST_TYPE.QNA.status,
              )));
          break;
        }
      case 'blog':
        {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SelectedFeedListPage(
                isFromProfile: false,
                appBarTitle:
                AppLocalizations.of(context)!.translate('article'),
                postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
                postType: POST_TYPE.BLOG.status,
              )));
          break;
        }
      case 'bookmark':
        {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SelectedFeedListPage(
                isFromProfile: false,
                isBookMarked: true,
                appBarTitle: AppLocalizations.of(context)!
                    .translate('bookmarked_posts'),
                postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
              )));
          break;
        }
      case 'poll':
        {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PollsListPage(
                prefs: prefs,
              )
            // SelectedFeedListPage(
            //   isFromProfile:false,
            //   appBarTitle: AppLocalizations.of(context).translate('poll'),
            //   postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
            //   postType: POST_TYPE.NEWS.status,)
          ));
          break;
        }
      case 'invite':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InvitationPage(),
              ));
          break;
        }
      case 'settings':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPage(),
              ));
          break;
        }
      case 'buddy':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuddyServicesPage(),
              ));
          break;
        }
      case 'news':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CampusNewsListPage(),
              ));
          break;
        }

      case 'lead_order':
        {

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CrmPage(
                    id: prefs!.getInt(Strings.userId),
                    type: "person",
                    hideTabs:true,
                    isSwipeDisabled:true,
                    hideAppBar: true,
                    currentTab: 0,
                    pageTitle: "",
                    imageUrl: "",
                    callback: () {

                    }),
              ));
        /*  Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CrmPage(
                    id: prefs!.getInt(Strings.userId),
                    type: "person",
                    hideTabs:true,
                    isSwipeDisabled:true,
                    hideAppBar: true,
                    currentTab: 0,
                    pageTitle: "",
                    imageUrl: "",
                    callback: () {

                    }),
              ));*/
          break;
        }

      case 'products':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SelectItemsPage(
                        id: prefs!.getInt(Strings.userId),
                        type: "person",
                        title: "Product Management",
                        hideTabs: true,
                        isSwipeDisabled: true,
                        hideAppBar: true,
                        from: "home",
                        currentTab: 0,
                        pageTitle: "",
                        imageUrl: "",
                        callback: () {

                        }),
              ));

          break;
        }


      case 'suppliers':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SupplierPage(
                        id: prefs!.getInt(Strings.userId),
                        type: "person",
                        hideTabs: true,
                        isSwipeDisabled: true,
                        hideAppBar: true,
                        from: "home",
                        currentTab: 1,
                        pageTitle: "",
                        imageUrl: "",
                        callback: () {

                        }),
              ));

          break;
        }
      case 'customers':
        {

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompanyAndCustomerPage(
                    id: prefs!.getInt(Strings.userId),
                    type: "person",
                    hideTabs:true,
                    isSwipeDisabled:true,
                    hideAppBar: true,
                    from:"home",
                    currentTab: 1,
                    pageTitle: "",
                    imageUrl: "",
                    callback: () {

                    }),
              ));
          break;
        }
      case 'payments':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CrmPage(
                    id: prefs!.getInt(Strings.userId),
                    type: "person",
                    hideTabs:true,
                    isSwipeDisabled:true,
                    hideAppBar: true,
                    currentTab: 3,
                    pageTitle: "",
                    imageUrl: "",
                    callback: () {

                    }),
              ));
          break;
        }
      case 'invoices':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CrmPage(
                    id: prefs!.getInt(Strings.userId),
                    type: "person",
                    hideTabs:true,
                    isSwipeDisabled:true,
                    hideAppBar: true,
                    currentTab: 2,
                    pageTitle: "",
                    imageUrl: "",
                    callback: () {

                    }),
              ));
          break;
        }


      case 'purchase_order':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PurchaseOrderPage(
                    id: prefs!.getInt(Strings.userId),
                    type: "person",
                    hideTabs:true,
                    isSwipeDisabled:true,
                    hideAppBar: true,
                    currentTab: 0,
                    pageTitle: "",
                    imageUrl: "",
                    callback: () {

                    }),
              ));
          break;
        }


      case 'events':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CalenderPage(),
              ));
          break;
        }
      case 'logout':
        {
          showDialog(
              context: context,
              builder: (BuildContext context) => LogoutDialog(logout));
          // logout();
          break;
        }
      case 'listTile':
        {
          showDialog(context: context,builder: (BuildContext context)=> TestListingPage());
          // logout();
          break;
        }
      case 'edufluencer':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EdufluencerTutorList(type: edufluencer_type.E,),
              ));
          break;
        }
      case 'tutor':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EdufluencerTutorList(type: edufluencer_type.T,),
              ));
          break;
        }
    }
  }
  int _selectedIndex = 0;
  List<MenuListItemNew>? menuList = [];
  List<Widget> _widgetOptions() {
    return <Widget>[


      HomePage(
          key: homePageState,
          newMessageCallBack: (String ?type) {

            if (type == "eventmessenger") {
              print("event_message-----------------------------------------------step1");
              talkPage.currentState!.newMessage();
            }
          }),
      CampusTalkListPage(
        key: talkPage,
      ),
      Center(
        child: Text(
          'Create',
        ),
      ),
      LessonsListPage(),



      CommunityPage(
      )



     /* AppMenuPage(
          key: appMenuKey,
          prefs: prefs,
          newMessageCallBack: (String type) {
            if (type == "messenger") getCount();
            if (type == "eventmessenger") {
              getCount();
              talkPage.currentState.newMessage();
            }
          }),*/
    ];
  }
  void _toggleDraggableScrollableSheet() {



      if(isExpanded)
        {
         setState(() {
           isExpanded=false;
           drageScrollController.close();
         });
        }
      else
        {
          setState(() {
            isExpanded=true;
            drageScrollController.open();
          });
        }

  }
  void _onItemTapped(int index) {

    setState(() {
      isExpanded=false;
      drageScrollController.close();
    });
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      _showModalBottomSheet(context);
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      builder: (context) {
        return CreateNewBottomSheet(
          prefs: prefs,
          onClickCallback: (value) {
            if (value == 'room') {
              Navigator.pop(context);
              if (prefs!.getBool(Strings.isVerified) != null &&
                  prefs!.getBool(Strings.isVerified)!) {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => CreateRoomPage(
                              isEdit: false,
                            )))
                    .then((value2) {
                  if (value2 != null && value2 == Strings.success_code) {
                    setState(() {
                      if (_selectedIndex == 4) {
                        appMenuKey.currentState!.menuitemClick('room');
                      } else {
                        _selectedIndex = 4;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RoomsPage()));
                      }
                    });
                    // Future.delayed(Duration(milliseconds: 500),(){
                    //   Navigator.of(context).push(MaterialPageRoute(builder:(context)=> RoomsPage()));
                    // });
                  }
                });
              } else {
                ToastBuilder().showToast(
                    AppLocalizations.of(context)!.translate("only_verirfied"),
                    context,
                    HexColor(AppColors.information));
              }
            } else {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => PostCreatePage(
                            type: value,
                            prefs: prefs,
                        callBack: (){
                          homePageState.currentState!.refresh();
                        },
                          )))
                  .then((value) {
                if (value != null && value) {
                  if (_selectedIndex == 2) {
                    setState(() {
                      _selectedIndex = 0;
                    });
                    homePageState.currentState!.refresh();

                  } else {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  }
                }
              });
            }
          },
        );
        // return BottomSheetContent();
      },
    );
  }
  void updatePersonProfile(BuildContext context) async {
    final body = jsonEncode({"person_id": null});

    Calls().call(body, context, Config.PERSONAL_PROFILE).then((value) async {
      if (value != null) {
        if (this.mounted) {
          setState(() {
            var data = PersonalProfile.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              Persondata? row = data.rows;
              rows = row;
              DataSaveUtils().saveUserData(prefs, row);
            }
          });

          setState(() {});
        }
      } else {}
    }).catchError((onError) {
      print(onError.toString());

      ToastBuilder()
          .showToast(onError.toString(), context, HexColor(AppColors.failure));
    });
  }








  void followersCountApi(BuildContext context) async {
    final body = jsonEncode({
      "object_type": "person",
      "object_id": prefs!.getInt(Strings.userId),
    });
    Calls().call(body, context, Config.FOLLOWERS_COUNT).then((value) async {
      if (value != null) {
        var data = FollowersFollowingCountEntity.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          setState(() {
            followers = data.rows!.followersCount ?? 0;
            following = data.rows!.followingCount ?? 0;
            roomsCount = data.rows!.roomsCount ?? 0;
            postCount = data.rows!.postCount ?? 0;
          });
        } else {}
      } else {}
    }).catchError((onError) {});
  }

  void getNotificationCount() async {
    final body = jsonEncode({
      "personId": prefs!.getInt(Strings.userId),
    });
    Calls().call(body, context, Config.NOTIFICATION_COUNT).then((value) {
      var res = NotificationCountResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        if (res.rows != null) {
          if (this.mounted)
            setState(() {
              notificationCount = int.parse(res.rows!);
            });
        }
      } else {}
    }).catchError((onError) {
      print(onError);
    });
  }
  void fetchMenuListData() async {
    packageInfo = await PackageInfo.fromPlatform();
    var res = await rootBundle.loadString('assets/menulist_new.json');
    final Map? parsed = json.decode(res);
    setState(() {
      menuList = MenuListResponseNew.fromJson(parsed as Map<String, dynamic>).rows;
    });
    var data = jsonEncode({
      "owner_id": prefs!.getInt(Strings.userId),
      "owner_type": prefs!.getString(Strings.ownerType)
    });
    Calls().call(data, context, Config.GET_PROFILE_PROGRESS).then((value){
      var response  = ProfileCardResponse.fromJson(value);
      setState(() {
        progress = response.total;
      });
    });

  }
  // ignore: missing_return
  Future<bool> _onBackPressed() {
    if (_selectedIndex == 0)
      SystemNavigator.pop(animated: true);
    // Navigator.of(context).pop(true);
    else
      setState(() {
        _selectedIndex = 0;
      });
    return new Future(() => false);
  }

  bool isFirstTime=true;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    _panelHeightOpen = MediaQuery.of(context).size.height * .75;

    print("dashboard-------------------------------------");
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child:


        Scaffold(
            resizeToAvoidBottomInset: false,
            body:
            SlidingUpPanel(
              backdropEnabled: true,
              controller: drageScrollController,
              maxHeight: _panelHeightOpen,
              minHeight: isFirstTime ?_panelHeightClosedFirstTime:_panelHeightClosed,
              parallaxEnabled: true,
              parallaxOffset: .5,
              body:
              Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    _widgetOptions().elementAt(_selectedIndex)

                  ],
                ),

              panelBuilder: (sc) => _panel(sc),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),

              onPanelClosed: (){
                setState(() {
                  isExpanded=false;
                });
              },
              onPanelOpened: (){
                setState(() {
                  isExpanded=true;
                });
              },
              onPanelSlide: (double pos) => setState(() {
                if(isFirstTime)
                  setState(() {
                    isFirstTime=false;
                  });
                if(pos<0.1)
                {

                  setState(() {
                    isExpanded=false;
                  });
                }
                else
                {

                  setState(() {

                    isExpanded=true;
                  });
                }
              }),
            ),




            bottomNavigationBar: appBottomSelector(
              onItemTapped: _onItemTapped,
              currentIndex: _selectedIndex,
              chatCount: chatCount,
              key: bottomSelectorKey,
            )

        )




      ),
    );
  }
  Widget _panel(ScrollController sc) {
    List<Institutions> institutionList = [];
    SharedPreferences? prefs = locator<SharedPreferences>();
    int i = 0;
    Map<String, dynamic> map =
    json.decode(prefs.getString("basicData") ?? "");
    rows = Persondata.fromJson(map);
    if (rows != null) {
      if (i == 0) {
        i = 1;
        institutionList.clear();
        if (rows != null) {
          for (int i = 0; i < rows!.institutions!.length; i++) {
            if (institutionList.any((element) {
              return element.name == rows!.institutions![i].name;
            })) {
              Institutions institutions = institutionList.firstWhere((element) {
                return element.name == rows!.institutions![i].name;
              });
              var index = institutionList.indexOf(institutions);
              if (institutionList[index].role != rows!.institutions![i].role) {
                institutionList[index].role = institutionList[index].role! +
                    ', ' +
                    rows!.institutions![i].role!;
              }
            } else {
              institutionList.add(rows!.institutions![i]);
            }
          }
        }
      }
    }


    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child:  Padding(
          padding: const EdgeInsets.only(bottom:2.0),
          child: Card(
            elevation: 15,
            color: HexColor(AppColors.appColorBackground),
            margin: const EdgeInsets.only(
                bottom: 1, left: 0, right: 0, top: 0),
            clipBehavior: Clip.antiAlias,

            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: ListView.builder(
              shrinkWrap: true,
              controller: sc,
              itemCount: menuList!.length >0 ?menuList!.length+1:0,

              itemBuilder: (BuildContext context, int index){
                if(index== menuList!.length){
                  return packageInfo!=null?Container(
                    margin: EdgeInsets.only(top:16),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/appimages/logo.png',width: 30,height: 30,),
                          SizedBox(width: 8,),
                          Text("Version -"+packageInfo!.version+"(${packageInfo!.buildNumber})")
                        ],
                      ),
                    ),
                  ):Container();
                }else {



                  return
                    menuList![index].title=="position_0"?
                    InkWell(
                      onTap: (){
                        _toggleDraggableScrollableSheet();
                      },
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: HexColor(AppColors.appColorWhite),
                          height: 45,
                          child: new SizedBox(
                            height: 45.0,
                            width: 60,
                            child: new Center(
                                child:
                                isExpanded?

                                new RotatedBox(
                                  quarterTurns: isFirstTime?2:0,
                                  child:    Lottie.asset(
                                      'assets/drop.json',
                                      width: 60,
                                      height: 45,
                                      fit: BoxFit.fill

                                  ),
                                )
                                    :
                                new Container(
                                  width: 36,
                                  decoration: BoxDecoration(
                                    color: HexColor(
                                        AppColors.appColorBlack35),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20)),
                                  ),
                                  margin:
                                  new EdgeInsetsDirectional.only(
                                      start: 1.0, end: 1.0),
                                  height: 5.0,
                                )
                            ),
                          ),
                        ),
                      ),
                    ):
                    menuList![index].title=="position_1"?
                    SizedBox(
                      width:
                      MediaQuery.of(context)
                          .size.width ,
                      height: 250,
                      child: Column(
                        children: [

                          Visibility(
                            visible: true,
                            child: Divider(
                              color: HexColor(AppColors.appColorBlack35),
                              height: 3,
                              thickness: 1,
                              indent: 1,
                              endIndent: 1,
                            ),
                          ),
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 240,
                                child: Image(
                                  height: 240,
                                  image: AssetImage(
                                      'assets/appimages/home_banner.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: SizedBox(
                                  width: MediaQuery.of(context)
                                      .size
                                      .width /
                                      2,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.translate("learn_together"),
                                          style: styleElements
                                              .headline5ThemeScalable(
                                              context)
                                              .copyWith(
                                              color: HexColor(
                                                  AppColors
                                                      .appColorWhite),
                                              fontWeight:
                                              FontWeight
                                                  .bold),
                                        ),
                                        Text(
                                            AppLocalizations.of(context)!.translate("lesson_desc_main"),
                                            style: styleElements
                                                .subtitle2ThemeScalable(
                                                context)
                                                .copyWith(
                                              color: HexColor(
                                                  AppColors
                                                      .appColorWhite),
                                            )),

                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ):

                    menuList![index].title=="position_2"?

                    appCard(
                      padding: EdgeInsets.all(2),
                      // margin: const EdgeInsets.only(
                      //     left: 12.0, right: 12.0, top: 8.0, bottom: 4.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: UserNameWithImageCard(
                                personData: rows,
                                clicked: null,
                                showQr: true,
                                instId:
                                prefs!=null? prefs.getInt(Strings.instituteId).toString():"",
                                title: prefs!=null?prefs.getString(Strings.userName)??"--":"",
                                isUserVerified:
                                rows != null ? rows!.isVerified : false,
                                ownerTye: prefs != null
                                    ? prefs.getString("ownerType")
                                    : "",
                                userType: 'person',
                                userId:
                                prefs != null ? prefs.getInt("userId") : null,
                                thirdPersonId: prefs!=null?prefs.getInt(Strings.userId):0,
                                subtitle: rows != null ? rows!.userName ?? "" : "",
                                isFollow: false,
                                isPersonProfile: true,
                                showProgress: true,
                                progress: progress!=null ? progress:0,
                                onClickProfile: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserProfileCards(
                                            userType: 'person',
                                            userId: rows!.id,
                                            callback: () {},
                                            currentPosition: 1,
                                            type: null,
                                          )));
                                },
                                imageUrl: Utility().getUrlForImage(
                                    prefs!=null?  prefs.getString(Strings.profileImage):"",
                                    RESOLUTION_TYPE.R64,
                                    SERVICE_TYPE.PERSON),
                                imagePath: null,
                                callbackPicker: () {
                                  updatePersonProfile(context);
                                }),
                          ),
                          Divider(
                            height: 0.5,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: MenuUserBalanceCard(),
                            // UserPopularityCard(
                            //   userId: prefs.getInt(Strings.userId),
                            //   userType: 'person',
                            //   instituteId:
                            //   prefs.getInt(Strings.instituteId).toString(),
                            //   imageurl: Utility().getUrlForImage(
                            //       prefs.getString(Strings.profileImage),
                            //       RESOLUTION_TYPE.R64,
                            //       SERVICE_TYPE.PERSON),
                            //   userName: prefs.getString(Strings.userName),
                            //   textFive: followers.toString(),
                            //   textSix: following.toString(),
                            //   textSeven: postCount.toString(),
                            //   textEight: roomsCount.toString(),
                            //   textOne: "followers",
                            //   textTwo: "following",
                            //   textThree: "posts",
                            //   textFour: "rooms",
                            //   ownerId: prefs.getInt(Strings.userId),
                            //   ownerType: 'person',
                            //   callback: () {
                            //     followersCountApi(context);
                            //   },
                            // ),
                          ),
                          Divider(
                            height: 0.5,
                          ),
                          appCard(
                            margin: EdgeInsets.only(
                                left: 8, right: 8.0, top: 4.0, bottom: 6.0),
                            padding: EdgeInsets.all(0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: seeMore
                                      ? institutionList.length
                                      : institutionList.length > 0
                                      ? institutionList.length > 1
                                      ? 1
                                      : institutionList.length
                                      : 0,
                                  itemBuilder: (BuildContext context, int index) {
                                    return appUserListTile(
                                      onPressed: (){
                                        print(
                                            institutionList[index].toJson().toString());


                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => UserProfileCards(
                                                  userType: 'business',
                                                  userId: institutionList[index].id,
                                                  callback: () {},
                                                  currentPosition: 1,
                                                  type: null,
                                                )));

                                      },
                                      imageUrl:  Config.BASE_URL +
                                          (institutionList[index] != null &&
                                              institutionList[index]
                                                  .profileImage !=
                                                  null
                                              ? institutionList[index].profileImage!
                                              : ""),
                                      service_type: SERVICE_TYPE.INSTITUTION,
                                      title:  institutionList[index].name,
                                      subtitle1:  institutionList[index].role,

                                    );

                                  },
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ):
                        // menuList![index].title=="position_3"?
                    //
                    //
                    // appCard(
                    //   margin: EdgeInsets.only(
                    //       left: 8, right: 8.0, top: 4.0, bottom: 6.0),
                    //   padding: EdgeInsets.only(top:12,bottom: 12),
                    //   child: ListView.builder(
                    //     shrinkWrap: true,
                    //     itemCount:institutionList.length,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       return ListTile(
                    //         onTap: (){
                    //           print(
                    //               institutionList[index].toJson().toString());
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => UserProfileCards(
                    //                     userType: 'business',
                    //                     userId: institutionList[index].id,
                    //                     callback: () {},
                    //                     currentPosition: 1,
                    //                     type: null,
                    //                   )));
                    //         },
                    //         leading: appAvatar(
                    //           imageUrl:  Config.BASE_URL +
                    //               (institutionList[index] != null &&
                    //                   institutionList[index]
                    //                       .profileImage !=
                    //                       null
                    //                   ? institutionList[index].profileImage!
                    //                   : ""),
                    //           service_type: SERVICE_TYPE.INSTITUTION,
                    //           resolution_type: RESOLUTION_TYPE.R64,
                    //         ),
                    //         title:  Text(institutionList[index].name!,style: styleElements.subtitle1ThemeScalable(context),),
                    //       );
                    //     },
                    //   ),
                    // )
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 12),
                          child: Text(menuList![index].title!,
                            style: styleElements.subtitle1ThemeScalable(
                                context).copyWith(
                                fontWeight: FontWeight.bold
                            ),),
                        ),
                        GridView.builder(
                          itemCount: menuList![index].data!.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int indx) {
                            return appMenuItem(
                              onMenuItemClick: menuitemClick,
                              item: menuList![index].data![indx],
                            );
                          },
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                              crossAxisCount: 2, height: 100),
                        ),
                      ],
                    );
                }
              },

            ),
          ),
        ));
  }



  Widget blur() {
    return ClipRect(
      // <-- clips to the 200x200 [Container] below
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2.0,
          sigmaY: 2.0,
        ),
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 2,
          height: 300.0,
          child: Container(
            color: HexColor(AppColors.appColorWhite).withOpacity(0.5),
          ),
        ),
      ),
    );
  }


}
