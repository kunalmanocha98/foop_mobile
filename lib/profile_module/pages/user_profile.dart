/*
import 'dart:convert';
import 'dart:io';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/ui/edit_education.dart';
import 'package:oho_works_app/ui/select_entity_single.dart';
import 'package:oho_works_app/ui/test.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:GlobalUploadFilePkg/Enums/contexttype.dart';
import 'package:GlobalUploadFilePkg/Enums/ownertype.dart';
import 'package:GlobalUploadFilePkg/Files/GlobalUploadFilePkg.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/common_cards/user_name_with_image_card.dart';
import 'package:oho_works_app/common_cards/user_pipulaity_card.dart';
import 'package:oho_works_app/enums/imageType.dart';
import 'package:oho_works_app/enums/ownerType.dart';
import 'package:oho_works_app/models/ClassesList.dart';
import 'package:oho_works_app/models/RolesList.dart';
import 'package:oho_works_app/models/SubjectList.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/models/followers_following_count.dart';
import 'package:oho_works_app/models/imageuploadrequestandresponse.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/ui/empty_widget.dart';
import 'package:oho_works_app/ui/report_abuse.dart';
import 'package:oho_works_app/ui/roomsPage.dart';
import 'package:oho_works_app/ui/settings.dart';
import 'package:oho_works_app/ui/testuserlist.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/getcards.dart';
import 'package:oho_works_app/utils/imagepickerAndCropper.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:location/location.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_subject_select_screen.dart';
import 'directions.dart';
import 'edit_language-page.dart';

// ignore: must_be_immutable
class UserProfile extends StatefulWidget {
  final String type;
  final int currentPosition;
  final List<StatelessWidget> listCardsAbout;

  final List<StatelessWidget> listCardsClasses;

  const UserProfile(
      {Key key,
      @required this.type,
      @required this.currentPosition,
      this.listCardsAbout,
      this.listCardsClasses})
      : super(key: key);

  _UserProfile createState() => _UserProfile(type, currentPosition);
}

class _UserProfile extends State<UserProfile>
    with TickerProviderStateMixin {
  String type;
  int _currentPosition;
  bool isUpdate = false;

  _UserProfile(String type, int currentPosition) {
    this.type = type;
    this._currentPosition = currentPosition;
  }

  var typeOfUser = "person";
  var userId;
  var personId;
  TextStyleElements styleElements;
  var userName = "";

  SharedPreferences prefs;
  String instituteId;
  var pageTitle = "";
  PersonalProfile personalProfile;
  Persondata rows;
  List<CommonCardData> listCardData = [];
  List<CommonCardData> listEducations = [];
  List<CommonCardData> listClasses = [];
  List<CommonCardData> listSubjects = [];
  List<StatelessWidget> listCardsAbout = [];
  List<StatelessWidget> listCardsClasses = [];
  List<StatelessWidget> listSubjectCards = [];
  List<StatelessWidget> listEducationCard = [];
  List<StatelessWidget> listSkillsCard = [];
  List<StatelessWidget> listLanguageCards = [];
  List<StatelessWidget> listWorkCards = [];
  List<StatelessWidget> listSportCards = [];
  List<StatelessWidget> listClubCards = [];
  List<StatelessWidget> listReviewCards = [];
  CommonCardData content = CommonCardData();
  List<StatelessWidget> listCards = [];
  var isCheckedColor = HexColor(AppColors.appColorWhite);
  TabController _tabController;
  Map<String, bool> mapRules = Map();
  List<Roles> listRules = [];
  List<Subjects> listOfSubjects = [];
  List<Classes> listOfClasses = [];
  var isClassesSelected = HexColor(AppColors.appColorWhite);
  var isSubjectSelected = HexColor(AppColors.appColorWhite);
  var isRoleSelected = false;
  List<CommonCardData> listCardDataClasses = [];
  List<CommonCardData> listSubjectsCards = [];
  List<CommonCardData> listEducationData = [];
  List<CommonCardData> listSkillsData = [];
  List<CommonCardData> listLanguageData = [];
  List<CommonCardData> listWorkData = [];
  List<CommonCardData> listSportsData = [];
  List<CommonCardData> listClubsData = [];
  List<CommonCardData> listReviewData = [];
  List<CustomTabMaker> list = [];
*/
/*  BuildContext context;*//*

  var followers = 0;
  var following = 0;
  var roomsCount = 0;
  String profileImage = "";
  String coverImage = "";
  bool isError = false;
  String errorMessage = "";
  Location location = new Location();
  ProgressDialog pr;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  void didUpdateWidget(UserProfile oldWidget) {

    super.didUpdateWidget(oldWidget);
  }
  @override
  void initState() {
    super.initState();
    setSharedPreferences();
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(onPositionChange);
  }




  Widget build(BuildContext context) {
    ScreenUtil.init(context);
*/
/*    this.context = context;*//*

    styleElements = TextStyleElements(context);

    FlutterStatusbarcolor.setStatusBarColor(HexColor(AppColors.appColorTransparent));

    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          backPressed();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: HexColor(AppColors.appColorBackground),
            body:  Stack(
                  children: <Widget>[
                    new Container(
                        width: MediaQuery.of(context).size.width,
                        child: new FadeInImage.assetNetwork(
                          placeholder: 'assets/appimages/cover.jpg',
                          image: coverImage ?? "",
                          fit: BoxFit.cover,
                          height: displayHeight(context) / 2,
                        )),
                    NestedScrollView(
                        headerSliverBuilder: (context, value) {
                          return [
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      right: 20,
                                      top: 30,
                                    ),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: IconButton(
                                          onPressed: () {
                                            backPressed();
                                          },
                                          icon: Icon(
                                            Icons.keyboard_backspace_rounded,
                                            size: 20.h,
                                            color: HexColor(AppColors.appColorWhite),
                                          ),
                                        )),
                                    decoration: BoxDecoration(
                                      color: HexColor(AppColors.appColorTransparent),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: GestureDetector(
                                      onTap: _coverPicker,
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              top: 16, left: 16),
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              color: HexColor(AppColors.appColorWhite),
                                              shape: BoxShape.circle),
                                          child: Icon(
                                            Icons.edit,
                                            color: HexColor(AppColors.appColorBlack65),
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    right: 20, top: 20, bottom: 16),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                    children: <Widget>[
                                      Opacity(
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
                                                      color: HexColor(AppColors.appColorBlack),
                                                      shape: BoxShape.circle),
                                                  margin:
                                                  const EdgeInsets.all(8),
                                                  child: Container(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        4),
                                                    child: Icon(Icons.message,
                                                        color: HexColor(AppColors.appColorWhite)),
                                                  )))),
                                      Opacity(
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
                                                    color: HexColor(AppColors.appColorBlack),
                                                    shape: BoxShape.circle),
                                                margin:
                                                const EdgeInsets.all(8),
                                                child: Container(
                                                  padding:
                                                  const EdgeInsets.all(4),
                                                  child: Icon(
                                                      Icons.favorite_border,
                                                      color: HexColor(AppColors.appColorWhite)),
                                                ))),
                                      ),
                                      Opacity(
                                        opacity: 0.4,
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReportAbuse(),
                                                  ));
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: HexColor(AppColors.appColorBlack),
                                                    shape: BoxShape.circle),
                                                margin:
                                                const EdgeInsets.all(8),
                                                child: Container(
                                                  padding:
                                                  const EdgeInsets.all(4),
                                                  child: Icon(Icons.star,
                                                      color: HexColor(AppColors.appColorWhite)),
                                                ))),
                                      ),
                                      Opacity(
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
                                                      color: HexColor(AppColors.appColorBlack),
                                                      shape: BoxShape.circle),
                                                  margin:
                                                  const EdgeInsets.all(8),
                                                  child: Container(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        4),
                                                    child: Icon(Icons.forward,
                                                        color: HexColor(AppColors.appColorWhite)),
                                                  )))),
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: HexColor(AppColors.appColorTransparent),
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Card(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 16.0, bottom: 16.0),
                                      child: UserNameWithImageCard(
                                          personData: rows,
                                          instId: instituteId,
                                          title: userName,
                                          subtitle: null,
                                          isFollow: true,
                                          isPersonProfile: true,
                                          onClickProfile: _profilePicker,
                                          imageUrl: profileImage ?? "",
                                          callbackPicker: () {
                                            FlutterStatusbarcolor
                                                .setStatusBarColor(
                                                HexColor(AppColors.appColorTransparent));
                                            Route route = MaterialPageRoute(
                                                builder: (context) =>
                                                    UserProfile(
                                                        type: type,
                                                        currentPosition: 1));
                                            Navigator.pushReplacement(
                                                context, route);
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
                                        type: typeOfUser,
                                        userName: userName,
                                        textFive: followers.toString(),
                                        textSix: following.toString(),
                                        textSeven: roomsCount.toString(),
                                        textEight: roomsCount.toString(),
                                        textOne: "followers",
                                        textTwo: "following",
                                        textThree: "posts",
                                        textFour: "rooms",
                                        callback: (updateFollowers) {
                                          update(updateFollowers);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Visibility(
                                  visible: list.length > 0 ? true : false,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 0,
                                      right: 0,
                                    ),
                                    alignment: Alignment.center,
                                    child: TabBar(
                                      labelColor: HexColor(AppColors.appColorWhite),
                                      indicatorColor: HexColor(AppColors.appColorTransparent),
                                      controller: _tabController,
                                      labelPadding: EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      isScrollable: true,
                                      tabs: List<Widget>.generate(list.length,
                                              (int index) {
                                            return new Tab(
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                  ),
                                                  child: ButtonTheme(
                                                    child: RawMaterialButton(
                                                      onPressed: () {
                                                        _tabController
                                                            .animateTo(index);

                                                        if (this.mounted) {
                                                          setState(() {
                                                            _currentPosition =
                                                                index;
                                                          });
                                                        }
                                                      },
                                                      elevation: 2.0,
                                                      child: Text(
                                                          list[index].tabName,
                                                          style: styleElements
                                                              .subtitle2ThemeScalable(
                                                              context)
                                                              .copyWith(
                                                            color: index ==
                                                                _currentPosition
                                                                ? HexColor(AppColors.appColorWhite)
                                                                : Colors
                                                                .black87,
                                                          )),
                                                      fillColor: index ==
                                                          _currentPosition
                                                          ? HexColor(AppColors.appMainColor)
                                                          : HexColor(AppColors.appColorWhite),
                                                      shape:
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                      ),
                                                    ),
                                                  )),
                                            );
                                          }),
                                    ),
                                  )),
                            ),
                          ];
                        },
                        body: !isError
                            ? Visibility(
                          visible: list.length > 0 ? true : false,
                          child: Stack(
                            children: <Widget>[
                              MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: TabBarView(
                                    physics:
                                    NeverScrollableScrollPhysics(),
                                    controller: _tabController,
                                    children: List<Widget>.generate(
                                        list.length, (int index) {
                                      return new Center(
                                          child: list[_currentPosition]
                                              .statelessWidget);
                                    }),
                                  )),
                            ],
                          ),
                        )
                            : EmptyWidget(errorMessage)),
                  ],
                )));
  }

  void update(updateFollowers) {
    if (updateFollowers) {
      followersCountApi(context);
    }
  }

  void followersCountApi(BuildContext context) async {
    final body = jsonEncode({
      "object_type": typeOfUser,
      "object_id": userId,
    });
    Calls()
        .calWithoutToken(body, context, Config.FOLLOWERS_COUNT)
        .then((value) async {
      if (value != null) {
        var data = FollowersFollowingCountEntity.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          setState(() {
            followers = data.rows.followersCount ?? 0;
            following = data.rows.followingCount ?? 0;

            roomsCount = data.rows.rooms ?? 0;
          });
        } else {}
      } else {}
    }).catchError((onError) {});
  }

  void getPersonProfile(BuildContext context) async {
    final body = jsonEncode({});

    await pr.show();
    Calls().call(body, context, Config.PERSONAL_PROFILE).then((value) async {
      if (value != null) {
        await pr.hide();
        // userProfileData = PersonalProfile.fromJson(value);
        if (this.mounted) {
          setState(() {
            var data = PersonalProfile.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              await pr.hide();
              rows = data.rows;
              if (prefs != null) {
                prefs.setString("profileImage", rows.profileImage ?? "");
                prefs.setString("coverImage", rows.coverImage ?? "");

                coverImage = Config.BASE_URL + rows.coverImage;
                profileImage = Config.BASE_URL + rows.profileImage;
              }
              userId = data.rows.userId;
              personId = data.rows.id;
              prefs.setInt("userId", data.rows.id);
              prefs.setInt("userIdOriginal", userId);
              userName = data.rows.firstName ?? "";
              var location="";
              if (data.rows.middleName != null)
                userName = userName + " " + data.rows.middleName ?? "";
              if (data.rows.lastName != null)
                userName = userName + " " + data.rows.lastName ?? "";
              if (data.rows.userLocation != null)
                {

                  location = data.rows.userLocation.locality ?? "" ;
                  prefs.setString("location", location);

                }
              prefs.setString("userName", userName);
              if (data.rows.institutions != null &&
                  data.rows.institutions.isNotEmpty) {
                instituteId = data.rows.institutions[0].id.toString();
                prefs.setString("instituteId", instituteId);
                followersCountApi(context);
                list = [];
                listCardsAbout = [];
                list.add(CustomTabMaker(
                    statelessWidget: Container(), tabName: "Timeline"));
                list.add(CustomTabMaker(
                    statelessWidget: AboutPage(
                      type: "closed",
                      rows: rows,
                      listCardsAbout: listCardsAbout,
                      callBck: (){
                        _tabController.dispose();
                        _currentPosition=1;
                        _tabController = TabController(vsync: this, length: 4);
                        _tabController.addListener(onPositionChange);
                      },
                    ),
                    tabName: "About"));
                if (type == "education")
                  list.add(CustomTabMaker(
                      statelessWidget: EducationPage(
                        type: type,
                        listCardsAbout: listCardsAbout,
                      ),
                      tabName: "education"));
                else if (type == "work")
                  list.add(CustomTabMaker(
                      statelessWidget: EducationPage(
                        type: type,
                        listCardsAbout: listCardsAbout,
                      ),
                      tabName: "work"));
                else if (type == "class")
                  list.add(CustomTabMaker(
                      statelessWidget: EducationPage(
                        type: type,
                        listCardsAbout: listCardsAbout,
                      ),
                      tabName: "class"));
                else if (type == "subject")
                  list.add(CustomTabMaker(
                      statelessWidget: EducationPage(
                        type: type,
                        listCardsAbout: listCardsAbout,
                      ),
                      tabName: "subject"));
                else if (type == "language")
                  list.add(CustomTabMaker(
                      statelessWidget: EducationPage(
                        type: type,
                        listCardsAbout: listCardsAbout,
                      ),
                      tabName: "language"));
                else if (type == "skill")
                  list.add(CustomTabMaker(
                      statelessWidget: EducationPage(
                        type: type,
                        listCardsAbout: listCardsAbout,
                      ),
                      tabName: "skill"));
                else
                  list.add(CustomTabMaker(
                      statelessWidget: Container(),
                      tabName: "Media"));
                list.add(CustomTabMaker(
                    statelessWidget: Container(), tabName: "More"));

              }
            }
          });
        }
      } else {
        await pr.hide();
      }
    }).catchError((onError) {
      await pr.hide();
      print(onError.toString());
      setState(() {
        isError = true;
        errorMessage = onError.toString();
      });
      ToastBuilder().showToast(onError.toString(), context);
    });
  }

  void getUserData(BuildContext context) async {
    final body = jsonEncode({
      "institution_id": instituteId,
      "person_id": personId,
      "detail_type": "user"
    });


    Calls().call(body, context, Config.USER_PROFILE).then((value) async {
      if (value != null) {

        if (this.mounted) {
          setState(() {
            var data = BaseResponses.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              if (data.rows != null) {
                listCardData = data.rows;
                if (listCardData != null && listCardData.length > 0) {
                  for (var item in listCardData) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(
                          instituteId, true, styleElements, item, rows, "personal", callBck: () {
                        Route route = MaterialPageRoute(
                            builder: (context) =>
                                UserProfile(type: type, currentPosition: 1));
                        Navigator.pushReplacement(context, route);
                      });
                      if (widget != null) listCardsAbout.add(widget);
                    }
                  }


                    if (this.mounted) {
                      setState(() {
                        list = [];
                        listCardsAbout = listCardsAbout;
                        list.add(CustomTabMaker(
                            statelessWidget: Container(),
                            tabName: "Timeline"));
                        list.add(CustomTabMaker(
                            statelessWidget: AboutPage(
                              type: "closed",
                              listCardsAbout: listCardsAbout,
                            ),
                            tabName: "About"));
                        list.add(CustomTabMaker(
                            statelessWidget: Container(),
                            tabName: "Media"));
                        list.add(CustomTabMaker(
                            statelessWidget: Container(), tabName: "More"));
                        */
/*_tabController = TabController(vsync: this, length: 4);
                        _tabController.addListener(onPositionChange);*//*

                      });
                    }

                }
              }
            }
          });
        }
      } else {
        await pr.hide();
      }
    }).catchError((onError) {
      await pr.hide();
      setState(() {
        isError = true;
        errorMessage = onError.toString();
      });
      print(onError.toString());
      ToastBuilder().showToast(onError.toString(), context);
    });
  }



  _coverPicker() async {
    ProgressDialog pr = ToastBuilder().setProgressDialog(context);
    File pickedFile = await ImagePickerAndCropperUtil().pickImage(context);
    var croppedFile =
        await ImagePickerAndCropperUtil().cropFile(context, pickedFile);
    if (croppedFile != null) {
      await pr.show();
      var contentType =
          ImagePickerAndCropperUtil().getMimeandContentType(croppedFile.path);
      await UploadFile(
              baseUrl: Config.BASE_URL,
              context: context,
              token: prefs.getString("token"),
              contextId: rows.id.toString(),
              contextType: CONTEXTTYPE_ENUM.COVER.type,
              ownerId: rows.id.toString(),
              ownerType: OWNERTYPE_ENUM.PERSON.type,
              file: croppedFile,
              subContextId: "",
              subContextType: "",
              mimeType: contentType[1],
              contentType: contentType[0])
          .uploadFile()
          .then((value) {
        var imageResponse = ImageUpdateResponse.fromJson(value);
        updateImage(imageResponse.rows.otherUrls[0].original,
            OWNERTYPE.person.type, IMAGETYPE.cover.type);
      }).catchError((onError) {
        await pr.hide();
        print(onError.toString());
      });
    }
  }

  _profilePicker() async {
    File pickedFile = await ImagePickerAndCropperUtil().pickImage(context);
    var croppedFile =
        await ImagePickerAndCropperUtil().cropFile(context, pickedFile);
    ProgressDialog pr = ToastBuilder().setProgressDialog(context);
    if (croppedFile != null) {
      await pr.show();
      var contentType =
          ImagePickerAndCropperUtil().getMimeandContentType(croppedFile.path);
      await UploadFile(
              baseUrl: Config.BASE_URL,
              context: context,
              token: prefs.getString("token"),
              contextId: rows.id.toString(),
              contextType: CONTEXTTYPE_ENUM.PROFILE.type,
              ownerId: rows.id.toString(),
              ownerType: OWNERTYPE_ENUM.PERSON.type,
              file: croppedFile,
              subContextId: "",
              subContextType: "",
              mimeType: contentType[1],
              contentType: contentType[0])
          .uploadFile()
          .then((value) {
        var imageResponse = ImageUpdateResponse.fromJson(value);
        updateImage(imageResponse.rows.otherUrls[0].original,
            OWNERTYPE.person.type, IMAGETYPE.profile.type);
      }).catchError((onError) {
        await pr.hide();
        print(onError.toString());
      });
    }
  }

  updateImage(String url, String ownerType, String imageType) async {
    ImageUpdateRequest request = ImageUpdateRequest();
    request.imagePath = url;
    request.imageType = imageType;
    request.ownerId = rows.id;
    request.ownerType = ownerType;
    var data = jsonEncode(request);
    Calls().call(data, context, Config.IMAGEUPDATE).then((value) {
      ProgressDialog pr = ToastBuilder().setProgressDialog(context);
      await pr.hide();
      var resposne = DynamicResponse.fromJson(value);
      if (resposne.statusCode == Strings.success_code) {
        if (imageType == IMAGETYPE.cover.type) {
          if (prefs != null) prefs.setString("coverImage", url);
          setState(() {
            coverImage = Config.BASE_URL + url;
          });
        } else {
          if (prefs != null) prefs.setString("profileImage", url);

          setState(() {
            profileImage = Config.BASE_URL + url;
          });
        }
      }
    });
  }

  onPositionChange() {
    if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
        _currentPosition = _tabController.index;
        if (_tabController.index == 3) {
          _showModalBottomSheet(context);
        }
      });
    }
  }

  onTabClicked() {
    if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
        _currentPosition = _tabController.index;
        if (_tabController.index == 3) {
          _showModalBottomSheet(context);
        }
      });
    }
  }

  _getCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    if (_locationData != null) {
      prefs.setDouble("lat", _locationData.latitude);
      prefs.setDouble("longi", _locationData.longitude);
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
        return BottomSheetContent();
      },
    );
  }

  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    pr = ToastBuilder().setProgressDialog(context);
    if (prefs.getString("coverImage") != null)
      coverImage =
          Config.BASE_URL + prefs.getString("coverImage") ?? "";
    if (prefs.getString("profileImage") != null)
      profileImage =
          Config.BASE_URL + prefs.getString("profileImage") ?? "";

    styleElements = TextStyleElements(context);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getPersonProfile(context));
    _getCurrentLocation();
  }

  void backPressed() {
    Navigator.of(context).pop({'result': "update"});
  }
}

// ignore: must_be_immutable
class AboutPage extends StatefulWidget {
  final String type;
  final Persondata rows;
  final List<StatelessWidget> listCardsAbout;
 final Null Function() callBck;
  const AboutPage(
      {Key key, @required this.type, this.listCardsAbout, this.rows,this.callBck})
      : super(key: key);

  _AboutPage createState() => _AboutPage(type, listCardsAbout, rows,callBck);
}

class _AboutPage extends State<AboutPage> {
  final Null Function() callBck;
  final String type;
  final List<StatelessWidget> listCardsAbout;
  List<CommonCardData> listCardData = [];
  SharedPreferences prefs;
  Persondata rows;
  TextStyleElements styleElements;
  ProgressDialog pr;

  _AboutPage(this.type, this.listCardsAbout, this.rows,this.callBck);


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    setSharedPreferences();
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

    WidgetsBinding.instance.addPostFrameCallback((_) => getUserData(context));
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Expanded(
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: NotificationListener(
            child:  listCardsAbout.isNotEmpty?ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: listCardsAbout.length,
                itemBuilder: (context, index) {
                  return listCardsAbout[index];
                }):CircularProgressIndicator(),
            // ignore: missing_return
            onNotification: (t) {
              if (t is ScrollStartNotification) {}
            },
          ),
        ));
  }

  void getUserData(BuildContext context) async {

    final body = jsonEncode({
      "institution_id": prefs.getString("instituteId"),
      "person_id": prefs.getInt("userId").toString(),
      "detail_type": "user"
    });


    Calls().call(body, context, Config.USER_PROFILE).then((value) async {
      if (value != null) {

        if (this.mounted) {
          setState(() {
            var data = BaseResponses.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              if (data.rows != null) {
                listCardData = data.rows;
                if (listCardData != null && listCardData.length > 0) {
                  for (var item in listCardData) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(
                          null, true, styleElements, item, rows,"personal",  callBck: () {

                        callBck();
                    */
/*    Route route = MaterialPageRoute(
                            builder: (context) =>
                                UserProfile(type: "", currentPosition: 1));
                        Navigator.pushReplacement(context, route);*//*

                      });
                      if (widget != null) listCardsAbout.add(widget);
                    }
                  }
                }
              }
            }
          });
        }
      } else {

      }
    }).catchError((onError) {

      setState(() {});
      print(onError.toString());
      ToastBuilder().showToast(onError.toString(), context);
    });
  }
}

class BottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    return Wrap(children: [
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
                  "More Options",
                  style: styleElements.headline6ThemeScalable(context),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        type: "education",
                        currentPosition: 2,
                      ),
                    ));
                if (result != null && result['result'] == "update") {
                  Route route = MaterialPageRoute(
                      builder: (context) =>
                          UserProfile(type: "", currentPosition: 1));
                  Navigator.pushReplacement(context, route);
                }
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.all(4.h),
                    child: ListTile(

                      title: Text(
                        AppLocalizations.of(context).translate("education"),
                        style: styleElements.headline6ThemeScalable(context),
                      ),
                    )),
              ),
            ),
            GestureDetector(
              onTap: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        type: "work",
                        currentPosition: 2,
                      ),
                    ));
                if (result != null && result['result'] == "update") {
                  Route route = MaterialPageRoute(
                      builder: (context) =>
                          UserProfile(type: "", currentPosition: 1));
                  Navigator.pushReplacement(context, route);
                }
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.all(4.h),
                    child: ListTile(

                      title: Text(
                        AppLocalizations.of(context)
                            .translate("work_experience"),
                        style: styleElements.headline6ThemeScalable(context),
                      ),
                    )),
              ),
            ),
            GestureDetector(
              onTap: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        type: "subject",
                        currentPosition: 2,
                      ),
                    ));
                if (result != null && result['result'] == "update") {
                  Route route = MaterialPageRoute(
                      builder: (context) =>
                          UserProfile(type: "", currentPosition: 1));
                  Navigator.pushReplacement(context, route);
                }
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.all(4.h),
                    child: ListTile(

                      title: Text(
                        AppLocalizations.of(context).translate("subject"),
                        style: styleElements.headline6ThemeScalable(context),
                      ),
                    )),
              ),
            ),
            GestureDetector(
              onTap: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        type: "class",
                        currentPosition: 2,
                      ),
                    ));
                if (result != null && result['result'] == "update") {
                  Route route = MaterialPageRoute(
                      builder: (context) =>
                          UserProfile(type: "", currentPosition: 1));
                  Navigator.pushReplacement(context, route);
                }
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.all(4.h),
                    child: ListTile(

                      title: Text(
                        AppLocalizations.of(context)
                            .translate("classes_branches"),
                        style: styleElements.headline6ThemeScalable(context),
                      ),
                    )),
              ),
            ),
            GestureDetector(
              onTap: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        type: "language",
                        currentPosition: 2,
                      ),
                    ));
                if (result != null && result['result'] == "update") {
                  Route route = MaterialPageRoute(
                      builder: (context) =>
                          UserProfile(type: "", currentPosition: 1));
                  Navigator.pushReplacement(context, route);
                }
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.all(4.h),
                    child: ListTile(

                      title: Text(
                        AppLocalizations.of(context).translate("language"),
                        style: styleElements.headline6ThemeScalable(context),
                      ),
                    )),
              ),
            ),
            GestureDetector(
              onTap: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        type: "skill",
                        currentPosition: 2,
                      ),
                    ));
                if (result != null && result['result'] == "update") {
                  Route route = MaterialPageRoute(
                      builder: (context) =>
                          UserProfile(type: "", currentPosition: 1));
                  Navigator.pushReplacement(context, route);
                }
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.all(4.h),
                    child: ListTile(

                      title: Text(
                        AppLocalizations.of(context).translate("skill"),
                        style: styleElements.headline6ThemeScalable(context),
                      ),
                    )),
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
// ignore: must_be_immutable
class EducationPage extends StatefulWidget {
  final String type;
  final Persondata rows;
  final List<StatelessWidget> listCardsAbout;
  final String instituteId;
  const EducationPage(
      {Key key, @required this.type, this.listCardsAbout, this.rows,this.instituteId})
      : super(key: key);

  _EducationPage createState() => _EducationPage(type, listCardsAbout, rows,instituteId);
}
class _EducationPage extends State<EducationPage> {
  String type;
  List<StatelessWidget> listCardsAbout = [];
  TextStyleElements styleElements;
  BuildContext context;
  String instituteId;
  final Persondata rows;
  List<CommonCardData> listCardData = [];
  SharedPreferences prefs;
  _EducationPage(this.type, this.listCardsAbout, this.rows,this.instituteId);
  Widget _simplePopup(String type) => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(type == "work"
                ? "Add Work"
                : type == "education"
                    ? "Add Education"
                    : type == "class"
                        ? "Add Class"
                        : type == "subject"
                            ? "Add Subject"
                            : type == "skill"
                                ? "Add Skill"
                                : type == "language" ? "Add Language" : ""),
          ),
        ],
        onSelected: (value) async {
          if (type == "work") {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditEducation(null, false, false, null)));

            if (result != null && result['result'] == "success") {
              Route route = MaterialPageRoute(
                  builder: (context) =>
                      UserProfile(type: "work", currentPosition: 2));
              Navigator.pushReplacement(context, route);
            }
          } else if (type == "education") {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditEducation(null, true, false, null)));

            if (result != null && result['result'] == "success") {

              Route route = MaterialPageRoute(
                  builder: (context) =>
                      UserProfile(type: "education", currentPosition: 2));
              Navigator.pushReplacement(context, route);
            }
          } else if (type == "class") {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectInstituteSingle(false, null),
                ));

            if (result != null && result['result'] == "success") {
              Route route = MaterialPageRoute(
                  builder: (context) =>
                      UserProfile(type: "class", currentPosition: 2));
              Navigator.pushReplacement(context, route);
            }
          } else if (type == "subject") {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddSelectSubject(int.parse(instituteId), false, null)));

            if (result != null && result['result'] == "success") {
              Route route = MaterialPageRoute(
                  builder: (context) =>
                      UserProfile(type: "subject", currentPosition: 2));
              Navigator.pushReplacement(context, route);
            }
          } else if (type == "skill") {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditLanguage("Skill", instituteId, false, null),
                ));

            if (result != null && result['result'] == "success") {
              Route route = MaterialPageRoute(
                  builder: (context) =>
                      UserProfile(type: "skill", currentPosition: 2));
              Navigator.pushReplacement(context, route);
            }
          } else if (type == "language") {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditLanguage("Languages", instituteId, false, null),
                ));

            if (result != null && result['result'] == "success") {
              Route route = MaterialPageRoute(
                  builder: (context) =>
                      UserProfile(type: "language", currentPosition: 2));
              Navigator.pushReplacement(context, route);
            }
          }
        },
        icon: Icon(
          Icons.more_horiz,
          size: 30,
          color: HexColor(AppColors.appColorBlack85),
        ),
      );

  @override
  void initState() {
    super.initState();

    setSharedPreferences();

  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    instituteId=prefs.getString("instituteId");
    if (type == "education")
      WidgetsBinding.instance.addPostFrameCallback((_) => getEducations(context));
    else if (type == "work")
      WidgetsBinding.instance.addPostFrameCallback((_) => getWorkExperience(context));
    else if (type == "class")
      WidgetsBinding.instance.addPostFrameCallback((_) => getDetailedClasses(context));
    else if (type == "subject")
      WidgetsBinding.instance.addPostFrameCallback((_) => getDetailedSubjects(context));
    else if (type == "language")
      WidgetsBinding.instance.addPostFrameCallback((_) => getLanguagesDetail(context,"language"));
    else if (type == "skill")
      WidgetsBinding.instance.addPostFrameCallback((_) => getLanguagesDetail(context,"skill"));
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.context = context;
    return Flexible(
        child: Container(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 12),
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
              Flexible(
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 16.0.h, right: 16.h, top: 12.h, bottom: 12.h),
                      child: Text(
                        type == "work"
                            ? AppLocalizations.of(context)
                                .translate("work_experience")
                            : type == "class"
                                ? AppLocalizations.of(context)
                                    .translate("classes_branches")
                                : type == "subject"
                                    ? AppLocalizations.of(context)
                                        .translate("subjects")
                                    : type == "skill"
                                        ? AppLocalizations.of(context)
                                            .translate("skill")
                                        : type == "language"
                                            ? AppLocalizations.of(context)
                                                .translate("language")
                                            : AppLocalizations.of(context)
                                                .translate("education"),
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
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: _simplePopup(type == "work"
                          ? "work"
                          : type == "class"
                              ? "class"
                              : type == "subject"
                                  ? "subject"
                                  : type == "skill"
                                      ? "skill"
                                      : type == "language"
                                          ? "language"
                                          : "education")),
                ),
                flex: 1,
              ),
            ],
          ),
          Visibility(
              visible: false,
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 16.0.h, right: 16.h, top: 12.h, bottom: 12.h),
                    child: Text(
                      AppLocalizations.of(context).translate("set_role"),
                      style: styleElements.captionThemeScalable(context),
                      textAlign: TextAlign.left,
                    ),
                  ))),
          Flexible(
              child: Container(
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.only(bottom: 8),
            child: NotificationListener(
              child: listCardsAbout.isNotEmpty?ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: listCardsAbout.length,
                  itemBuilder: (context, index) {
                    return listCardsAbout[index];
                  }):CircularProgressIndicator(),
              // ignore: missing_return
              onNotification: (t) {
                if (t is ScrollStartNotification) {}
              },
            ),
          ))
        ],
      ),
    ));
  }

  void getEducations(BuildContext context) async {
    final body = jsonEncode({
      "person_id": prefs.getInt("userId").toString(),
      "type": "person",
      "all_institutions_id": prefs.getString("instituteId"),
      "page_number": 1,
      "page_size": 100
    });

    Calls().call(body, context, Config.EDUCATIONS).then((value) async {
      if (value != null) {

        if (this.mounted) {
          setState(() {
            var data = BaseResponses.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {

              if (data.rows != null) {
                listCardData = data.rows;
                if (listCardData != null && listCardData.length > 0) {
                  for (var item in listCardData) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(
                          instituteId, false, styleElements, item, rows, "personal", callBck: () {

                        */
/*  getEducations(context);*//*

                        Route route = MaterialPageRoute(
                            builder: (context) => UserProfile(
                                type: "education", currentPosition: 2));
                        Navigator.pushReplacement(context, route);
                      });
                      if (widget != null) listCardsAbout.add(widget);
                    }
                  }
                  if (this.mounted) {
                    setState(() {
                      listCardsAbout = listCardsAbout;

                    });
                  }
                }
              }
            }
          });
        }
      } else {

      }
    }).catchError((onError) {


      print(onError.toString());
      ToastBuilder().showToast(onError.toString(), context);
    });
  }

  void getWorkExperience(BuildContext context) async {
    final body = jsonEncode({
      "person_id": prefs.getInt("userId").toString(),
      "type": "person",
      "all_institutions_id": prefs.getString("instituteId"),
      "page_number": 1,
      "page_size": 100
    });

    Calls().call(body, context, Config.WORK_EXP).then((value) async {
      if (value != null) {

        if (this.mounted) {
          setState(() {
            var data = BaseResponses.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {

              if (data.rows != null) {
                listCardData = data.rows;
                if (listCardData != null && listCardData.length > 0) {
                  for (var item in listCardData) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(
                          instituteId, false, styleElements, item, rows,"personal",  callBck: () {
                        print(
                            "work000000000000000000000000000000000000000000000000000000000000");
                        Route route = MaterialPageRoute(
                            builder: (context) =>
                                UserProfile(type: type, currentPosition: 2));
                        Navigator.pushReplacement(context, route);
                      });
                      if (widget != null) listCardsAbout.add(widget);
                    }
                  }

                }
              }
            }
          });
        }
      } else {

      }
    }).catchError((onError) {


      print(onError.toString());
      ToastBuilder().showToast(onError.toString(), context);
    });
  }

  void getDetailedClasses(BuildContext context) async {
    final body = jsonEncode({
      "person_id": prefs.getInt("userId").toString(),
      "type": "person",
      "all_institutions_id": prefs.getString("instituteId"),
      "page_number": 1,
      "page_size": 100
    });

    Calls().call(body, context, Config.DETAIL_CLASSES).then((value) async {
      if (value != null) {

        if (this.mounted) {
          setState(() {
            var data = BaseResponses.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {

              if (data.rows != null) {
                listCardData = data.rows;

                if (listCardData != null && listCardData.length > 0) {
                  for (var item in listCardData) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(
                          instituteId, false, styleElements, item, rows, "personal", callBck: () {
                        print(
                            "classsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
                        Route route = MaterialPageRoute(
                            builder: (context) =>
                                UserProfile(type: type, currentPosition: 2));
                        Navigator.pushReplacement(context, route);
                      });
                      if (widget != null) listCardsAbout.add(widget);
                    }
                  }

                }
              }
            }
          });
        }
      } else {

      }
    }).catchError((onError) {


      print(onError.toString());
      ToastBuilder().showToast(onError.toString(), context);
    });
  }

  void getDetailedSubjects(BuildContext context) async {
    final body = jsonEncode({
      "person_id": prefs.getInt("userId").toString(),
      "type": "person",
      "all_institutions_id": prefs.getString("instituteId"),
      "page_number": 1,
      "page_size": 100
    });

    Calls().call(body, context, Config.DETAILS_SUBJECTS).then((value) async {
      if (value != null) {

        if (this.mounted) {
          setState(() {
            var data = BaseResponses.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {

              if (data.rows != null) {
                listCardData = data.rows;

                if (listCardData != null && listCardData.length > 0) {
                  for (var item in listCardData) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(
                          instituteId, false, styleElements, item, rows,"personal",  callBck: () {
                        print(
                            "subject00000000000000000000000000000000000000000000000000000000000000000");
                        Route route = MaterialPageRoute(
                            builder: (context) =>
                                UserProfile(type: type, currentPosition: 2));
                        Navigator.pushReplacement(context, route);
                      });
                      if (widget != null) listCardsAbout.add(widget);
                    }
                  }

                }
              }
            }
          });
        }
      }
      {

      }
    }).catchError((onError) {

      print(onError.toString());
      ToastBuilder().showToast(onError.toString(), context);
    });
  }

  void getLanguagesDetail(BuildContext context, String type) async {
    final body = jsonEncode({
      "person_id": prefs.getInt("userId"),
      "standard_expertise_category": type == "language" ? "2" : "4",
      "page_number": 1,
      "page_size": 100
    });

    Calls()
        .call(body, context, Config.LANGUAGE_SKILLS_SEE_MORE)
        .then((value) async {
      if (value != null) {

        if (this.mounted) {
          setState(() {
            var data = BaseResponses.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {

              if (data.rows != null) {
                listCardData = data.rows;

                if (listCardData != null && listCardData.length > 0) {
                  for (var item in listCardData) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(
                          instituteId, false, styleElements, item, rows, "personal", callBck: () {
                        Route route = MaterialPageRoute(
                            builder: (context) =>
                                UserProfile(type: type, currentPosition: 2));
                        Navigator.pushReplacement(context, route);
                      });
                      if (widget != null) listCardsAbout.add(widget);
                    }
                  }

                }
              }
            }
          });
        }
      }
      {

      }
    }).catchError((onError) {
      print(onError.toString());
      ToastBuilder().showToast(onError.toString(), context);
    });
  }
}
*/
