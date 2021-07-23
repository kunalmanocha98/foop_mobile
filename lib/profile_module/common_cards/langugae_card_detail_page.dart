
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/delete_class.dart';
import 'package:oho_works_app/profile_module/pages/select_language_proficiency_dialog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'overlaped_circular_images.dart';

// ignore: must_be_immutable
class LanguageCardDetailPage extends StatelessWidget {
  final CommonCardData data;
  int? id;
  String? personType;
  String? userName;
  String? instituteName;
  String? instituteAddress;
  BuildContext? context;
  Null Function()? callbackPicker;
  List<SubRow>? list = [];
  TextStyleElements? styleElements;

  VoidCallback onSeeMoreClicked;

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

  LanguageCardDetailPage(
      {Key? key,
      required this.data,
      required this.onSeeMoreClicked,
      this.styleElements,
      this.userName,
      this.personType,
      this.id,
      this.callbackPicker})
      : super(key: key);
  String? type;

  @override
  Widget build(BuildContext context) {
    list = data.subRow;
    if (data.title == "Language")
      type = "Languages";
    else
      type = "Skill";
    styleElements = TextStyleElements(context);
    this.context = context;
    return Container(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(0.0),
        itemCount: list!.length,
        shrinkWrap: true,
        itemBuilder: (context, position) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onLongPress: () {
              if (personType == "person") {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => DeleteClass(
                      id: list![position].id.toString(),
                      categoryType:
                      data.title == "Language" ? "language" : "skill",
                      instId: list![position].allInstitutionsId.toString(),
                      callbackPicker: () {
                        callbackPicker!();
                      },
                      subtitle: null,
                      title: null,
                      type: null,
                    ));
              }
            },
            onTap: () {

              if (list![position].isUserAuthorized == "Yes" &&
                  (personType == "person" || personType == "thirdPerson")) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        SelectLanguageProficiencyDialogue(
                          personId: id,
                          title2: AppLocalizations.of(context)!
                              .translate("what_want_to_be"),
                          title: personType == "person"
                              ? AppLocalizations.of(context)!
                              .translate("my_proficiency")
                              : ("Endorse " +
                              userName!.split(' ')[0] +
                              "'s " +
                              AppLocalizations.of(context)!
                                  .translate("proficiency")),
                          subtitle: personType == "person"
                              ? AppLocalizations.of(context)!
                              .translate("rate_experties")
                              : AppLocalizations.of(context)!
                              .translate("rate_expert"),
                          categoryType: type,
                          id1: list![position]
                              .standardExpertiseCategoryTypeId
                              .toString(),
                          starRatingsId: list![position].starRatingId,
                          id2: list![position]
                              .standardExpertiseCategoryId
                              .toString(),
                          id3: list![position].standardExpertiseCategoryTypeId,
                          starRatings: list![position].rattingStar!.toDouble(),
                          instId: list![position].institutionId,
                          itemId: int.parse(list![position].id!),

                          callbackPicker: () {
                            callbackPicker!();
                          },
                          type: null,
                        ));
              }
              else
              { {
                ToastBuilder().showToast(
                    AppLocalizations.of(
                        context)!
                        .translate(
                        "not_authorized"),
                    context,HexColor(AppColors.information));
              }}
            },
            child: Container(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 16, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    child: Text(
                                      Utility().toCamelCase(list![position]
                                          .standardExpertiseCategoryTypes ??
                                          ""),
                                      style: styleElements!
                                          .bodyText1ThemeScalable(context)
                                          .copyWith(fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                list![position].avgRating != null
                                                    ? list![position]
                                                    .avgRating!
                                                    .toStringAsFixed(2)
                                                    .toString()
                                                    : "",
                                                style: styleElements!
                                                    .captionThemeScalable(context)
                                                    .copyWith(
                                                    color: HexColor(AppColors.appColorBlack35)),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: RatingBar(
                                                initialRating: list![position]
                                                    .avgRating !=
                                                    null
                                                    ? double.parse(list![position]
                                                    .avgRating!
                                                    .toStringAsFixed(2))
                                                    : 0,
                                                minRating: list![position]
                                                    .avgRating !=
                                                    null
                                                    ? double.parse(list![position]
                                                    .avgRating!
                                                    .toStringAsFixed(2))
                                                    : 0,
                                                maxRating: list![position]
                                                    .avgRating !=
                                                    null
                                                    ? double.parse(list![position]
                                                    .avgRating!
                                                    .toStringAsFixed(2))
                                                    : 0,
                                                direction: Axis.horizontal,
                                                ignoreGestures: true,
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 2.h),
                                  child: Text(
                                    list![position].abilites != null &&
                                        list![position].abilites!.isNotEmpty
                                        ? getExpertise(list![position].abilites!)
                                        : "",
                                    style: styleElements!
                                        .subtitle2ThemeScalable(context)
                                        .copyWith(color: HexColor(AppColors.appColorBlack65)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Visibility(
                                  visible: list![position].totalCount != null &&
                                      list![position].totalCount != "",
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      top: 2.h,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                            child: OverlappedImages(
                                                list![position].images)),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(left: 4),
                                            child: Text(
                                              list![position].totalCount ?? "",
                                              overflow: TextOverflow.ellipsis,
                                              style: styleElements!
                                                  .captionThemeScalable(context)
                                                  .copyWith(
                                                  color: HexColor(AppColors.appColorBlack35)),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.only(
                              right: 16.h,
                            ),
                            child: Icon(
                              Icons.star_border_outlined,
                              color: HexColor(AppColors.appMainColor),
                              size: 24.h,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String getExpertise(List<String> list) {
    return list.join(',');
  }
}
