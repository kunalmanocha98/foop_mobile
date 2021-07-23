import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/models/courses_data.dart';
import 'package:oho_works_app/profile_module/common_cards/institute_card.dart';
import 'package:oho_works_app/profile_module/common_cards/overlaped_circular_images.dart';
import 'package:oho_works_app/profile_module/common_cards/user_pipulaity_card.dart';
import 'package:oho_works_app/profile_module/pages/particular_subject_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:random_color/random_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CourseDetailPage extends StatefulWidget {
  String id;

  CourseDetailPage({Key? key, required this.id}) : super(key: key);

  _CourseDetailPage createState() => _CourseDetailPage();
}

class _CourseDetailPage extends State<CourseDetailPage>
    with SingleTickerProviderStateMixin {

  SharedPreferences? prefs;
  List<CoursesItem>? listSubjects = [];
  var isSearching = false;
  RandomColor _randomColor = RandomColor();
  late TextStyleElements styleElements;

  @override
  void initState() {
    super.initState();

    getCourses(null);
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

  Widget build(BuildContext context) {
    ScreenUtil.init;
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor(AppColors.appColorBackground),
        body: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: HexColor(AppColors.appColorBackground),
            body: Stack(
              children: <Widget>[
                Container(
                  height: displayHeight(context) / 3,
                  decoration: BoxDecoration(
                    color:  HexColor(AppColors.appMainColor35),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          'https://picsum.photos/seed/picsum/200/300'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                ListView(
                  children: <Widget>[
                    Container(
                      height: displayHeight(context) / 5,
                      decoration: BoxDecoration(
                        color: HexColor(AppColors.appColorTransparent),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color:  HexColor(AppColors.appColorWhite),
                        boxShadow: [CommonComponents().getShadowforBox()],
                      ),
                      margin: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                      child: Column(
                        children: <Widget>[
                          InstituteCard(
                            title: "",
                            subtitle: AppLocalizations.of(context)!.translate('academics'),
                            subtitle1: AppLocalizations.of(context)!.translate('courses'),
                            isShowMore: true,
                            isIntroCard: true,
                            subtitle2: "Himachal Pradesh",
                            content: "DAV Palampur Suraj Kund 176107",
                          ),
                          Divider(
                            height: 0.5,
                          ),
                          Container(
                            margin:
                                const EdgeInsets.only(top: 10.0, bottom: 20.0),
                            child: UserPopularityCard(
                                textFive: "32",
                                callback: () {},
                                textSix: "3",
                                textSeven: "2",
                                textEight: "45",
                                textOne: "courses",
                                textTwo: "sections",
                                textThree: "classes",
                                textFour: "rooms"),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          children: listSubjects!.map((CoursesItem data) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ParticularSubject(
                                          type: "subject",
                                          currentPosition: 1,
                                          /* type: "teacher",*/
                                        ),
                                      ));
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 120,
                                      child: Card(
                                        semanticContainer: true,
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        child: Container(
                                          color: _randomColor.randomColor(),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        elevation: 5,
                                        margin: EdgeInsets.all(10),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8.0,
                                      left: 4.0,
                                      right: 4.0,
                                      child: Container(
                                          color: HexColor(AppColors.appColorTransparent),
                                          child: Column(
                                            children: <Widget>[
                                              Positioned(
                                                top: 4.0,
                                                left: 4.0,
                                                right: 4.0,
                                                child: Container(
                                                    color: HexColor(AppColors.appColorTransparent),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 16.0,
                                                                  right: 16.0,
                                                                  bottom: 16.0,
                                                                  top: 16.0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image: DecorationImage(
                                                                      image:
                                                                          CachedNetworkImageProvider(
                                                                              ""),
                                                                      fit: BoxFit
                                                                          .fill),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      right: 16.0,
                                                                    ),
                                                                    child: Text(
                                                                      data.courseName ??=
                                                                          "",
                                                                      style:
                                                                          styleElements.subtitle1ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorWhite)),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                    )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0,
                                                    right: 16.0,
                                                    bottom: 16.0,
                                                    top: 4.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                        child:
                                                            OverlappedImages(null)),
                                                    Expanded(
                                                        child: Text(
                                                      data.courseDescription ??=
                                                          "",
                                                      style: styleElements.subtitle1ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorWhite)),
                                                      textAlign: TextAlign.left,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ));
                          }).toList()),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }

  void getCourses(String? searchValue) async {

    final body = jsonEncode({
      "institution_id": 2,
      "searchVal": searchValue,
    });

    Calls().call(body, context, Config.COURSE_LIST).then((value) async {


      isSearching = false;
      if (value != null) {
        var data = CourseData.fromJson(value);
        setState(() {
          listSubjects = data.rows;
        });
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));

    });
  }
}
