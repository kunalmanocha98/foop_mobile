import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/points_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_localization.dart';
import 'colors.dart';
import 'hexColors.dart';

// ignore: must_be_immutable
class DialogFinishGoal extends StatelessWidget {
  String title;
  String subtitle;
  BuildContext context;
  TextStyleElements styleElements;

  getbio(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          hintText: AppLocalizations.of(context).translate('write_remark')),
    );
  }

  String type;

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
    this.context = context;
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 16, bottom: 16, top: 16),
                      child: Text(AppLocalizations.of(context).translate('goal_completion'),
                        style: styleElements.subtitle1ThemeScalable(context),
                      ),
                    )),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      child: Text(AppLocalizations.of(context).translate('want_to_finish_hindi'),
                        style: styleElements.headline6ThemeScalable(context),
                      ),
                    )),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        "By 20 Sep 2020",
                        style:  styleElements.captionThemeScalable(context),
                        textAlign: TextAlign.center,
                      ),
                    )),
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(AppLocalizations.of(context).translate('start'),
                              style:  styleElements.headline6ThemeScalable(context),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 100),
                            child: Text(
                              "12 Aug 2020",
                              style:  styleElements.headline6ThemeScalable(context),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    )),
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(AppLocalizations.of(context).translate('achieved'),
                              style:  styleElements.headline6ThemeScalable(context),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 50),
                            child: Text(
                              "12 Aug 2020",
                              style:  styleElements.headline6ThemeScalable(context),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    )),
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16, top: 16),
                      child: Text(AppLocalizations.of(context).translate('sure_goal'),
                        style:  styleElements.captionThemeScalable(context),
                      ),
                    )),
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(AppLocalizations.of(context).translate('remarks'),
                              style:  styleElements.headline5ThemeScalable(context),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    )),
                Container(
                    height: 100,
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: HexColor(AppColors.appColorGrey500),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: getbio(context)),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      height: 60,
                      color: HexColor(AppColors.appColorWhite),
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(
                                left: 16.0, top: 16.0, bottom: 16.0),
                            height: 40,
                            child: TricycleElevatedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  side: BorderSide(color: HexColor(AppColors.appMainColor))),
                              onPressed: () {
                                Navigator.pop(context, null);
                              },
                              color: HexColor(AppColors.appColorWhite),
                              child: Text(
                                  AppLocalizations.of(context)
                                      .translate('cancel')
                                      .toUpperCase(),
                                  style: styleElements.bodyText2ThemeScalable(context).copyWith(
                                    color:  HexColor(AppColors.appMainColor),
                                  )),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 16.0, top: 16.0, bottom: 16.0, right: 16),
                            height: 40,
                            child: TricycleElevatedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  side: BorderSide(color: HexColor(AppColors.appMainColor))),
                              onPressed: () {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        PointsDialog(
                                          title: "You won 48 cycle points",
                                          subtitle:
                                              "How do you rate your efforts in achieving goals",
                                          type: "",
                                        ));
                              },
                              color: HexColor(AppColors.appMainColor),
                              child: Text(
                                  AppLocalizations.of(context)
                                      .translate('confirm')
                                      .toUpperCase(),
                                  style: styleElements.bodyText2ThemeScalable(context).copyWith(
                                    color: HexColor(AppColors.appColorWhite),
                                  )),
                            ),
                          ),
                        ],
                      )),
                )
              ],
            ),
          ),
        ));
  }

  DialogFinishGoal();




}
