import 'dart:convert';

import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/profile_module/common_cards/overlaped_circular_images.dart';
import 'package:oho_works_app/ui/rate_dialog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SkillsListWidget extends StatefulWidget {
  _SkillsListWidget createState() => _SkillsListWidget();
}

class _SkillsListWidget extends State<SkillsListWidget> {

  SharedPreferences prefs;
  TextStyleElements styleElements;
  List<String> language = [
    'Skill 1',
    'Skill 2',
    'Skill 3',
    'Skill4 ',
    'skill 5',
  ];

  @override
  void initState() {
    super.initState();
  }

  final body = jsonEncode({
    "conversationOwnerId": '1580807502972',
    "conversationOwnerType": 'personal',
    "businessId": '145274578',
    "registeredUserId": '145274578',
    "pageNo": 0,
    "pageNumber": 1,
    "pageSize": 5
  });

  Widget build(BuildContext context) {

    ScreenUtil.init;
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor(AppColors.appColorBackground),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        HexColor(AppColors.appColorWhite),
                        HexColor(AppColors.appColorWhite),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    boxShadow: [CommonComponents().getShadowforBox()],
                  ),
                  child: Center(
                    child: Container(
                        child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            onChanged: (text) {
                              setState(() {});
                            },
                            style: styleElements.subtitle1ThemeScalable(context).copyWith(
                                color: HexColor(AppColors.appColorBlack65)
                            ),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context).translate('search'),
                              border: InputBorder.none,
                              hintStyle:
                                  styleElements.bodyText2ThemeScalable(context).copyWith(
                                    color: HexColor(AppColors.appColorBlack35)
                                  ),
                              prefixIcon: Padding(
                                  padding: EdgeInsets.all(0.0),
                                  child: Icon(Icons.search, color: HexColor(AppColors.appColorGrey500))),
                            ),
                          ),
                        ),
                        Visibility(
                            child: Container(
                          margin: const EdgeInsets.all(16),
                          child: new SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: new CircularProgressIndicator(
                              value: null,
                              strokeWidth: 2.0,
                            ),
                          ),
                        ))
                      ],
                    )),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 80),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: language.length,
                      itemBuilder: (context, position) {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => RateDialog(
                                    type: "", title: AppLocalizations.of(context).translate('rate_skill'), subtitle: ""));
                          },
                          child: Container(
                            margin:
                                const EdgeInsets.only(left: 8, right: 8, top: 8),
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 16,
                                         ),
                                      child: Text(
                                        language[position],
                                        style: styleElements
                                            .subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 20.h,
                                    child:  Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Text("",
                                                  style: styleElements
                                                      .subtitle2ThemeScalable(
                                                      context),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),

                                              Align(
                                                alignment: Alignment.center,
                                                child: RatingBar(
                                                  initialRating: 3,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: false,
                                                  itemCount: 5,
                                                  itemSize: 12.0,
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
                                              )
                                              ,
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.star_border_outlined,
                                              color: HexColor(AppColors.appMainColor),
                                              size: 20.h,
                                            ),
                                            tooltip: 'Profile',
                                            onPressed: () {},
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.only(left: 16,right: 16),
                                    child: Text(AppLocalizations.of(context).translate('read_write_speak'),
                                      style: styleElements
                                          .subtitle2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack65)),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: Row(
                                      children: <Widget>[
                                        OverlappedImages(null),
                                        Text("",
                                          style: styleElements
                                              .captionThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
                                          textAlign: TextAlign.left,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    color: HexColor(AppColors.appColorWhite),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, null);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 16),
                            height: 60,
                            color: HexColor(AppColors.appColorWhite),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  AppLocalizations.of(context)
                                      .translate('save_exit')
                                      .toUpperCase(),
                                  style: styleElements
                                      .captionThemeScalable(context)
                                      .copyWith(
                                          color: HexColor(AppColors.appMainColor))),
                            ),
                          ),
                        ),
                        Container(
                          height: 60,
                          color: HexColor(AppColors.appColorWhite),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                child: TricycleElevatedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(116.0),
                                      side: BorderSide(color: HexColor(AppColors.appMainColor))),
                                  onPressed: () {
                                    /* Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditLanguage(),
                                        ));*/
                                  },
                                  color: HexColor(AppColors.appColorWhite),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('next'),
                                    style: styleElements
                                        .subtitle2ThemeScalable(context)
                                        .copyWith(
                                            color:
                                                HexColor(AppColors.appMainColor)),
                                  ),
                                ),
                              )),
                        )
                      ],
                    )))
          ],
        ),
      ),
    );
  }

// Future<bool> _onBackPressed() {
//   return showDialog(
//         context: context,
//         builder: (context) => new AlertDialog(
//           title: new Text('Are you sure?'),
//           content: new Text('Do you want to exit Tricycle?'),
//           actions: <Widget>[
//             new GestureDetector(
//               onTap: () => Navigator.of(context).pop(false),
//               child: Text("NO"),
//             ),
//             SizedBox(height: 16),
//             new GestureDetector(
//               onTap: () {
//                 SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//               },
//               child: Text("YES"),
//             ),
//           ],
//         ),
//       ) ??
//       false;
// }
}
