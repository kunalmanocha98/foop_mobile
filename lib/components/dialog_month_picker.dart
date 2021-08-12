import 'package:flutter/material.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';

class MonthPickerDialog extends StatefulWidget{
  final Function(String) monthPicked;
  MonthPickerDialog({required this.monthPicked});
  @override
  _MonthPickerDialog createState() => _MonthPickerDialog();
}

class _MonthPickerDialog extends State<MonthPickerDialog>{
  String? selectedMonth = '';
  @override
  Widget build(BuildContext context) {
  TextStyleElements styleElements = TextStyleElements(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Select month",
              style: styleElements.headline6ThemeScalable(context).copyWith(
                  fontWeight: FontWeight.bold
              ),),
          ),
          Row(
            children: [
              Expanded(child: getMonth(
                styleElements,
                type:"january",
                isSelected: selectedMonth == 'january',
              )),
              Expanded(child: getMonth(
                styleElements,
                type:"feburary",
                isSelected: selectedMonth == 'feburary',
              )),Expanded(child: getMonth(
                styleElements,
                type:"march",
                isSelected: selectedMonth == 'march',
              )),
              Expanded(child: getMonth(
                styleElements,
                type:"april",
                isSelected: selectedMonth == 'april',
              ))
            ],
          ),
          Row(
            children: [
              Expanded(child: getMonth(
                styleElements,
                type:"may",
                isSelected: selectedMonth == 'may',
              )),
              Expanded(child: getMonth(
                styleElements,
                type:"june",
                isSelected: selectedMonth == 'june',
              )),Expanded(child: getMonth(
                styleElements,
                type:"july",
                isSelected: selectedMonth == 'july',
              )),
              Expanded(child: getMonth(
                styleElements,
                type:"august",
                isSelected: selectedMonth == 'august',
              ))
            ],
          ),
          Row(
            children: [
              Expanded(child: getMonth(
                styleElements,
                type:"september",
                isSelected: selectedMonth == 'september',
              )),
              Expanded(child: getMonth(
                styleElements,
                type:"october",
                isSelected: selectedMonth == 'october',
              )),Expanded(child: getMonth(
                styleElements,
                type:"november",
                isSelected: selectedMonth == 'november',
              )),
              Expanded(child: getMonth(
                styleElements,
                type:"december",
                isSelected: selectedMonth == 'december',
              ))
            ],
          ),
          SizedBox(height: 16,),
          Row(children: [
            Spacer(),
            appTextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              shape: StadiumBorder(),
              child: Text(AppLocalizations.of(context)!.translate('cancel')),
            ),
            SizedBox(width: 8,),
            appTextButton(
              onPressed: (){
                widget.monthPicked(selectedMonth!);
                Navigator.pop(context);
              },
              shape: StadiumBorder(),
              child: Text(AppLocalizations.of(context)!.translate('ok')),
            )
          ],)
        ]
      ),
    );
  }

  getMonth(TextStyleElements styleElements,{required String type,required bool isSelected}) {
    return Container(
      child: Center(
        child: InkWell(
          onTap: (){
            setState(() {
              selectedMonth = type;
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width/4-32,
            height: MediaQuery.of(context).size.width/4-32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: HexColor(isSelected?AppColors.appMainColor:AppColors.appColorWhite)
            ),
            child: Center(
              child: Text(type.capitalize.substring(0,3),
              style: styleElements.bodyText1ThemeScalable(context).copyWith(
                color: HexColor(isSelected?AppColors.appColorWhite:AppColors.appMainColor),
                fontWeight: FontWeight.bold
              ),),
            ),
          ),
        ),
      ),
    );
  }



}
extension CAP on String {
  String get capitalize {
    var s = this.toString();
    if(s.isNotEmpty) {
      return s[0].toUpperCase() + s.substring(1);
    }else{
      return "";
    }
  }
}