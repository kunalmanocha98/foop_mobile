import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FollowButton extends StatelessWidget {
  FollowButton({
    Key? key,
  }) : super(key: key);
  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(-292.0, -129.0),
          child: Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(292.0, 129.0),
                child: Container(
                  width: 51.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color:  HexColor(AppColors.appMainColor),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(297.0, 87.17),
                child: SizedBox(
                  width: 42.0,
                  child: Text(AppLocalizations.of(context)!.translate('follow'),
                    style: styleElements.captionThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
