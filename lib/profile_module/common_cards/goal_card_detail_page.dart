import 'dart:ui';

import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/create_goal.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class GoalsAndObjectiveCardDetailPage extends StatelessWidget {
  final CommonCardData data;
  late BuildContext context;

  // double _sigmaX = 5.01; // from 0-10
  // double _sigmaY = 5.01; // from 0-10
  // double _opacity = 0.0; // from 0-1.0
  Widget _simplePopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(AppLocalizations.of(context)!.translate('add_goal')),
          ),
        ],
        onSelected: (value) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateGoal(),
              ));
        },
        icon: Icon(
          Icons.more_horiz,
          size: 30,
          color: HexColor(AppColors.appColorBlack85),
        ),
      );

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
  late TextStyleElements styleElements;
  GoalsAndObjectiveCardDetailPage({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    return Container(
        margin:  EdgeInsets.only(left: 8.0.h,right: 8.0.h, top: 4.0.h, bottom: 4.0.h),
      child: Card(
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.only(left: 16, right: 16,top:12,bottom:12),
                          child: Text(
                            data.title ?? "",
                            style: styleElements.headline5ThemeScalable(context),
                            textAlign: TextAlign.left,
                          ),
                        )),
                    flex: 3,
                  ),
                  Flexible(
                    child: Align(
                        alignment: Alignment.topRight, child: _simplePopup()),
                    flex: 1,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 20, top: 20, right: 20, bottom: 20),
                  child: Text(
                    data.textOne ?? "",
                    style: styleElements.bodyText1ThemeScalable(context),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
