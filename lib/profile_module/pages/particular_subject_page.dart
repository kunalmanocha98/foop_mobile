import 'dart:convert';

import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/models/ClassesList.dart';
import 'package:oho_works_app/models/RolesList.dart';
import 'package:oho_works_app/models/SubjectList.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/profile_module/common_cards/institute_card.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:oho_works_app/profile_module/common_cards/user_pipulaity_card.dart';
import 'package:oho_works_app/ui/settings.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ParticularSubject extends StatefulWidget {
  String type;
  int currentPosition;

  ParticularSubject(
      {Key key, @required this.type, @required this.currentPosition})
      : super(key: key);

  _ParticularSubject createState() => _ParticularSubject(type, currentPosition);
}

class _ParticularSubject extends State<ParticularSubject>
    with SingleTickerProviderStateMixin {
  String type;
  int _currentPosition;
  TextStyleElements styleElements;

  _ParticularSubject(String type, int currentPosition) {
    this.type = type;
    this._currentPosition = currentPosition;
  }

  ProgressDialog pr;
  SharedPreferences prefs;
  var pageTitle = "";
  PersonalProfile personalProfile;
  Persondata rows;
  List<CommonCardData> listCardData = [];
  var color1 = HexColor(AppColors.appMainColor);
  var selectedTextColor1 = HexColor(AppColors.appColorWhite);
  var selectedTextColor2 = HexColor(AppColors.appColorBlack85);
  var selectedTextColor3 = HexColor(AppColors.appColorBlack85);
  var selectedTextColor4 = HexColor(AppColors.appColorBlack85);
  var color2 = HexColor(AppColors.appColorWhite);
  var color3 = HexColor(AppColors.appColorWhite);
  var color4 = HexColor(AppColors.appColorWhite);
  List<StatelessWidget> listCardsAbout = [];
  List<StatelessWidget> listCardsClasses = [];
  List<StatelessWidget> listStudentsData = [];
  List<StatelessWidget> listGurusData = [];
  List<StatelessWidget> listSkillsCard = [];
  List<StatelessWidget> listLanguageCards = [];
  List<StatelessWidget> listWorkCards = [];
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
  List<CommonCardData> listStudentsCards = [];
  List<CommonCardData> listGurusCard = [];
  List<CommonCardData> listLanguageData = [];
  List<CommonCardData> listWorkData = [];
  List<CustomTabMaker> list = [];
  BuildContext context;

  onPositionChange() {
    if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
        _currentPosition = _tabController.index;
      });
    }
  }

  onTabClicked() {
    if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
        _currentPosition = _tabController.index;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    loadPages(type);
  }

  final body = jsonEncode({
    "conversationOwnerId": '1580807502972',
    "conversationOwnerType": 'personal',
    "businessId": '1580811876121',
    "registeredUserId": '1580807502972',
    "pageNo": 0,
    "pageNumber": 1,
    "pageSize": 5
  });

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

  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    ScreenUtil.init;
    this.context = context;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor(AppColors.appColorBackground),
        body: Container(
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
                          Container(
                            height: displayHeight(context) / 2,
                            decoration: BoxDecoration(
                              color:  HexColor(AppColors.appMainColor35),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    'https://picsum.photos/seed/picsum/200/300'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          NestedScrollView(
                              headerSliverBuilder: (context, value) {
                                return [
                                  SliverToBoxAdapter(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          right: 20, top: 60, bottom: 16),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Column(
                                          children: <Widget>[
                                            Opacity(
                                                opacity: 0.4,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: HexColor(AppColors.appColorBlack),
                                                        shape: BoxShape.circle),
                                                    margin:
                                                        const EdgeInsets.all(8),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(4),
                                                      child: Icon(Icons.message,
                                                          color: HexColor(AppColors.appColorWhite)),
                                                    ))),
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
                                                            const EdgeInsets.all(
                                                                4),
                                                        child: Icon(
                                                            Icons.favorite_border,
                                                            color: HexColor(AppColors.appColorWhite)),
                                                      ))),
                                            ),
                                            Opacity(
                                                opacity: 0.4,
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
                                            Opacity(
                                                opacity: 0.4,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: HexColor(AppColors.appColorBlack),
                                                        shape: BoxShape.circle),
                                                    margin:
                                                        const EdgeInsets.all(8),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(4),
                                                      child: Icon(Icons.forward,
                                                          color: HexColor(AppColors.appColorWhite)),
                                                    ))),
                                          ],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: HexColor(AppColors.appColorTransparent),
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                        color:  HexColor(AppColors.appColorWhite),
                                        boxShadow: [
                                          BoxShadow(
                                            color:  HexColor(AppColors.appColorBlack08),
                                            offset: Offset(0, 3),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                          top: 4.0,
                                          bottom: 4.0),
                                      child: Column(
                                        children: <Widget>[
                                          InstituteCard(
                                            title: "",
                                            subtitle: AppLocalizations.of(context).translate('academics'),
                                            subtitle1: type,
                                            isShowMore: true,
                                            isIntroCard: true,
                                            subtitle2: "Himachal Pradesh",
                                            content:
                                                "DAV Palampur Suraj Kund 176107",
                                          ),
                                          Divider(
                                            height: 0.5,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 10.0, bottom: 20.0),
                                            child: UserPopularityCard(
                                                textFive: "32",
                                                callback: () {},
                                                textSix: "3",
                                                textSeven: "2",
                                                textEight: "45",
                                                textOne: "Students",
                                                textTwo: "Gurus",
                                                textThree: "Classes",
                                                textFour: "Rooms"),
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
                                            tabs: List<Widget>.generate(
                                                list.length, (int index) {
                                                  return TricycleTabButton(
                                                    isActive: index ==
                                                        _currentPosition,
                                                    tabName:  list[index].tabName,
                                                    onPressed: (){
                                                      _tabController.animateTo(index);
                                                      if (this.mounted) {
                                                        setState(() {
                                                          _currentPosition =
                                                              index;
                                                        });
                                                      }
                                                    },
                                                  );
                                            }),
                                          ),
                                        )),
                                  ),
                                ];
                              },
                              body: Visibility(
                                visible: list.length > 0 ? true : false,
                                child: Stack(
                                  children: <Widget>[
                                    MediaQuery.removePadding(
                                        context: context,
                                        removeTop: true,
                                        child: TabBarView(
                                          physics: NeverScrollableScrollPhysics(),
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
                              ))
                        ],
                      )),
                ))),
      ),
    );
  }

  loadPages(String type) async {
    var resAbout;
    if (type == "student")
      resAbout =
          await rootBundle.loadString('assets/student_profile_json.json');
    else if (type == "teacher")
      resAbout =
          await rootBundle.loadString('assets/teachers_profile_json.json');
    else
      resAbout = await rootBundle.loadString('assets/parent_profile_json.json');

    final Map parsedAbout = json.decode(resAbout);
    listCardData = BaseResponses.fromJson(parsedAbout).rows;
    // for (var item in listCardData) {
    //   /*    listCardsAbout.add(GetAllCards().getCard(item));*/
    // }

    var res = await rootBundle.loadString('assets/students.json');
    final Map parsed = json.decode(res);
    listStudentsCards = BaseResponses.fromJson(parsed).rows;
    // for (var item in listStudentsCards) {
    //   /* listStudentsData.add(GetAllCards().getCard(item));*/
    // }

    var resG = await rootBundle.loadString('assets/gurus.json');
    final Map parsedG = json.decode(resG);
    listGurusCard = BaseResponses.fromJson(parsedG).rows;
    // for (var item in listGurusCard) {
    //   /*listGurusData.add(GetAllCards().getCard(item));*/
    // }

    if (this.mounted) {
      setState(() {
        list = [];
        listCardsAbout = listCardsAbout;
        listStudentsData = listStudentsData;
        listGurusData = listGurusData;
        list.add(CustomTabMaker(
            statelessWidget: AboutPage(
              type: "open",
              listCardsAbout: listCardsAbout,
            ),
            tabName: AppLocalizations.of(context).translate('timeline')));
        list.add(CustomTabMaker(
            statelessWidget: AboutPage(
              type: "closed",
              listCardsAbout: listStudentsData,
            ),
            tabName: AppLocalizations.of(context).translate('student')));

        list.add(CustomTabMaker(
            statelessWidget: AboutPage(
              type: "assigned",
              listCardsAbout: listGurusData,
            ),
            tabName: AppLocalizations.of(context).translate('guru')));

        list.add(CustomTabMaker(
            statelessWidget: AboutPage(
              type: "assigned",
              listCardsAbout: listCardsAbout,
            ),
            tabName: AppLocalizations.of(context).translate('more')));
        _tabController = TabController(vsync: this, length: list.length);
        _tabController.addListener(onPositionChange);
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
