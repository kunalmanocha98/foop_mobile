
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/profile_module/common_cards/overlappedImagesLarger.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateGoal extends StatefulWidget {
  _CreateGoal createState() => _CreateGoal();
}

class _CreateGoal extends State<CreateGoal> {

  SharedPreferences? prefs;
  CustomTabMaker? customTabMaker;
  List<CustomTabMaker> list = [];
  Map<String, bool?> language = {
    'Chapter 1 to be done': false,
    'Grammar to be covered': false,
    'Letters to be learnt': false,
  };

  Map<String, bool?> repeat = {
    'Only Once': false,
    'Every Monday': false,
    'Every Wednesday': false,
    'Every Friday': false,
    'Every Sunday': false,
    'Yearly': false,
    'Monthly': false,
    'Every Saturday': false,
    'Every Thursday': false,
    'Every Tuesday': false,
    'Daily': false,
  };

  @override
  void initState() {
    super.initState();
  }
  late TextStyleElements styleElements;
  Widget build(BuildContext context) {
    styleElements=TextStyleElements(context);

    ScreenUtil.init;
    // var size = MediaQuery.of(context).size;
    // final double itemHeight = 30;
    // final double itemWidth = size.width / 2;
    return
      SafeArea(child:  Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: HexColor(AppColors.appColorBackground),
          appBar: TricycleAppBar().getCustomAppBarWithSearch(
              context,
              appBarTitle: 'Create Goal',
              onBackButtonPress: (){_onBackPressed();},
              onSearchValueChanged: (value){

              }),
          body: Container(
            child: ListView(
              children: <Widget>[
                Container(
                    margin:
                    const EdgeInsets.only(left: 16, top: 8.0, bottom: 8.0),
                    child: TextField(
                      style: styleElements.subtitle1ThemeScalable(context).copyWith(
                          color: HexColor(AppColors.appColorBlack65)
                      ),
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: AppLocalizations.of(context)!.translate('what_is_goal'),
                          hintStyle:styleElements.bodyText2ThemeScalable(context).copyWith(
                            color: HexColor(AppColors.appColorBlack35)
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(0.0),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.0,
                            ),
                          )),
                    )),
                Container(
                    child: ConstrainedBox(
                        constraints: new BoxConstraints(
                          minHeight: 50.0,
                          maxHeight: 190.0,
                        ),
                        child: Card(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 16, top: 24),
                                            child: Text(AppLocalizations.of(context)!.translate('check_points'),
                                              style: styleElements.subtitle1ThemeScalable(context),
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
                                                    builder: (context) => CreateGoal(

                                                      /* type: "teacher",*/
                                                    ),
                                                  ));
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 24, left: 8, right: 16),
                                              child: Icon(
                                                Icons.add,
                                                color: HexColor(AppColors.appColorGrey500),
                                              ),
                                            ))),
                                  ],
                                ),
                                Flexible(
                                  child: Stack(
                                    children: <Widget>[
                                      ListView(
                                        padding: EdgeInsets.all(16.0),
                                        physics: NeverScrollableScrollPhysics(),
                                        children: language.keys
                                            .map((String key) => Container(
                                          margin:
                                          const EdgeInsets.only(top: 8),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: 24.0,
                                                width: 24.0,
                                                child: Checkbox(
                                                  activeColor:
                                                  HexColor(AppColors.appMainColor),
                                                  value: language[key],
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      language[key] = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Flexible(
                                                  child: Container(
                                                    margin: const EdgeInsets.only(
                                                        left: 16),
                                                    child: Text(
                                                      key,
                                                      maxLines: 2,
                                                      style:styleElements.subtitle2ThemeScalable(context),
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ))
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )))),
                Container(
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: ConstrainedBox(
                        constraints: new BoxConstraints(
                          minHeight: 50.0,
                          maxHeight: 320.0,
                        ),
                        child: Card(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 16, top: 24),
                                            child: Text(AppLocalizations.of(context)!.translate('repeat_frequency'),
                                              style: styleElements.subtitle1ThemeScalable(context),
                                              textAlign: TextAlign.left,
                                            ),
                                          )),
                                      flex: 3,
                                    ),
                                  ],
                                ),
                                Flexible(
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: GridView.count(
                                      padding: EdgeInsets.all(16.0),
                                      physics: NeverScrollableScrollPhysics(),
                                      crossAxisCount: 2,
                                      childAspectRatio: MediaQuery.of(context)
                                          .size
                                          .width /
                                          (MediaQuery.of(context).size.height / 8),
                                      children: repeat.keys
                                          .map((String key) => Flexible(
                                          child: Container(
                                            margin:
                                            const EdgeInsets.only(top: 12),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 24.0,
                                                  width: 24.0,
                                                  child: Checkbox(
                                                    activeColor: HexColor(AppColors.appMainColor),
                                                    value: repeat[key],
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        repeat[key] = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Flexible(
                                                    child: Container(
                                                        margin:
                                                        const EdgeInsets.only(
                                                            left: 16),
                                                        child: Text(
                                                          key,
                                                          maxLines: 2,
                                                          style: styleElements.subtitle2ThemeScalable(context),
                                                          textAlign:
                                                          TextAlign.start,
                                                        )))
                                              ],
                                            ),
                                          )))
                                          .toList(),
                                    ),
                                  ),
                                )
                              ],
                            )))),
                Container(
                  padding: const EdgeInsets.only(
                    top: 4,
                  ),
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
                                    child: Text(AppLocalizations.of(context)!.translate('target_date'),
                                      style:styleElements.subtitle1ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                              flex: 3,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 16, top: 4, right: 16, bottom: 16),
                            child: Text(AppLocalizations.of(context)!.translate('none'),
                              style:styleElements.captionThemeScalable(context),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 4,
                  ),
                  child: Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 24, left: 16, right: 16),
                                      child: Text("Guru(s) for the goal",
                                        style: styleElements.subtitle1ThemeScalable(context),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                                Container(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin:
                                        const EdgeInsets.only(top: 8, bottom: 16),
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  'https://homepages.cae.wisc.edu/~ece533/images/boy.bmp'),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 16),
                                            child: Text("Savil,Kunal,Sahwaz",
                                              style: styleElements.subtitle2ThemeScalable(context),
                                              textAlign: TextAlign.left,
                                            ),
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: const EdgeInsets.all(16),
                                child: Icon(Icons.keyboard_arrow_right,
                                    color: HexColor(AppColors.appColorBlack85)),
                              )),
                        ],
                      )),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 4,
                  ),
                  child: Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 16, left: 16, right: 16),
                                      child: Text("Collaborate with",
                                        style: styleElements.subtitle1ThemeScalable(context),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 16, bottom: 16, top: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      OverlappedImagesLarger(),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: const EdgeInsets.all(16),
                                child: Icon(Icons.keyboard_arrow_right,
                                    color: HexColor(AppColors.appColorBlack85)),
                              ))
                        ],
                      )),
                ),
                Container(
                    padding: const EdgeInsets.only(
                        top: 4, bottom: 4, left: 4, right: 4),
                    child: Container(
                      child: Card(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 16, left: 16, right: 16),
                                          child: Text(
                                            AppLocalizations.of(context)!.translate('assign_to'),
                                            style: styleElements.subtitle1ThemeScalable(context),
                                            textAlign: TextAlign.center,
                                          ),
                                        )),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 16, bottom: 16, top: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          OverlappedImagesLarger(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: const EdgeInsets.all(16),
                                    child: Icon(Icons.keyboard_arrow_right,
                                        color: HexColor(AppColors.appColorBlack85)),
                                  ))
                            ],
                          )),
                    )),
              ],
            ),
            margin: const EdgeInsets.all(8),
          )))
     ;
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
