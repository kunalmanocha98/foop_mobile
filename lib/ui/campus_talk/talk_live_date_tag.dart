import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/cupertino.dart';

class DateLiveTag extends StatelessWidget{
  final bool? isLive;
  final DateTime? date;
  DateLiveTag({this.isLive,this.date});

  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    return isLive!?
    Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
          color: HexColor(AppColors.appColorGreen),
          borderRadius: BorderRadius.circular(4)),
      child: Text(
        AppLocalizations.of(context)!.translate('live').toUpperCase(),
        style: styleElements
            .captionThemeScalable(context)
            .copyWith(color: HexColor(AppColors.appColorWhite),fontSize: 10),
      ),
    ):
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        Utility().getDateFormat('dd MMM yyyy, HH:mm', date!),
        style: styleElements.captionThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65
          )
        ),
      ),
    );
  }
}