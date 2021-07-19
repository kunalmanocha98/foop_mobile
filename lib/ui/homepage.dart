import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appbar_with_profile%20_image.dart';
import 'package:oho_works_app/enums/post_enums.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/event_bus/make_count_zero.dart';
import 'package:oho_works_app/event_bus/newMessageReceived.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/messenger_module/screens/chat_list_page.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/common_response.dart';
import 'package:oho_works_app/models/notification_count_response.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/models/sync_contacts.dart';
import 'package:oho_works_app/models/unread_messages_count.dart';
import 'package:oho_works_app/models/user_contacts.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:oho_works_app/search_module/globl_search_new.dart';
import 'package:oho_works_app/services/audio_socket_service.dart';
import 'package:oho_works_app/services/push_notification_service.dart';
import 'package:oho_works_app/services/share_data_service.dart';
import 'package:oho_works_app/tri_cycle_database/data_base_helper.dart';
import 'package:oho_works_app/ui/postModule/CampusNewsListPage.dart';
import 'package:oho_works_app/ui/postModule/assignments_page.dart';
import 'package:oho_works_app/ui/postModule/pollsListPage.dart';
import 'package:oho_works_app/ui/postModule/postListPage.dart';
import 'package:oho_works_app/ui/postModule/selectedPostListPage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/getcards.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'Notification/notification_page.dart';


class HomePage extends StatefulWidget {
  final Null Function(String) newMessageCallBack;
  @override
  HomePageState createState() => HomePageState(newMessageCallBack);

  HomePage({Key key ,this.newMessageCallBack}):super(key:key);
}
class HomePageState extends State<HomePage> with WidgetsBindingObserver{
  BuildContext context;
  TextStyleElements styleElements;
  int notificationCount=0;
  int chatCount=0;
  IO.Socket socket;
  int personId;
  Null Function(String) newMessageCallBack;
  String personType;
  String profileImage;
  bool isLoading = true;
  bool isPostsLoading = true;
  int totalPostToExclude = 0;
  Persondata persondata;
  AudioSocketService audioSocketService = locator<AudioSocketService>();
  HomePageState(this.newMessageCallBack);
  // bool _hasPermission;
  SharedPreferences prefs;
  var list = [];
  final dbHelper = DatabaseHelper.instance;
  bool isNotUploading = false;
  final PushNotificationService pushNotificationService = locator<PushNotificationService>();
  final SharedDataService sharedDataService = locator<SharedDataService>();

  ProgressDialog pr;
  List<StatelessWidget> listData = [];
  List<CommonCardData> listCards = [];
  EventBus eventBus = locator<EventBus>();
  GlobalKey<PostListState> postListKey = GlobalKey();


  void setSharedPreferences() async {
    Utility().refreshList(context);
    _askPermissions();
    getListContacts();

    prefs = await SharedPreferences.getInstance();
    getCount();
    print("fcm============================================" +
        prefs.getString("fcmId"));
    if(prefs.getString("ownerType")!=null && prefs.getInt("userId")!=null)
    {
      personId=prefs.getInt("userId");
      personType=prefs.getString("ownerType");
      getUserData(context);
      getNotificationCount();
    }
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        refresh();
        print("Resumed--------------------------");
        break;
      case AppLifecycleState.inactive:
        print("inactive--------------------------");
      // widget is inactive
        break;
      case AppLifecycleState.paused:
        print("paused--------------------------");
      // widget is paused
        break;
      case AppLifecycleState.detached:
        print("detached--------------------------");
      // widget is detached
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  void initState() {
    super.initState();
    pushNotificationService.initialise(
        callback: () {
          getNotificationCount();
        },
        callbackMessenger: (String type) {

          if (type == "messenger") getCount();
          if (type == "eventmessenger") {
            getCount();
            widget.newMessageCallBack(type);
          }


        },
        context: context);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => setSharedPreferences());
    eventBus.on<NewMessage>().listen((event) {
      print("messsafggeeee=======================================");
      getCount();
    });
    eventBus.on<MakeCountZero>().listen((event) {
      print("messsafggeeee=======================================");
      getCount();
    });
    Utility().refreshList(context);
  }

  void getNotificationCount() async {
    final body = jsonEncode({
      "personId": personId,
    });
    Calls().call(body, context, Config.NOTIFICATION_COUNT).then((value) {
      var res = NotificationCountResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        if (res.rows != null) {
          if (this.mounted)
            setState(() {
              print(int.parse(res.rows).toString()+"====================================================================================");
              notificationCount = int.parse(res.rows);
            });
        }
      } else {}
    }).catchError((onError) {
      print(onError);
    });
  }
  void getCount() async {
    GetUnreadCount unreadCount = GetUnreadCount();

    unreadCount.conversationOwnerId = prefs.getInt(Strings.userId).toString();
    unreadCount.conversationOwnerType = "person";
    Calls()
        .call(
        jsonEncode(unreadCount), context, Config.CHAT_MESSAGES_UNREAD_COUNT)
        .then((value) async {
      if (value != null) {
        var res = NotificationCountResponse.fromJson(value);
        print(value.toString());
        setState(() {
          chatCount = res.total;
        });
        //delete messages
      }
    }).catchError((onError) {});
  }
  void getUserData(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    final body = jsonEncode({
      "owner_type": personType,
      "owner_id": personId,
    });
    Calls().call(body, context, Config.HOME_PAGE_CARDS).then((value) async {
      if (value != null) {
        isLoading = false;
        listData = [];
        if (this.mounted) {
          setState(() {
            var d = BaseResponses.fromJson(value);
            totalPostToExclude = d.total;
            if (d != null && d.statusCode == 'S10001') {
              if (d.rows != null) {
                listCards = d.rows;
                if (listCards != null && listCards.length > 0) {
                  for (var item in listCards) {
                    if (item != null) {
                      var widget = GetAllCards().getCardHome(
                          null,
                          null,
                          true,
                          null,
                          item,
                          null,
                          prefs.getString(Strings.personType),
                          null,
                          personType,
                          personId, callBck: () {
                        getUserData(context);
                      });
                      if (widget != null) listData.add(widget);
                    }
                  }
                }
              }
            }
          });
        }
      } else {
        isLoading = false;
        isPostsLoading = false;
      }
    }).catchError((onError) {
      isLoading = false;
      isPostsLoading = false;
      setState(() {});
      print(onError.toString());
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    print("homePage______________________________________");
    pr = ToastBuilder().setProgressDialog(context);
    styleElements = TextStyleElements(context);
    this.context = context;
    return Scaffold(
        appBar: AppBarWithProfileNew(
          centerTitle: false,
          isNotificationVisible: true,
          callBack: () {
            getNotificationCount();
            // getPersonProfile(context, true);
          },
          imageUrl: Utility().getUrlForImage(
              prefs != null ? prefs.getString(Strings.profileImage) : "",
              RESOLUTION_TYPE.R64,
              SERVICE_TYPE.PERSON),
          title: AppLocalizations.of(context).translate('campus_feed'),
          notificationCount: notificationCount,
          actions: [
            InkWell(
              onTap: ()async{
                Navigator.of(context)
                    .push(MaterialPageRoute(
                    builder: (context) =>  ChatListsPage(
                      conversationId: " ",
                      homePageUnreadCount: (){
                        getCount();
                      },
                    )));
              },
              child: Visibility(
                visible: true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0,right: 16.0),
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        Container(

                          child:  Icon(
                              Icons.message_outlined,
                              size: 32.0,
                              color: HexColor(AppColors.appColorBlack65),
                            ),

                        ),
                        Visibility(
                          visible: chatCount != null &&
                              chatCount != 0,
                          child: new Positioned(
                            right: 0.5,
                            top: 0.5,
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
                                  chatCount!=null?chatCount.toString() ?? "":"0",
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
            ),
            InkWell(
              onTap: ()async{
                Navigator.of(context)
                    .push(MaterialPageRoute(
                    builder: (context) => GlobalSearchNew()));
              },
              child: Visibility(
                visible: true,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16,top: 14),
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        Container(

                          child:  Icon(
                              Icons.search,
                              size: 32.0,
                              color: HexColor(AppColors.appColorBlack65),

                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: ()async{
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
              child: Visibility(
                visible: true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        Container(

                          child: Icon(
                            Icons.notifications_none_outlined,
                            size: 30.0,
                            color: HexColor(AppColors.appColorBlack65),
                          ),
                        ),
                        Visibility(
                          visible: notificationCount != null &&
                              notificationCount != 0,
                          child: new Positioned(
                            right: 1,
                            top: 1,
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
            ),
            simplePopup()
          ],
        ),
        body : NestedScrollView(
          physics: NeverScrollableScrollPhysics(),
            headerSliverBuilder: (context, value) {
              return [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context , int index){
                        if(index+1 == listData.length && isPostsLoading == true){
                        callPosts();
                      }
                        return listData[index];
                      },
                    childCount: listData.length
                  ),
                )
              ];
            },
            body:  Container(
              child: !isPostsLoading?PostListPage(
                key: postListKey,
                isFromProfile: false,
                isOthersPostList: false,
                excludeRecordsNumber: totalPostToExclude,
              ):CustomPaginator(context).loadingWidgetMaker(),
            )

        ));
  }
  Widget simplePopup() {
    // var name = headerData.title;
    return PopupMenuButton(
      icon: Icon(
        Icons.segment,
        size: 32,
        color: HexColor(AppColors.appColorBlack85),
      ),
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: HexColor(AppColors.appColorBackground),
      itemBuilder: (context) => PostListMenu(context: context).menuList,
      onSelected: (value) {
        switch (value) {
          case 'notice':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    callBack: (){refresh();},
                    appBarTitle: AppLocalizations.of(context)
                        .translate('notice_board'),
                    postRecipientStatus:
                    POST_RECIPIENT_STATUS.UNREAD.status,
                    postType: POST_TYPE.NOTICE.status,
                  )));
              break;
            }
          case 'bookmark':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    isBookMarked: true,
                    callBack: (){refresh();},
                    appBarTitle: AppLocalizations.of(context)
                        .translate('bookmarked_posts'),
                    postRecipientStatus:
                    POST_RECIPIENT_STATUS.UNREAD.status,
                  )));
              break;
            }
          case 'news':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CampusNewsListPage()));
              break;
            }
          case 'blog':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    callBack: (){refresh();},
                    appBarTitle:
                    AppLocalizations.of(context).translate('article'),
                    postRecipientStatus:
                    POST_RECIPIENT_STATUS.UNREAD.status,
                    postType: POST_TYPE.BLOG.status,
                  )));
              break;
            }
          case 'assignment':
            {

              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return AssignmentPage();
                  }
              ));
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => SelectedFeedListPage(
              //       isFromProfile: false,
              //       appBarTitle:
              //       AppLocalizations.of(context).translate('assignment'),
              //       postRecipientStatus:
              //       POST_RECIPIENT_STATUS.UNREAD.status,
              //       postType: POST_TYPE.ASSIGNMENT.status,
              //     )));
              break;
            }
          case 'qa':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    callBack: (){refresh();},
                    appBarTitle: AppLocalizations.of(context)
                        .translate('ask_expert'),
                    postRecipientStatus:
                    POST_RECIPIENT_STATUS.UNREAD.status,
                    postType: POST_TYPE.QNA.status,
                  )));
              break;
            }
          case 'poll':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PollsListPage(
                    prefs: prefs,
                    callBack: (){refresh();},
                  )));
              break;
            }
          case 'old':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    appBarTitle: 'Older Posts',
                    callBack: (){refresh();},
                    postRecipientStatus: POST_RECIPIENT_STATUS.READ.status,
                  )));
              break;
            }
          case 'general':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    callBack: (){refresh();},
                    appBarTitle:
                    AppLocalizations.of(context).translate('general'),
                    postRecipientStatus: POST_RECIPIENT_STATUS.READ.status,
                  )));
              break;
            }
          default:
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    callBack: (){refresh();},
                    appBarTitle:
                    AppLocalizations.of(context).translate('notice'),
                    postRecipientStatus:
                    POST_RECIPIENT_STATUS.UNREAD.status,
                    postType: POST_TYPE.NOTICE.status,
                  )));
              break;
            }
        }
      },
    );
  }


  void getListContacts() async {
    list = await dbHelper.getContacts();
    if (list.isNotEmpty && !isNotUploading) {
      uploadContacts(list);
    }
  }

  void uploadContacts(List<UserContact> list) async {
    if (this.mounted)
      setState(() {
        isNotUploading = true;
      });
    List<SyncContactsEntity> payload = [];
    for (var item in list) {
      CommunicationDetails dataMain = CommunicationDetails();
      List<CommunicationDetails> communicationDetail = [];
      SyncContactsEntity syncContactsEntity = SyncContactsEntity();
      dataMain.communicationDetail = item.mobileNumber;
      dataMain.communicationMedium = "mobile";
      dataMain.communicationType = "person";
      if (item.email != null && item.email != "") {
        CommunicationDetails dataEmail = CommunicationDetails();
        dataEmail.communicationDetail = item.email;
        dataEmail.communicationMedium = "email";
        dataEmail.communicationType = "person";
        communicationDetail.add(dataEmail);
      }
      communicationDetail.add(dataMain);
      syncContactsEntity.communicationDetails = communicationDetail;
      syncContactsEntity.contactNickName = item.name ?? "";
      syncContactsEntity.contactFirstName = item.firstName ?? "";
      syncContactsEntity.contactLastName = item.lastName ?? "";
      syncContactsEntity.addressBookOwnerId = prefs.getInt("userId").toString();
      syncContactsEntity.addressBookOwnerType = "person";
      syncContactsEntity.contactAddMethod = "";
      syncContactsEntity.contactAddressLine01 = "";
      syncContactsEntity.contactAddressLine02 = "";
      syncContactsEntity.contactAddressLine03 = "";
      syncContactsEntity.contactCity = "";
      syncContactsEntity.contactCountry = "";
      syncContactsEntity.contactGender = "";
      syncContactsEntity.contactMiddleName = "";
      syncContactsEntity.contactReferenceId = "";
      syncContactsEntity.contactState = "";
      syncContactsEntity.contactOrganization = "";
      syncContactsEntity.contactTitle = "";
      payload.add(syncContactsEntity);
    }
    var data = jsonEncode(payload);

    var value = await Calls().call(data, context, Config.SYNC_CONTACT);
    var dd = CommonBasicResponse.fromJson(value);
    if (this.mounted)
      setState(() {
        isNotUploading = false;
      });
    if (dd.statusCode == Strings.success_code) {
      for (var i = 0; i < list.length; i++) {
        var user = list[i];
        user.isSync = 1;
        _updateSync(user);
        if (i == list.length - 1) {
          getListContacts();
        }
      }
    }
  }


  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus;
    if (permissionStatus != PermissionStatus.granted) {
      try {
        permissionStatus = await _getContactPermission();
        if (permissionStatus != PermissionStatus.granted) {
        } else {
          getContacts();
        }
      } catch (e) {
        print(e.error);
      }
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    final status = await Permission.contacts.status;
    if (!status.isGranted) {
      final result = await Permission.contacts.request();
      return result ?? PermissionStatus.denied;
    } else {
      return status;
    }
  }


  void getAlreadySavedContact(UserContact row) async {
    UserContact data =
    await dbHelper.getContactUsingMobileNumber(row.mobileNumber);

    if (data != null) {
      if (data.name != null && (data.name != row.name)) {
        _updateName(row);
      } else if (data.name == null && data.mobileNumber == null) {
        _insert(row);
      }
    } else {
      _insert(row);
    }
  }

  void _insert(UserContact row) async {
    // row to insert
    row.isSelected = 0;
    await dbHelper.insertContacts(row);
  }

  void _updateName(UserContact row) async {
    // row to insert
    await dbHelper.update(row);
  }

  void _updateSync(UserContact row) async {
    // row to insert
    await dbHelper.updateSync(row);
  }

  Future<void> getContacts() async {
    // var i = 0;

    await Contacts.streamContacts(bufferSize: 200).forEach((contact) {
      var mob = "";

      if (contact.phones.toList().isNotEmpty) {
        mob = contact.phones.toList()[0].value.toString() ?? "";
        var row = UserContact();
        row.name = contact.displayName ?? "";
        row.firstName = contact.givenName ?? "";
        row.lastName = contact.familyName ?? "";
        if (contact.emails.toList().isNotEmpty)
          row.email = contact.emails.toList()[0].value.toString() ?? "";
        row.mobileNumber = mob;
        row.isSync = 0;
        getAlreadySavedContact(row);
      }
    });
  }

  void refresh() {

    print("refreshing -------------------------------");
    Future.microtask((){
      setState(() {
        listData.clear();
        listCards.clear();
        isLoading = true;
        isPostsLoading = true;
      });
    });
    getUserData(context);
    if(postListKey.currentState!=null)
    postListKey.currentState.refresh();
  }


  void callPosts() async{
    Future.delayed(Duration(seconds: 2),(){
      Future.microtask(() {
        setState(() {
          isPostsLoading = false;
        });
      });
    });

  }
}
