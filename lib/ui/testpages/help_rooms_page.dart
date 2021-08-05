import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HelpRoomsPage extends StatelessWidget{
late TextStyleElements styleElements;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        appBar: OhoAppBar()
            .getCustomAppBar(
            context,
            appBarTitle: AppLocalizations.of(context)!.translate('helprooms'),
            onBackButtonPress: (){
              Navigator.pop(context);
            }),
        body: Container(
          padding: EdgeInsets.only(top: 16),
          child: appCard(

            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top:4,left:4,right:4),
                    child: Text(AppLocalizations.of(context)!.translate('select_privacy_type'),
                    style: styleElements.headline6ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:8,left:4,right:4),
                    child: Text(AppLocalizations.of(context)!.translate('private'),
                        style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding:EdgeInsets.only(top:0,left:4,right:4),
                    child: Text(AppLocalizations.of(context)!.translate('private_room_des'),
                        style: styleElements.bodyText2ThemeScalable(context)),
                  ),
                  Padding(
                    padding:EdgeInsets.only(top:8,left:4,right:4),
                    child: Text(AppLocalizations.of(context)!.translate('campus'),
                        style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding:EdgeInsets.only(top:0,left:4,right:4),
                    child: Text(AppLocalizations.of(context)!.translate('campus_room_des'),
                        style: styleElements.bodyText2ThemeScalable(context)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:8,left:4,right:4),
                    child: Text(AppLocalizations.of(context)!.translate('social'),
                        style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:0,left:4,right:4),
                    child: Text(AppLocalizations.of(context)!.translate('social_room_des'),
                        style: styleElements.bodyText2ThemeScalable(context)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:8,left:4,right:4),
                    child: Text(AppLocalizations.of(context)!.translate('public'),
                        style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:0,left:4,right:4),
                    child: Text(AppLocalizations.of(context)!.translate('public_room_des'),
                        style: styleElements.bodyText2ThemeScalable(context)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}