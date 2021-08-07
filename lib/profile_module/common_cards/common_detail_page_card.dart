import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CommonDetailPageCard extends StatelessWidget {
  String title;
  String subtitle;
  String content;
  bool isShowMore;
  bool isIntroCard;
  bool? isContentAvailabel;
  String subtitle1;
  String subtitle2;
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

  CommonDetailPageCard(
      {Key? key,
      required this.isShowMore,
      required this.isIntroCard,
      required this.title,
      required this.subtitle,
      required this.subtitle1,
      required this.subtitle2,
      required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Column(
      children: <Widget>[
        Visibility(
          child: Align(
              alignment: Alignment.center,
              child: Visibility(
                child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Container(
                              child: Image(
                            image:
                                AssetImage('assets/appimages/dummyschool.png'),
                            fit: BoxFit.contain,
                            width: 78,
                            height: 78,
                          )),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                              '$content',
                              style: styleElements.bodyText1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),
                              textAlign: TextAlign.center,
                            )),
                        Align(
                          alignment: Alignment.center,
                          child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          child: Icon(
                                            Icons.location_on,
                                            color: HexColor(AppColors.appColorWhite),
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                          text: subtitle2,
                                          style: styleElements.subtitle1ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorWhite))),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: const EdgeInsets.all(16.0),
                              height: 30,
                              child: appElevatedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(color: HexColor(AppColors.appMainColor))),
                                onPressed: () {},
                                color: HexColor(AppColors.appMainColor),
                                child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('follow')
                                        .toUpperCase(),
                                    style:styleElements.buttonThemeScalable(context).copyWith(
                                      color: HexColor(AppColors.appColorWhite),
                                    )),
                              ),
                            ))
                      ],
                    )),
              )),
        )
      ],
    );
  }
}
