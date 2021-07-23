import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'commonComponents.dart';

// ignore: must_be_immutable
class TricycleTabButton extends StatelessWidget {
  bool isActive;
  Function onPressed;
  String? tabName;
  late TextStyleElements styleElements;

  TricycleTabButton(
      {required this.isActive,
        required this.onPressed,
        required this.tabName});

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45.0),
        boxShadow: [CommonComponents().getShadowforBox()],
      ),
      child: TricycleElevatedButton(
        elevation: 0,
        shape: StadiumBorder(
            side: BorderSide(
                color: isActive ? HexColor(AppColors.appMainColor) : HexColor(AppColors.appColorWhite))),
        onPressed: onPressed,
        child: Text(
          tabName!,
          style: styleElements.captionThemeScalable(context).copyWith(
              color: isActive ? HexColor(AppColors.appColorWhite) : HexColor(AppColors.appMainColor)),
        ),
        color: isActive ? HexColor(AppColors.appMainColor) : HexColor(AppColors.appColorWhite),
      ),
    );
  }
}
