import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/models/subject_categories.dart';
import 'package:oho_works_app/profile_module/common_cards/user_pipulaity_card.dart';
import 'package:oho_works_app/profile_module/pages/particular_subject_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:random_color/random_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'institute_card.dart';
import 'overlaped_circular_images.dart';

// ignore: must_be_immutable
class SubjectsProfilePage extends StatefulWidget {
  String id;
  TextStyleElements? styleElements;
  SubjectsProfilePage({Key? key, required this.id}) : super(key: key);

  _SubjectsProfilePage createState() => _SubjectsProfilePage();
}

class _SubjectsProfilePage extends State<SubjectsProfilePage>
    with SingleTickerProviderStateMixin {

  late TextStyleElements styleElements;
  SharedPreferences? prefs;
  List<SubjectsItem>? listSubjects = [];
  var isSearching = false;
  RandomColor _randomColor = RandomColor();
bool isLoading=false;
  @override
  void initState() {
    super.initState();

    getSubjectCategories(null);
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
                    color:  HexColor(AppColors.appColorRed50),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          'https://picsum.photos/seed/picsum/200/300'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                isLoading?    PreloadingView(
                    url: "assets/appimages/settings.png"): ListView(
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
                            subtitle: AppLocalizations.of(context)!.translate('entity'),
                            subtitle1: AppLocalizations.of(context)!.translate('subject'),
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
                                textSix: "3",
                                textSeven: "2",
                                textEight: "45",
                                textOne: "courses",
                                textTwo: "sections",
                                textThree: "classes",
                                callback: () {},
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
                          children: listSubjects!.map((SubjectsItem data) {
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
                                                                      data.subjectCategoryName ??=
                                                                          "",
                                                                      style:
                                                                      styleElements.subtitle1ThemeScalable(context),
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
                                                      data.subjectCategoryCode ??=
                                                          "",
                                                      style:styleElements.captionThemeScalable(context),
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

  void getSubjectCategories(String? searchValue) async {
setState(() {
  isLoading=true;
});
    final body = jsonEncode({
      "institution_id": 2,
      "searchVal": searchValue,
    });

    Calls().call(body, context, Config.SUBJECTS_CATEGORIES).then((value) async {
      setState(() {
        isLoading=false;
      });
      isSearching = false;
      if (value != null) {
        var data = SubjectsCategories.fromJson(value);
        setState(() {
          listSubjects = data.rows;
        });
      }
    }).catchError((onError) async {

      setState(() {
        isLoading=false;
      });
    });
  }
}
