
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/profile_module/common_cards/overlaped_circular_images.dart';
import 'package:oho_works_app/ui/test.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'goal_detail_page.dart';

class GoalsScreen extends StatefulWidget {
  _GoalsScreen createState() => _GoalsScreen();
}

class _GoalsScreen extends State<GoalsScreen> {

  SharedPreferences? prefs;
  CustomTabMaker? customTabMaker;
  List<CustomTabMaker> list = [];
  TextStyleElements? styleElements;

  @override
  void initState() {
    super.initState();
    list.add(CustomTabMaker(
        statelessWidget: MainPage(goalType: "open"), tabName: AppLocalizations.of(context)!.translate('open')));
    list.add(CustomTabMaker(
        statelessWidget: MainPage(goalType: "closed"), tabName: AppLocalizations.of(context)!.translate('closed')));
    list.add(CustomTabMaker(
        statelessWidget: MainPage(goalType: "assigned"), tabName: AppLocalizations.of(context)!.translate('assigned')));
  }

  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    ScreenUtil.init;

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: HexColor(AppColors.appColorBackground),
          appBar:OhoAppBar().getCustomAppBarWithSearch(
              context,
              appBarTitle: 'Goals',
              onBackButtonPress: (){_onBackPressed();},
              onSearchValueChanged: (value){

              }),
          body: CustomTabs(list)),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
                AppLocalizations.of(context)!.translate('are_you_sure')),
            content: new Text(
                AppLocalizations.of(context)!.translate('exit_app')),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context)!.translate('no')),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text(AppLocalizations.of(context)!.translate('yes')),
              ),
            ],
          ),
        ).then((value) => value as bool) ;
  }
}

// ignore: must_be_immutable
class MainPage extends StatelessWidget {
  String goalType;
  late TextStyleElements styleElements;
  MainPage({Key? key, required this.goalType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
                child: Container(
              margin: const EdgeInsets.all(8),
              child: Card(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 16, top: 24),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate("goals_and_objectives"),
                                  style: styleElements.headline6ThemeScalable(context),
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
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 20, top: 20, right: 20, bottom: 20),
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate("select_right_entity"),
                          style:styleElements.subtitle1ThemeScalable(context),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ];
        },
        body: Expanded(
            child: Container(
                margin: const EdgeInsets.all(8),
                child: ListView(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GoalsDetailPage(

                                  /* type: "teacher",*/
                                  ),
                            ));
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(left: 8, right: 8, top: 8.0),
                        child: Card(
                          child: Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 8, top: 8.0),
                                      child: Text(AppLocalizations.of(context)!.translate('want_to_learn'),
                                        style: styleElements.subtitle1ThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(8),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text("",
                                            style: styleElements.bodyText2ThemeScalable(context),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        RatingBar(
                                          initialRating: 3,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: false,
                                          itemCount: 5,
                                          itemSize: 15.0,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          ratingWidget: RatingWidget(
                                            empty: Icon(
                                              Icons.star_outline,
                                              color: HexColor(AppColors.appMainColor),
                                            ),
                                            half:  Icon(
                                              Icons.star_half_outlined,
                                              color: HexColor(AppColors.appMainColor),
                                            ),
                                            full:  Icon(
                                              Icons.star_outlined,
                                              color: HexColor(AppColors.appMainColor),
                                            ),
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 8.0),
                                    child: LinearPercentIndicator(
                                      width: 100,
                                      animation: true,
                                      lineHeight: 5.0,
                                      animationDuration: 2000,
                                      percent: 0.8,
                                      linearStrokeCap: LinearStrokeCap.roundAll,
                                      progressColor: HexColor(AppColors.appColorGreen),
                                      backgroundColor: HexColor(AppColors.appColorTransparent),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(8),
                                    child: Row(
                                      children: <Widget>[
                                        OverlappedImages(null),
                                        Text("",
                                          style: styleElements.bodyText2ThemeScalable(context),
                                          textAlign: TextAlign.left,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 8, right: 8, top: 8.0),
                                        child: Text("",
                                          style: styleElements.subtitle2ThemeScalable(context),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(""),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 8, right: 8, top: 8.0),
                                        child: Text("",
                                          style: styleElements.bodyText2ThemeScalable(context),
                                          textAlign: TextAlign.left,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 8, right: 8, top: 8.0),
                      child: Card(
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 8, top: 8.0),
                                    child: Text(AppLocalizations.of(context)!.translate('want_to_learn'),
                                      style: styleElements.subtitle1ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text("",
                                          style: styleElements.bodyText2ThemeScalable(context),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      RatingBar(
                                        initialRating: 3,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: false,
                                        itemCount: 5,
                                        itemSize: 15.0,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        ratingWidget: RatingWidget(
                                          empty: Icon(
                                            Icons.star_outline,
                                            color: HexColor(AppColors.appMainColor),
                                          ),
                                          half:  Icon(
                                            Icons.star_half_outlined,
                                            color: HexColor(AppColors.appMainColor),
                                          ),
                                          full:  Icon(
                                            Icons.star_outlined,
                                            color: HexColor(AppColors.appMainColor),
                                          ),
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8.0),
                                  child: LinearPercentIndicator(
                                    width: 100,
                                    animation: true,
                                    lineHeight: 5.0,
                                    animationDuration: 2000,
                                    percent: 0.8,
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    progressColor: HexColor(AppColors.appColorGreen),
                                    backgroundColor: HexColor(AppColors.appColorTransparent),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  child: Row(
                                    children: <Widget>[
                                      OverlappedImages(null),
                                      Text("",
                                        style: styleElements.bodyText2ThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 8, top: 8.0),
                                      child: Text("",
                                        style: styleElements.subtitle2ThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(""),
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 8, top: 8.0),
                                      child: Text("",
                                        style: styleElements.bodyText2ThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 8, right: 8, top: 8.0),
                      child: Card(
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 8, top: 8.0),
                                    child: Text(AppLocalizations.of(context)!.translate('want_to_learn'),
                                      style: styleElements.subtitle2ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text("",
                                          style: styleElements.bodyText2ThemeScalable(context),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      RatingBar(
                                        initialRating: 3,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: false,
                                        itemCount: 5,
                                        itemSize: 15.0,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        ratingWidget: RatingWidget(
                                          empty: Icon(
                                            Icons.star_outline,
                                            color: HexColor(AppColors.appMainColor),
                                          ),
                                          half:  Icon(
                                            Icons.star_half_outlined,
                                            color: HexColor(AppColors.appMainColor),
                                          ),
                                          full:  Icon(
                                            Icons.star_outlined,
                                            color: HexColor(AppColors.appMainColor),
                                          ),
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8.0),
                                  child: LinearPercentIndicator(
                                    width: 100,
                                    animation: true,
                                    lineHeight: 5.0,
                                    animationDuration: 2000,
                                    percent: 0.8,
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    progressColor: HexColor(AppColors.appColorGreen),
                                    backgroundColor: HexColor(AppColors.appColorTransparent),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  child: Row(
                                    children: <Widget>[
                                      OverlappedImages(null),
                                      Text("",
                                        style:styleElements.bodyText2ThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 8, top: 8.0),
                                      child: Text("",
                                        style: styleElements.subtitle2ThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(""),
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 8, top: 8.0),
                                      child: Text("",
                                        style: styleElements.bodyText2ThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ))));
  }
}
