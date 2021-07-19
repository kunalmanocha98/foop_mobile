import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class VerifiedCard extends StatelessWidget {
  final CommonCardData data;
  VerifiedCard({this.data});
  @override
  Widget build(BuildContext context) {
    final TextStyleElements styleElements = TextStyleElements(context);
    return TricycleListCard(
      padding: EdgeInsets.only(left: 16.0, right: 16, top: 12, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (data!=null && data.title!=null)?data.title:AppLocalizations.of(context).translate('verified_by'),
            style: styleElements.headline6ThemeScalable(context).copyWith(
                fontWeight: FontWeight.bold,
                color: HexColor(AppColors.appColorBlack85)),
            textAlign: TextAlign.left,
          ),
          ListView.builder(
            itemCount: (data!=null && data.subRow!=null && data.subRow.length>0)?data.subRow.length:0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                  leading: TricycleAvatar(
                    service_type: SERVICE_TYPE.PERSON,
                    resolution_type: RESOLUTION_TYPE.R64,
                    imageUrl:data.subRow[index].urlOne,
                    size: 36,
                    key: UniqueKey(),
                  ),
                  title: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: data.subRow[index].textOne,
                          style: styleElements
                              .subtitle1ThemeScalable(context)
                              .copyWith(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: ', ',
                          style: styleElements
                              .bodyText2ThemeScalable(context)),
                      TextSpan(
                          text: data.subRow[index].textTwo,
                          style: styleElements
                              .bodyText2ThemeScalable(context))
                    ]),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
