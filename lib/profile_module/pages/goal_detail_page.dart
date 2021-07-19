
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/profile_module/common_cards/overlappedImagesLarger.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/dialogue_finish_dialogue.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_goal.dart';

class GoalsDetailPage extends StatefulWidget {
  _GoalsDetailPage createState() => _GoalsDetailPage();
}

class _GoalsDetailPage extends State<GoalsDetailPage> {

  SharedPreferences prefs;
  CustomTabMaker customTabMaker;
  bool isChecked = false;
  List<CustomTabMaker> list = [];
  Map<String, bool> language = {
    'Chapter 1 to be done': false,
    'Grammar to be covered': false,
    'Letters to be learnt': false,
  };

  @override
  void initState() {
    super.initState();
  }
  TextStyleElements styleElements;
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    ScreenUtil.init;

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: HexColor(AppColors.appColorBackground),
          appBar: TricycleAppBar().getCustomAppBarWithSearch(context,
              appBarTitle:  AppLocalizations.of(context).translate("select_date"),
              onSearchValueChanged: (value){},
              onBackButtonPress: (){
                _onBackPressed();
              }),
          body: Stack(
            children: [
              NestedScrollView(
                  headerSliverBuilder: (context, value) {
                    return [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 16, top: 8.0, bottom: 8.0),
                                child: Text(AppLocalizations.of(context).translate('want_to_learn'),
                                  style: styleElements.headline6ThemeScalable(context),
                                )),
                            Container(
                                margin:
                                    const EdgeInsets.only(left: 16, bottom: 8.0),
                                child: Text('By 19 nov 2020',
                                  style: styleElements.captionThemeScalable(context),
                                )),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20.0, top: 8.0, bottom: 8.0, right: 20),
                              child: LinearPercentIndicator(
                                animation: true,
                                lineHeight: 10.0,
                                animationDuration: 2000,
                                percent: 0.8,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                progressColor: HexColor(AppColors.appMainColor),
                                backgroundColor: HexColor(AppColors.appColorGrey100),
                              ),
                            ),
                            ConstrainedBox(
                                constraints: new BoxConstraints(
                                  minHeight: 50.0,
                                  maxHeight: 250.0,
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 16, bottom: 8, left: 8, right: 8),
                                  child: Card(
                                      child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 16, top: 24),
                                                  child: Text(AppLocalizations.of(context).translate('check_points'),
                                                    style: styleElements.headline6ThemeScalable(context),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                )),
                                            flex: 3,
                                          ),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CreateGoal(

                                                                  /* type: "teacher",*/
                                                                  ),
                                                        ));
                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets.only(
                                                        top: 24,
                                                        left: 8,
                                                        right: 16),
                                                    child: Icon(
                                                      Icons.add_box,
                                                      color: HexColor(AppColors.appMainColor),
                                                    ),
                                                  ))),
                                        ],
                                      ),
                                      Flexible(
                                        child: Stack(
                                          children: <Widget>[
                                            ListView(
                                              padding: EdgeInsets.all(16.0),
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              children: language.keys
                                                  .map((String key) => Container(
                                                        margin:
                                                            const EdgeInsets.only(
                                                                top: 8),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              height: 24.0,
                                                              width: 24.0,
                                                              child: Checkbox(
                                                                activeColor: Colors
                                                                    .redAccent,
                                                                value:
                                                                    language[key],
                                                                onChanged:
                                                                    (bool value) {
                                                                  setState(() {
                                                                    language[
                                                                            key] =
                                                                        value;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            Flexible(
                                                                child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 16),
                                                              child: Text(
                                                                key,
                                                                maxLines: 2,
                                                                style: styleElements.subtitle2ThemeScalable(context),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                            ))
                                                          ],
                                                        ),
                                                      ))
                                                  .toList(),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                  height: 60,
                                                  color: HexColor(AppColors.appColorWhite),
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Container(
                                                        margin:
                                                            const EdgeInsets.only(
                                                                left: 16.0,
                                                                top: 16.0,
                                                                bottom: 16.0),
                                                        height: 40,
                                                        child: TricycleElevatedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0),
                                                              side: BorderSide(
                                                                  color:  HexColor(AppColors.appMainColor))),
                                                          onPressed: () {},
                                                          color: HexColor(AppColors.appColorWhite),

                                                          child: Text(AppLocalizations.of(context).translate('cancel')
                                                                  .toUpperCase(),
                                                              style:  styleElements.bodyText2ThemeScalable(context).copyWith(
                                                                color: HexColor(AppColors.appMainColor),
                                                              )),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            const EdgeInsets.only(
                                                                left: 16.0,
                                                                top: 16.0,
                                                                bottom: 16.0,
                                                                right: 16),
                                                        height: 40,
                                                        child: TricycleElevatedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0),
                                                              side: BorderSide(
                                                                  color:  HexColor(AppColors.appMainColor))),
                                                          onPressed: () {
                                                            showDialog(
                                                                context: context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    DialogFinishGoal());
                                                          },
                                                          color:  HexColor(AppColors.appMainColor),
                                                          child: Text(AppLocalizations.of(context).translate('finish')
                                                                  .toUpperCase(),
                                                              style:  styleElements.bodyText2ThemeScalable(context)),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                                )),
                            Container(
                              padding: const EdgeInsets.only(
                                  bottom: 8, left: 8, right: 8),
                              child: Card(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      bottom: 16, left: 16, right: 16, top: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      OverlappedImagesLarger(),Text("",
                                        style:  styleElements.subtitle1ThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      ),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            margin: const EdgeInsets.all(16),
                                            child: Icon(
                                                Icons.keyboard_arrow_right,
                                                color: HexColor(
                                                    AppColors.appColorBlack85)),
                                          ))
                                    ],
                                  ),
                                )
                              ),
                            ),
                          ],
                        ),
                      )
                    ];
                  },
                  body: Container(
                    padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                    /* child: Card(
                          child: SizedBox(
                        height: 300,
                        child: ListView(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 20, top: 20),
                                        child: Text(
                                          "Progress Journal",
                                          style: TextStyle(
                                            fontFamily: 'bold',
                                            fontSize: ScreenUtil().setSp(48,
                                                ),
                                            color: const Color(0xd9000000),
                                            fontWeight: FontWeight.w700,
                                            height: 1,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      )),
                                  flex: 3,
                                ),
                                Flexible(
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 16, top: 24, left: 16),
                                        child: Icon(
                                          Icons.more_horiz,
                                        ),
                                      )),
                                  flex: 1,
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          width: 15,
                                          height: 15,
                                          margin: const EdgeInsets.only(
                                              top: 20, left: 16),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: CachedNetworkImageProvider(
                                                    'https://homepages.cae.wisc.edu/~ece533/images/airplane.png'),
                                                fit: BoxFit.fill),
                                          ),
                                        )),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 8, top: 20),
                                          child: Text(
                                            "Desi Valli",
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(42,
                                                  ),
                                              color: const Color(0xd9000000),
                                              fontWeight: FontWeight.w700,
                                              height: 1,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        )),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 8, top: 20),
                                          child: Text(
                                            "12-9-2020",
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(32,
                                                  ),
                                              color: HexColor(
                                                  AppColors.appColorBlack35),
                                              fontWeight: FontWeight.w500,
                                              height: 1,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        )),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, top: 20, right: 20, bottom: 20),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate("select_right_institute"),
                                      style: TextStyle(
                                        fontFamily: 'Source Sans Pro',
                                        fontSize: ScreenUtil().setSp(42,
                                            ),
                                        color: HexColor(AppColors.appColorBlack65),
                                        fontWeight: FontWeight.w500,
                                        height: 1,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          width: 15,
                                          height: 15,
                                          margin: const EdgeInsets.only(
                                              top: 20, left: 16),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: CachedNetworkImageProvider(
                                                    'https://homepages.cae.wisc.edu/~ece533/images/airplane.png'),
                                                fit: BoxFit.fill),
                                          ),
                                        )),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 8, top: 20),
                                          child: Text(
                                            "Desi Valli",
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(42,
                                                  ),
                                              color: const Color(0xd9000000),
                                              fontWeight: FontWeight.w700,
                                              height: 1,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        )),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 8, top: 20),
                                          child: Text(
                                            "12-9-2020",
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(32,
                                                  ),
                                              color: HexColor(
                                                  AppColors.appColorBlack35),
                                              fontWeight: FontWeight.w500,
                                              height: 1,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        )),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, top: 20, right: 20, bottom: 20),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate("select_right_institute"),
                                      style: TextStyle(
                                        fontFamily: 'Source Sans Pro',
                                        fontSize: ScreenUtil().setSp(42,
                                            ),
                                        color: HexColor(AppColors.appColorBlack65),
                                        fontWeight: FontWeight.w500,
                                        height: 1,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          width: 15,
                                          height: 15,
                                          margin: const EdgeInsets.only(
                                              top: 20, left: 16),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: CachedNetworkImageProvider(
                                                    'https://homepages.cae.wisc.edu/~ece533/images/airplane.png'),
                                                fit: BoxFit.fill),
                                          ),
                                        )),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 8, top: 20),
                                          child: Text(
                                            "Desi Valli",
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(42,
                                                  ),
                                              color: const Color(0xd9000000),
                                              fontWeight: FontWeight.w700,
                                              height: 1,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        )),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 8, top: 20),
                                          child: Text(
                                            "12-9-2020",
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(32,
                                                  ),
                                              color: HexColor(
                                                  AppColors.appColorBlack35),
                                              fontWeight: FontWeight.w500,
                                              height: 1,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        )),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, top: 20, right: 20, bottom: 20),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate("select_right_institute"),
                                      style: TextStyle(
                                        fontFamily: 'Source Sans Pro',
                                        fontSize: ScreenUtil().setSp(42,
                                            ),
                                        color: HexColor(AppColors.appColorBlack65),
                                        fontWeight: FontWeight.w500,
                                        height: 1,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))*/
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: HexColor(AppColors.appColorGrey50),
                  height: 61,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: HexColor(AppColors.appColorWhite),
                              borderRadius: BorderRadius.circular(35.0),
                              boxShadow: [CommonComponents().getShadowforBox()],
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.face), onPressed: () {}),
                                Expanded(
                                  child: TextField(
                                    style: styleElements.subtitle1ThemeScalable(context).copyWith(
                                        color: HexColor(AppColors.appColorBlack65)
                                    ),
                                    decoration: InputDecoration(
                                        hintText: "Record progress notes..........",
                                        border: InputBorder.none,
                                      hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)).copyWith(color:HexColor(AppColors.appColorBlack35))
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: HexColor(AppColors.appColorBlack85),
                                  ),
                                  onPressed: () {},
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: HexColor(AppColors.appMainColor),
                              shape: BoxShape.circle),
                          child: InkWell(
                            child: Icon(
                              Icons.keyboard_voice,
                              color: HexColor(AppColors.appColorWhite),
                            ),
                            onLongPress: () {
                              setState(() {});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
                AppLocalizations.of(context).translate('are_you_sure')),
            content: new Text(
                AppLocalizations.of(context).translate('exit_tricycle')),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context).translate('no')),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text(AppLocalizations.of(context).translate('yes')),
              ),
            ],
          ),
        ) ??
        false;
  }
}
