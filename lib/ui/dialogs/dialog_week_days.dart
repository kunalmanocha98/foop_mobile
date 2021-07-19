import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class DialogWeekDays extends StatefulWidget {
  @override
  DialogWeekDaysState createState() => DialogWeekDaysState();
}

class DialogWeekDaysState extends State<DialogWeekDays> {
  bool isMonday = false;
  bool isTuesday = false;
  bool isWednesday = false;
  bool isThursday = false;
  bool isFriday = false;
  bool isSaturday = false;
  bool isSunday = false;

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select week Days',style: styleElements.headline6ThemeScalable(context).copyWith(
              fontWeight: FontWeight.bold
            ),),
            SizedBox(
              height: 6,
            ),
            CheckboxListTile(
              value: isMonday,
              onChanged: (value) {
                setState(() {
                  isMonday = !isMonday;
                });
              },
              title: Text(
                'Monday',
                style: styleElements.subtitle1ThemeScalable(context),
              ),
            ),
            CheckboxListTile(
              value: isTuesday,
              onChanged: (value) {
                setState(() {
                  isTuesday = !isTuesday;
                });
              },
              title: Text(
                'Tuesday',
                style: styleElements.subtitle1ThemeScalable(context),
              ),
            ),
            CheckboxListTile(
              value: isWednesday,
              onChanged: (value) {
                setState(() {
                  isWednesday = !isWednesday;
                });
              },
              title: Text(
                'Wednesday',
                style: styleElements.subtitle1ThemeScalable(context),
              ),
            ),
            CheckboxListTile(
              value: isThursday,
              onChanged: (value) {
                setState(() {
                  isThursday = !isThursday;
                });
              },
              title: Text(
                'Thursday',
                style: styleElements.subtitle1ThemeScalable(context),
              ),
            ),
            CheckboxListTile(
              value: isFriday,
              onChanged: (value) {
                setState(() {
                  isFriday = !isFriday;
                });
              },
              title: Text(
                'Friday',
                style: styleElements.subtitle1ThemeScalable(context),
              ),
            ),
            CheckboxListTile(
              value: isSaturday,
              onChanged: (value) {
                setState(() {
                  isSaturday = !isSaturday;
                });
              },
              title: Text(
                'Saturday',
                style: styleElements.subtitle1ThemeScalable(context),
              ),
            ),
            CheckboxListTile(
              value: isSunday,
              onChanged: (value) {
                setState(() {
                  isSunday = !isSunday;
                });
              },
              title: Text(
                'Sunday',
                style: styleElements.subtitle1ThemeScalable(context),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Spacer(),
                TricycleTextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  shape: StadiumBorder(),
                  child: Text(
                    AppLocalizations.of(context).translate('cancel'),
                    style: styleElements
                        .captionThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appMainColor)),
                  ),
                ),
                TricycleTextButton(
                  onPressed: () {
                    List<String> list = [];
                    if (isMonday) {
                      list.add('Monday');
                    }
                    if (isTuesday) {
                      list.add('Tuesday');
                    }
                    if (isWednesday) {
                      list.add('Wednesday');
                    }
                    if (isThursday) {
                      list.add('Thursday');
                    }
                    if (isFriday) {
                      list.add('Friday');
                    }
                    if (isSaturday) {
                      list.add('Saturday');
                    }
                    if (isSunday) {
                      list.add('Sunday');
                    }
                    if(list.length>0) {
                      Navigator.pop(context, list);
                    }else{
                      Navigator.pop(context);
                    }
                  },
                  shape: StadiumBorder(),
                  child: Text(
                    AppLocalizations.of(context).translate('submit'),
                    style: styleElements
                        .captionThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appMainColor)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }
}
