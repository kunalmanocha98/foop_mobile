import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

import 'commonComponents.dart';

// ignore: must_be_immutable
class ImaxyzButton extends StatelessWidget {
  ImaxyzButton({
    Key key,
  }) : super(key: key);

  TextStyleElements  styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Stack(
      children: <Widget>[
        Container(
          width: 328.0,
          height: 70.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color:  HexColor(AppColors.appColorWhite),
            boxShadow: [CommonComponents().getShadowforBox()],
          ),
        ),
        Transform.translate(
          offset: Offset(24.0, 17.0),
          child:
              // Adobe XD layer: 'Home-color' (shape)
              Container(
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(''),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(-24.0, -324.0),
          child:
              // Adobe XD layer: 'Text' (group)
              Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(96.0, 342.33),
                child: Text(AppLocalizations.of(context).translate('i_am_teacher'),
                  style:styleElements.headline6ThemeScalable(context),
                  textAlign: TextAlign.left,
                ),
              ),
              Transform.translate(
                offset: Offset(96.0, 363.0),
                child: Text(
                  AppLocalizations.of(context).translate('teaching_non_teaching'),
                  style: styleElements.captionThemeScalable(context),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
