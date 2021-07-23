import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/regisration_detail_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class EarnCard extends StatelessWidget {
  final String? moneyVal;
  final String? imageUrl;
  final bool? isClickable;
  final String? quote;
  EarnCard({this.moneyVal,this.imageUrl,this.quote,this.isClickable});
  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    return TricycleCard(
        onTap: (){
          if(isClickable!)
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>RegisInstruction()));
        },
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(AppLocalizations.of(context)!.translate('if_no_inst_found'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: styleElements
                          .headline6ThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appColorBlack85),fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(AppLocalizations.of(context)!.translate('earn_upto'),
                    style: styleElements
                        .subtitle1ThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appColorBlack85)),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "₹",
                          style: styleElements
                              .headline5ThemeScalable(context)
                              .copyWith(color: HexColor(AppColors.appMainColor),
                              fontWeight: FontWeight.w900)),
                      TextSpan(
                          text: moneyVal,
                          style: styleElements
                              .headline3ThemeScalable(context)
                              .copyWith(color: HexColor(AppColors.appMainColor),
                              fontWeight: FontWeight.w900)),
                    ]),
                  )
                ],
              ),
              Padding(
                padding:  EdgeInsets.only(top:8.0),
                child: Text(AppLocalizations.of(context)!.translate('get_institute_registered'),
                  style:  styleElements.subtitle1ThemeScalable(context),),
              ),
             
            ]));
  }
}
