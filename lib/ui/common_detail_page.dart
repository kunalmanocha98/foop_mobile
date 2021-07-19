import 'dart:convert';

import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/models/ClassesList.dart';
import 'package:oho_works_app/models/RolesList.dart';
import 'package:oho_works_app/models/SubjectList.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/common_cards/common_detail_page_card.dart';
import 'package:oho_works_app/profile_module/common_cards/user_pipulaity_card.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CommonDetailPage extends StatefulWidget {
  String id;

  CommonDetailPage({Key key, @required this.id}) : super(key: key);

  _CommonDetailPage createState() => _CommonDetailPage();
}

class _CommonDetailPage extends State<CommonDetailPage>
    with SingleTickerProviderStateMixin {

  SharedPreferences prefs;
  var pageTitle = "";
  var color1 = HexColor(AppColors.appMainColor);
  var selectedTextColor1 = HexColor(AppColors.appColorWhite);
  var selectedTextColor2 = HexColor(AppColors.appColorBlack85);
  var selectedTextColor3 = HexColor(AppColors.appColorBlack85);
  var selectedTextColor4 = HexColor(AppColors.appColorBlack85);
  var color2 = HexColor(AppColors.appColorWhite);
  var color3 = HexColor(AppColors.appColorWhite);
  var color4 = HexColor(AppColors.appColorWhite);
  List<CommonCardData> listCardData = [];
  CommonCardData content = CommonCardData();
  List<StatelessWidget> listCards = [];
  var isCheckedColor = HexColor(AppColors.appColorWhite);
  TabController _tabController;
  var _tabIndex = 0;
  Map<String, bool> mapRules = Map();
  List<Roles> listRules = [];
  String type;
  var isClassesSelected = HexColor(AppColors.appColorWhite);
  var isSubjectSelected = HexColor(AppColors.appColorWhite);
  var isRoleSelected = false;
  List<Subjects> listOfSubjects = [];
  List<Classes> listOfClasses = [];
  TextStyleElements styleElements;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    // loadAsset();
  }

  void _toggleTab(index) {
    _tabIndex = index;
    _tabController.animateTo(_tabIndex);
  }

  List<Color> _colors = [HexColor(AppColors.appColorBlueAccent), HexColor(AppColors.appColorPurpleAccent)];
  List<double> _stops = [0.0, 0.7];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor(AppColors.appColorBackground),
        body: Container(
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: HexColor(AppColors.appColorBackground),
                body: DefaultTabController(
                  length: 4,
                  child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      backgroundColor: HexColor(AppColors.appColorBackground),
                      body: Stack(
                        children: <Widget>[
                          Container(
                            height: displayHeight(context) / 3,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              colors: _colors,
                              stops: _stops,
                            )),
                          ),
                          NestedScrollView(
                              headerSliverBuilder: (context, value) {
                                return [
                                  SliverToBoxAdapter(
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: HexColor(AppColors.appColorTransparent),
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                        color: HexColor(AppColors.appColorTransparent),
                                        boxShadow: [
                                          CommonComponents().getShadowforBox()
                                        ],
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 12.0, right: 12.0, bottom: 4.0),
                                      child: Column(
                                        children: <Widget>[
                                          CommonDetailPageCard(
                                            subtitle1: "",
                                            title: "",
                                            subtitle: "",
                                            isShowMore: true,
                                            isIntroCard: true,
                                            subtitle2: "Palampur Kangra",
                                            content: "Youth Club Himachal 176107",
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0, bottom: 20.0),
                                              child: Card(
                                                child: UserPopularityCard(
                                                    textFive: "32",
                                                    callback: () {},
                                                    textSix: "3",
                                                    textSeven: "2",
                                                    textEight: "45",
                                                    textOne: "followers",
                                                    textTwo: "following",
                                                    textThree: "cycles",
                                                    textFour: "rooms"),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: TabBar(
                                      controller: _tabController,
                                      isScrollable: true,
                                      indicatorColor: HexColor(AppColors.appColorTransparent),
                                      tabs: [
                                        ButtonTheme(
                                          child: RawMaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                _toggleTab(0);
                                                selectedTextColor1 = HexColor(AppColors.appColorWhite);
                                                selectedTextColor2 = HexColor(
                                                    AppColors.appColorBlack85);
                                                selectedTextColor3 = HexColor(
                                                    AppColors.appColorBlack85);
                                                selectedTextColor4 = HexColor(
                                                    AppColors.appColorBlack85);
                                                color1 = HexColor(AppColors.appMainColor);

                                                color2 = HexColor(AppColors.appColorWhite);

                                                color3 = HexColor(AppColors.appColorWhite);

                                                color4 = HexColor(AppColors.appColorWhite);
                                              });
                                            },
                                            elevation: 2.0,
                                            child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('timeline'),
                                                style: styleElements.subtitle1ThemeScalable(context)),
                                            fillColor: color1,
                                            padding: EdgeInsets.all(2.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                        ),
                                        ButtonTheme(
                                          child: RawMaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                _toggleTab(1);
                                                selectedTextColor1 = HexColor(
                                                    AppColors.appColorBlack85);
                                                selectedTextColor2 = HexColor(AppColors.appColorWhite);
                                                selectedTextColor3 = HexColor(
                                                    AppColors.appColorBlack85);
                                                selectedTextColor4 = HexColor(
                                                    AppColors.appColorBlack85);
                                                color2 = HexColor(AppColors.appMainColor);

                                                color1 = HexColor(AppColors.appColorWhite);

                                                color3 = HexColor(AppColors.appColorWhite);

                                                color4 = HexColor(AppColors.appColorWhite);
                                              });
                                            },
                                            elevation: 2.0,
                                            child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('about'),
                                                style:  styleElements.subtitle1ThemeScalable(context)),
                                            fillColor: color2,
                                            padding: EdgeInsets.all(2.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                        ),
                                        ButtonTheme(
                                          child: RawMaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                {
                                                  _toggleTab(2);
                                                  selectedTextColor1 = HexColor(
                                                      AppColors.appColorBlack85);
                                                  selectedTextColor2 = HexColor(
                                                      AppColors.appColorBlack85);
                                                  selectedTextColor3 =
                                                      HexColor(AppColors.appColorWhite);
                                                  selectedTextColor4 = HexColor(
                                                      AppColors.appColorBlack85);
                                                  color3 = HexColor(AppColors.appMainColor);

                                                  color1 = HexColor(AppColors.appColorWhite);

                                                  color2 = HexColor(AppColors.appColorWhite);

                                                  color4 = HexColor(AppColors.appColorWhite);
                                                }
                                              });
                                            },
                                            elevation: 2.0,
                                            child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('members'),
                                                style: styleElements.subtitle1ThemeScalable(context)),
                                            fillColor: color3,
                                            padding: EdgeInsets.all(2.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                        ),
                                        ButtonTheme(
                                          child: RawMaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                {
                                                  selectedTextColor1 = HexColor(
                                                      AppColors.appColorBlack85);
                                                  selectedTextColor2 = HexColor(
                                                      AppColors.appColorBlack85);
                                                  selectedTextColor3 = HexColor(
                                                      AppColors.appColorBlack85);
                                                  selectedTextColor4 =
                                                      HexColor(AppColors.appColorWhite);
                                                  _toggleTab(3);
                                                  color4 = HexColor(AppColors.appMainColor);

                                                  color3 = HexColor(AppColors.appColorWhite);

                                                  color1 = HexColor(AppColors.appColorWhite);

                                                  selectedTextColor4 =
                                                      HexColor(AppColors.appColorWhite);
                                                  color2 = HexColor(AppColors.appColorWhite);
                                                }
                                              });
                                            },
                                            elevation: 2.0,
                                            child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('more'),
                                                style:  styleElements.subtitle1ThemeScalable(context)),
                                            fillColor: color4,
                                            padding: EdgeInsets.all(2.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                              body: Stack(
                                children: <Widget>[
                                  TabBarView(
                                    physics: NeverScrollableScrollPhysics(),
                                    controller: _tabController,
                                    children: [
                                      Container(
                                        child: ListView(
                                          children: <Widget>[],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 60),
                                        child: ListView.builder(
                                            itemCount: listCards.length,
                                            itemBuilder: (context, index) {
                                              return listCards[index];
                                            }),
                                      ),
                                      Container(
                                        child: ListView(
                                          children: <Widget>[],
                                        ),
                                      ),
                                      Container(
                                        child: ListView(
                                          children: <Widget>[],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 60,
                                        color: HexColor(AppColors.appColorWhite),
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 16.0, right: 16.0),
                                              child: TricycleElevatedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: BorderSide(
                                                        color: HexColor(AppColors.appMainColor))),
                                                onPressed: () {},
                                                color: HexColor(AppColors.appColorWhite),

                                                child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate('next'),
                                                    style:
                                                    styleElements.bodyText2ThemeScalable(context).copyWith(
                                                      color: HexColor(AppColors.appMainColor),
                                                    )),
                                              ),
                                            )),
                                      ))
                                ],
                              ))
                        ],
                      )),
                ))),
      ),
    );
  }

  // loadAsset() async {
  //   var res = await rootBundle.loadString('assets/common_profile_json.json');
  //
  //   final Map parsed = json.decode(res);
  //
  //   listCardData = BaseResponses.fromJson(parsed).rows;
  //
  //   // for (var item in listCardData) {
  //   //   /* listCards.add(GetAllCards().getCard(item));*/
  //   // }
  //   setState(() {
  //     listCards = listCards;
  //   });
  // }
}
