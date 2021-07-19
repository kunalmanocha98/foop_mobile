import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/api_calls/logout_api.dart';
import 'package:oho_works_app/components/appbar_with_profile%20_image.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/customgridDelegate.dart';
import 'package:oho_works_app/components/tricycle_user_list_tile.dart';
import 'package:oho_works_app/components/tricyclemenuitem.dart';
import 'package:oho_works_app/enums/post_enums.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/home/home.dart';
import 'package:oho_works_app/home/locator.dart';
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
import 'package:oho_works_app/services/push_notification_service.dart';
import 'package:oho_works_app/services/share_data_service.dart';
import 'package:oho_works_app/tri_cycle_database/data_base_helper.dart';
import 'package:oho_works_app/ui/EdufluencerTutorModule/become_edufluencer_tutor_page.dart';
import 'package:oho_works_app/ui/EdufluencerTutorModule/edufluencer_tutor_list.dart';
import 'package:oho_works_app/ui/RoomModule/roomsPage.dart';
import 'package:oho_works_app/ui/dialogs/logout_dialog.dart';
import 'package:oho_works_app/ui/postModule/CampusNewsListPage.dart';
import 'package:oho_works_app/ui/postModule/pollsListPage.dart';
import 'package:oho_works_app/ui/postModule/selectedPostListPage.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BuddyApproval/buddyservicePage.dart';
import 'CalenderModule/calender_list_page.dart';
import 'CouponsModule/couponsPage.dart';
import 'LearningModule/lessons_list_page.dart';
import 'Notification/notification_page.dart';
import 'invitations/invitation_page.dart';
import 'menu_user_popularity_card.dart';

// ignore: must_be_immutable
class AppMenuPage extends StatefulWidget {
  SharedPreferences prefs;
  final Null Function(String) newMessageCallBack;
  AppMenuPage({Key key, this.prefs,this.newMessageCallBack}) : super(key: key);

  @override
  AppMenuPageState createState() => AppMenuPageState(prefs: prefs);
}

class AppMenuPageState extends State<AppMenuPage> {
  TextStyleElements styleElements;
  bool isLoading = false;
  Persondata rows;
  var followers = 0;
  var following = 0;
  var roomsCount = 0;
  var postCount = 0;

  final SharedDataService sharedDataService = locator<SharedDataService>();

  bool cb1 = false, cb2 = false;
  List<MenuListItemNew> menuList = [];
  int selectedRadio;
  SharedPreferences prefs = locator<SharedPreferences>();
  List<Institutions> institutionList = [];
  int i = 0;
  bool seeMore = false;
  PackageInfo packageInfo;

  int notificationCount;
  final db = DatabaseHelper.instance;

  int progress;
  AppMenuPageState({this.prefs});

  @override
  void initState() {
    super.initState();
    sharedDataService.handleReceivedData(context);


    DataSaveUtils().getUserData(context, prefs);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getPersonProfile(context));
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    if (rows != null) {
      if (i == 0) {
        i = 1;
        institutionList.clear();
        if (rows != null) {
          for (int i = 0; i < rows.institutions.length; i++) {
            if (institutionList.any((element) {
              return element.name == rows.institutions[i].name;
            })) {
              Institutions institutions = institutionList.firstWhere((element) {
                return element.name == rows.institutions[i].name;
              });
              var index = institutionList.indexOf(institutions);
              if (institutionList[index].role != rows.institutions[i].role) {
                institutionList[index].role = institutionList[index].role +
                    ', ' +
                    rows.institutions[i].role;
              }
            } else {
              institutionList.add(rows.institutions[i]);
            }
          }
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBarWithOnlyTitle(
          title: 'Tricycle',
          actions: [



             Visibility(
                      visible: true,
                      child: Padding(
                        padding: const EdgeInsets.only(right:16.0),
                        child: Container(
                          child: Stack(
                            children: <Widget>[
                              IconButton(
                                onPressed: ()async{
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationsPage(
                                                callback:(){
                                                  getNotificationCount();
                                                },
                                              )));
                                },
                                icon: Icon(
                                  Icons.notifications_none_outlined,
                                  size: 30.0,
                                  color: HexColor(AppColors.appColorBlack65),
                                ),
                              ),
                              Visibility(
                                visible: notificationCount != null &&
                                    notificationCount != 0,
                                child: new Positioned(
                                  right: 8,
                                  top: 8,
                                  child: new Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: new BoxDecoration(
                                      color: HexColor(AppColors.appMainColor),
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Center(
                                      child: Text(
                                        notificationCount!=null?notificationCount.toString() ?? "":"0",
                                        style: TextStyle(
                                            color: HexColor(AppColors.appColorWhite),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

           /* IconButton(
                icon: Icon(
                  Icons.settings,
                  color: HexColor(AppColors.appColorBlack35),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BasicInfo(rows, () {
                            updatePersonProfile(context);
                          })));
                }),*/
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(top: 8),
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: TricycleCard(
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
                              title: prefs!=null?prefs.getString(Strings.userName):"",
                              isUserVerified:
                              rows != null ? rows.isVerified : false,
                              ownerTye: prefs != null
                                  ? prefs.getString("ownerType")
                                  : "",
                              userType: 'person',
                              userId:
                              prefs != null ? prefs.getInt("userId") : null,
                              thirdPersonId: prefs!=null?prefs.getInt(Strings.userId):0,
                              subtitle: rows != null ? rows.userName ?? "" : "",
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
                                          userId: rows.id,
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
                        )
                      ],
                    ),
                  ),
                ),
                // SliverToBoxAdapter(
                //   child: ProfileProgressCard(
                //     persondata: rows,
                //     ownerId: prefs!=null?prefs.getInt(Strings.userId):0,
                //     ownerType: prefs!=null?prefs.getString(Strings.ownerType):"",
                //     callback: (){
                //       updatePersonProfile(context);
                //     },
                //   ),
                // ),
                SliverToBoxAdapter(
                  child: TricycleCard(
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
                            return TricycleUserListTile(
                              onPressed: (){
                                print(
                                    institutionList[index].toJson().toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserProfileCards(
                                          userType: 'institution',
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
                                      ? institutionList[index].profileImage
                                      : ""),
                              service_type: SERVICE_TYPE.INSTITUTION,
                              title:  institutionList[index].name,
                              subtitle1:  institutionList[index].role,

                            );
                            // return ListTile(
                            //   onTap: () {
                            //
                            //   },
                            //   leading: TricycleAvatar(
                            //     size: 48,
                            //     isFullUrl: true,
                            //     imageUrl: Config.BASE_URL +
                            //         (institutionList[index] != null &&
                            //             institutionList[index]
                            //                 .profileImage !=
                            //                 null
                            //             ? institutionList[index].profileImage
                            //             : ""),
                            //   ),
                            //   title: Text(
                            //     institutionList[index].name,
                            //     style: styleElements
                            //         .subtitle1ThemeScalable(context),
                            //   ),
                            //   subtitle: Text(
                            //     institutionList[index].role,
                            //     style: styleElements
                            //         .subtitle2ThemeScalable(context),
                            //   ),
                            //   /* trailing: Radio(
                            //     value: 1,
                            //     groupValue: selectedRadio ,
                            //     onChanged: (int value) {
                            //       setState(() {
                            //         selectedRadio = value;
                            //       });
                            //     },
                            //   ),*/
                            // );
                          },
                        ),
                        Divider(
                          height: 1,
                          color: HexColor(AppColors.appColorBlack35),
                        ),
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    seeMore = !seeMore;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(seeMore ? 'See less' : 'See more',
                                      style: styleElements
                                          .captionThemeScalable(context)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body:ListView.builder(
              shrinkWrap: true,
              itemCount: menuList.length >0 ?menuList.length+1:0,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
                if(index== menuList.length){
                  return packageInfo!=null?Container(
                    margin: EdgeInsets.only(top:16),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/appimages/logo.png',width: 30,height: 30,),
                          SizedBox(width: 8,),
                          Text("Version -"+packageInfo.version+"(${packageInfo.buildNumber})")
                        ],
                      ),
                    ),
                  ):Container();
                }else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 12),
                        child: Text(menuList[index].title,
                          style: styleElements.subtitle1ThemeScalable(
                              context).copyWith(
                              fontWeight: FontWeight.bold
                          ),),
                      ),
                      GridView.builder(
                        itemCount: menuList[index].data.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int indx) {
                          return TricycleMenuItem(
                            onMenuItemClick: menuitemClick,
                            item: menuList[index].data[indx],
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

            )
          ),
        ),
      ),
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
              Persondata row = data.rows;
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

  void logout() async {
    setState(() {
      isLoading = true;
    });

    DeviceInfo deviceInfo = DeviceInfo();
    if (prefs.getString("DeviceInfo") != null) {
      Map<String, dynamic> map =
      json.decode(prefs.getString("DeviceInfo") ?? "");
      deviceInfo = DeviceInfo.fromJson(map);
    }
    if (prefs.getDouble("lat") != null)
      deviceInfo.gpsInfo = "Latitude :" +
          prefs.getDouble("lat").toString() +
          ", Longitude : " +
          prefs.getDouble("longi").toString();
    deviceInfo.fcmId = prefs.getString("fcmId");

    LogOutApi().logOut(context, jsonEncode(deviceInfo)).then((value) async {
      if (value != null) {
        await db.deleteConversations();
        await db.deleteMessages();
        await db.deleteParticipants();
        prefs = await SharedPreferences.getInstance();
        var data = CommonBasicResponse.fromJson(value);
        if (data.statusCode == Strings.success_code) {
          prefs.clear();
          prefs.setBool("isLogout", true);
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

  getPersonProfile(BuildContext context) async {
    fetchMenuListData();
    prefs ??= await SharedPreferences.getInstance();
    if (prefs.getString("basicData") != null) {
      Map<String, dynamic> map =
      json.decode(prefs.getString("basicData") ?? "");
      rows = Persondata.fromJson(map);
      followersCountApi(context);
    }
  }

  void followersCountApi(BuildContext context) async {
    final body = jsonEncode({
      "object_type": "person",
      "object_id": prefs.getInt(Strings.userId),
    });
    Calls().call(body, context, Config.FOLLOWERS_COUNT).then((value) async {
      if (value != null) {
        var data = FollowersFollowingCountEntity.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          setState(() {
            followers = data.rows.followersCount ?? 0;
            following = data.rows.followingCount ?? 0;
            roomsCount = data.rows.roomsCount ?? 0;
            postCount = data.rows.postCount ?? 0;
          });
        } else {}
      } else {}
    }).catchError((onError) {});
  }

  void menuitemClick(String code) {
    switch (code) {
      case 'parentalcontrol':
        {
          break;
        }
      case 'network':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NetworkPage(
                      id: prefs.getInt("userId"),
                      imageUrl: Utility().getUrlForImage(
                          prefs.getString(Strings.profileImage),
                          RESOLUTION_TYPE.R64,
                          prefs.getString("ownerType") == "institution"
                              ? SERVICE_TYPE.INSTITUTION
                              : SERVICE_TYPE.PERSON),
                      type: prefs.getString("ownerType") == "institution"
                          ? "institution"
                          : "person",
                      currentTab: 0,
                      pageTitle: prefs.getString(Strings.firstName),
                      callback: () {})));
          break;
        }
      case 'room':
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RoomsPage()));
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
                AppLocalizations.of(context).translate('notice_board'),
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
                AppLocalizations.of(context).translate('ask_expert'),
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
                AppLocalizations.of(context).translate('article'),
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
                appBarTitle: AppLocalizations.of(context)
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
      case 'learning':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LessonsListPage(),
                    // LearningListPage(),
              ));
          break;
        }
      case 'calender':
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CalenderPage(),
              ));
          break;
        }
      case 'events':
        {
          ToastBuilder().showToast('Coming soon', context, HexColor(AppColors.information));
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => EventList(),
          //     ));
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
  void getNotificationCount() async {
    final body = jsonEncode({
      "personId": prefs.getInt(Strings.userId),
    });
    Calls().call(body, context, Config.NOTIFICATION_COUNT).then((value) {
      var res = NotificationCountResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        if (res.rows != null) {
          if (this.mounted)
            setState(() {
              notificationCount = int.parse(res.rows);
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
    final Map parsed = json.decode(res);
    setState(() {
      menuList = MenuListResponseNew.fromJson(parsed).rows;
    });
    var data = jsonEncode({
      "owner_id": prefs.getInt(Strings.userId),
      "owner_type": prefs.getString(Strings.ownerType)
    });
    Calls().call(data, context, Config.GET_PROFILE_PROGRESS).then((value){
      var response  = ProfileCardResponse.fromJson(value);
      setState(() {
        progress = response.total;
      });
    });

  }
}
