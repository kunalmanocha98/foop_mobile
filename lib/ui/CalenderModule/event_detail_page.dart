import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycleProgressButton.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/CalenderModule/event_create_models.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/campus_talk/socket_emit_models.dart';
import 'package:oho_works_app/services/audio_socket_service.dart';
import 'package:oho_works_app/ui/CalenderModule/host_list_page.dart';
import 'package:oho_works_app/ui/CalenderModule/select_event_location_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'event_language_page.dart';

class EventDetailPage extends StatefulWidget {
  final String? type;
  final EventCreateRequest? payload;
  final RoomListItem? roomItem;
  final  Function? refreshCallBack;
  EventDetailPage({this.type,this.payload,this.roomItem,this.refreshCallBack});
  @override
  EventDetailPageState createState() => EventDetailPageState(type:type,payload: payload);
}

class EventDetailPageState extends State<EventDetailPage> {
  static const String EVENT_CREATE = "event_create";
  bool isOnline= false;
  final String? type;
  EventCreateRequest? payload;
  EventDetailPageState({this.type,this.payload});
  late TextStyleElements styleElements;
  String? description;
  List<EventLocation> eventLocation = [];
  GlobalKey<FormState> formKey = GlobalKey();
  List<String> _selectedLanguage = [];
  AudioSocketService? audioSocketService = locator<AudioSocketService>();
  SharedPreferences? prefs = locator<SharedPreferences>();
  GlobalKey<TricycleProgressButtonState> progressButtonKey = GlobalKey();


  String? getTitle(){
    if(eventLocation.length>0){
      var location = eventLocation.firstWhere((element){
        return element.type == 'offline';
      });
      if(location!=null){
        return location.address!.address;
      }else{
        return 'Location';
      }
    }else{
      return "Select location";
    }
  }
  @override
  Widget build(BuildContext context) {
  styleElements = TextStyleElements(context);
    final locationWidget = GestureDetector(
      onTap: (){},
      child: ListTile(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SelectEventLocationPage(eventLocation: eventLocation,refreshCallBack:widget.refreshCallBack);
            // return InstituteLocationAddressPage(prefs.getInt(Strings.instituteId));
          })).then((value) {
            if(value!=null){
              setState(() {
                eventLocation = value;
              });
            }
          });
        },
        contentPadding: EdgeInsets.all(0),
        title: Text(getTitle()!,style: styleElements.subtitle1ThemeScalable(context),),
        trailing: Icon(Icons.arrow_forward_ios, color: HexColor(AppColors.appColorBlack35),
          size: 20,),

      ),
    );
    final languageWidget = GestureDetector(
      onTap: (){},
      child: ListTile(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return EventLanguagePage(selectedLanguages: _selectedLanguage,);
            // return InstituteLocationAddressPage(prefs.getInt(Strings.instituteId));
          })).then((value){
            if(value!=null){
              setState(() {
                _selectedLanguage = value;
              });
            }
          });
        },
        contentPadding: EdgeInsets.all(0),
        title: Text(_selectedLanguage.length>0?_selectedLanguage.length>1?_selectedLanguage.elementAt(0)+' & Others':_selectedLanguage.elementAt(0):'Select language', style: styleElements.subtitle1ThemeScalable(context),),
        trailing: Icon(Icons.arrow_forward_ios, color: HexColor(AppColors.appColorBlack35),
          size: 20,),

      ),
    );
    final onlineDetailsWidget = TextFormField(
      maxLines: 8,
      validator: CommonMixins().validateTextField,
      onSaved: (value){
        description = value;
      },
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
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
          appBar: TricycleAppBar().getCustomAppBar(context,
              appBarTitle: AppLocalizations.of(context)!.translate('event_details'),
              onBackButtonPress: () {
                Navigator.pop(context);
              },
            actions: [
              TricycleProgressButton(
                key: progressButtonKey,
                shape: StadiumBorder(),
                color: HexColor(AppColors.appColorBackground),
                elevation: 0,
                onPressed:  () {
                  // if(payload.eventPrivacyType == 'private'){
                    updatePayload();
                  // }else{
                  //   createEvent();
                  // }
                },
                child: Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('next'),
                      style: styleElements
                          .subtitle2ThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appMainColor)),
                    ),
                    Icon(Icons.keyboard_arrow_right,
                        color: HexColor(AppColors.appMainColor))
                  ],
                ),
              ),
            ]
              ),
          body: Form(
            key: formKey,
            child: Container(
              child: SingleChildScrollView(
                child: TricycleListCard(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      getEventDetailCard('Select Language', languageWidget),
                      Visibility(
                        visible: type!='talk',
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _divider,
                            getEventDetailCard('Location: Campus talk or offline or other online', locationWidget),
                          ],
                        ),
                      ),
                      _divider,
                      // getEventDetailCard('Paid Event', paidEventWidget),
                      // _divider,
                      getEventDetailCard('Details: Write about your event and speakers', onlineDetailsWidget),
                    ],
                  ),
                ),
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
  Widget get _divider => Padding(
    padding: EdgeInsets.only(top: 4,bottom: 4),
    child: Container(
      width: double.infinity,
      height: 1,
      color: HexColor(AppColors.appColorBackground),
    ),
  );

  void updatePayload() {
    progressButtonKey.currentState!.show();
    formKey.currentState!.save();
    if(type == 'talk' || eventLocation.length>0){
      progressButtonKey.currentState!.hide();
      payload!.eventLocation = eventLocation;
      payload!.eventDescription = description;
      payload!.eventLanguages = _selectedLanguage;
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return HostListPage(privacyType: payload!.eventPrivacyType,isReceiverList: true,payload: payload,roomItem: widget.roomItem,refreshCallBack:widget.refreshCallBack);
      })).then((value){
        if(value!=null){
          Map<String,dynamic> map = value;
          if(map['type'] == 'boolean'){
            var b = map['value'];
            if(b) Navigator.pop(context,true);
          }
        }
      });
    }else{
      progressButtonKey.currentState!.hide();
      ToastBuilder().showToast(AppLocalizations.of(context)!.translate('please_select_location'), context, HexColor(AppColors.information));
    }
  }

  void createEvent() async{
    // FocusScope.of(context).requestFocus(FocusNode());
    progressButtonKey.currentState!.show();
    formKey.currentState!.save();
    if(type == 'talk' || eventLocation.length>0) {
      payload!.eventLocation = eventLocation;
      payload!.eventDescription = description;
      payload!.eventLanguages = _selectedLanguage;
      payload!.recipientType = ['person'];
      payload!.recipientDetails = List<RecipientDetails>.generate(0, (index) {
        return RecipientDetails();
      });
      Calls().call(jsonEncode(payload), context, Config.CREATE_EVENT).then((
          value) {
        progressButtonKey.currentState!.hide();
        var res = CreateEventResponse.fromJson(value);
        if (res.statusCode == Strings.success_code) {
          ToastBuilder().showToast(AppLocalizations.of(context)!.translate(
              'event_created_successfully')
              , context, HexColor(AppColors.information));
          emitCreatePayload(res.rows!.id);
          Navigator.pop(context, true);
        }
      }).catchError((onError) {
        print(onError);
        progressButtonKey.currentState!.hide();
      });
    }else{
      progressButtonKey.currentState!.hide();
      ToastBuilder().showToast(AppLocalizations.of(context)!.translate('please_select_location'), context, HexColor(AppColors.information));
    }
  }

  void emitCreatePayload(int? eventId) {
    JoinEventPayload payload  = JoinEventPayload();
    payload.personId = prefs!.getInt(Strings.userId);
    payload.eventId = eventId;
    audioSocketService!.getSocket()!.emit(EVENT_CREATE,payload);
  }
}
