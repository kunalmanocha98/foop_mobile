import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/profile_module/pages/dialogue_select_old_or_current_student.dart';
import 'package:oho_works_app/regisration_module/welcomePage.dart';
import 'package:oho_works_app/ui/person_type_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SelectProfileCard extends StatefulWidget {
  String type;
  int currentPosition;

  _SelectProfileCard createState() => _SelectProfileCard();
}

// ignore: must_be_immutable
class _SelectProfileCard extends State<SelectProfileCard> {
  TextStyleElements styleElements;
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

  List<PersonItem> rows = [];

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getPersonTypeList(context));
    super.initState();
  }

  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            margin: const EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).translate("set_role"),
                      style: styleElements.captionThemeScalable(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: rows.length > 0,
                    child: ListView.builder(
                        padding:
                            EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                        itemCount: rows.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              if (rows[index].personTypeCode == "student") {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        SelectStudentTypeDialog(
                                            id: rows[index].personTypeId,
                                            type: "student",
                                            title: AppLocalizations.of(context)
                                                .translate("old_new_student"),
                                            subtitle: AppLocalizations.of(context)
                                                .translate(
                                                    "select_student_text")));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          WelComeScreen(
                                      /*  type: rows[index].personTypeCode,
                                        id: rows[index].personTypeId,
                                        studentType: null,
                                          from:"welcome"
                                        *//*type: "student",*/
                                      ),
                                    ));
                              }
                            },
                            child: Container(
                              width: 328.0,
                              height: 84.0,
                              margin: const EdgeInsets.only(
                                  top: 12, left: 4, right: 4, bottom: 4),
                              // margin: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: HexColor(AppColors.appColorWhite),
                                shape: BoxShape.rectangle,
                                boxShadow: [CommonComponents().getShadowforBox()],
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                    topLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0)),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: <Widget>[
                                    new Flexible(
                                        child: Image(
                                      image: CachedNetworkImageProvider(
                                          "http://test.tricycle.group/media/" +
                                              rows[index].imageUrl),
                                      width: 48,
                                      height: 48,
                                    )),
                                    new Flexible(
                                      child: Container(
                                        child: Column(children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 0),
                                            child: Text(
                                              rows[index].personTypeName,
                                              textAlign: TextAlign.start,
                                              style: styleElements.headline6ThemeScalable(context),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.only(left: 16),
                                              child: Text(
                                                rows[index].personTypeDescription,
                                                // textAlign: TextAlign.start,
                                                style: styleElements.captionThemeScalable(context),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          )
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void getPersonTypeList(BuildContext context) async {
    final body = jsonEncode({
      "searchVal": null,
    });

    Calls().call(body, context, Config.PERSON_LIST).then((value) async {
      if (value != null) {
        var data = PersonTypeList.fromJson(value);
        setState(() {
          rows = data.rows;
          print(rows.toString());
        });
      }
    }).catchError((onError) {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
    });
  }
}
