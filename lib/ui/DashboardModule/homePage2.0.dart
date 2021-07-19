import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appbar_with_profile%20_image.dart';
import 'package:oho_works_app/enums/post_enums.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/common_response.dart';
import 'package:oho_works_app/models/notification_count_response.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/models/sync_contacts.dart';
import 'package:oho_works_app/models/user_contacts.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:oho_works_app/services/audio_socket_service.dart';
import 'package:oho_works_app/services/push_notification_service.dart';
import 'package:oho_works_app/tri_cycle_database/data_base_helper.dart';
import 'package:oho_works_app/ui/postModule/CampusNewsListPage.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;


class HomePage2 extends StatefulWidget {
  final Null Function(String) newMessageCallBack;
  @override
  _HomePage2 createState() => _HomePage2(newMessageCallBack);

  HomePage2({this.newMessageCallBack});
}
class _HomePage2 extends State<HomePage2> {
  BuildContext context;
  TextStyleElements styleElements;
  int notificationCount;
  IO.Socket socket;
  int personId;
  Null Function(String) newMessageCallBack;
  String personType;
  String profileImage;
  bool isLoading = true;
  int totalPostToExclude = 0;
  Persondata persondata;
  AudioSocketService audioSocketService = locator<AudioSocketService>();

  _HomePage2(this.newMessageCallBack);

  // bool _hasPermission;
  SharedPreferences prefs;
  var list = [];
  final dbHelper = DatabaseHelper.instance;

  bool isNotUploading = false;

  ProgressDialog pr;
  List<StatelessWidget> listData = [];
  List<CommonCardData> listCards = [];

  GlobalKey<PostListState> postListKey = GlobalKey();


  void setSharedPreferences() async {
    Utility().refreshList(context);
    _askPermissions();
    getListContacts();

    prefs = await SharedPreferences.getInstance();
    print("fcm============================================" +
        prefs.getString("fcmId"));
    if(prefs.getString("ownerType")!=null && prefs.getInt("userId")!=null)
    {
      personId=prefs.getInt("userId");
      personType=prefs.getString("ownerType");
      getUserData(context);
      // getPersonProfile(context, false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setSharedPreferences());
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
              notificationCount = int.parse(res.rows);
            });
        }
      } else {}
    }).catchError((onError) {
      print(onError);
    });
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
      }
    }).catchError((onError) {
      isLoading = false;
      setState(() {});
      print(onError.toString());
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
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
        title: AppLocalizations.of(context).translate('app_name'),
        notificationCount: notificationCount,
      ),

    body : NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate("welcome_name") +
                                    " " +
                                    (prefs != null
                                        ? prefs.getString(
                                        Strings.firstName) ??
                                        ""
                                        : "") ??
                                    " ",
                                style: styleElements
                                    .headline6ThemeScalable(context)
                                    .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                    HexColor(AppColors.appColorBlack85)),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate("have_nice_day"),
                                style:
                                styleElements.subtitle2ThemeScalable(context),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                  simplePopup()
                      ],
                    ),
                  ),
                ),

            SliverToBoxAdapter(
              child: ListView.builder(
                  itemCount: listData.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return listData[index];
                  }),
            )
          ];
        },
        body:  Container(
          child: !isLoading?PostListPage(
            key: postListKey,
            isFromProfile: false,
            isOthersPostList: false,
            excludeRecordsNumber: totalPostToExclude,
          ):null,
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
                    appBarTitle:
                    AppLocalizations.of(context).translate('article'),
                    postRecipientStatus:
                    POST_RECIPIENT_STATUS.UNREAD.status,
                    postType: POST_TYPE.BLOG.status,
                  )));
              break;
            }
          case 'qa':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
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
                  )));
              break;
            }
          case 'old':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    appBarTitle: 'Older Posts',
                    postRecipientStatus: POST_RECIPIENT_STATUS.READ.status,
                  )));
              break;
            }
          case 'general':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
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
}
