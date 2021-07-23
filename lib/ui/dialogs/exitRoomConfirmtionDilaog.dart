import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExitConfirmationDialog extends StatefulWidget {
  Function(bool isSuccess) callback;

  ExitConfirmationDialog({required this.callback});

  @override
  _ExitConfirmationDialog createState() =>
      _ExitConfirmationDialog(callback: callback);
}

class _ExitConfirmationDialog extends State<ExitConfirmationDialog> {
  Function(bool isSuccess) callback;
  late TextStyleElements styleElements;
  _ExitConfirmationDialog({required this.callback});

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 16.0, bottom: 8.0, left: 16, right: 16),
            child: Text(
              AppLocalizations.of(context)!.translate("want_exit"),
              style: styleElements.subtitle1ThemeScalable(context),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: TricycleElevatedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: HexColor(AppColors.appMainColor))),
                  onPressed: () {
                    Navigator.pop(context);
                    callback(false);
                  },
                  color: HexColor(AppColors.appColorWhite),
                  child: Text(
                    AppLocalizations.of(context)!.translate('cancel'),
                    style:styleElements.captionThemeScalable(context).
                    copyWith(fontWeight: FontWeight.bold,
                    color: HexColor(AppColors.appMainColor)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: TricycleElevatedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: HexColor(AppColors.appMainColor))),
                  onPressed: () {
                    Navigator.pop(context);
                    callback(true);
                  },
                  color: HexColor(AppColors.appMainColor),
                  child: Text(
                    AppLocalizations.of(context)!.translate('exit'),
                    style: styleElements.captionThemeScalable(context).
                    copyWith(fontWeight: FontWeight.bold,
                    color:HexColor(AppColors.appColorWhite)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
