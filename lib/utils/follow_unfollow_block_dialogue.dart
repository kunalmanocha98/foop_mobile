import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

// ignore: must_be_immutable
class DilogBlockUnfollow extends StatelessWidget {
  DilogBlockUnfollow(
      {Key? key,
      this.image,
      this.title,
      this.startGradientColor,
      this.endGradientColor,
      this.subText,
        this.clicked,
      this.callback})
      : super(key: key);

  final String? image;
  final title;
  Null Function()? clicked;
  final Color? startGradientColor;
  final Color? endGradientColor;
  final String? subText;
  Null Function(bool isCallSuccess)? callback;

  String? type;
  late TextStyleElements styleElements;

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

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 50),
            alignment: Alignment.topCenter,
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image!),
                fit: BoxFit.fill,
              ),
            ),
            child: null /* add child content here */,
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 16, bottom: 12, top: 12, right: 16),
            alignment: Alignment.center,
            child: Text(
              title,
              style: styleElements.headline5ThemeScalable(context),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 16, bottom: 12, top: 12, right: 16),
            alignment: Alignment.center,
            child: Text(
              subText!,
              style:styleElements.subtitle2ThemeScalable(context),
              textAlign: TextAlign.center,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(

                color: HexColor(AppColors.appColorWhite),
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        child: appElevatedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: HexColor(AppColors.appMainColor))),
                          onPressed: () {
                            Navigator.pop(context, null);
                            callback!(false);
                          },
                          color: HexColor(AppColors.appColorWhite),
                          child: Text(
                              AppLocalizations.of(context)!
                                  .translate('cancel')
                                  .toUpperCase(),
                              style: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor))),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        child: appElevatedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: HexColor(AppColors.appMainColor))),
                          onPressed: () {
                            Navigator.pop(context, null);
                            if(clicked!=null)
                            clicked!();
                            callback!(true);
                          },
                          color: HexColor(AppColors.appMainColor),
                            child: Text(
                                AppLocalizations.of(context)!
                                    .translate('ok')
                                    .toUpperCase(),
                                style: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite))),
                        ),
                      ),
                    ),

                  ],
                )),
          )
        ],
      ),
    );
  }
}
