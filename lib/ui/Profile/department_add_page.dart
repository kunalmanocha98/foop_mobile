import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/profile.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DepartmentAddPage extends StatefulWidget {
  @override
  _DepartmentAddPage createState() => _DepartmentAddPage();
}

class _DepartmentAddPage extends State<DepartmentAddPage> with CommonMixins{
  TextEditingController departmentNameController = TextEditingController();
  TextEditingController departmentCodeController = TextEditingController();
  TextEditingController departmentDescriptiponController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  TextStyleElements? styleElements;
  SharedPreferences prefs = locator<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    final departmentName = Container(
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: HexColor(AppColors.appColorBackground),
      ),
      child: TextFormField(
        validator: validateTextField,
        controller: departmentNameController,
        onSaved: (value) {},
        decoration: InputDecoration(
            hintText: "Department name",
            contentPadding:
            EdgeInsets.only(left: 12, top: 16, bottom: 8),
            border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: "Enter department name"),
      ),
    );
    final departmentCode = Container(
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: HexColor(AppColors.appColorBackground),
      ),
      child: TextFormField(
        validator: validateTextField,
        controller: departmentCodeController,
        onSaved: (value) {},
        decoration: InputDecoration(
            hintText: "Department code",
            contentPadding:
            EdgeInsets.only(left: 12, top: 16, bottom: 8),
            border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: "Enter department code"),
      ),
    );
    final departmentDes = Container(
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: HexColor(AppColors.appColorBackground),
      ),
      child: TextFormField(
        validator: validateTextField,
        controller: departmentDescriptiponController,
        onSaved: (value) {},
        decoration: InputDecoration(
            hintText: "Department description",
            contentPadding:
            EdgeInsets.only(left: 12, top: 16, bottom: 8),
            border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: "Enter department description"),
      ),
    );
    return SafeArea(
      child: Scaffold(
        appBar: appAppBar().getCustomAppBar(context,
            appBarTitle: AppLocalizations.of(context)!.translate('add_dept'),
            onBackButtonPress: () {
              Navigator.pop(context);
            },
          actions: [
            Container(
              margin: EdgeInsets.only(top: 14, bottom: 14, left: 4),
              child: appElevatedButton(
                  onPressed: () async {
                   if(formKey.currentState!.validate()){
                     formKey.currentState!.save();
                     addDept();
                   }
                  },
                  color: HexColor(AppColors.appMainColor),
                  child: Text(
                    AppLocalizations.of(context)!.translate('add'),
                    style: styleElements!
                        .subtitle2ThemeScalable(context)
                        .copyWith(
                        color: HexColor(AppColors.appColorWhite)),
                  )),
            )
          ]
        ),
        body: appListCard(
          child:Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: departmentName,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: departmentCode,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: departmentDes,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addDept() async{
    DepartmentCreateRequest payload  = DepartmentCreateRequest();
    payload.institutionId = prefs.getInt(Strings.instituteId);
    payload.addedDepartments = [AddedDepartments(
      departmentName: departmentNameController.text,
      departmentCode: departmentCodeController.text,
      departmentDescription: departmentDescriptiponController.text
    )];
    Calls().call(jsonEncode(payload), context, Config.DEPARTMENT_CREATE).then((value) {

    });
  }
}
