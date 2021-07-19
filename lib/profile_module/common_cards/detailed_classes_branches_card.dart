import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/delete_class.dart';
import 'package:oho_works_app/profile_module/pages/select_language_proficiency_dialog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:random_color/random_color.dart';


// ignore: must_be_immutable
class ClassesAndBranchesDetailed extends StatelessWidget {
  final CommonCardData data;

  String type;
  String instituteName;
  String instituteAddress;
  String userName;
  BuildContext context;
  List<SubRow> list = [];
  TextStyleElements styleElements;
  String institutionId;
  Null Function() callbackPicker;
  int id;
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

  ClassesAndBranchesDetailed(
      {Key key,
      @required this.data,
      this.callbackPicker,
      this.styleElements,
        this.type,
        this.id,
        this.userName,
      this.institutionId})
      : super(key: key);
  RandomColor _randomColor = RandomColor();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    list = data.subRow;
    styleElements = TextStyleElements(context);
    return Container(
        margin: EdgeInsets.only(
            left: 8.0.h, right: 8.0.h, top: 4.0.h, bottom: 4.0.h),
        child: list.isNotEmpty
            ? GridView.count(
            padding: EdgeInsets.all(0.0),
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: 2 / 2,
                children: list.map((SubRow data) {
                  return Visibility(
                    visible: list.isNotEmpty && list.length > 0,
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onLongPress: () {
                          if(type=="person")
                          {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => DeleteClass(
                                  id: data.id,

                                  categoryType: "class",
                                  instId: data.allInstitutions.toString(),
                                  callbackPicker: () {
                                    callbackPicker();
                                  }, subtitle: null, title: null, type: null,




                                ));
                          }

                        },
                        onTap: () {
                          if(data.isUserAuthorized=="Yes" && (type=="person"|| type=="thirdPerson") )
                          {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    SelectLanguageProficiencyDialogue(
                                        personId: id,
                                        type:type=="person"? "edit_class":"add_class",
                                        title:type=="person"?"My Relation In this Class":("Endorse "+userName.split(' ')[0]+"'s " +"Proficiency In this Class"),
                                        subtitle: type=="person"?"Rate yourself in this class":"Rate this class",
                                        categoryType: "Class",
                                        id1: data.institutionClassId,
                                        id2: data.textThree,
                                        id3: data.institutionClassId,
                                        abilites: data.abilites,
                                        itemId: int.parse(data.id),
                                        starRatingsId: data.starRatingId,
                                        starRatings:
                                        data.rattingStar.toDouble(),
                                        instId: data.allInstitutions.toString(),
                                        callbackPicker: () {
                                          callbackPicker();
                                        }));
                          }
                          else
                          {
                            ToastBuilder().showToast(
                                AppLocalizations.of(
                                    context)
                                    .translate(
                                    "not_authorized"),
                                context,HexColor(AppColors.information));
                          }

                        },
                        child: Container(
                            child: Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: _randomColor.randomColor(),
                                      borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(8.0),
                                          topRight: const Radius.circular(8.0)),
                                    ),
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        data.textOne ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: styleElements
                                            .subtitle2ThemeScalable(context)
                                            .copyWith(
                                            color: HexColor(AppColors.appColorWhite),
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 16, right: 16, top: 8),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  data.avgRating != null
                                                      ? data.avgRating
                                                      .toStringAsFixed(2)
                                                      .toString()
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
                                                  initialRating:
                                                  data.avgRating != null
                                                      ? double.parse(data
                                                      .avgRating
                                                      .toStringAsFixed(2))
                                                      : 0,
                                                  minRating:
                                                  data.avgRating != null
                                                      ? double.parse(data
                                                      .avgRating
                                                      .toStringAsFixed(2))
                                                      : 0,
                                                  maxRating:
                                                  data.avgRating != null
                                                      ? double.parse(data
                                                      .avgRating
                                                      .toStringAsFixed(2))
                                                      : 0,
                                                  direction: Axis.horizontal,
                                                  ignoreGestures: true,
                                                  allowHalfRating: false,
                                                  itemCount: 5,
                                                  itemSize: 12.0,
                                                  itemPadding:
                                                  EdgeInsets.symmetric(
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
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 16, top: 4),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text("",
                                            style: styleElements
                                                .captionThemeScalable(context),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Flexible(
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              data.classTeacherName ??= "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: styleElements
                                                  .subtitle2ThemeScalable(context)
                                                  .copyWith(
                                                  color: HexColor(AppColors.appColorBlack85),
                                                  fontWeight:
                                                  FontWeight.w600),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 16.0,
                                          bottom: 4.0,
                                          top: 8.0),
                                      child: Text(
                                        data.totalCount ??= "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: styleElements
                                            .captionThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: SizedBox(
                                        height: 22.h,
                                        child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Container(
                                                margin: const EdgeInsets.all(16),
                                                child: Icon(
                                                  Icons.star_border_outlined,
                                                  color: HexColor(AppColors.appMainColor),
                                                  size: 22.h,
                                                ))),
                                      ))
                                ],
                              ),
                            ))),
                  );
                }).toList())
            : GestureDetector(
                child: Container(
                    height: 150,
                    margin: const EdgeInsets.only(bottom: 20, top: 20),
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      color: HexColor(AppColors.appColorWhite),
                    ),
                    child: CustomPaginator(context).emptyListWidgetMaker(null)),
              ));
  }
}
