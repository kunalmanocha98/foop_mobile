import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:GlobalUploadFilePkg/Enums/contexttype.dart';
import 'package:GlobalUploadFilePkg/Enums/ownertype.dart';
import 'package:GlobalUploadFilePkg/Enums/subcontexttype.dart';
import 'package:GlobalUploadFilePkg/Files/GlobalUploadFilePkg.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/components/tricycleemptywidget.dart';
import 'package:oho_works_app/enums/create_deeplink.dart';
import 'package:oho_works_app/enums/imageType.dart';
import 'package:oho_works_app/enums/ownerType.dart';
import 'package:oho_works_app/enums/share_item_type.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/models/followers_following_count.dart';
import 'package:oho_works_app/models/imageuploadrequestandresponse.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/profile_module/common_cards/images_see_more.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:oho_works_app/profile_module/common_cards/user_name_with_image_card.dart';
import 'package:oho_works_app/profile_module/common_cards/user_pipulaity_card.dart';
import 'package:oho_works_app/profile_module/pages/media%20_page.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/ui/LearningModule/lessons_list_page.dart';
import 'package:oho_works_app/ui/dashboardhomepage.dart';
import 'package:oho_works_app/ui/dialogs/invalid%20_profile_image_dialog.dart';
import 'package:oho_works_app/ui/postModule/selectedPostListPage.dart';
import 'package:oho_works_app/ui/testuserlist.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/datasave.dart';
import 'package:oho_works_app/utils/getcards.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/imagepickerAndCropper.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/RoomModule/roomsPage.dart';
import '../../ui/add_subject_select_screen.dart';
import '../../ui/settings.dart';
import 'edit_education.dart';
import 'edit_language-page.dart';
import 'expertise_classes.dart';
import 'facility_create.dart';

class UserProfileCards extends StatefulWidget {
  final String? type;
  final int currentPosition;
  final String? userType;
  final int? userId;
  final Null Function()? callback;
  final bool? isUserExist;
  final bool? isFromRegisration;
  final bool isFromAudioConf;
  final Function? audioOptionsCallback;
  final bool? isSwipeDisabled;

  const UserProfileCards({
    Key? key,
    required this.type,
    required this.userId,
    required this.userType,
    this.callback,
    this.isSwipeDisabled,
    this.isFromAudioConf= false,
    this.isFromRegisration,
    this.audioOptionsCallback,
    required this.currentPosition,
    this.isUserExist,
  }) : super(key: key);

  @override
  UserProfileCardsState createState() => UserProfileCardsState(type, currentPosition,
      userId, userType, callback, isUserExist, isFromRegisration,isFromAudioConf);
}

class UserProfileCardsState extends State<UserProfileCards> {
  final Null Function()? callback;
  String? userType;
  int? userId;
  String? type;
  bool? isFromRegisration;
  int? ownerId;
  String? subTitle;
  String? ownerType;
  bool? isPersonalProfile;
  int currentPosition;
  List<CustomTabMaker>? data;
  String? profileImage;
  bool isUserVerified = false;
  bool isFromAudioConf;

  String? profileImageFromPath;
  String? coverImage;
  String? coverPath;
  SharedPreferences? prefs;
  var followers = 0;
  var following = 0;
  var roomsCount = 0;
  var postCount = 0;
  var personId;
  bool isFollow = false;
  String? instituteId;
  bool? isUserExist;
  bool isAllowed = true;
  var pageTitle = "";

  TextStyleElements? styleElements;
  String? userName = "";

/*  Location location = new Location();*/
  ProgressDialog? pr;

/*  PermissionStatus _permissionGranted;
  LocationData _locationData;*/
  List<StatelessWidget> listCardsAbout = [];
  List<CommonCardData>? listCardData = [];
  List<CommonCardData>? listEducations = [];
  List<StatelessWidget> listCardsCommon = [];
  Persondata? rows;
  bool isLoading = false;
  bool isEmpty = false;

  @override
  void initState() {
    isPersonalProfile = userType == "person" ? true : false;
    setSharedPreferences();

    super.initState();
  }

  void addTabs() {
    data = [];
    data!.add(CustomTabMaker(
        statelessWidget: SelectedFeedListPage(
          appBarTitle: userName! + "'s Activity",
          isOthersPostList: true,
          isFromProfile: true,
          postOwnerTypeId: userId != null ? userId : ownerId,
          postOwnerType: userId != null
              ? userType == "institution"
              ? "institution"
              : "person"
              : ownerType,
        ),
        tabName: AppLocalizations.of(context)!.translate('timeline')));
    data!.add(CustomTabMaker(
        statelessWidget: AboutPage(
          type: "closed",
          rows: null,
          isLoading: isLoading,
          isAllowed: isAllowed,
          listCardsAbout: listCardsAbout,
          callBck: () {
            getUserData(context);
            setState(() {});
          },
        ),
        tabName: AppLocalizations.of(context)!.translate('about')));
    if (type == "education")
      data!.add(CustomTabMaker(
          statelessWidget: EducationPage(
              type: type,
              isEmpty: isEmpty,
              listCardsAbout: listCardsCommon,
              instituteId: instituteId,
              userType: userType,
              callBck: () {
                getEducations(context);
              }),
          tabName: AppLocalizations.of(context)!.translate('education')));
    else if (type == "work")
      data!.add(CustomTabMaker(
          statelessWidget: EducationPage(
              type: type,
              isEmpty: isEmpty,

              listCardsAbout: listCardsCommon,
              instituteId: instituteId,
              userType: userType,
              callBck: () {
                getWorkExperience(context);
              }),
          tabName: AppLocalizations.of(context)!.translate('work')));
    else if (type == "class") {
      data!.add(CustomTabMaker(
          statelessWidget: EducationPage(
              type: type,
              isEmpty: isEmpty,

              listCardsAbout: listCardsCommon,
              instituteId: instituteId,
              userType: userType,
              callBck: () {
                getDetailedClasses(context);
              }),
          tabName: AppLocalizations.of(context)!.translate('class')));
    } else if (type == "subject")
      data!.add(CustomTabMaker(
          statelessWidget: EducationPage(
              type: type,
              isEmpty: isEmpty,

              listCardsAbout: listCardsCommon,
              userType: userType,
              instituteId: instituteId,
              callBck: () {
                getDetailedSubjects(context);
              }),
          tabName: AppLocalizations.of(context)!.translate('subject')));
    else if (type == "language")
      data!.add(CustomTabMaker(
          statelessWidget: EducationPage(
              type: type,
              isEmpty: isEmpty,

              listCardsAbout: listCardsCommon,
              userType: userType,
              instituteId: instituteId,
              callBck: () {
                getLanguagesDetail(context, "language");
              }),
          tabName: AppLocalizations.of(context)!.translate('language')));
    else if (type == "skill")
      data!.add(CustomTabMaker(
          statelessWidget: EducationPage(
              type: type,
              isEmpty: isEmpty,

              listCardsAbout: listCardsCommon,
              userType: userType,
              instituteId: instituteId,
              callBck: () {
                getLanguagesDetail(context, "skill");
              }),
          tabName: AppLocalizations.of(context)!.translate('skill')));
    else if (type == "medium")
      data!.add(CustomTabMaker(
          statelessWidget: EducationPage(
              type: type,
              isEmpty: isEmpty,

              listCardsAbout: listCardsCommon,
              userType: userType,
              instituteId: instituteId,
              callBck: () {
                getMediums(context, type);
              }),
          tabName: AppLocalizations.of(context)!.translate('medium')));
    else if (type == "course")
      data!.add(CustomTabMaker(
          statelessWidget: EducationPage(
              type: type,
              isEmpty: isEmpty,

              listCardsAbout: listCardsCommon,
              instituteId: instituteId,
              userType: userType,
              callBck: () {
                getCourses(context, type);
              }),
          tabName: AppLocalizations.of(context)!.translate('courses')));
    else if (type == "department")
      data!.add(CustomTabMaker(
          statelessWidget: EducationPage(
              type: type,
              isEmpty: isEmpty,

              listCardsAbout: listCardsCommon,
              instituteId: instituteId,
              userType: userType,
              callBck: () {
                getCourses(context, type);
              }),
          tabName: AppLocalizations.of(context)!.translate('department')));
    else if (type == "club")
      data!.add(CustomTabMaker(
          statelessWidget: EducationPage(
              type: "club",
              isEmpty: isEmpty,

              listCardsAbout: listCardsCommon,
              instituteId: instituteId,
              userType: userType,
              callBck: () {
                getClubs(context, type);
              }),
          tabName: AppLocalizations.of(context)!.translate('club')));
    else if (type == "sports")
      data!.add(CustomTabMaker(
          statelessWidget: EducationPage(
              type: "sports",
              isEmpty: isEmpty,

              listCardsAbout: listCardsCommon,
              instituteId: instituteId,
              userType: userType,
              callBck: () {
                getSports(context, type);
              }),
          tabName: AppLocalizations.of(context)!.translate('sport')));
    else if (type == "learning")
      data!.add(CustomTabMaker(
        statelessWidget: LessonsListPage(
          headerVisible: false
        ),
        tabName: AppLocalizations.of(context)!.translate('learning')
      ));
    else if (type == "Campus & Facilities")
      data!.add(CustomTabMaker(
          statelessWidget: ImagesSeeMore(
            type: userType,
            instituteId: userId.toString(),
            isUserExist: isUserExist,
          ),
          tabName: type));
    else
      data!.add(CustomTabMaker(
          statelessWidget: MediaPage(
            userType: userType,
            instituteId: userId.toString(),
            userId: userId,
          ),
          tabName: AppLocalizations.of(context)!.translate('media')));
    data!.add(CustomTabMaker(
        statelessWidget: Container(),
        tabName: AppLocalizations.of(context)!.translate('more')));
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (userType == "person") {
      setState(() {
        if (prefs!.getString("coverImage") != null)
          coverImage =
              Config.BASE_URL + prefs!.getString("coverImage")!;
        if (prefs!.getString("profileImage") != null)
          profileImage =
              Config.BASE_URL + prefs!.getString("profileImage")!;
      });
    }

    ownerId = prefs!.getInt("userId");
    ownerType = prefs!.getString("ownerType");
    addTabs();
    styleElements = TextStyleElements(context);
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => userType == "thirdPerson"
        ? getThirdPersonInfo(context)
        : userType == "person"
        ? updatePersonProfile(context)
        : getInstituteData());

    //_getCurrentLocation();
  }

  void backPressed() {
    if (isFromRegisration != null && isFromRegisration!)
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => DashboardPage()),
              (Route<dynamic> route) => false);
    else
      Navigator.of(context).pop({'result': "update"});
  }

  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  final CreateDeeplink? createDeeplink = locator<CreateDeeplink>();
  BuildContext? sctx;

  Widget build(BuildContext context) {
    ScreenUtil.init;
    var dHeight = displayHeight(context) / 4;
    styleElements = TextStyleElements(context);
    if (userType == "person" && prefs != null) {
      if (prefs!.getString("coverImage") != null)
        coverImage =
            Config.BASE_URL + prefs!.getString("coverImage")!;
      if (prefs!.getString("profileImage") != null)
        profileImage =
            Config.BASE_URL + prefs!.getString("profileImage")!;
    }

    return WillPopScope(
      // ignore: missing_return
        onWillPop: () {
          backPressed();
          return new Future(() => false);
        } ,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: TricycleAppBar().getCustomAppBar(context,
                appBarTitle: "",
                titleWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image(width: 30,height: 30,image: AssetImage('assets/appimages/logo.png'),),
                    // SizedBox(width: 4,),
                    Flexible(
                      child: Text(
                        userName ??= "",
                        style: styleElements!
                            .headline6ThemeScalable(context)
                            .copyWith(
                            fontWeight: FontWeight.w600,
                            color: HexColor(AppColors.appColorBlack85),
                            fontSize: 24),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                centerTitle: false,
                actions: [
                  IconButton(
                      icon: Icon(Icons.share,
                          color: HexColor(AppColors.primaryTextColor65)),
                      onPressed: () {
                        getDeeplink();
                      }),
                  Visibility(
                    visible: widget.isFromAudioConf,
                    child: IconButton(
                        icon: Icon(Icons.more_vert,
                            color: HexColor(AppColors.primaryTextColor65)),
                        onPressed: widget.audioOptionsCallback as void Function()?
                    ),
                  ),
                ], onBackButtonPress: backPressed),
            body: new Builder(builder: (BuildContext context) {
              this.sctx = context;
              return new Stack(
                children: <Widget>[
                  NestedScrollView(
                      headerSliverBuilder: (context, value) {
                        return [
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                Visibility(
                                  visible: false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        backPressed();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          right: 30,
                                          top: 30,
                                        ),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Icon(
                                              Icons.keyboard_backspace_rounded,
                                              size: 20.h,
                                              color: HexColor(
                                                  AppColors.appColorWhite),
                                            )),
                                        decoration: BoxDecoration(
                                          color: HexColor(
                                              AppColors.appColorTransparent),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: /* userType == "person"*/ false,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: GestureDetector(
                                      onTap: _coverPicker,
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              top: 16, left: 16),
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              color: HexColor(
                                                  AppColors.appColorWhite),
                                              shape: BoxShape.circle),
                                          child: Icon(
                                            Icons.edit,
                                            color: HexColor(
                                                AppColors.appColorBlack65),
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Visibility(
                              child: Container(
                                height: dHeight,
                                margin: const EdgeInsets.only(
                                    right: 20, top: 20, bottom: 16),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      SizedBox(
                                        child: Visibility(
                                          visible: false,
                                          child: Opacity(
                                              opacity: 0.4,
                                              child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                RoomsPage()));
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: HexColor(
                                                              AppColors
                                                                  .appColorBlack),
                                                          shape:
                                                          BoxShape.circle),
                                                      margin:
                                                      const EdgeInsets.all(
                                                          8),
                                                      child: Container(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(4),
                                                        child: Icon(
                                                            Icons.message,
                                                            color: HexColor(
                                                                AppColors
                                                                    .appColorWhite)),
                                                      )))),
                                        ),
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: Opacity(
                                          opacity: 0.4,
                                          child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SettingsPage(),
                                                    ));
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: HexColor(AppColors
                                                          .appColorBlack),
                                                      shape: BoxShape.circle),
                                                  margin:
                                                  const EdgeInsets.all(8),
                                                  child: Container(
                                                    padding:
                                                    const EdgeInsets.all(4),
                                                    child: Icon(
                                                        Icons.favorite_border,
                                                        color: HexColor(AppColors
                                                            .appColorWhite)),
                                                  ))),
                                        ),
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: Opacity(
                                          opacity: 0.4,
                                          child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          TestUserList(),
                                                    ));
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: HexColor(AppColors
                                                          .appColorBlack),
                                                      shape: BoxShape.circle),
                                                  margin:
                                                  const EdgeInsets.all(8),
                                                  child: Container(
                                                    padding:
                                                    const EdgeInsets.all(4),
                                                    child: Icon(Icons.star,
                                                        color: HexColor(AppColors
                                                            .appColorWhite)),
                                                  ))),
                                        ),
                                      ),
                                      Opacity(
                                          opacity: 0.7,
                                          child: GestureDetector(
                                              onTap: () {
                                                getDeeplink();
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: HexColor(AppColors
                                                          .appColorBlack),
                                                      shape: BoxShape.circle),
                                                  margin:
                                                  const EdgeInsets.all(8),
                                                  child: Container(
                                                    padding:
                                                    const EdgeInsets.all(4),
                                                    child: Icon(Icons.share,
                                                        color: HexColor(AppColors
                                                            .appColorWhite)),
                                                  )))),
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color:
                                  HexColor(AppColors.appColorTransparent),
                                ),
                              ),
                              visible: false,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: TricycleCard(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 16.0, bottom: 16.0),
                                    child: UserNameWithImageCard(
                                        personData: rows,
                                        isFromProfile: true,
                                        instId: instituteId,
                                        title: userName,
                                        clicked: () {
                                          setState(() {
                                            if (isFollow)
                                              isFollow = false;
                                            else
                                              isFollow = true;
                                          });
                                        },
                                        ownerTye: prefs != null
                                            ? prefs!.getString("ownerType")
                                            : "",
                                        userType: userType,
                                        userId: prefs != null
                                            ? prefs!.getInt("userId")
                                            : null,
                                        thirdPersonId: userId,
                                        subtitle: subTitle,
                                        isUserVerified: isUserVerified,
                                        isFollow: isFollow,
                                        isPersonProfile: true,
                                        onClickProfile: userType == "person"
                                            ? _profilePicker
                                            : null,
                                        imageUrl: profileImage ?? "",
                                        imagePath: profileImageFromPath,
                                        callbackPicker: () {
                                          if (callback != null) callback!();

                                          if (userType == "person")
                                            updatePersonProfile(context);
                                          else if (userType == "thirdPerson")
                                            getThirdPersonInfo(context);
                                          else
                                            getInstituteData();
                                        }),
                                  ),
                                  Divider(
                                    height: 0.5,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                    child: UserPopularityCard(
                                      userId: userId,
                                      userType: userType,
                                      instituteId: instituteId,
                                      userName: userName,
                                      imageurl: profileImage,
                                      textFive: followers.toString(),
                                      textSix: following.toString(),
                                      textSeven: postCount.toString(),
                                      textEight: roomsCount.toString(),
                                      textOne: "followers",
                                      textTwo: "following",
                                      textThree: "posts",
                                      textFour: "rooms",
                                      ownerId: ownerId,
                                      ownerType: ownerType,
                                      callback: callback != null
                                          ? callback
                                          : () {
                                        followersCountApi(context);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ];
                      },
                      body: CustomTabView(
                        marginTop: const EdgeInsets.only(top: 0.0),
                        currentPosition: currentPosition,
                        itemCount:
                        data != null && data!.isNotEmpty ? data!.length : 0,
                        tabBuilder: (context, index) => Visibility(
                          visible: !isFromAudioConf,
                          child: TricycleTabButton(
                            onPressed: () {
                              setState(() {
                                if (index == 3) {
                                  _showModalBottomSheet(
                                      context, userType, userId, callback);
                                  currentPosition = currentPosition;
                                } else
                                  currentPosition = index;
                              });
                            },
                            tabName: data![index].tabName,
                            isActive: index == currentPosition,
                          ),
                        ),
                        pageBuilder: (context, index) =>
                            Center(child: data![index].statelessWidget),
                        onPositionChange: (index) {
                          setState(() {
                            currentPosition = index!;
                          });
                        },
                        onScroll: (position) => print('$position'),
                      )),
                ],
              );
            })));
  }

  void _showModalBottomSheet(BuildContext context, String? personType, int? id,
      final Null Function()? callback) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      builder: (context) {
        if (personType == "person" || personType == "thirdPerson")
          return BottomSheetContent(
              personType: personType,
              id: id,
              callback: (t) {
                setState(() {
                  type = t;
                  currentPosition = 2;
                  getCardWiseData();
                });
                Navigator.pop(context);
              });
        else
          return BottomSheetContentInstitute(
              personType: personType,
              id: id,
              callback: (t) {
                setState(() {
                  type = t;
                  currentPosition = 2;

                  getCardWiseData();
                });
                Navigator.pop(context);
              });
      },
    );
  }

  void getInstituteData() async {
    setState(() {
      personId = prefs!.getInt("userIdOriginal");
      profileImage = "";
      coverImage = "";

      instituteId = userId.toString();
    });

    followersCountApi(context);
    getUserData(context);
    getCardWiseData();
    /*     getPhotos(
          context,
          AppLocalizations.of(context)
              .translate("campus_facilities"));*/
  }

  void getPersonProfile() async {
    setState(() {
      if (userType == "person") userId = prefs!.getInt("userId");
      print(prefs!.getString("basicData"));
      if (prefs!.getString("basicData") != null) {
        Map<String, dynamic> map =
        json.decode(prefs!.getString("basicData") ?? "");
        rows = Persondata.fromJson(map);
      } else {
        updatePersonProfile(context);
      }
      profileImage = Config.BASE_URL + prefs!.getString("profileImage")!;
      coverImage = Config.BASE_URL + prefs!.getString("coverImage")!;
      personId = prefs!.getInt("userIdOriginal");
      userName = prefs!.getString("userName");
      instituteId = prefs!.getInt("instituteId").toString();
      ownerType = prefs!.getString("ownerType");
    });

    followersCountApi(context);
    getUserData(context);
    getCardWiseData();
  }

  void getDeeplink() async {
    createDeeplink!.getDeeplink(
        SHAREITEMTYPE.PROFILE.type,
        ownerId.toString(),
        userId,
        userType == "institution"
            ? DEEPLINKTYPE.INSTITUTION.type
            : DEEPLINKTYPE.PERSON.type,
        context);
  }

  void updatePersonProfile(BuildContext context) async {
    final body = jsonEncode({"person_id": null});

    Calls().call(body, context, Config.PERSONAL_PROFILE).then((value) async {
      if (value != null) {
        if (this.mounted) {
          setState(() {
            var data = PersonalProfile.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              Persondata? rows = data.rows;
              DataSaveUtils().saveUserData(prefs, rows);
            } else {
              setState(() {
                isAllowed = false;
              });
              ToastBuilder().showToast(
                  data.message ?? "", sctx, HexColor(AppColors.failure));
            }
            getPersonProfile();
          });
          setState(() {});
        }
      } else {}
    }).catchError((onError) {
      print(onError.toString());

      ToastBuilder().showSnackBar(
          "Something went wrong !!", sctx!, HexColor(AppColors.failure));
    });
  }

  void getThirdPersonInfo(BuildContext context) async {
    final body = jsonEncode({"person_id": userId});

    Calls().call(body, context, Config.PERSONAL_PROFILE).then((value) async {
      if (value != null) {
        // userProfileData = PersonalProfile.fromJson(value);
        if (this.mounted) {
          setState(() {
            var data = PersonalProfile.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              rows = data.rows;
              coverImage = Config.BASE_URL + rows!.coverImage!;
              profileImage = Config.BASE_URL + rows!.profileImage!;
              personId = data.rows!.id;
              userName = data.rows!.firstName ?? "";
              if (data.rows!.middleName != null)
                userName = userName! + " " + data.rows!.middleName!;
              if (data.rows!.lastName != null)
                userName = userName! + " " + data.rows!.lastName!;
              if (data.rows!.userLocation != null) {}

              if (data.rows!.institutions != null &&
                  data.rows!.institutions!.isNotEmpty ||
                  data.rows!.institutionId != null) {
                if (data.rows!.institutions!.isNotEmpty)
                  instituteId = data.rows!.institutions![0].id.toString();
                else {
                  instituteId = data.rows!.institutionId.toString();
                }

                followersCountApi(context);
                getUserData(context);
                getCardWiseData();
              }
            } else {
              setState(() {
                isAllowed = false;
              });

              ToastBuilder().showToast(
                  data.message ?? "", sctx, HexColor(AppColors.failure));
              Future.delayed(const Duration(milliseconds: 3000), () {
                Navigator.of(context).pop({'result': "update"});
              });
            }
          });
        }
      } else {}
    }).catchError((onError) {
      print(onError.toString());
      ToastBuilder().showToast(
          onError.toString(), sctx, HexColor(AppColors.information));
    });
  }

  void getCardWiseData() {
    if (type == "education")
      getEducations(context);
    else if (type == "work")
      getWorkExperience(context);
    else if (type == "class")
      getDetailedClasses(context);
    else if (type == "subject")
      getDetailedSubjects(context);
    else if (type == "language")
      getLanguagesDetail(context, "language");
    else if (type == "skill")
      getLanguagesDetail(context, "skill");
    else if (type == "medium")
      getMediums(context, "medium");
    else if (type == "course")
      getCourses(context, "courses");
    else if (type == "course")
      getDepartments(context, "departments");
    else if (type == "club")
      getClubs(context, "club");
    else if (type == "sports")
      getSports(context, "sports");
    else if(type == 'learning')
      setState(() {
        data![2] = CustomTabMaker(
            statelessWidget: LessonsListPage(
                headerVisible: false
            ),
            tabName: AppLocalizations.of(context)!.translate('learning')
        );
      });
    else if (type == "Campus & facilities") {
      setState(() {
        data![2] = CustomTabMaker(
            statelessWidget: ImagesSeeMore(
              type: userType,
              instituteId: userId.toString(),
              isUserExist: isUserExist,
            ),
            tabName: type);
      });
    }
  }

  void getUserData(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    final body = jsonEncode({
      "institution_id": instituteId,
      "person_id": userId,
      "detail_type": userType == "institution" ? "institution" : "user",
      "owner_id": ownerId
    });
    setState(() {
      listCardsCommon = [];
    });
    Calls().call(body, context, Config.USER_PROFILE).then((value) async {
      if (value != null) {
        listCardsAbout = [];

        if (this.mounted) {
          setState(() {
            isLoading = false;
            var d = BaseResponses.fromJson(value);
            if (d != null && d.statusCode == 'S10001') {
              if (d.rows != null) {
                listCardData = d.rows;
                if (listCardData != null && listCardData!.length > 0) {
                  for (var item in listCardData!) {
                    if (item != null) {
                      if (item != null && item.cardName == "profileNameCard") {
                        isFollow = item.isFollow2 ?? false;
                        if (userType == "institution") {
                          if (item.image != null)
                            profileImage =
                                Config.BASE_URL + item.image!;
                          if (item.coverImage != null)
                            coverImage =
                                Config.BASE_URL + item.coverImage!;
                          userName = item.name ?? "";
                          isFollow = item.isFollow2 ?? false;
                        } else {
                          subTitle = item.userName ?? "";
                          isUserVerified = item.isVerified ?? "" as bool;
                          rows!.userName = subTitle;
                        }
                      }
                      if(isFromAudioConf){
                        if(item.cardName == 'RatingAndReviewCard') {
                          var widget = GetAllCards().getCard(
                              userName,
                              instituteId,
                              true,
                              null,
                              item,
                              rows,
                              userType,
                              userId,
                              ownerType,
                              ownerId,
                              profileImage,
                              callBck: () {
                                getUserData(context);
                                if (userType == "person")
                                  updatePersonProfile(context);
                                else if (userType == "thirdPerson")
                                  getThirdPersonInfo(context);
                                else
                                  getInstituteData();
                              });
                          if (widget != null) listCardsAbout.add(widget as StatelessWidget);
                        }
                      }else{
                        var widget = GetAllCards().getCard(
                            userName,
                            instituteId,
                            true,
                            null,
                            item,
                            rows,
                            userType,
                            userId,
                            ownerType,
                            ownerId,
                            profileImage, callBck: () {
                          getUserData(context);
                          if (userType == "person")
                            updatePersonProfile(context);
                          else if (userType == "thirdPerson")
                            getThirdPersonInfo(context);
                          else
                            getInstituteData();
                        });
                        if (widget != null) listCardsAbout.add(widget as StatelessWidget);
                      }
                    }
                  }
                }
              }
            }
            data![1] = CustomTabMaker(
                statelessWidget: AboutPage(
                  type: "closed",
                  rows: null,
                  isLoading: isLoading,
                  isAllowed: isAllowed,

                  listCardsAbout: listCardsAbout,
                  callBck: () {
                    getUserData(context);
                    setState(() {});
                  },
                ),
                tabName: AppLocalizations.of(context)!.translate('about'));
          });
        }
      } else {
        setState(() {
          isLoading = true;
        });
      }
    }).catchError((onError) {
      setState(() {
        isLoading = true;
      });
      print(onError.toString());
      ToastBuilder().showToast(
          onError.toString(), sctx, HexColor(AppColors.information));
    });
  }

  void getEducations(BuildContext context) async {
    setState(() {
      data![2] = CustomTabMaker(
          statelessWidget: EducationPage(
              type: type,
              rows: null,
              isEmpty: isEmpty,
              userType: userType,

              instituteId: instituteId,
              listCardsAbout: [],
              callBck: () {
                getEducations(context);
              }),
          tabName: type);
    });

    final body = jsonEncode({
      "person_id": userId,
      "type": userType == "institution" ? "institution" : "person",
      "all_institutions_id": userType == "institution" ? userId : instituteId,
      "page_number": 1,
      "given_by_id": ownerId,
      "page_size": 100
    });
    setState(() {
      listCardsCommon = [];
    });
    Calls().call(body, context, Config.EDUCATIONS).then((value) async {
      if (value != null) {

        if (this.mounted) {
          setState(() {
            var d = BaseResponses.fromJson(value);
            if (d != null && d.statusCode == 'S10001') {
              if (d.rows != null && d.rows!.isNotEmpty) {
                listCardsCommon = [];
                listEducations = d.rows;
                if (listEducations != null && listEducations!.length > 0) {
                  for (var item in listEducations!) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(
                          userName,
                          instituteId,
                          false,
                          styleElements,
                          item,
                          rows,
                          userType,
                          userId,
                          ownerType,
                          ownerId,
                          profileImage, callBck: () {
                        getEducations(context);
                      });
                      if (widget != null) listCardsCommon.add(widget as StatelessWidget);
                    }
                  }
                } else
                  setState(() {
                    isEmpty = true;
                  });
              } else {
                setState(() {
                  isEmpty = true;
                });
              }

              setState(() {
                data![2] = CustomTabMaker(
                    statelessWidget: EducationPage(
                        type: type,
                        rows: null,
                        isEmpty: isEmpty,

                        instituteId: instituteId,
                        userType: userType,
                        listCardsAbout: listCardsCommon,
                        callBck: () {
                          getEducations(context);
                        }),
                    tabName:
                    AppLocalizations.of(context)!.translate('education'));
              });
            }
          });
        }
      } else {}
    }).catchError((onError) {
      print(onError.toString());
      ToastBuilder().showToast(
          onError.toString(), sctx, HexColor(AppColors.information));
    });
  }

  void getWorkExperience(BuildContext context) async {
    setState(() {
      data![2] = CustomTabMaker(
          statelessWidget: EducationPage(
              type: type,
              rows: null,
              isEmpty: isEmpty,

              instituteId: instituteId,
              userType: userType,
              listCardsAbout: [],
              callBck: () {
                getEducations(context);
              }),
          tabName: type);
    });
    final body = jsonEncode({
      "person_id": userId,
      "type": userType == "institution" ? "institution" : "person",
      "all_institutions_id": userType == "institution" ? userId : instituteId,
      "page_number": 1,
      "given_by_id": ownerId,
      "page_size": 100
    });
    setState(() {
      listCardsCommon = [];
    });
    Calls().call(body, context, Config.WORK_EXP).then((value) async {
      if (value != null) {
        if (this.mounted) {
          setState(() {
            var d = BaseResponses.fromJson(value);
            if (d != null && d.statusCode == 'S10001') {
              if (d.rows != null && d.rows!.isNotEmpty) {
                listEducations = d.rows;
                listCardsCommon = [];
                if (listEducations != null && listEducations!.length > 0) {
                  for (var item in listEducations!) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(
                          userName,
                          instituteId,
                          false,
                          styleElements,
                          item,
                          rows,
                          userType,
                          userId,
                          ownerType,
                          ownerId,
                          profileImage, callBck: () {
                        getWorkExperience(context);
                      });
                      if (widget != null) listCardsCommon.add(widget as StatelessWidget);
                    }
                  }
                } else
                  setState(() {
                    isEmpty = true;
                  });
              } else {
                setState(() {
                  isEmpty = true;
                });
              }
              setState(() {
                data![2] = CustomTabMaker(
                    statelessWidget: EducationPage(
                        type: type,
                        rows: null,
                        isEmpty: isEmpty,

                        instituteId: instituteId,
                        userType: userType,
                        listCardsAbout: listCardsCommon,
                        callBck: () {
                          getWorkExperience(context);
                        }),
                    tabName: AppLocalizations.of(context)!.translate('work'));
              });
            }
          });
        }
      } else {}
    }).catchError((onError) {
      print(onError.toString());
      ToastBuilder().showSnackBar(
          "Something went wrong !!", sctx!, HexColor(AppColors.information));
    });
  }

  _addPhoto() async {
    var pr = ToastBuilder()
        .setProgressDialogWithPercent(context, 'Uploading Image...');
    File pickedFile = await (ImagePickerAndCropperUtil().pickImage(context) as FutureOr<File>);
    var croppedFile =
    await ImagePickerAndCropperUtil().cropFile(context, pickedFile);
    if (croppedFile != null) {
      await pr.show();
      var contentType =
      ImagePickerAndCropperUtil().getMimeandContentType(croppedFile.path);
      await UploadFile(
          baseUrl: Config.BASE_URL,
          context: context,
          token: prefs!.getString("token"),
          contextId: instituteId,
          contextType: CONTEXTTYPE_ENUM.PROFILE.type,
          subContextType: SUBCONTEXTTYPE_ENUM.FACILITIES.type,
          ownerId: prefs!.getInt("userId").toString(),
          ownerType: OWNERTYPE_ENUM.PERSON.type,
          file: croppedFile,
          subContextId: "",
          onProgressCallback: (int value) {
            pr.update(progress: value.toDouble());
          },
          mimeType: contentType[1],
          contentType: contentType[0])
          .uploadFile()
          .then((value) async {
        var imageResponse = ImageUpdateResponse.fromJson(value);
        var url = imageResponse.rows!.otherUrls![0].original;
        print(url);
        await pr.hide();
        var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateFacilities(
                url: url,
                id: instituteId,
              ),
            ));
        if (result != null && result['result'] != null) {
          callback!();
        }
      }).catchError((onError) async {
        await pr.hide();
        print(onError.toString());
      });
    }
  }

  void getPhotos(BuildContext context, String type) async {
    setState(() {
      data![2] = CustomTabMaker(
          statelessWidget: EducationPage(
              type: "Campus & Facilities",
              rows: null,
              isUserExist: false,
              isEmpty: isEmpty,

              instituteId: instituteId,
              userType: userType,
              callBackCreate: () {
                _addPhoto();
              },
              listCardsAbout: [],
              callBck: () {
                getPhotos(context, "Campus & Facilities");
              }),
          tabName: AppLocalizations.of(context)!.translate('campus_facilities'));
    });
    final body = jsonEncode({
      "person_id": null,
      "type": "institution",
      "institution_id": userId,
      "page_number": 1,
      "given_by_id": ownerId,
      "page_size": 100
    });
    setState(() {
      listCardsCommon = [];
    });
    var isUserExist = false;
    Calls()
        .call(body, context, Config.CAMPUS_FACILITIES_SEE_MORE)
        .then((value) async {
      if (value != null) {
        if (this.mounted) {
          setState(() {
            var d = BaseResponses.fromJson(value);
            if (d != null && d.statusCode == 'S10001') {
              if (d.rows != null && d.rows!.isNotEmpty && d.total != 0) {
                listEducations = [];
                listEducations = d.rows;
                listCardsCommon = [];

                if (listEducations != null && listEducations!.length > 0) {
                  for (var item in listEducations!) {
                    if (item != null) {
                      if (item.cardName == "Campus&FacilityCard") {
                        isUserExist = item.isUserExist ?? false;
                      }
                      var widget = GetAllCards().getCard(
                          userName,
                          instituteId,
                          false,
                          styleElements,
                          item,
                          rows,
                          userType,
                          userId,
                          ownerType,
                          ownerId,
                          profileImage, callBck: () {
                        getPhotos(
                            context,
                            AppLocalizations.of(context)!
                                .translate("campus_facilities"));
                      });
                      if (widget != null) listCardsCommon.add(widget as StatelessWidget);
                    }
                  }
                } else
                  setState(() {
                    isEmpty = true;
                  });
              } else {
                setState(() {
                  isEmpty = true;
                });
              }
              setState(() {
                data![2] = CustomTabMaker(
                    statelessWidget: EducationPage(
                        type: type,
                        rows: null,
                        isEmpty: isEmpty,
                        instituteId: instituteId,
                        userType: userType,

                        isUserExist: isUserExist,
                        listCardsAbout: listCardsCommon,
                        callBackCreate: () {
                          _addPhoto();
                        },
                        callBck: () {
                          getPhotos(
                              context,
                              AppLocalizations.of(context)!
                                  .translate("campus_facilities"));
                        }),
                    tabName: type);
              });
            }
          });
        }
      } else {}
    }).catchError((onError) {
      print(onError.toString());
      ToastBuilder().showSnackBar(
          "Something went wrong!!", sctx!, HexColor(AppColors.information));
    });
  }

  void getDetailedClasses(BuildContext context) async {
    setState(() {
      data![2] = CustomTabMaker(
          statelessWidget: EducationPage(
              type: type,
              rows: null,
              isEmpty: isEmpty,

              instituteId: instituteId,
              userType: userType,
              listCardsAbout: [],
              callBck: () {
                getEducations(context);
              }),
          tabName: type);
    });
    final body = jsonEncode({
      "person_id": userId,
      "type": userType == "institution" ? "institution" : "person",
      "all_institutions_id": userType == "institution" ? userId : instituteId,
      "page_number": 1,
      "given_by_id": ownerId,
      "page_size": 100
    });
    setState(() {
      listCardsCommon = [];
    });
    Calls().call(body, context, Config.DETAIL_CLASSES).then((value) async {
      if (value != null) {
        if (this.mounted) {
          setState(() {
            var d = BaseResponses.fromJson(value);
            if (d != null && d.statusCode == 'S10001') {
              if (d.rows != null && d.rows!.isNotEmpty && d.total != 0) {
                listEducations = d.rows;
                listCardsCommon = [];
                if (listEducations != null && listEducations!.length > 0) {
                  for (var item in listEducations!) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(
                          userName,
                          instituteId,
                          false,
                          styleElements,
                          item,
                          rows,
                          userType,
                          userId,
                          ownerType,
                          ownerId,
                          profileImage, callBck: () {
                        getDetailedClasses(context);
                      });
                      if (widget != null) listCardsCommon.add(widget as StatelessWidget);
                    }
                  }
                } else
                  setState(() {
                    isEmpty = true;
                  });
              } else {
                setState(() {
                  isEmpty = true;
                });
              }
              setState(() {
                data![2] = CustomTabMaker(
                    statelessWidget: EducationPage(
                        type: type,
                        rows: null,
                        isEmpty: isEmpty,

                        instituteId: instituteId,
                        userType: userType,
                        listCardsAbout: listCardsCommon,
                        callBck: () {
                          getDetailedClasses(context);
                        }),
                    tabName: AppLocalizations.of(context)!.translate('class'));
              });
            }
          });
        }
      } else {}
    }).catchError((onError) {
      print(onError.toString());
      ToastBuilder().showSnackBar(
          "Something went wrong !!", sctx!, HexColor(AppColors.information));
    });
  }

  void getDetailedSubjects(BuildContext context) async {
    setState(() {
      data![2] = CustomTabMaker(
          statelessWidget: EducationPage(
              type: type,
              rows: null,
              isEmpty: isEmpty,

              instituteId: instituteId,
              userType: userType,
              listCardsAbout: [],
              callBck: () {
                getEducations(context);
              }),
          tabName: type);
    });
    final body = jsonEncode({
      "person_id": userId,
      "type": userType == "institution" ? "institution" : "person",
      "all_institutions_id":
      userType == "institution" ? userId.toString() : instituteId,
      "page_number": 1,
      "given_by_id": ownerId,
      "page_size": 100
    });
    setState(() {
      listCardsCommon = [];
    });
    Calls().call(body, context, Config.DETAILS_SUBJECTS).then((value) async {
      if (value != null) {
        if (this.mounted) {
          setState(() {
            var d = BaseResponses.fromJson(value);
            if (d != null && d.statusCode == 'S10001') {
              if (d.rows != null && d.rows!.isNotEmpty && d.total != 0) {
                listCardsCommon = [];
                listEducations = d.rows;
                if (listEducations != null && listEducations!.length > 0) {
                  for (var item in listEducations!) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(
                          userName,
                          instituteId,
                          false,
                          styleElements,
                          item,
                          rows,
                          userType,
                          userId,
                          ownerType,
                          ownerId,
                          profileImage, callBck: () {
                        getDetailedSubjects(context);
                      });
                      if (widget != null) listCardsCommon.add(widget as StatelessWidget);
                    }
                  }
                } else
                  setState(() {
                    isEmpty = true;
                  });
              } else {
                setState(() {
                  isEmpty = true;
                });
              }
              setState(() {
                data![2] = CustomTabMaker(
                    statelessWidget: EducationPage(
                        type: type,
                        rows: null,
                        isEmpty: isEmpty,

                        instituteId: instituteId,
                        userType: userType,
                        listCardsAbout: listCardsCommon,
                        callBck: () {
                          getDetailedSubjects(context);
                        }),
                    tabName: AppLocalizations.of(context)!.translate('subject'));
              });
            }
          });
        }
      }
      {}
    }).catchError((onError) {
      print(onError.toString());
      ToastBuilder().showSnackBar(
          "Something went wrong !!", sctx!, HexColor(AppColors.information));
    });
  }

  void getLanguagesDetail(BuildContext context, String type) async {
    setState(() {
      data![2] = CustomTabMaker(
          statelessWidget: EducationPage(
              type: type,
              rows: null,
              isEmpty: isEmpty,

              userType: userType,
              instituteId:
              userType == "institution" ? userId.toString() : instituteId,
              listCardsAbout: [],
              callBck: () {
                getEducations(context);
              }),
          tabName: type);
    });
    final body = jsonEncode({
      "person_id": userId,
      "standard_expertise_category": type == "language" ? "2" : "4",
      "page_number": 1,
      "given_by_id": ownerId,
      "page_size": 100
    });
    setState(() {
      listCardsCommon = [];
    });
    Calls()
        .call(body, context, Config.LANGUAGE_SKILLS_SEE_MORE)
        .then((value) async {
      if (value != null) {
        if (this.mounted) {
          setState(() {
            var d = BaseResponses.fromJson(value);
            if (d != null && d.statusCode == 'S10001') {
              if (d.rows != null && d.rows!.isNotEmpty && d.total != 0) {
                setState(() {
                  isEmpty = false;
                });
                listCardsCommon = [];
                listEducations = d.rows;
                if (listEducations != null && listEducations!.length > 0) {
                  for (var item in listEducations!) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(
                          userName,
                          instituteId,
                          false,
                          styleElements,
                          item,
                          rows,
                          userType,
                          userId,
                          ownerType,
                          ownerId,
                          profileImage, callBck: () {
                        getLanguagesDetail(
                            context, type == "skill" ? "skill" : "language");
                      });
                      if (widget != null) listCardsCommon.add(widget as StatelessWidget);
                    }
                  }
                } else
                  setState(() {
                    isEmpty = true;
                  });
              } else {
                setState(() {
                  isEmpty = true;
                });
              }
              setState(() {
                data![2] = CustomTabMaker(
                    statelessWidget: EducationPage(
                        type: type,
                        rows: null,
                        isEmpty: isEmpty,

                        instituteId: instituteId,
                        userType: userType,
                        listCardsAbout: listCardsCommon,
                        callBck: () {
                          getLanguagesDetail(
                              context, type == "skill" ? "skill" : "language");
                        }),
                    tabName: type == "skill" ? "Skill" : "Language");
              });
            }
          });
        }
      }
      {}
    }).catchError((onError) {
      print(onError.toString());
      ToastBuilder().showSnackBar(
          "Something went wrong !!", sctx!, HexColor(AppColors.information));
    });
  }

  void getDepartments(BuildContext context, String type) async {
    final body = jsonEncode({
      "person_id": personId,
      "institution_id": instituteId,
      "page_number": 1,
      "given_by_id": ownerId,
      "page_size": 100
    });
    setState(() {
      listCardsCommon = [];
    });
    Calls().call(body, context, Config.COURSES_SEE_MORE).then((value) async {
      if (value != null) {
        if (this.mounted) {
          setState(() {
            var d = BaseResponses.fromJson(value);
            if (d != null && d.statusCode == 'S10001') {
              if (d.rows != null && d.rows!.isNotEmpty && d.total != 0) {
                listEducations = d.rows;
                listCardsCommon = [];
                if (listEducations != null && listEducations!.length > 0) {
                  for (var item in listEducations!) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(
                          userName,
                          instituteId,
                          false,
                          styleElements,
                          item,
                          rows,
                          userType,
                          userId,
                          ownerType,
                          ownerId,
                          profileImage, callBck: () {
                        getDetailedClasses(context);
                      });
                      if (widget != null) listCardsCommon.add(widget as StatelessWidget);
                    }
                  }
                } else
                  setState(() {
                    isEmpty = true;
                  });
              }
              setState(() {
                isEmpty = true;
              });
              setState(() {
                data![2] = CustomTabMaker(
                    statelessWidget: EducationPage(
                        type: type,
                        rows: null,
                        isEmpty: isEmpty,

                        instituteId: instituteId,
                        userType: userType,
                        listCardsAbout: listCardsCommon,
                        callBck: () {
                          getDetailedClasses(context);
                        }),
                    tabName: AppLocalizations.of(context)!.translate('courses'));
              });
            }
          });
        }
      } else {}
    }).catchError((onError) {
      print(onError.toString());
      ToastBuilder().showSnackBar(
          "Something went wrong !!", sctx!, HexColor(AppColors.information));
    });
  }

  void getCourses(BuildContext context, String? type) async {
    final body = jsonEncode({
      "person_id": personId,
      "institution_id": instituteId,
      "page_number": 1,
      "given_by_id": ownerId,
      "page_size": 100
    });
    setState(() {
      listCardsCommon = [];
    });
    Calls().call(body, context, Config.COURSES_SEE_MORE).then((value) async {
      if (value != null) {
        if (this.mounted) {
          setState(() {
            var d = BaseResponses.fromJson(value);
            if (d != null && d.statusCode == 'S10001') {
              if (d.rows != null && d.rows!.isNotEmpty && d.total != 0) {
                listEducations = d.rows;
                listCardsCommon = [];
                if (listEducations != null && listEducations!.length > 0) {
                  for (var item in listEducations!) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(
                          userName,
                          instituteId,
                          false,
                          styleElements,
                          item,
                          rows,
                          userType,
                          userId,
                          ownerType,
                          ownerId,
                          profileImage, callBck: () {
                        getDetailedClasses(context);
                      });
                      if (widget != null) listCardsCommon.add(widget as StatelessWidget);
                    }
                  }
                } else
                  setState(() {
                    isEmpty = true;
                  });
              }
              setState(() {
                isEmpty = true;
              });
              setState(() {
                data![2] = CustomTabMaker(
                    statelessWidget: EducationPage(
                        type: type,
                        rows: null,
                        isEmpty: isEmpty,

                        instituteId: instituteId,
                        userType: userType,
                        listCardsAbout: listCardsCommon,
                        callBck: () {
                          getDetailedClasses(context);
                        }),
                    tabName: AppLocalizations.of(context)!.translate('courses'));
              });
            }
          });
        }
      } else {}
    }).catchError((onError) {
      print(onError.toString());
      ToastBuilder().showSnackBar(
          "Something went wrong !!", sctx!, HexColor(AppColors.information));
    });
  }

  void getMediums(BuildContext context, String? type) async {
    final body = jsonEncode({
      "person_id": personId,
      "institution_id":
      userType == "institution" ? userId.toString() : instituteId,
      "page_number": 1,
      "given_by_id": ownerId,
      "page_size": 100
    });
    setState(() {
      listCardsCommon = [];
    });
    Calls().call(body, context, Config.MEDIUM_SEE_MORE).then((value) async {
      if (value != null) {
        if (this.mounted) {
          setState(() {
            var d = BaseResponses.fromJson(value);
            if (d != null && d.statusCode == 'S10001') {
              if (d.rows != null && d.rows!.isNotEmpty && d.total != 0) {
                listEducations = d.rows;
                listCardsCommon = [];
                if (listEducations != null && listEducations!.length > 0) {
                  for (var item in listEducations!) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(
                          userName,
                          instituteId,
                          false,
                          styleElements,
                          item,
                          rows,
                          userType,
                          userId,
                          ownerType,
                          ownerId,
                          profileImage, callBck: () {
                        getDetailedClasses(context);
                      });
                      if (widget != null) listCardsCommon.add(widget as StatelessWidget);
                    }
                  }
                } else
                  setState(() {
                    isEmpty = true;
                  });
              }
              setState(() {
                isEmpty = true;
              });
              setState(() {
                data![2] = CustomTabMaker(
                    statelessWidget: EducationPage(
                        type: type,
                        rows: null,
                        isEmpty: isEmpty,

                        instituteId: instituteId,
                        userType: userType,
                        listCardsAbout: listCardsCommon,
                        callBck: () {
                          getDetailedClasses(context);
                        }),
                    tabName: AppLocalizations.of(context)!.translate('medium'));
              });
            }
          });
        }
      } else {}
    }).catchError((onError) {
      print(onError.toString());
      ToastBuilder().showSnackBar(
          "Something went wrong !!", sctx!, HexColor(AppColors.information));
    });
  }

  void getClubs(BuildContext context, String? type) async {
    final body = jsonEncode({
      "person_id": personId,
      "institution_id":
      userType == "institution" ? userId.toString() : instituteId,
      "page_number": 1,
      "given_by_id": ownerId,
      "page_size": 100
    });
    setState(() {
      listCardsCommon = [];
    });
    Calls().call(body, context, Config.CLUBS_SEE_MORE).then((value) async {
      if (value != null) {
        if (value != null) {
          if (this.mounted) {
            setState(() {
              var d = BaseResponses.fromJson(value);
              if (d != null && d.statusCode == 'S10001') {
                if (d.rows != null && d.rows!.isNotEmpty && d.total != 0) {
                  listEducations = d.rows;
                  listCardsCommon = [];
                  if (listEducations != null && listEducations!.length > 0) {
                    for (var item in listEducations!) {
                      if (item != null) {
                        var widget = GetAllCards().getCard(
                            userName,
                            instituteId,
                            false,
                            styleElements,
                            item,
                            rows,
                            userType,
                            userId,
                            ownerType,
                            ownerId,
                            profileImage, callBck: () {
                          getDetailedClasses(context);
                        });
                        if (widget != null) listCardsCommon.add(widget as StatelessWidget);
                      }
                    }
                  } else
                    setState(() {
                      isEmpty = true;
                    });
                }
                setState(() {
                  isEmpty = true;
                });
                setState(() {
                  data![2] = CustomTabMaker(
                      statelessWidget: EducationPage(
                          type: type,
                          rows: null,
                          isEmpty: isEmpty,

                          instituteId: instituteId,
                          userType: userType,
                          listCardsAbout: listCardsCommon,
                          callBck: () {
                            getDetailedClasses(context);
                          }),
                      tabName: AppLocalizations.of(context)!.translate('club'));
                });
              }
            });
          }
        } else {}
      }
      {}
    }).catchError((onError) {
      print(onError.toString());
      ToastBuilder().showSnackBar(
          "Something went wrong !!", sctx!, HexColor(AppColors.information));
    });
  }

  void getSports(BuildContext context, String? type) async {
    final body = jsonEncode({
      "person_id": personId,
      "institution_id":
      userType == "institution" ? userId.toString() : instituteId,
      "page_number": 1,
      "given_by_id": ownerId,
      "page_size": 100
    });
    setState(() {
      listCardsCommon = [];
    });
    Calls().call(body, context, Config.SPORTS_SEE_MORE).then((value) async {
      if (value != null) {
        if (this.mounted) {
          setState(() {
            var d = BaseResponses.fromJson(value);
            if (d != null && d.statusCode == 'S10001') {
              if (d.rows != null && d.rows!.isNotEmpty && d.total != 0) {
                listEducations = d.rows;
                listCardsCommon = [];
                if (listEducations != null && listEducations!.length > 0) {
                  for (var item in listEducations!) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(
                          userName,
                          instituteId,
                          false,
                          styleElements,
                          item,
                          rows,
                          userType,
                          userId,
                          ownerType,
                          ownerId,
                          profileImage, callBck: () {
                        getDetailedClasses(context);
                      });
                      if (widget != null) listCardsCommon.add(widget as StatelessWidget);
                    }
                  }
                } else
                  setState(() {
                    isEmpty = true;
                  });
              } else
                setState(() {
                  isEmpty = true;
                });
              setState(() {
                data![2] = CustomTabMaker(
                    statelessWidget: EducationPage(
                        type: type,
                        rows: null,
                        isEmpty: isEmpty,

                        instituteId: instituteId,
                        userType: userType,
                        listCardsAbout: listCardsCommon,
                        callBck: () {
                          getDetailedClasses(context);
                        }),
                    tabName: AppLocalizations.of(context)!.translate('sport'));
              });
            }
          });
        }
      } else {}
    }).catchError((onError) {
      print(onError.toString());
      ToastBuilder().showSnackBar(
          "Something went wrong !!", sctx!, HexColor(AppColors.information));
    });
  }

  void update(updateFollowers) {
    if (updateFollowers) {
      followersCountApi(context);
    }
  }

  void followersCountApi(BuildContext context) async {
    final body = jsonEncode({
      "object_type": userType == "institution" ? "institution" : "person",
      "object_id": userId,
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

  _coverPicker() async {
    var pr = ToastBuilder()
        .setProgressDialogWithPercent(context, 'Uploading Image...');
    File pickedFile = await (ImagePickerAndCropperUtil().pickImage(context) as FutureOr<File>);
    var croppedFile =
    await ImagePickerAndCropperUtil().cropFile(context, pickedFile);
    if (croppedFile != null) {
      setState(() {
        coverPath = croppedFile.path;
      });
      await pr.show();
      var contentType =
      ImagePickerAndCropperUtil().getMimeandContentType(croppedFile.path);
      await UploadFile(
          baseUrl: Config.BASE_URL,
          context: context,
          token: prefs!.getString("token"),
          contextId: rows!.id.toString(),
          contextType: CONTEXTTYPE_ENUM.COVER.type,
          ownerId: rows!.id.toString(),
          ownerType: OWNERTYPE_ENUM.PERSON.type,
          file: croppedFile,
          subContextId: "",
          subContextType: "",
          onProgressCallback: (int progress) {
            pr.update(progress: progress.toDouble());
          },
          mimeType: contentType[1],
          contentType: contentType[0])
          .uploadFile()
          .then((value) async {
        await pr.hide();
        var imageResponse = ImageUpdateResponse.fromJson(value);
        updateImage(imageResponse.rows!.fileUrl, OWNERTYPE.person.type,
            IMAGETYPE.cover.type);
      }).catchError((onError) {
        print(onError.toString());
      });
    }
  }

  _profilePicker() async {

    var pr = ToastBuilder()
        .setProgressDialogWithPercent(context, 'Uploading Image...');
    File pickedFile = await (ImagePickerAndCropperUtil().pickImage(context) as FutureOr<File>);
    var croppedFile =
    await ImagePickerAndCropperUtil().cropFile(context, pickedFile);
    if (croppedFile != null) {


      bool isFaceDetected= await Utility().recognizeFace(croppedFile);
      if(isFaceDetected)
      {
        setState(() {
          profileImageFromPath = croppedFile.path;
        });
        await pr.show();
        var contentType = ImagePickerAndCropperUtil().getMimeandContentType(croppedFile.path);
        await UploadFile(
            baseUrl: Config.BASE_URL,
            context: context,
            token: prefs!.getString("token"),
            contextId: rows!.id.toString(),
            contextType: CONTEXTTYPE_ENUM.PROFILE.type,
            ownerId: rows!.id.toString(),
            ownerType: OWNERTYPE_ENUM.PERSON.type,
            file: croppedFile,
            subContextId: "",
            subContextType: "",
            onProgressCallback: (int progress) {
              pr.update(progress: progress.toDouble());
            },
            mimeType: contentType[1],
            contentType: contentType[0])
            .uploadFile()
            .then((value) async {
          await pr.hide();
          var imageResponse = ImageUpdateResponse.fromJson(value);
          updateImage(imageResponse.rows!.fileUrl, OWNERTYPE.person.type,
              IMAGETYPE.profile.type);
        }).catchError((onError) {
          print(onError.toString());
        });
      }
      else
      {
        showDialog(context: context,builder: (BuildContext context)=> InvalidProfileImageDilog()); }



    }
  }

  updateImage(String? url, String ownerType, String imageType) async {
    var pr = ToastBuilder()
        .setProgressDialogWithPercent(context, 'Updating Image...');
    ImageUpdateRequest request = ImageUpdateRequest();
    request.imagePath = url;
    request.imageType = imageType;
    request.ownerId = rows!.id;
    request.ownerType = ownerType;
    var data = jsonEncode(request);
    await pr.show();
    Calls().call(data, context, Config.IMAGEUPDATE).then((value) async {
      await pr.hide();
      var resposne = DynamicResponse.fromJson(value);
      if (resposne.statusCode == Strings.success_code) {
        if (imageType == IMAGETYPE.cover.type) {
          if (prefs != null) prefs!.setString("coverImage", url!);
          setState(() {
            coverImage = Config.BASE_URL + url!;
          });
        } else {
          if (prefs != null) prefs!.setString("profileImage", url!);
          if (callback != null) callback!();
          setState(() {
            profileImage = Config.BASE_URL + url!;
          });
        }
      }
    });
  }

  UserProfileCardsState(this.type, this.currentPosition, this.userId, this.userType,
      this.callback, this.isUserExist, this.isFromRegisration,this.isFromAudioConf);

  void refreshForAudioPage() {
    isFromAudioConf = false;
    getUserData(context);
  }
}

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget? stub;
  final ValueChanged<int?>? onPositionChange;
  final ValueChanged<double>? onScroll;
  final int? currentPosition;
  final Null Function()? callback;
  final EdgeInsetsGeometry? marginTop;
final bool? isTabVisible;
final bool? isSwipeDisabled;
  CustomTabView({
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.marginTop,
    this.callback,
    this.isSwipeDisabled=false,
    this.isTabVisible,
    this.currentPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState(callback);
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {

  TabController? controller;
  int? _currentCount;
  int? _currentPosition;
  final Null Function()? callback;



  @override
  void initState() {
    _currentPosition = widget.currentPosition ?? 0;


    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition!,
    );
    controller!.addListener(onPositionChange);
    controller!.animation!.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller!.animation!.removeListener(onScroll);
      controller!.removeListener(onPositionChange);
      controller!.dispose();

      if (widget.currentPosition != null) {
        _currentPosition = widget.currentPosition;
      }

      if (_currentPosition! > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition! < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange!(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition!,
        );
        controller!.addListener(onPositionChange);
        controller!.animation!.addListener(onScroll);
      });
    } else if (widget.currentPosition != null) {
      controller!.animateTo(widget.currentPosition!);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller!.animation!.removeListener(onScroll);
    controller!.removeListener(onPositionChange);
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Visibility(
          visible:widget.isTabVisible!=null ?widget.isTabVisible!:true,
          child: Container(
            margin: widget.marginTop,
            alignment: Alignment.center,
            child: TabBar(
              isScrollable: true,
              controller: controller,
              labelPadding: EdgeInsets.symmetric(horizontal: 3.0),
              indicatorColor: HexColor(AppColors.appColorTransparent),
              labelColor: HexColor(AppColors.appMainColor),
              unselectedLabelColor: Theme.of(context).hintColor,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: HexColor(AppColors.appColorTransparent),
                    width: 0,
                  ),
                ),
              ),
              tabs: List.generate(
                widget.itemCount,
                    (index) => widget.tabBuilder(context, index),
              ),
            ),
          ),
        ),
        Expanded(
          child:TabBarView(
            controller: controller,
            physics: widget.isSwipeDisabled!?NeverScrollableScrollPhysics():BouncingScrollPhysics(),
            children: List.generate(
              widget.itemCount,
                  (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if(!widget.isSwipeDisabled!)

   { if (!controller!.indexIsChanging ) {
      _currentPosition = controller!.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange!(_currentPosition);
      }
    }}
  }

  onScroll() {
    if(!widget.isSwipeDisabled!)
  {  if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll!(controller!.animation!.value);
    }}
  }

  _CustomTabsState(this.callback);
} // ignore: must_be_immutable

// ignore: must_be_immutable
class AboutPage extends StatelessWidget {
  final Null Function()? callBck;
  final String type;
  final List<StatelessWidget>? listCardsAbout;
  final isLoading;
  final isAllowed;
  List<CommonCardData> listCardData = [];

  Persondata? rows;
  TextStyleElements? styleElements;
  ProgressDialog? pr;

  AboutPage(
      {Key? key,
        required this.type,
        this.listCardsAbout,
        this.rows,

        this.isAllowed,
        this.isLoading,
        this.callBck})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return listCardsAbout!.isNotEmpty
        ? Stack(
      children: [

        RefreshIndicator(
          onRefresh: refreshList,
          child: ListView.builder(
              padding: EdgeInsets.all(0.0),
              physics: BouncingScrollPhysics(),
              itemCount: listCardsAbout!.length,
              itemBuilder: (context, index) {
                return listCardsAbout![index];
              }),
        )

      ],
    )
        : Visibility(visible: isAllowed, child: CircularProgressIndicator());
  }

  Future<Null> refreshList() async {
    callBck!();
    await new Future.delayed(new Duration(seconds: 2));

    return null;
  }
}

// ignore: must_be_immutable
class BottomSheetContent extends StatelessWidget {
  String? personType;
  int? id;
  final Null Function(String type)? callback;

  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    return SafeArea(
      child: Wrap(children: [
        Container(
          decoration: new BoxDecoration(
              color: HexColor(AppColors.appColorWhite),
              borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(20.0.h),
                  topRight: Radius.circular(20.0.h))),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(16.h),
                  child: Text(
                    AppLocalizations.of(context)!.translate('more_options'),
                    style: styleElements.headline6ThemeScalable(context),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  callback!("class");
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.all(4.h),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)!
                              .translate("classes_branches"),
                          style: styleElements.headline6ThemeScalable(context),
                        ),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  callback!("education");
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.all(4.h),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.translate("education"),
                          style: styleElements.headline6ThemeScalable(context),
                        ),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  callback!("language");
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.all(4.h),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.translate("language"),
                          style: styleElements.headline6ThemeScalable(context),
                        ),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  callback!("skill");
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.all(4.h),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.translate("skill"),
                          style: styleElements.headline6ThemeScalable(context),
                        ),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  callback!("subject");
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.all(4.h),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.translate("subject"),
                          style: styleElements.headline6ThemeScalable(context),
                        ),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  callback!("work");
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.all(4.h),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)!
                              .translate("work_experience"),
                          style: styleElements.headline6ThemeScalable(context),
                        ),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  callback!("learning");
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.all(4.h),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)!
                              .translate("learning"),
                          style: styleElements.headline6ThemeScalable(context),
                        ),
                      )),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  BottomSheetContent({Key? key, this.personType, this.id, this.callback})
      : super(key: key);
}

// ignore: must_be_immutable
class BottomSheetContentInstitute extends StatelessWidget {
  int? instituteId;
  String? personType;
  int? id;
  final Null Function(String type)? callback;

  BottomSheetContentInstitute(
      {Key? key, this.personType, this.id, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    return SafeArea(
      child: Wrap(children: [
        Container(
          decoration: new BoxDecoration(
              color: HexColor(AppColors.appColorWhite),
              borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(20.0.h),
                  topRight: Radius.circular(20.0.h))),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(16.h),
                  child: Text(
                    AppLocalizations.of(context)!.translate('more_options'),
                    style: styleElements.headline6ThemeScalable(context),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  callback!(
                    AppLocalizations.of(context)!.translate("campus_facilities"),
                  );
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.all(4.h),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)!
                              .translate("campus_facilities"),
                          style: styleElements.headline6ThemeScalable(context),
                        ),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  callback!(
                    "class",
                  );
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.all(4.h),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)!
                              .translate("classes_branches"),
                          style: styleElements.headline6ThemeScalable(context),
                        ),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  callback!(
                    "course",
                  );
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.all(4.h),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.translate("courses"),
                          style: styleElements.headline6ThemeScalable(context),
                        ),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  callback!(
                    "medium",
                  );
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.all(4.h),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.translate("medium"),
                          style: styleElements.headline6ThemeScalable(context),
                        ),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  callback!(
                    "sports",
                  );
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.all(4.h),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.translate("sports"),
                          style: styleElements.headline6ThemeScalable(context),
                        ),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  callback!(
                    "subject",
                  );
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.all(4.h),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.translate("subject"),
                          style: styleElements.headline6ThemeScalable(context),
                        ),
                      )),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}

// ignore: must_be_immutable
class EducationPage extends StatelessWidget {
  String? type;
  String? userType;
  List<StatelessWidget>? listCardsAbout = [];
  late TextStyleElements styleElements;
  BuildContext? context;
  String? instituteId;

  final bool? isPersonalProfile;
  bool? isUserExist = false;
  final Persondata? rows;
  List<CommonCardData> listCardData = [];
  SharedPreferences? prefs;
  final Null Function()? callBck;
  final Null Function()? callBackCreate;
  bool? isEmpty = false;

  EducationPage(
      {Key? key,
        required this.type,
        this.listCardsAbout,
        this.rows,
        this.callBck,
        this.isUserExist,
        this.callBackCreate,
        this.isPersonalProfile,
        this.userType,
        this.isEmpty,
        this.instituteId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.context = context;

    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8.0, top: 12),
      decoration: BoxDecoration(
        color: HexColor(AppColors.appColorWhite),
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(8.0),
            topRight: const Radius.circular(8.0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 16.0.h,
                        right: 16.h,
                        top: 12.h,
                      ),
                      child: Text(
                        type == "work"
                            ? AppLocalizations.of(context)!
                            .translate("work_experience")
                            : type == "class"
                            ? AppLocalizations.of(context)!
                            .translate("classes_branches")
                            : type == "subject"
                            ? AppLocalizations.of(context)!
                            .translate("subject")
                            : type == "skill"
                            ? AppLocalizations.of(context)!
                            .translate("skill")
                            : type == "language"
                            ? AppLocalizations.of(context)!
                            .translate("language")
                            : type == "medium"
                            ? AppLocalizations.of(context)!
                            .translate("medium_title")
                            : type == "courses"
                            ? AppLocalizations.of(context)!
                            .translate(
                            "entity_programs")
                            : type == "department"
                            ? AppLocalizations.of(context)!
                            .translate(
                            "department")
                            : type == "club"
                            ? AppLocalizations.of(
                            context)!
                            .translate(
                            "club")
                            : type == "sports"
                            ? AppLocalizations.of(
                            context)!
                            .translate(
                            "sports")
                            : type ==
                            AppLocalizations.of(context)!.translate("campus_facilities")
                            ? AppLocalizations.of(context)!.translate("campus_facilities")
                            : AppLocalizations.of(context)!.translate("education"),
                        style: styleElements
                            .headline6ThemeScalable(context)
                            .copyWith(
                            fontWeight: FontWeight.bold,
                            color: HexColor(AppColors.appColorBlack85)),
                        textAlign: TextAlign.left,
                      ),
                    )),
                flex: 3,
              ),
              Flexible(
                child: Visibility(
                    visible: isUserExist ?? false,
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          callBackCreate!();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            color: HexColor(AppColors.appColorGrey500),
                            size: 25,
                          ),
                        ))),
                flex: 1,
              ),
              Visibility(
                visible: userType == "person",
                child: Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            {
                              if (type == "work") {
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditEducation(
                                            null, false, false, null)));

                                if (result != null &&
                                    result['result'] == "success") {
                                  callBck!();
                                }
                              } else if (type == "education") {
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditEducation(
                                            null, true, false, null)));

                                if (result != null &&
                                    result['result'] == "success") {
                                  callBck!();
                                }
                              } else if (type == "class") {
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ExpertiseSelectClass(
                                              int.parse(instituteId!),
                                              null,
                                              true,
                                              0,
                                              callBck,
                                              false),
                                    ));

                                if (result != null &&
                                    result['result'] == "success") {
                                  callBck!();
                                }
                              } else if (type == "subject") {
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddSelectSubject(
                                            int.parse(instituteId!),
                                            false,
                                            null)));

                                if (result != null &&
                                    result['result'] == "success") {
                                  callBck!();
                                }
                              } else if (type == "skill") {
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditLanguage(
                                          "Skill", instituteId, false, null),
                                    ));

                                if (result != null &&
                                    result['result'] == "success") {
                                  callBck!();
                                }
                              } else if (type == "language") {
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditLanguage(
                                          "Languages",
                                          instituteId,
                                          false,
                                          null),
                                    ));

                                if (result != null &&
                                    result['result'] == "success") {
                                  callBck!();
                                }
                              }
                            }
                          },
                          child: Icon(
                            Icons.add,
                            size: 30,
                            color: HexColor(AppColors.appColorBlack85),
                          ),
                        )),
                  ),
                  flex: 1,
                ),
              ),
            ],
          ),
          Flexible(
              child: Container(
                margin: const EdgeInsets.only(bottom: 2, top: 16),
                child: NotificationListener(
                  child: listCardsAbout!.isNotEmpty
                      ? RefreshIndicator(
                    onRefresh: refreshList,
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0.0),
                        physics: BouncingScrollPhysics(),
                        itemCount: listCardsAbout!.length,
                        itemBuilder: (context, index) {
                          return listCardsAbout![index];
                        }),
                  )
                      : isEmpty!
                      ? Center(
                      child: TricycleEmptyWidget(
                        message:
                        AppLocalizations.of(context)!.translate('no_data'),
                      )
                    // EmptyWidget(AppLocalizations.of(context)
                    //     .translate('no_data'),

                  )
                      : CircularProgressIndicator(),
                  // ignore: missing_return

                ),
              ))
        ],
      ),
    );
  }
  Future<Null> refreshList() async {
    callBck!();
    await new Future.delayed(new Duration(seconds: 2));

    return null;
  }
}
