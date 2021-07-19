
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'overlaped_circular_images.dart';

// ignore: must_be_immutable
class MediunDetail extends StatelessWidget {
  final CommonCardData data;

  String instituteName;
  String instituteAddress;
  BuildContext context;
  Null Function() callbackPicker;
  List<SubRow> list = [];
  TextStyleElements styleElements;
  int id;
  String personType;

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

  MediunDetail(
      {Key key,
        @required this.data,
        @required this.onSeeMoreClicked,
        this.styleElements,
        this.id,
        this.personType,
        this.callbackPicker})
      : super(key: key);
  String type;

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
      child:ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: list.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(0.0),
        itemBuilder: (context, position) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onLongPress: () {

            },
            onTap: () {
            },
            child: Container(
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
                                      Utility().toCamelCase(list[position].textOne??"")??
                                          "",
                                      style: styleElements
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
                                                list[position].avgRating !=null? list[position].avgRating.toStringAsFixed(2).toString() : "",
                                                style: styleElements
                                                    .captionThemeScalable(context)
                                                    .copyWith(color: HexColor(AppColors.appColorBlack35)),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: RatingBar(
                                                initialRating: list[position].avgRating !=null? double.parse(list[position].avgRating.toStringAsFixed(2)):0,
                                                minRating: list[position].avgRating !=null? double.parse(list[position].avgRating.toStringAsFixed(2)):0,
                                                maxRating: list[position].avgRating !=null? double.parse(list[position].avgRating.toStringAsFixed(2)):0,
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
                                  visible: list[position].textTwo != null &&
                                      list[position].textTwo != "",
                                  child: Container(
                                    padding: EdgeInsets.only(

                                      top: 2.h,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        OverlappedImages(list[position].images),
                                        Flexible(
                                          child:
                                          Padding(
                                            padding: const EdgeInsets.only(left: 4),
                                            child: Text(
                                              list[position].textTwo ?? "",
                                              overflow: TextOverflow.ellipsis,
                                              style: styleElements
                                                  .captionThemeScalable(context)
                                                  .copyWith(color: HexColor(AppColors.appColorBlack35)),
                                              textAlign: TextAlign.left,
                                            ),
                                          )
                                          ,
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
            ),
          );
        },
      ),
    );
  }

  String getExpertise(List<String> list) {
    return  list.join(',');
  }


}
