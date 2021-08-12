import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/CalenderModule/event_create_models.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/institute_location_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';

class SelectEventLocationPage extends StatefulWidget {
  final List<EventLocation>? eventLocation;
  final Function? refreshCallBack;
  SelectEventLocationPage({this.eventLocation,this.refreshCallBack});
  @override
  SelectEventLocationPageState createState() => SelectEventLocationPageState();
}

class SelectEventLocationPageState extends State<SelectEventLocationPage> {
  late TextStyleElements styleElements;
  String? onlineDetails;
  EventLocation? offlineLocation;
  GlobalKey<FormState> formKey =GlobalKey();

  String? getOnlineDetails(){
    if(widget.eventLocation!=null && widget.eventLocation!.length > 0) {
      var onlineDetails = widget.eventLocation!.firstWhere((element) { return element.type == 'online';});
      var offline = widget.eventLocation!.firstWhere((element) { return element.type == 'offline';});
      if(offline!=null){
        offlineLocation = offline;
      }
      return onlineDetails.other;
    }else{
      return null;
    }
  }
  String? getOfflineDetails(){
    if(widget.eventLocation!=null && widget.eventLocation!.length > 0) {
      var offline = widget.eventLocation!.firstWhere((element) { return element.type == 'offline';});
      if(offline!=null){
        offlineLocation = offline;
        return offlineLocation!.address!.address;
      }else{
        return 'Location';
      }
    }else if(offlineLocation!=null){
      return offlineLocation!.address!.address;
    }else{
      return 'Location';
    }
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    final locationWidget = ListTile(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return InstituteLocationAddressPage(instId:0,isEvent: true,offlineLocation: offlineLocation,);
          // return InstituteLocationAddressPage(prefs.getInt(Strings.instituteId));
        })).then((value){
          if(value!=null){
            setState(() {
              offlineLocation = value;
            });
          }
        });
      },
      contentPadding: EdgeInsets.all(0),
      title: Text(getOfflineDetails()!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: styleElements.subtitle1ThemeScalable(context),),
      trailing: Icon(Icons.arrow_forward_ios_rounded),
    );
    final onlineDetailsWidget = TextFormField(
      maxLines: 8,
      validator: CommonMixins().validateTextField,
      onSaved: (value){onlineDetails = value;},
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      initialValue: getOnlineDetails(),
      decoration: InputDecoration(
        focusColor: HexColor(AppColors.appColorBackground),
        fillColor: HexColor(AppColors.appColorBackground),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        hintText: 'Enter details',
        hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35))
      ),
    );
    return SafeArea(
        child: Scaffold(
          appBar: appAppBar().getCustomAppBar(
              context,
              actions: [ appTextButton(
                onPressed: () {
                  updateLanguage();
                },
                child: Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.translate('next'),
                      style: styleElements
                          .subtitle2ThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appMainColor)),
                    ),
                    Icon(Icons.keyboard_arrow_right,
                        color: HexColor(AppColors.appMainColor))
                  ],
                ),
                shape: CircleBorder(),
              ),],
              appBarTitle: AppLocalizations.of(context)!.translate('select_location'),
              onBackButtonPress: () {
                Navigator.pop(context);
              }),
          body: Form(
            key: formKey,
            child: Container(
              child: ListView(
                shrinkWrap: true,
                children: [
                  appListCard(
                    padding: EdgeInsets.all(16),
                      child: getEventDetailCard('Offline', locationWidget)
                  ),
                  appListCard(
                    padding: EdgeInsets.all(16),
                    child: getEventDetailCard('Online details', onlineDetailsWidget),
                  )
                ],
              ),
            ),
          ),
        ));
  }
  Widget getEventDetailCard(String title,Widget child,{EdgeInsets? padding}){
    return Container(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            Padding(
              padding:padding??EdgeInsets.all(0),
              child: child,
            )
          ],
        )
    );
  }

  void updateLanguage() {
    formKey.currentState!.save();
    if(offlineLocation!=null || onlineDetails!.isNotEmpty) {
      List<EventLocation?> list = [];
      list.add(EventLocation(
          other: onlineDetails,
          type: 'online'
      ));
      list.add(offlineLocation);
      Navigator.pop(context,list);
    }else{
      ToastBuilder().showToast('Enter some location', context, HexColor(AppColors.information));
    }
  }
}
