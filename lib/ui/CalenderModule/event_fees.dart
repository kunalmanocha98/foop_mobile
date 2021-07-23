import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';

import 'currency_selection_page.dart';

class EventFeesPage extends StatefulWidget{
  @override
  EventFeesPageState createState() => EventFeesPageState();
}
class EventFeesPageState extends State<EventFeesPage>{
  late TextStyleElements styleElements;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBar(context, appBarTitle: 'Event Fees', onBackButtonPress: (){Navigator.pop(context);}),
        body: Container(
          child: Column(
            children: [
              TricycleListCard(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return CurrencySelectPage();
                  }));
                },
                child: ListTile(
                  leading: TricycleAvatar(
                    size: 56,
                    imageUrl: Utility().getUrlForImage('', RESOLUTION_TYPE.R64, SERVICE_TYPE.PERSON),
                    key: UniqueKey(),
                  ),
                  title: Text('Select the currency',style: styleElements.captionThemeScalable(context),),
                  subtitle: Text('Indian Rupess',style: styleElements.subtitle1ThemeScalable(context),),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
              ),
              TricycleListCard(
                padding: EdgeInsets.only(top:24,bottom: 24,left: 16,right: 16),
                child: TextFormField(
                  style: styleElements.subtitle1ThemeScalable(context).copyWith(
                      color: HexColor(AppColors.appColorBlack65)
                  ),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35))
                  ),

                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}