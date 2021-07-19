import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

import '../../ui/camera_module/photo_preview_screen.dart';

// ignore: must_be_immutable
class SelectStudentTypeDialog extends StatelessWidget {
  String title;
  String subtitle;
  TextStyleElements styleElements;
  String type;
  int id;

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

  SelectStudentTypeDialog({
    Key key,
    @required this.id,
    @required this.type,
    @required this.title,
    @required this.subtitle,
  }) : super(key: key);
  RandomColor _randomColor = RandomColor();

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          height: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12, top: 30),
                    child: Text(
                      title,
                      style: styleElements.headline5ThemeScalable(context),
                      textAlign: TextAlign.center,
                    ),
                  )),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      subtitle,
                      style: styleElements.bodyText2ThemeScalable(context),
                      textAlign: TextAlign.center,
                    ),
                  )),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhotoPreviewScreen(
                                registerUserAs: null,
                                /*type: "student",*/
                              ),
                            ));
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 120,
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Container(
                                color: _randomColor.randomColor(),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              margin: EdgeInsets.all(10),
                            ),
                          ),
                          Positioned.fill(
                              child: Align(
                            alignment: Alignment.center,
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 12, right: 12, top: 30),
                                color: HexColor(AppColors.appColorTransparent),
                                child: Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.school,
                                      size: 30,
                                      color: HexColor(AppColors.appColorWhite),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate("current_student"),
                                      maxLines: 2,
                                      style: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorWhite)),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                )),
                          )),
                        ],
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PhotoPreviewScreen(
                                      registerUserAs: null,
                                      /*type: "student",*/
                                    ),
                                  ));
                            },
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: 120,
                                  child: Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Container(
                                      color: _randomColor.randomColor(),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 12, right: 12, top: 30),
                                      color: HexColor(AppColors.appColorTransparent),
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.person,
                                            size: 30,
                                            color: HexColor(AppColors.appColorWhite),
                                          ),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate("old_student"),
                                            maxLines: 2,
                                            style: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorWhite)),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      )),
                                ),
                              ],
                            ))),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
