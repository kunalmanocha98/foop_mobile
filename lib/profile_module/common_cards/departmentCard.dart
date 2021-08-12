import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/e_learning_module/ui/academic_details_selection_pages.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/departmentEditaddPage.dart';
import 'package:oho_works_app/profile_module/pages/edit_language-page.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/Profile/department_add_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DepartmentCard extends StatelessWidget {
  final CommonCardData data;
  BuildContext? context;
  TextStyleElements? styleElements;
  // List<String>? listSubItems = ["Finance","Software Development","Yoga","Event management","Crisis Management"];
  Null Function()? callbackPicker;
  String? type;
  int? id;
  String? personType;

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

  String? instId;

  DepartmentCard(
      {Key? key,
        required this.data,
        this.styleElements,
        this.callbackPicker,
        this.personType,
        this.id,
        this.instId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    type =  "Departments";
    styleElements = TextStyleElements(context);
    this.context = context;
    return appListCard(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 12, bottom: 8),
                        child: Text(
                          "Departments",
                          style: styleElements!
                              .headline6ThemeScalable(context)
                              .copyWith(
                              fontWeight: FontWeight.bold,
                              color: HexColor(AppColors.appColorBlack85)),
                          textAlign: TextAlign.left,
                        ),
                      )),
                  flex: 3,
                ),
                Visibility(
                  child: Flexible(
                    child:Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                          alignment: Alignment.topRight,
                          child:  GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context){
                                  return DepartmentAddPage(
                                    callbackPicker: callbackPicker,
                                  );
                                }
                              ));
                            },
                            child: Icon(
                              Icons.add,
                              size: 30,
                              color: HexColor(AppColors.appColorBlack85),
                            ),
                          )),
                    ),
                    flex: 1,
                  ),
                ),
              ],
            ),
            Container(
                margin: const EdgeInsets.only(left: 12, right: 12),
                child: data.subRow!=null &&data.subRow!.isNotEmpty
                    ? Align(
                    alignment: Alignment.centerLeft,
                    child:  Container(
                        height: 100.0,
                        child:
                        Wrap(
                          spacing: 8.0, // gap between adjacent chips
                          runSpacing: 4.0, // gap between lines
                          // children: <Widget>[...generate_tags(programs[3].isSelected?programs :sectionsWithMore, degreeType, id,className,classCode)],

                          children: <Widget>[...generate_tags(data.subRow!)],

                        )



                       ))
                    : GestureDetector(
                  onTap: () async {
                    if (type == "Skill") {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditLanguage(
                                "Skill", instId, false, null),
                          ));

                      if (result != null &&
                          result['result'] == "success") {
                        callbackPicker!();
                      }
                    } else if (type == "Language") {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditLanguage(
                                "Languages", instId, false, null),
                          ));

                      if (result != null &&
                          result['result'] == "success") {
                        callbackPicker!();
                      }
                    }
                  },
                  child: Container(
                      height: 150,
                      margin: const EdgeInsets.only(bottom: 20, top: 20),
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: HexColor(AppColors.appColorWhite),
                      ),
                      child: CustomPaginator(context).emptyListWidgetMaker(null)),
                )),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                  onTap: () async {
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileCards(
                            userId: id,
                            userType: personType,
                            type:
                            "department",
                            currentPosition: 2,
                          ),
                        ));
                    if (result != null && result['result'] == "update") {
                      callbackPicker!();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16, bottom: 16),
                    child: Visibility(
                      /*visible: data.isShowMore ??= false,*/
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(AppLocalizations.of(context)!.translate('see_more'),
                          style: styleElements!.subtitle2ThemeScalable(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        ));
  }

  generate_tags(List<SubRow> list,) {
    return list
        .map((list) => get_chip(list))
        .toList();
  }

  get_chip(SubRow item) {
    return     Container(
      margin: const EdgeInsets.only(
          left: 4, right: 4),
      child: Chip(
          label: Padding(
            padding: const EdgeInsets.only(
                left: 4, right: 4),
            child: Text(
              item.department!,
              overflow: TextOverflow.ellipsis,
              style: styleElements!
                  .subtitle2ThemeScalable(
                  context!),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }

}
