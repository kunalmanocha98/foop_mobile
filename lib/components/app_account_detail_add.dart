import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/business_accounting_register.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'appBarWithSearch.dart';
import 'app_buttons.dart';

class AddAccountDetails extends StatefulWidget{
  @override
  _AddAccountDetails createState() => _AddAccountDetails();
}
class _AddAccountDetails extends State<AddAccountDetails> with CommonMixins{

  String startDate = 'Start Date';
  String endDate = 'End Date';
  int? selectedEpoch, selectedEpoch2;
  TextStyleElements? styleElements;
  TextEditingController gstController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController cinController = TextEditingController();
  TextEditingController tanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    final dateStart = GestureDetector(
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
              style: styleElements!.bodyText2ThemeScalable(context),
            ),
          )),
    );
    final dateEnd = GestureDetector(
      onTap: () {
          _selectDate(context, endDate);
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
              "$endDate",
              textAlign: TextAlign.left,
              style: styleElements!.bodyText2ThemeScalable(context),
            ),
          )),
    );

    final gst = Container(
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: HexColor(AppColors.appColorBackground),
      ),
      child: TextFormField(
        validator: validateTextField,
        controller: gstController,
        onSaved: (value) {},
        decoration: InputDecoration(
            hintText: "Gst number",
            contentPadding:
            EdgeInsets.only(left: 12, top: 16, bottom: 8),
            border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: "Enter gst number"),
      ),
    );
    final pan =Container(
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: HexColor(AppColors.appColorBackground),
      ),
      child: TextFormField(
        validator: validateTextField,
        controller: panController,
        onSaved: (value) {},
        decoration: InputDecoration(
            hintText: "Pan number",
            contentPadding:
            EdgeInsets.only(left: 12, top: 16, bottom: 8),
            border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: "Enter pan number"),
      ),
    );
    final cin = Container(
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: HexColor(AppColors.appColorBackground),
      ),
      child: TextFormField(
        validator: validateTextField,
        controller: cinController,
        onSaved: (value) {},
        decoration: InputDecoration(
            hintText: "Cin number",
            contentPadding:
            EdgeInsets.only(left: 12, top: 16, bottom: 8),
            border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: "Enter cin number"),
      ),
    );
    final tan = Container(
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: HexColor(AppColors.appColorBackground),
      ),
      child: TextFormField(
        validator: validateTextField,
        controller: tanController,
        onSaved: (value) {},
        decoration: InputDecoration(
            hintText: "Tan number",
            contentPadding:
            EdgeInsets.only(left: 12, top: 16, bottom: 8),
            border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: "Enter tan number"),
      ),
    );

    return SafeArea(
      child:  Scaffold(
        appBar:  appAppBar().getCustomAppBar(context,
            appBarTitle: AppLocalizations.of(context)!.translate('account_details'),
            onBackButtonPress: (){Navigator.pop(context);}),
        body: appListCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              dateStart, dateEnd, gst, pan,cin,tan
            ],
          ),
        ),
        bottomNavigationBar: Container(
          child: Row(
            children: [
              Spacer(),
              appTextButton(
                onPressed: (){
                  if(isCheck()) {
                    setAccountingDetails();
                  }
                },
                child:Text( AppLocalizations.of(context)!.translate('save_exit')),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String dateType) async {
    var newDate;
    late var selectedDate;

    newDate = new DateTime.now();
    if (selectedEpoch != null)
      selectedDate = new DateTime.fromMillisecondsSinceEpoch(selectedEpoch!);
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: newDate,
        initialDatePickerMode: DatePickerMode.year,
        firstDate: dateType == "End Date" ? selectedDate : DateTime(1800),
        lastDate: newDate);
      if (this.mounted){
        setState(() {
          setState(() {
            if (dateType == "startDate") {
              selectedEpoch = picked!.millisecondsSinceEpoch;
              startDate = DateFormat('yyyy').format(picked);
            } else {
              selectedEpoch2 = picked!.millisecondsSinceEpoch;
              endDate = DateFormat('yyyy').format(picked);
            }
          });
        });
      }
  }

  void setAccountingDetails() async{
    BusinessAccountRegisterRequest payload = BusinessAccountRegisterRequest();
    payload.taxStartMonth = startDate;
    payload.taxEndMonth = endDate;
    payload.cin = cinController.text;
    payload.pan = panController.text;
    payload.gst = gstController.text;
    payload.tan = tanController.text;
    Calls().call(jsonEncode(payload), context, Config.BUSINESS_ACCOUNTING_REGISTER).then((value){
      Navigator.pop(context,true);
    });
  }

  bool isCheck() {
    if(selectedEpoch!=null){
      if(selectedEpoch2!=null) {
        if (gstController.text.isNotEmpty) {
          if (panController.text.isNotEmpty) {
            if (cinController.text.isNotEmpty) {
              if (tanController.text.isNotEmpty) {
                return true;
              } else {
                ToastBuilder().showToast('Please enter tan number', context,
                    HexColor(AppColors.information));
                return false;
              }
            } else {
              ToastBuilder().showToast('Please enter cin number', context,
                  HexColor(AppColors.information));
              return false;
            }
          } else {
            ToastBuilder().showToast('Please enter pan number', context,
                HexColor(AppColors.information));
            return false;
          }
        } else {
          ToastBuilder().showToast('Please enter gst number', context,
              HexColor(AppColors.information));
          return false;
        }
      }else{
        ToastBuilder().showToast('Please select first month of tax year', context, HexColor(AppColors.information));
        return false;
      }
    }else{
      ToastBuilder().showToast('Please select first month of financial year', context, HexColor(AppColors.information));
      return false;
    }
  }


}