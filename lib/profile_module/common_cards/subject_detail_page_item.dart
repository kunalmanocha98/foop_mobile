
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
class SubjectsDetailPageCard extends StatelessWidget {
  final CommonCardData data;
  int? id;
  String? instituteName;
  String? instituteAddress;
  BuildContext? ctx;
  Null Function()? callbackPicker;
  List<SubRow>? list = [];
  TextStyleElements? styleElements;
  String? instId;
  String? type;
  VoidCallback onSeeMoreClicked;
  String? userName;
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

  SubjectsDetailPageCard(
      {Key? key,
      required this.data,
      required this.onSeeMoreClicked,
      this.styleElements,
        this.type,
        this.id,
        this.userName,
      this.callbackPicker,
      this.instId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    list = data.subRow;
    styleElements = TextStyleElements(context);
    this.ctx = context;
    return Container(
      child:ListView.builder(
        padding: EdgeInsets.all(0.0),
        physics: BouncingScrollPhysics(),
        itemCount: list!.length,
        shrinkWrap: true,
        itemBuilder: (context, position) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onLongPress: () {
              if(type=="person"){
                showDialog(
                    context: context,
                    builder: (BuildContext context) => DeleteClass(
                      id: list![position].id.toString(),
                      categoryType: "subject",
                      instId: list![position].allInstitutionsId.toString(),
                      callbackPicker: () {
                        callbackPicker!();
                      }, subtitle: null, title: null, type: null,));}
            },
            onTap: () {
              if (list![position].isUserAuthorized == "Yes" && (type == "person" || type == "thirdPerson"))
              {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        SelectLanguageProficiencyDialogue(
                            personId: id,
                            type: type=="person"?"edit_subject":"add_subject",
                            title2: AppLocalizations.of(context)!
                                .translate("what_want_to_be"),
                            title:type=="person"?AppLocalizations.of(context)!
                                .translate("my_proficiency"):("Endorse "+userName!.split(' ')[0]+"'s " +AppLocalizations.of(context)!
                                .translate("proficiency")) ,
                            subtitle: type=="person"?AppLocalizations.of(context)!
                                .translate("rate_experties"):AppLocalizations.of(context)!
                                .translate("rate_expert"),
                            categoryType: "Subject",
                            starRatingsId:list![position].starRatingId,
                            starRatings: list![position].rattingStar!.toDouble(),
                            itemId: int.parse(list![position].id!),
                            id1: list![position].institutionSubject,
                            instId: list![position].allInstitutionsId.toString(),
                            id3: list![position].instSubjectId.toString(),
                            callbackPicker: () {
                              callbackPicker!();
                            }
                          /* id1: subjectId,
                          instId: instituteId.toString(),*/
                        ));
              }
              else
              {
                ToastBuilder().showToast(
                    AppLocalizations.of(
                        ctx!)!
                        .translate(
                        "not_authorized"),
                    ctx,HexColor(AppColors.information));
              }

            },
            child:Container(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 16,bottom: 16) ,
                    child:  Row(
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
                                      Utility().toCamelCase(list![position].textOne??""),
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
                                        padding: EdgeInsets.only(
                                            top: 2.h),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                list![position].avgRating !=null? list![position].avgRating!.toStringAsFixed(2).toString() : "",
                                                style: styleElements!
                                                    .captionThemeScalable(context)
                                                    .copyWith(color: HexColor(AppColors.appColorBlack35)),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: RatingBar(
                                                initialRating: list![position].avgRating !=null? double.parse(list![position].avgRating!.toStringAsFixed(2)):0,
                                                minRating: list![position].avgRating !=null? double.parse(list![position].avgRating!.toStringAsFixed(2)):0,
                                                maxRating: list![position].avgRating !=null? double.parse(list![position].avgRating!.toStringAsFixed(2)):0,
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
                                Visibility(
                                    visible: list![position].abilites != null &&
                                        list![position].abilites!.isNotEmpty,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 2.h),
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
                                    ))
                                ,
                                Container(
                                  padding: EdgeInsets.only(

                                    top: 2.h,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width:75,
                                        child: OverlappedImages(list![position].images),

                                      ) ,
                                      Flexible(
                                        child:
                                        Padding(
                                          padding: const EdgeInsets.only(left: 4),
                                          child: Text(
                                            list![position].textTwo ?? "",
                                            overflow: TextOverflow.ellipsis,
                                            style: styleElements!
                                                .captionThemeScalable(context)
                                                .copyWith(color: HexColor(AppColors.appColorBlack35)),
                                            textAlign: TextAlign.left,
                                          ),
                                        )
                                        ,
                                        flex: 4,
                                      )
                                    ],
                                  ),
                                ),


                              ],
                            )),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.only(
                              right: 16.h, ),
                            child: Icon(
                              Icons.star_border_outlined,
                              color: HexColor(AppColors.appMainColor),
                              size: 24.h,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                  ,
                  Divider(
                    height: 1,
                  )
                ],
              ),
            ) /*Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 16.0.h, right: 16.h, top: 8.h),
                                child: Text(
                                  list[position].textOne ?? "",
                                  style: styleElements
                                      .subtitle1ThemeScalable(context)
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
                                    padding: EdgeInsets.only(
                                        left: 16.0.h, right: 16.h, top: 2.h),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            list[position].avgRating != null
                                                ? list[position].avgRating.roundToDouble().toString()
                                                : "",
                                            style: styleElements
                                                .subtitle2ThemeScalable(
                                                    context),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: RatingBar(
                                            initialRating: 5,
                                            minRating: 5,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemSize: 12.0,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star_border,
                                              color: HexColor(AppColors.appColorGrey500),
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
                              padding: EdgeInsets.only(
                                  left: 16.0.h, right: 16.h, top: 2.h),
                              child: Text(
                                list[position].abilites != null &&
                                        list[position].abilites.isNotEmpty
                                    ? getExpertise(list[position].abilites)
                                    : "",
                                style: styleElements
                                    .subtitle2ThemeScalable(context)
                                    .copyWith(color: HexColor(AppColors.appColorBlack65)),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 16.0.h,
                                  right: 16.h,
                                  top: 2.h,
                                  bottom: 16.h),
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    child: OverlappedImages(list[position].images),
                                  ),

                                  Text(
                                    list[position].totalCount ?? "",
                                    style: styleElements
                                        .captionThemeScalable(context)
                                        .copyWith(color: HexColor(AppColors.appColorBlack35)),
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 16.0.h, right: 36.h, top: 2.h),
                          child: Icon(
                            Icons.star_border_outlined,
                            color: HexColor(AppColors.appMainColor),
                            size: 24.h,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 1,
                    )
                  ],
                ),
              )*/,
          );
        },
      ),
    );
  }

  String getExpertise(List<String> list) {
    return  list.join(',');
  }
}
