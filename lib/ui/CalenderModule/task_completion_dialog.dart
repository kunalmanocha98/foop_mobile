import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCompletionDialog extends StatefulWidget {
  @override
  TaskCompletionDialogState createState() => TaskCompletionDialogState();
}

class TaskCompletionDialogState extends State<TaskCompletionDialog> {
  late TextStyleElements styleElements;
  int selectedCompletionEpoch = 0;
  String selectedCompletionDate = "Completion date";

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    final completiondate = GestureDetector(
        onTap: () {
          _selectCompletionDate(context);
        },
        child: Container(
            padding: EdgeInsets.only(top: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  //
                  color: Colors.grey,
                  width: 1.0,
                ),
              ), // set border width
            ),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedCompletionDate != "Completion date"
                      ? DateFormat('dd-MM-yyyy')
                      .format(DateTime.parse(selectedCompletionDate))
                      : "Completion date",
                  textAlign: TextAlign.left,
                  style: styleElements.bodyText2ThemeScalable(context),
                ))));

    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Task Completion',
                style: styleElements
                    .headline6ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Want to finish learning Hindi',
                    style: styleElements.subtitle1ThemeScalable(context),
                  ),
                  Text(
                    'Target date: 20 Sep 2020',
                    style: styleElements.bodyText2ThemeScalable(context),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  completiondate,
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    'Remarks(progress journal)',
                    style: styleElements.bodyText2ThemeScalable(context),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    maxLines: 4,
                    style: styleElements.subtitle1ThemeScalable(context).copyWith(
                        color: HexColor(AppColors.appColorBlack65)
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Leave your remarks',
                      hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35))
                    ),
                  ),
                  Text(
                    'Are you sure you want mark this goal as achieved?',
                    style: styleElements.bodyText2ThemeScalable(context),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      TricycleTextButton(
                          onPressed: () {},
                          child: Text(
                            'cancel',
                            style: styleElements
                                .captionThemeScalable(context)
                                .copyWith(
                                color: HexColor(AppColors.appMainColor)),
                          )),
                      SizedBox(
                        width: 16,
                      ),
                      TricycleTextButton(
                          onPressed: () {},
                          shape: StadiumBorder(),
                          color: HexColor(AppColors.appMainColor),
                          child: Text(
                            'finish',
                            style: styleElements
                                .captionThemeScalable(context)
                                .copyWith(
                                color: HexColor(AppColors.appColorWhite)),
                          ))
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Future<void> _selectCompletionDate(BuildContext context) async {
    var newDate;

    newDate = new DateTime.now();

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: newDate,
        firstDate: DateTime(1900),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Colors.black,
              accentColor: Colors.black,
              colorScheme: ColorScheme.dark(
                primary: Colors.black,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
        lastDate: newDate);
    if (picked != null)
      setState(() {
        selectedCompletionEpoch = picked.millisecondsSinceEpoch;
        selectedCompletionDate = DateFormat('yyyy-MM-dd').format(picked);
      });
  }
}
