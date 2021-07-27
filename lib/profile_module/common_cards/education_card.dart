import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
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
class EducationCard extends StatelessWidget {
  final CommonCardData data;
  BuildContext? context;
  Null Function()? callbackPicker;
  String? type;
  int? id;
  String? personType;
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

  EducationCard(
      {Key? key,
      required this.data,
      this.styleElements,
      this.callbackPicker,
      this.id,
        this.CardType,
      this.personType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    CardType =="work" ? "work" : "education";

    styleElements = TextStyleElements(context);
    return appListCard(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Visibility(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 16.0.h,
                          right: 16.h,
                          top: 12.h,
                          bottom: 12.h),
                      child: Text(
                        data.title ?? "",
                        style: styleElements!
                            .headline6ThemeScalable(context)
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: HexColor(AppColors.appColorBlack85)),
                        textAlign: TextAlign.left,
                      ),
                    )),
                flex: 3,
              ),
              Visibility(
                visible: personType == "person",
                child: Flexible(
                  child:  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                        alignment: Alignment.topRight,
                        child:  GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            if ( CardType =="work") {
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditEducation(null, false, false, null)));

                              if (result != null && result['result'] == "success") {
                                callbackPicker!();
                              }
                            } else {
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditEducation(null, true, false, null)));

                              if (result != null && result['result'] == "success") {
                                callbackPicker!();
                              }
                            }

                          },
                          child: Icon(
                            Icons.add,
                            size: 30,
                            color: HexColor(AppColors.appColorBlack85),
                          ),
                        )),
                  ),
                  flex: 1,
                ),
              ),
            ],
          ),
        ),
        (data.textOne != null && data.textOne != "None")
            ? Container(
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
                            visible:
                                data.textOne != null && data.textOne != "",
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 8.h, right: 8.h, top: 8.0.h),
                                child: Text(
                                  data.textOne!,
                                  style: styleElements!
                                      .subtitle1ThemeScalable(context)
                                      .copyWith(
                                          fontWeight: FontWeight.w600),
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
                                (data.textFive != null &&
                                            data.textFive != "None"
                                        ? DateFormat('MM/yyyy').format(
                                            DateTime.parse(data.textFive!))
                                        : "  --") +
                                    (data.textSix != null &&
                                            data.textSix != "None"
                                        ? " to " +
                                            DateFormat('MM/yyyy').format(
                                                DateTime.parse(
                                                    data.textSix!))
                                        : data.textFive != null &&
                                                data.textFive != "None"
                                            ? data.isCurrent!
                                                ? " to till now"
                                                : ""
                                            : ""),
                                style: styleElements!
                                    .subtitle2ThemeScalable(context),
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
                                        color: HexColor(
                                            AppColors.appColorBlack65)),
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
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            if (personType == "person") {
                              if ( CardType =="work") {
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditEducation(
                                            data, false, false, null)));

                                if (result != null &&
                                    result['result'] == "success") {
                                  callbackPicker!();
                                }
                              } else {
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditEducation(
                                            data, true, false, null)));
                                if (result != null &&
                                    result['result'] == "success") {
                                  callbackPicker!();
                                }
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
                      ),
                    )
                  ],
                ))
            : Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () async {
                    if (personType == "person") {
                      if ( CardType =="work") {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditEducation(
                                    null, false, false, null)));

                        if (result != null &&
                            result['result'] == "success") {
                          callbackPicker!();
                        }
                      } else {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditEducation(
                                    null, true, false, null)));
                        if (result != null &&
                            result['result'] == "success") {
                          callbackPicker!();
                        }
                      }
                    }
                  },
                  child: Container(
                      height: 150,
                      width: 200,
                      margin: const EdgeInsets.only(bottom: 20, top: 20),
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: HexColor(AppColors.appColorWhite),
                      ),
                      child: CustomPaginator(context).emptyListWidgetMaker(null)),
                ),
              ),
        Container(
          margin: EdgeInsets.only(left: 16.h, right: 20.h, top: 8.0.h),
          child: Text(
            data.textFour ??= "",
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
              onTap: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileCards(
                        userId: id,
                        userType: personType,
                        type:  CardType =="work"
                            ? "work"
                            : "education",
                        currentPosition: 2,
                      ),
                    ));
                if (result != null && result['result'] == "update") {
                  callbackPicker!();
                }
              },
              child: Container(
                margin:
                    EdgeInsets.only(right: 20.h, top: 20.h, bottom: 20.h),
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
    ));
  }
}
