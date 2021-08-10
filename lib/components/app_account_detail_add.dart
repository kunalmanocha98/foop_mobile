import 'package:flutter/material.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/utils/app_localization.dart';

import 'appBarWithSearch.dart';

class AppAccountDetailCard extends StatefulWidget{
  @override
  _AppAccountDetailCard createState() => _AppAccountDetailCard();
}
class _AppAccountDetailCard extends State<AppAccountDetailCard>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Scaffold(
        appBar:  appAppBar().getCustomAppBar(context,
            appBarTitle: AppLocalizations.of(context)!.translate('account_details'),
            onBackButtonPress: (){Navigator.pop(context);}),
        body: appListCard(
          child: ,
        ),
      ),
    );
  }

}