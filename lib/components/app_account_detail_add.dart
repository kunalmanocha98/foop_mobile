import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'appBarWithSearch.dart';

class AddAccountDetails extends StatefulWidget{
  @override
  _AddAccountDetails createState() => _AddAccountDetails();
}
class _AddAccountDetails extends State<AddAccountDetails>{

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

    final gst = TextField(
      obscureText: false,
      controller: gstController,
      textCapitalization: TextCapitalization.words,
      onChanged: (text) {
        if (text.length == 1 && text != text.toUpperCase()) {
          gstController.text = text.toUpperCase();
          gstController.selection = TextSelection.fromPosition(
              TextPosition(offset: gstController.text.length));
        }
      },
      style: styleElements!
          .subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      scrollPadding: const EdgeInsets.all(20.0),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 8.0),
          hintText: AppLocalizations.of(context)!.translate("gst"),
          hintStyle: styleElements!.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
    );
    final pan = TextField(
      obscureText: false,
      controller: panController,
      textCapitalization: TextCapitalization.words,
      onChanged: (text) {
        if (text.length == 1 && text != text.toUpperCase()) {
          panController.text = text.toUpperCase();
          panController.selection = TextSelection.fromPosition(
              TextPosition(offset: panController.text.length));
        }
      },
      style: styleElements!
          .subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      scrollPadding: const EdgeInsets.all(20.0),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 8.0),
          hintText: AppLocalizations.of(context)!.translate("pan"),
          hintStyle: styleElements!.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
    );
    final cin = TextField(
      obscureText: false,
      controller: cinController,
      textCapitalization: TextCapitalization.words,
      onChanged: (text) {
        if (text.length == 1 && text != text.toUpperCase()) {
          cinController.text = text.toUpperCase();
          cinController.selection = TextSelection.fromPosition(
              TextPosition(offset: cinController.text.length));
        }
      },
      style: styleElements!
          .subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      scrollPadding: const EdgeInsets.all(20.0),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 8.0),
          hintText: AppLocalizations.of(context)!.translate("cin"),
          hintStyle: styleElements!.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
    );
    final tan = TextField(
      obscureText: false,
      controller: tanController,
      textCapitalization: TextCapitalization.words,
      onChanged: (text) {
        if (text.length == 1 && text != text.toUpperCase()) {
          tanController.text = text.toUpperCase();
          tanController.selection = TextSelection.fromPosition(
              TextPosition(offset: tanController.text.length));
        }
      },
      style: styleElements!
          .subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      scrollPadding: const EdgeInsets.all(20.0),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 8.0),
          hintText: AppLocalizations.of(context)!.translate("tan"),
          hintStyle: styleElements!.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
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
              startDate = DateFormat('MM-yyyy').format(picked);
            } else {
              selectedEpoch2 = picked!.millisecondsSinceEpoch;
              endDate = DateFormat('MM-yyyy').format(picked);
            }
          });
        });
      }
  }


}