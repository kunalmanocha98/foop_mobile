import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';

class AddAboutBio extends StatefulWidget{
  @override
  _AddAboutBio createState() => _AddAboutBio();
}
class _AddAboutBio extends State<AddAboutBio> with CommonMixins{

  TextEditingController designationController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController reportingManagerController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  String startDate = 'Start Date';
  int? selectedEpoch;
  late TextStyleElements styleElements;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    final designation = Container(
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: HexColor(AppColors.appColorBackground),
      ),
      child: TextFormField(
        validator: validateTextField,
        controller: designationController,
        onSaved: (value) {},
        decoration: InputDecoration(
            hintText: "Designation",
            contentPadding:
            EdgeInsets.only(left: 12, top: 16, bottom: 8),
            border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: "Enter designation"),
      ),
    );
    final department =Container(
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: HexColor(AppColors.appColorBackground),
      ),
      child: TextFormField(
        validator: validateTextField,
        controller: departmentController,
        onSaved: (value) {},
        decoration: InputDecoration(
            hintText: "Department",
            contentPadding:
            EdgeInsets.only(left: 12, top: 16, bottom: 8),
            border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: "Enter department"),
      ),
    );
    final reportingManager = Container(
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: HexColor(AppColors.appColorBackground),
      ),
      child: TextFormField(
        validator: validateTextField,
        controller: reportingManagerController,
        onSaved: (value) {},
        decoration: InputDecoration(
            hintText: "Reporting manager",
            contentPadding:
            EdgeInsets.only(left: 12, top: 16, bottom: 8),
            border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: "Enter your reporting manager"),
      ),
    );

    final bio = Container(
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: HexColor(AppColors.appColorBackground),
      ),
      child: TextFormField(
        validator: validateTextField,
        controller: bioController,
        onSaved: (value) {},
        decoration: InputDecoration(
            hintText: "Enter your bio",
            contentPadding:
            EdgeInsets.only(left: 12, top: 16, bottom: 8),
            border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: "Enter your bio"),
      ),
    );


    final joiningDate = GestureDetector(
      onTap: () {
        _selectDate(context, startDate);
      },
      child: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                //
                color: HexColor(AppColors.appColorGrey500),
                width: 1.0,
              ),
            ), // set border width
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "$startDate",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: styleElements.bodyText2ThemeScalable(context),
            ),
          )),
    );


    return Scaffold(
      appBar: appAppBar().getCustomAppBar(
          context,
          appBarTitle: AppLocalizations.of(context)!.translate('add_about'),
          onBackButtonPress: (){
            Navigator.pop(context);
          }),
      body: SingleChildScrollView(
        child: appListCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              designation,
              department,
              joiningDate,
              reportingManager,
              bio
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String dateType) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.year,
        firstDate: DateTime(1800),
        lastDate: DateTime.now());
    if (this.mounted){
      setState(() {
        setState(() {
            selectedEpoch = picked!.millisecondsSinceEpoch;
            startDate = DateFormat('dd-MMM-yyyy').format(picked);
        });
      });
    }
  }


}