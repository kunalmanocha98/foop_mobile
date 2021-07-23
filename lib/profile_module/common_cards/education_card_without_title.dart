import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/edit_education.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class EducationCardWithOutTitle extends StatelessWidget {
  final CommonCardData data;
  BuildContext? context;
  Null Function()? callbackPicker;
  String? personType;
  int? id;
  String? CardType;

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

  TextStyleElements? styleElements;

  EducationCardWithOutTitle(
      {Key? key,
      required this.data,
      this.styleElements,
      this.callbackPicker,
      this.personType,
      this.id,
      this.CardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 8.h, right: 8.h, top: 8.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                        visible: data.textOne != null && data.textOne != "",
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 8.h, right: 8.h, top: 8.0.h),
                            child: Text(
                              data.textOne ??= "",
                              style: styleElements!
                                  .subtitle1ThemeScalable(context)
                                  .copyWith(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 8.h, right: 8.h, top: 8.0.h),
                          child: Text(
                            (data.textFive != null && data.textFive != "None"
                                    ? DateFormat('MM/yyyy')
                                        .format(DateTime.parse(data.textFive!))
                                    : "  --") +
                                (data.textSix != null && data.textSix != "None"
                                    ? " to " +
                                        DateFormat('MM/yyyy').format(
                                            DateTime.parse(data.textSix!))
                                    : data.isCurrent!
                                        ? " to till now"
                                        : ""),
                            style:
                                styleElements!.subtitle2ThemeScalable(context),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 8.h, right: 8.h, top: 8.0.h),
                          child: Text(
                            data.textThree ??= "",
                            style: styleElements!
                                .subtitle1ThemeScalable(context)
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: HexColor(AppColors.appColorBlack65)),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: personType == "person",
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      if (CardType == "work") {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditEducation(data, false, false, null)));

                        if (result != null && result['result'] == "success") {
                          callbackPicker!();
                        }
                      } else {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditEducation(data, true, false, null)));

                        if (result != null && result['result'] == "success") {
                          callbackPicker!();
                        }
                      }
                    },
                    child: Container(
                      height: 36,
                      width: 36,
                      margin: EdgeInsets.all(8.h),
                      child: Icon(
                        Icons.edit_outlined,
                        color: HexColor(AppColors.appColorGrey500),
                      ),
                    ),
                  ),
                )
              ],
            )),
        Container(
          margin: EdgeInsets.only(left: 16.h, right: 20.h, top: 8.0.h),
          child: Text(
            data.textFour != null && data.textFour != "None"
                ? data.textFour ??= ""
                : "",
            style: styleElements!.subtitle2ThemeScalable(context),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            textAlign: TextAlign.left,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileCards(
                        type: CardType == "work" ? "work" : "education",
                        userType: personType,
                        userId: id,
                        currentPosition: 2,
                      ),
                    ));
              },
              child: Container(
                margin: EdgeInsets.only(right: 20.h, top: 20.h, bottom: 10.h),
                child: Visibility(
                  visible: data.isShowMore ??= false,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(AppLocalizations.of(context)!.translate('see_more'),
                      style: styleElements!.subtitle2ThemeScalable(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
