/*
import 'dart:convert';
import 'dart:io';
import 'package:GlobalUploadFilePkg/Enums/subcontexttype.dart';
import 'package:oho_works_app/ui/edit_education.dart';
import 'package:oho_works_app/ui/select_entity_single.dart';

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
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
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_subject_select_screen.dart';
import 'camera_module/photo_preview_screen.dart';
import 'create_facility.dart';
import 'directions.dart';
import 'edit_language-page.dart';
import 'package:oho_works_app/utils/colors.dart';

// ignore: must_be_immutable
class InstitutionProfile extends StatefulWidget {
  final String type;
  final int currentPosition;
  final int instituteId;

  const InstitutionProfile(
      {Key key,
      @required this.type,
      @required this.currentPosition,
      @required this.instituteId})
      : super(key: key);

  _InstituteState createState() =>
      _InstituteState(type, currentPosition, instituteId);
}

class _InstituteState extends State<InstitutionProfile>
    with SingleTickerProviderStateMixin {
  String type;
  int _currentPosition;

  _InstituteState(String type, int currentPosition, this.instituteId) {
    this.type = type;
    this._currentPosition = currentPosition;
  }

  var typeOfUser = "person";
  var userId;
  var personId;
  TextStyleElements styleElements;
  var userName = "";
  bool isFollow = false;
  SharedPreferences prefs;
  int instituteId;
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
  BuildContext context;
  var followers = 0;
  var following = 0;
  var roomsCount = 0;
  String profileImage = "";
  String coverImage = "";
  String location="";
  bool isError = false;
  String errorMessage = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setSharedPreferences();
  }

  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      builder: (context) {
        return BottomSheetContent(instituteId);
      },
    );
  }
  
  
  
  double displayWidth(BuildContext context) {
    debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    styleElements = TextStyleElements(context);
    userId = prefs.getInt("userId");
    personId = prefs.getInt("userId");
    WidgetsBinding.instance.addPostFrameCallback((_) => getUserData(context));
  }

  void backPressed() {
    Navigator.of(context).pop({'result': "update"});
  }

  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    this.context = context;
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
            body: DefaultTabController(
              length: list.length,
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: HexColor(AppColors.appColorBackground),
                  body: Stack(
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
                                            title: userName,
                                            subtitle: location,
                                            isFollow: isFollow,
                                            userId: userId,
                                            thirdPersonId: instituteId,
                                            isPersonProfile: false,
                                            onClickProfile: () {},
                                            imageUrl: profileImage ?? "",
                                            callbackPicker: () {
                                              Route route = MaterialPageRoute(
                                                  builder: (context) =>
                                                      InstitutionProfile(
                                                          instituteId:
                                                              instituteId,
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
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8,
                                                                right: 8),
                                                        child: Text(
                                                            list[index].tabName,
                                                            style: styleElements
                                                                .subtitle2ThemeScalable(
                                                                    context)
                                                                .copyWith(
                                                                  color: index ==
                                                                          _currentPosition
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black87,
                                                                ))),
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
                  )),
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

  void getUserData(BuildContext context) async {
    final body = jsonEncode({
      "institution_id": instituteId.toString(),
      "person_id": prefs.getInt("userId"),
      "detail_type": "institution"
    });
    ProgressDialog pr = ToastBuilder().setProgressDialog(context);
    await pr.show();
    Calls().call(body, context, Config.USER_PROFILE).then((value) async {
      if (value != null) {
        await pr.hide();
        if (this.mounted) {
          setState(() {
            var data = BaseResponses.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              await pr.hide();
              if (data.rows != null) {
                listCardData = data.rows;
                if (listCardData != null && listCardData.length > 0) {
                  for (var item in listCardData) {
                    if (item != null) {
                      if (item != null && item.cardName == "profileNameCard") {
                        profileImage = item.image ?? "";
                        coverImage = item.coverImage ?? "";
                        userName = item.name ?? "";
                        location=item.localityInstitute??"";
                        isFollow = item.isFollow ?? false;
                      }

                      var widget = GetAllCards().getCard(instituteId.toString(),
                          true, styleElements, item, rows,"institute", callBck: () {
   Route route = MaterialPageRoute(
                            builder: (context) => InstitutionProfile(
                                instituteId: instituteId,
                                type: type, currentPosition: 1));
                        Navigator.pushReplacement(context, route);


                      });
                      if (widget != null) listCardsAbout.add(widget);
                    }
                  }
                  if (type == "education")
                    getEducations(context);
                  else if (type == "work")
                    getWorkExperience(context);
                  else if (type == "class")
                    getDetailedClasses(context);
                  else if (type == "subject")
                    getDetailedSubjects(context);
                  else if (type == "medium")
                    getMediums(context, "medium");
                  else if (type == "course")
                    getCourses(context, "courses");
                  else if (type == "club")
                    getClubs(context, "club");
                  else if (type == "sports")
                    getSports(context, "sports");
                  else if (type == "photos")
                    getPhotos(
                        context,
                        AppLocalizations.of(context)
                            .translate("campus_facilities"));
                  else {
                    if (this.mounted) {
                      setState(() {
                        list = [];
                        listCardsAbout = listCardsAbout;
                        list.add(CustomTabMaker(
                            statelessWidget: AboutPage(
                              type: "open",
                              listCardsAbout: listCardsAbout,
                            ),
                            tabName: "Timeline"));
                        list.add(CustomTabMaker(
                            statelessWidget: AboutPage(
                              type: "closed",
                              listCardsAbout: listCardsAbout,
                            ),
                            tabName: "About"));
                        list.add(CustomTabMaker(
                            statelessWidget: AboutPage(
                              type: "closed",
                              listCardsAbout: listCardsAbout,
                            ),
                            tabName: "Media"));
                        list.add(CustomTabMaker(
                            statelessWidget: AboutPage(
                              type: "assigned",
                              listCardsAbout: listCardsAbout,
                            ),
                            tabName: "More"));
                        _tabController =
                            TabController(vsync: this, length: list.length);
                        _tabController.addListener(onPositionChange);
                      });
                    }
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

  void getEducations(BuildContext context) async {
    final body =
        jsonEncode({"person_id": personId, "page_number": 1, "page_size": 50});
    ProgressDialog pr = ToastBuilder().setProgressDialog(context);
    await pr.show();
    Calls().call(body, context, Config.EDUCATIONS).then((value) async {
      if (value != null) {
        await pr.hide();
        if (this.mounted) {
          setState(() {
            var data = BaseResponses.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              await pr.hide();
              if (data.rows != null) {
                listEducations = data.rows;
                if (listEducations != null && listEducations.length > 0) {
                  for (var item in listEducations) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(instituteId.toString(),
                          false, styleElements, item, rows,"institute", callBck: () {
    Route route = MaterialPageRoute(
                            builder: (context) => InstitutionProfile(
                                instituteId: instituteId,
                                type: "education", currentPosition: 2));
                        Navigator.pushReplacement(context, route);


                      });
                      if (widget != null) listEducationCard.add(widget);
                    }
                  }
                  if (this.mounted) {
                    setState(() {
                      list = [];
                      listCardsAbout = listCardsAbout;
                      listEducationCard = listEducationCard;
                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "open",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "Timeline"));
                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "closed",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "About"));
                      list.add(CustomTabMaker(
                          statelessWidget: EducationPage(
                            type: "education",
                            listCardsAbout: listEducationCard,
                            instituteId: instituteId.toString(),
                          ),
                          tabName: "Education"));

                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "assigned",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "More"));
                      _tabController =
                          TabController(vsync: this, length: list.length);
                      _tabController.addListener(onPositionChange);
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

  void getWorkExperience(BuildContext context) async {
    final body =
        jsonEncode({"person_id": personId, "page_number": 1, "page_size": 50});
    ProgressDialog pr = ToastBuilder().setProgressDialog(context);
    await pr.show();
    Calls().call(body, context, Config.WORK_EXP).then((value) async {
      if (value != null) {
        await pr.hide();
        if (this.mounted) {
          setState(() {
            var data = BaseResponses.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              await pr.hide();
              if (data.rows != null) {
                listEducations = data.rows;
                if (listEducations != null && listEducations.length > 0) {
                  for (var item in listEducations) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(instituteId.toString(),
                          false, styleElements, item, rows,"institute", callBck: () {

                      });
                      if (widget != null) listEducationCard.add(widget);
                    }
                  }
                  if (this.mounted) {
                    setState(() {
                      list = [];
                      listCardsAbout = listCardsAbout;
                      listEducationCard = listEducationCard;
                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "open",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "Timeline"));
                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "closed",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "About"));

                      list.add(CustomTabMaker(
                          statelessWidget: EducationPage(
                            type: "work",
                            listCardsAbout: listEducationCard,
                            instituteId: instituteId.toString(),
                          ),
                          tabName: "Work"));

                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "assigned",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "More"));
                      _tabController =
                          TabController(vsync: this, length: list.length);
                      _tabController.addListener(onPositionChange);
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

  void getDetailedClasses(BuildContext context) async {
    final body = jsonEncode({
      "person_id": personId.toString(),
      "type": "institution",
      "all_institutions_id": instituteId.toString(),
      "page_number": 1,
      "page_size": 100
    });
    ProgressDialog pr = ToastBuilder().setProgressDialog(context);
    await pr.show();
    Calls().call(body, context, Config.DETAIL_CLASSES).then((value) async {
      if (value != null) {
        await pr.hide();
        if (this.mounted) {
          setState(() {
            var data = BaseResponses.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              await pr.hide();
              if (data.rows != null) {
                listClasses = data.rows;

                if (listClasses != null && listClasses.length > 0) {
                  for (var item in listClasses) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(instituteId.toString(),
                          false, styleElements, item, rows,"institute", callBck: () {
  print(
                            "classsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
                        Route route = MaterialPageRoute(
                            builder: (context) => InstitutionProfile(
                              instituteId: instituteId,
                                type: type, currentPosition: 2));
                        Navigator.pushReplacement(context, route);


                      });
                      if (widget != null) listCardsClasses.add(widget);
                    }
                  }
                  if (this.mounted) {
                    setState(() {
                      list = [];
                      listCardsAbout = listCardsAbout;
                      listCardsClasses = listCardsClasses;
                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "open",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "Timeline"));
                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "closed",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "About"));

                      list.add(CustomTabMaker(
                        statelessWidget: EducationPage(
                          type: "class",
                          listCardsAbout: listCardsClasses,
                          instituteId: instituteId.toString(),
                        ),
                        tabName:
                            AppLocalizations.of(context).translate("classes_"),
                      ));

                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "assigned",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "More"));
                      _tabController =
                          TabController(vsync: this, length: list.length);
                      _tabController.addListener(onPositionChange);
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

  void getDetailedSubjects(BuildContext context) async {
    final body = jsonEncode({
      "person_id": personId,
      "type": "institution",
      "all_institutions_id": instituteId,
      "page_number": 1,
      "page_size": 100
    });
    ProgressDialog pr = ToastBuilder().setProgressDialog(context);
    await pr.show();
    Calls().call(body, context, Config.DETAILS_SUBJECTS).then((value) async {
      if (value != null) {
        await pr.hide();
        if (this.mounted) {
          setState(() {
            var data = BaseResponses.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              await pr.hide();
              if (data.rows != null) {
                listSubjects = data.rows;

                if (listSubjects != null && listSubjects.length > 0) {
                  for (var item in listSubjects) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(instituteId.toString(),
                          false, styleElements, item, rows, "institute", callBck: () {
   print(
                            "subject00000000000000000000000000000000000000000000000000000000000000000");
                        Route route = MaterialPageRoute(
                            builder: (context) => InstitutionProfile(
                                instituteId: instituteId,
                                type: type, currentPosition: 2));
                        Navigator.pushReplacement(context, route);


                      });
                      if (widget != null) listSubjectCards.add(widget);
                    }
                  }
                  if (this.mounted) {
                    setState(() {
                      list = [];
                      listCardsAbout = listCardsAbout;
                      listCardsClasses = listCardsClasses;
                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "open",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "Timeline"));
                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "closed",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "About"));

                      list.add(CustomTabMaker(
                        statelessWidget: EducationPage(
                          type: "subject",
                          listCardsAbout: listSubjectCards,
                          instituteId: instituteId.toString(),
                        ),
                        tabName:
                            AppLocalizations.of(context).translate("subjects"),
                      ));

                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "assigned",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "More"));
                      _tabController =
                          TabController(vsync: this, length: list.length);
                      _tabController.addListener(onPositionChange);
                    });
                  }
                }
              }
            }
          });
        }
      }
      {
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

  void getMediums(BuildContext context, String type) async {
    final body = jsonEncode({
      "person_id": personId,
      "institution_id": instituteId.toString(),
      "page_number": 1,
      "page_size": 100
    });
    ProgressDialog pr = ToastBuilder().setProgressDialog(context);
    await pr.show();
    Calls().call(body, context, Config.MEDIUM_SEE_MORE).then((value) async {
      if (value != null) {
        await pr.hide();
        if (this.mounted) {
          setState(() {
            var data = BaseResponses.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              await pr.hide();
              if (data.rows != null) {
                listSubjects = data.rows;

                if (listSubjects != null && listSubjects.length > 0) {
                  for (var item in listSubjects) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(instituteId.toString(),
                          false, styleElements, item, rows,"institute",
                          callBck: () {});
                      if (widget != null) listSubjectCards.add(widget);
                    }
                  }
                  if (this.mounted) {
                    setState(() {
                      list = [];
                      listCardsAbout = listCardsAbout;
                      listCardsClasses = listCardsClasses;
                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "open",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "Timeline"));
                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "closed",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "About"));

                      list.add(CustomTabMaker(
                        statelessWidget: EducationPage(
                          type: type,
                          listCardsAbout: listSubjectCards,
                          instituteId: instituteId.toString(),
                        ),
                        tabName: AppLocalizations.of(context).translate(type),
                      ));

                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "assigned",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "More"));
                      _tabController =
                          TabController(vsync: this, length: list.length);
                      _tabController.addListener(onPositionChange);
                    });
                  }
                }
              }
            }
          });
        }
      }
      {
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

  void getCourses(BuildContext context, String type) async {
    final body = jsonEncode({
      "person_id": personId,
      "institution_id": instituteId.toString(),
      "page_number": 1,
      "page_size": 100
    });
    ProgressDialog pr = ToastBuilder().setProgressDialog(context);
    await pr.show();
    Calls().call(body, context, Config.COURSES_SEE_MORE).then((value) async {
      if (value != null) {
        await pr.hide();
        if (this.mounted) {
          setState(() {
            var data = BaseResponses.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              await pr.hide();
              if (data.rows != null) {
                listSubjects = data.rows;

                if (listSubjects != null && listSubjects.length > 0) {
                  for (var item in listSubjects) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(instituteId.toString(),
                          false, styleElements, item, rows,"institute",
                          callBck: () {});
                      if (widget != null) listSubjectCards.add(widget);
                    }
                  }
                  if (this.mounted) {
                    setState(() {
                      list = [];
                      listCardsAbout = listCardsAbout;
                      listCardsClasses = listCardsClasses;
                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "open",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "Timeline"));
                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "closed",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "About"));

                      list.add(CustomTabMaker(
                        statelessWidget: EducationPage(
                          type: type,
                          listCardsAbout: listSubjectCards,
                          instituteId: instituteId.toString(),
                        ),
                        tabName: AppLocalizations.of(context).translate(type),
                      ));

                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "assigned",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "More"));
                      _tabController =
                          TabController(vsync: this, length: list.length);
                      _tabController.addListener(onPositionChange);
                    });
                  }
                }
              }
            }
          });
        }
      }
      {
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

  void getClubs(BuildContext context, String type) async {
    final body = jsonEncode({
      "person_id": personId,
      "institution_id": instituteId.toString(),
      "page_number": 1,
      "page_size": 100
    });
    ProgressDialog pr = ToastBuilder().setProgressDialog(context);
    await pr.show();
    Calls().call(body, context, Config.CLUBS_SEE_MORE).then((value) async {
      if (value != null) {
        await pr.hide();
        if (this.mounted) {
          setState(() {
            var data = BaseResponses.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              await pr.hide();
              if (data.rows != null) {
                listSubjects = data.rows;

                if (listSubjects != null && listSubjects.length > 0) {
                  for (var item in listSubjects) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(instituteId.toString(),
                          false, styleElements, item, rows,"institute",
                          callBck: () {});
                      if (widget != null) listSubjectCards.add(widget);
                    }
                  }
                  if (this.mounted) {
                    setState(() {
                      list = [];
                      listCardsAbout = listCardsAbout;
                      listCardsClasses = listCardsClasses;
                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "open",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "Timeline"));
                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "closed",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "About"));

                      list.add(CustomTabMaker(
                        statelessWidget: EducationPage(
                          type: type,
                          listCardsAbout: listSubjectCards,
                          instituteId: instituteId.toString(),
                        ),
                        tabName: AppLocalizations.of(context).translate(type),
                      ));

                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "assigned",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "More"));
                      _tabController =
                          TabController(vsync: this, length: list.length);
                      _tabController.addListener(onPositionChange);
                    });
                  }
                }
              }
            }
          });
        }
      }
      {
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

  void getPhotos(BuildContext context, String type) async {
    var res = await rootBundle.loadString('assets/common_profile_json.json');

    final Map parsed = json.decode(res);

    listSubjects = BaseResponses.fromJson(parsed).rows;
    if (listSubjects != null && listSubjects.length > 0) {
      for (var item in listSubjects) {
        if (item != null) {
          var widget = GetAllCards().getCard(
              instituteId.toString(), false, styleElements, item, rows,"institute",
              callBck: () {});
          if (widget != null) listSubjectCards.add(widget);
        }
      }
      if (this.mounted) {
        setState(() {
          list = [];
          listCardsAbout = listCardsAbout;
          listCardsClasses = listCardsClasses;
          list.add(CustomTabMaker(
              statelessWidget: AboutPage(
                type: "open",
                listCardsAbout: listCardsAbout,
              ),
              tabName: "Timeline"));
          list.add(CustomTabMaker(
              statelessWidget: AboutPage(
                type: "closed",
                listCardsAbout: listCardsAbout,
              ),
              tabName: "About"));

          list.add(CustomTabMaker(
            statelessWidget: EducationPage(
              type: type,
              listCardsAbout: listSubjectCards,
              instituteId: instituteId.toString(),
            ),
            tabName:
                AppLocalizations.of(context).translate("campus_facilities"),
          ));

          list.add(CustomTabMaker(
              statelessWidget: AboutPage(
                type: "assigned",
                listCardsAbout: listCardsAbout,
              ),
              tabName: "More"));
          _tabController = TabController(vsync: this, length: list.length);
          _tabController.addListener(onPositionChange);
        });
      }
    }
  }

  void getSports(BuildContext context, String type) async {
    final body = jsonEncode({
      "person_id": personId,
      "institution_id": instituteId.toString(),
      "page_number": 1,
      "page_size": 100
    });
    ProgressDialog pr = ToastBuilder().setProgressDialog(context);
    await pr.show();
    Calls().call(body, context, Config.SPORTS_SEE_MORE).then((value) async {
      if (value != null) {
        await pr.hide();
        if (this.mounted) {
          setState(() {
            var data = BaseResponses.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              await pr.hide();
              if (data.rows != null) {
                listSubjects = data.rows;

                if (listSubjects != null && listSubjects.length > 0) {
                  for (var item in listSubjects) {
                    if (item != null) {
                      var widget = GetAllCards().getCard(instituteId.toString(),
                          false, styleElements, item, rows,"institute",
                          callBck: () {});
                      if (widget != null) listSubjectCards.add(widget);
                    }
                  }
                  if (this.mounted) {
                    setState(() {
                      list = [];
                      listCardsAbout = listCardsAbout;
                      listCardsClasses = listCardsClasses;
                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "open",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "Timeline"));
                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "closed",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "About"));

                      list.add(CustomTabMaker(
                        statelessWidget: EducationPage(
                          type: type,
                          listCardsAbout: listSubjectCards,
                          instituteId: instituteId.toString(),
                        ),
                        tabName: AppLocalizations.of(context).translate(type),
                      ));

                      list.add(CustomTabMaker(
                          statelessWidget: AboutPage(
                            type: "assigned",
                            listCardsAbout: listCardsAbout,
                          ),
                          tabName: "More"));
                      _tabController =
                          TabController(vsync: this, length: list.length);
                      _tabController.addListener(onPositionChange);
                    });
                  }
                }
              }
            }
          });
        }
      }
      {
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
}

// ignore: must_be_immutable
class AboutPage extends StatelessWidget {
  String type;
  List<StatelessWidget> listCardsAbout = [];

  AboutPage({Key key, @required this.type, @required this.listCardsAbout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: NotificationListener(
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: listCardsAbout.length,
            itemBuilder: (context, index) {
              return listCardsAbout[index];
            }),
        // ignore: missing_return
        onNotification: (t) {
          if (t is ScrollStartNotification) {}
        },
      ),
    ));
  }
}

// ignore: must_be_immutable
class EducationPage extends StatelessWidget {
  String type;
  List<StatelessWidget> listCardsAbout = [];
  TextStyleElements styleElements;
  BuildContext context;
  String instituteId;
  SharedPreferences prefs;

  EducationPage(
      {Key key,
      @required this.type,
      @required this.listCardsAbout,
      this.instituteId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.context = context;
    setSharedPreferences();
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
                                            : type == "medium"
                                                ? AppLocalizations.of(context)
                                                    .translate("medium_title")
                                                : type == "courses"
                                                    ? AppLocalizations.of(context)
                                                        .translate("courses")
                                                    : type == "club"
                                                        ? AppLocalizations.of(context)
                                                            .translate("club")
                                                        : type == "sports"
                                                            ? AppLocalizations.of(context)
                                                                .translate(
                                                                    "sports")
                                                            : type ==
                                                                    AppLocalizations.of(context).translate(
                                                                        "campus_facilities")
                                                                ? AppLocalizations.of(context)
                                                                    .translate(
                                                                        "campus_facilities")
                                                                : AppLocalizations.of(
                                                                        context)
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
                child: Visibility(
                    visible: type ==
                        AppLocalizations.of(context)
                            .translate("campus_facilities"),
                    child: GestureDetector(
                        onTap: () async {
                          _addPhoto();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Icon(
                            Icons.add_a_photo,
                            color: HexColor(AppColors.appColorGrey500),
                            size: 35,
                          ),
                        ))),
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
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: listCardsAbout.length,
                  itemBuilder: (context, index) {
                    return listCardsAbout[index];
                  }),
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

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  _addPhoto() async {
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
              contextId: instituteId,
              contextType: CONTEXTTYPE_ENUM.PROFILE.type,
              subContextType: SUBCONTEXTTYPE_ENUM.FACILITIES.type,
              ownerId: prefs.getInt("userId").toString(),
              ownerType: OWNERTYPE_ENUM.PERSON.type,
              file: croppedFile,
              subContextId: "",
              mimeType: contentType[1],
              contentType: contentType[0])
          .uploadFile()
          .then((value) async {
        var imageResponse = ImageUpdateResponse.fromJson(value);
        var url = imageResponse.rows.otherUrls[0].original;
        print(url);
        await pr.hide();
        var result =
            await  Navigator.push(context,
            MaterialPageRoute(
              builder: (context) =>
                  CreateFacility(
                    url: url,
                    id: instituteId,
                  ),
            ));
if(result!=null&& result['result'] != null)
  {
    Route route = MaterialPageRoute(
        builder: (context) =>
            InstitutionProfile(
                instituteId: int.parse(instituteId),
                type: "photos",
                currentPosition: 2));
    Navigator.pushReplacement(
        context, route);


  }
      }).catchError((onError) {
        await pr.hide();
        print(onError.toString());
      });
    }
  }
}
class BottomSheetContent extends StatelessWidget {
  int  instituteId;

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
                      builder: (context) =>     InstitutionProfile(
                          instituteId: instituteId,
                          type: "photos",
                          currentPosition: 2)
                    ));
                if (result != null && result['result'] == "update") {
                  Route route = MaterialPageRoute(
                      builder: (context) =>
                          InstitutionProfile(
                              instituteId:
                              instituteId,
                              type: "",
                              currentPosition: 1));
                  Navigator.pushReplacement(context, route);
                }
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.all(4.h),
                    child:     ListTile(
                      title: Text(
                        AppLocalizations.of(context).translate("campus_facilities"),
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
                      builder: (context) =>   InstitutionProfile(
                          instituteId:
                          instituteId,
                          type: "sports",
                          currentPosition: 2),
                    ));
                if (result != null && result['result'] == "update") {
                  Route route = MaterialPageRoute(
                      builder: (context) =>
                          InstitutionProfile(
                              instituteId:
                              instituteId,
                              type: "",
                              currentPosition: 1));
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
                            .translate("sports"),
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
                      builder: (context) => InstitutionProfile(
                        type: "subject",
                        instituteId:
                        instituteId,
                        currentPosition: 2,
                      ),
                    ));
                if (result != null && result['result'] == "update") {
                  Route route = MaterialPageRoute(
                      builder: (context) =>
                          InstitutionProfile(type: "", instituteId:
                          instituteId, currentPosition: 1));
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
                      builder: (context) => InstitutionProfile(
                        type: "class",
                        currentPosition: 2,
                        instituteId:
                        instituteId,
                      ),
                    ));
                if (result != null && result['result'] == "update") {
                  Route route = MaterialPageRoute(
                      builder: (context) =>
                          InstitutionProfile(type: "",  instituteId:
                          instituteId,currentPosition: 1));
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
                      builder: (context) => InstitutionProfile(
                        type: "course",
                        instituteId:
                        instituteId,
                        currentPosition: 2,
                      ),
                    ));
                if (result != null && result['result'] == "update") {
                  Route route = MaterialPageRoute(
                      builder: (context) =>
                          InstitutionProfile(type: "",  instituteId:
                          instituteId,currentPosition: 1));
                  Navigator.pushReplacement(context, route);
                }
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.all(4.h),
                    child: ListTile(

                      title: Text(
                        AppLocalizations.of(context).translate("courses"),
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
                      builder: (context) => InstitutionProfile(
                        type: "medium",
                        currentPosition: 2,
                        instituteId:
                        instituteId,
                      ),
                    ));
                if (result != null && result['result'] == "update") {
                  Route route = MaterialPageRoute(
                      builder: (context) =>
                          InstitutionProfile(type: "", instituteId:
                          instituteId, currentPosition: 1));
                  Navigator.pushReplacement(context, route);
                }
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.all(4.h),
                    child: ListTile(

                      title: Text(
                        AppLocalizations.of(context).translate("medium"),
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

  BottomSheetContent(this.instituteId,);
}
*/
