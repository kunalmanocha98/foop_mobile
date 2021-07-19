import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

import 'commonComponents.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class Googlebutton extends StatelessWidget {
  Googlebutton({
    Key key,
    String name,
    double offsetX,
    double offsetY,
  }) : super(key: key);
  TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Stack(
      children: <Widget>[
        Container(
          width: 260.0,
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            color:  HexColor(AppColors.appColorWhite),
            boxShadow: [CommonComponents().getShadowforBox()],
          ),
        ),
        Transform.translate(
          offset: Offset(55.96, 11.44),
          child: Text(
            AppLocalizations.of(context).translate('google_in'),
            style: styleElements.headline5ThemeScalable(context),
            textAlign: TextAlign.left,
          ),
        ),
        Transform.translate(
          offset: Offset(31.51, 12.72),
          child: Stack(
            children: <Widget>[
              // Adobe XD layer: 'search' (group)
              Stack(
                children: <Widget>[
                  // SvgPicture.string(
                  //   _svg_4macix,
                  //   allowDrawingOutsideViewBox: true,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
