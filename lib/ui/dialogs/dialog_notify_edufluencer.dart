import 'dart:ui';

import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/ui/EdufluencerTutorModule/become_edufluencer_tutor_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class NotifyEdufluencerDialog extends StatelessWidget {
  final edufluencer_type type;

  NotifyEdufluencerDialog({this.type});

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context).translate(
                type == edufluencer_type.E
                    ? 'notify_edufluencer'
                    : 'notify_tutor'),
            textAlign: TextAlign.center,
            style: styleElements.subtitle1ThemeScalable(context),),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Spacer(),
                TricycleTextButton(
                  shape: RoundedRectangleBorder(),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context).translate('ok'),
                    style: styleElements.captionThemeScalable(context).copyWith(
                      color: HexColor(AppColors.appMainColor)
                    ),))
              ],
            )
          ],
        ),
      ),
    );
  }
}
