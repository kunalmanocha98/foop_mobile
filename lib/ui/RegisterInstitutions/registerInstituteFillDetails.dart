import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/RefferralInstitution/RefferralModels.dart';
import 'package:oho_works_app/models/RefferralInstitution/stafflistmodels.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/thankyoufillingdialog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterInstituteFillDetails extends StatefulWidget{
  @override
  RegisterInstituteFillDetailsState createState() => RegisterInstituteFillDetailsState();
  
}
class RegisterInstituteFillDetailsState extends State<RegisterInstituteFillDetails> with CommonMixins{
  late TextStyleElements styleElements;
  String? mobileNumber;
  String? upiId;
  var formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();

  StaffListItem? selectedItem;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    SharedPreferences? prefs;
   return SafeArea(
     child: Scaffold(
       appBar: appAppBar().getCustomAppBar(context, appBarTitle: 'app', onBackButtonPress: (){
         Navigator.pop(context);
       }),
       body: FutureBuilder<SharedPreferences>(
         future: SharedPreferences.getInstance(),
         builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
           return SingleChildScrollView(
             child: Form(
               key: formKey,
               child: Container(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     SizedBox(height: 40,),
                     Padding(
                       padding:  EdgeInsets.only(left:8.0,right:8),
                       child: appUserListTile(
                         imageUrl: snapshot.data!.getStringList(Strings.institutionImageList)![0],
                         service_type: SERVICE_TYPE.INSTITUTION,
                         title:snapshot.data!.getStringList(Strings.institutionNameList)![0],
                       ),
                     ),
                     Padding(
                       padding:  EdgeInsets.only(top:24,left:20.0,right:20.0),
                       child: Column(
                         children: [
                           Text(AppLocalizations.of(context)!.translate('detail_of_staff'),
                             style: styleElements.subtitle1ThemeScalable(context),),
                           SizedBox(height: 10,),
                           TypeAheadField(
                             debounceDuration: Duration(milliseconds: 700),
                             textFieldConfiguration: TextFieldConfiguration(
                               controller: _typeAheadController,
                                 style: styleElements.subtitle1ThemeScalable(context).copyWith(
                                     color: HexColor(AppColors.appColorBlack65)
                                 ),
                                 decoration: InputDecoration(
                               hintText: AppLocalizations.of(context)!.translate('enter_name_staff'),
                               hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
                               contentPadding: EdgeInsets.only(left: 8)
                             )),
                             onSuggestionSelected: (dynamic suggestion) {
                               selectedItem = suggestion;
                               this._typeAheadController.text = selectedItem!.firstName!+" "+selectedItem!.lastName!;
                             },
                             itemBuilder: (BuildContext context, dynamic itemData) {
                               StaffListItem item = itemData;
                               return appUserListTile(
                                 imageUrl: item.profileImage,
                                 title:item.firstName!+" "+item.lastName!,
                               );
                             },
                             suggestionsCallback: (String pattern) async{
                               prefs??= await SharedPreferences.getInstance();
                               if(pattern.isNotEmpty){
                                 StaffListRequest payload = StaffListRequest();
                                 payload.institutionId = prefs!.getInt(Strings.instituteId);
                                 payload.pageNumber=1;
                                 payload.pageSize=5;
                                 payload.personType ='staff';
                                 payload.searchVal = pattern;
                                 var res = await Calls().call(jsonEncode(payload), context, Config.INSTITUTION_STAFFLIST);
                                 return StaffListResponse.fromJson(res).rows!;
                               }else{
                                 return [];
                               }
                             },),
                           // TextFormField(
                           //   validator: validateTextField,
                           //   onSaved: (value){
                           //     name = value;
                           //   },
                           //   decoration: InputDecoration(
                           //     contentPadding: EdgeInsets.only(left:8),
                           //       hintText: 'Enter the name of the staff'
                           //   ),
                           // ),
                           SizedBox(height: 10,),
                           Text(AppLocalizations.of(context)!.translate('staff_registered'),
                             style: styleElements.captionThemeScalable(context),),
                           SizedBox(height: 10,),
                           TextFormField(
                             validator: validateTextField,
                             onSaved: (value){
                               mobileNumber = value;
                             },
                             style: styleElements.subtitle1ThemeScalable(context).copyWith(
                                 color: HexColor(AppColors.appColorBlack65)
                             ),
                             keyboardType: TextInputType.number,
                             decoration: InputDecoration(
                                 contentPadding: EdgeInsets.only(left:8),
                                 hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
                                 hintText: AppLocalizations.of(context)!.translate('mobile_number'),
                             ),
                           ),
                           SizedBox(height: 8,),
                           TextFormField(
                             validator: validateTextField,
                             onSaved: (value){
                               upiId = value;
                             },
                             style: styleElements.subtitle1ThemeScalable(context).copyWith(
                                 color: HexColor(AppColors.appColorBlack65)
                             ),
                             decoration: InputDecoration(
                                 contentPadding: EdgeInsets.only(left:8),
                                 hintText: AppLocalizations.of(context)!.translate('upi'),
                               hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35))
                             ),
                           ),
                           SizedBox(height: 32,),
                           appProgressButton(
                             key: progressButtonKey,
                             onPressed: (){
                               if(formKey.currentState!.validate()){
                                 formKey.currentState!.save();
                                 if(selectedItem!=null) {
                                   createReferral();
                                 }else{
                                   ToastBuilder().showToast('Please select a staff member', context, HexColor(AppColors.information));
                                 }
                               }
                               },
                             child: Text(AppLocalizations.of(context)!.translate('submit'),style: styleElements.bodyText2ThemeScalable(context).copyWith(
                               color: HexColor(AppColors.appColorWhite)
                             ),),)
                         ],
                       ),
                     ),
                   ],
                 ),
               ),
             ),
           );
         },
       ),
     ),
   );
  }

  void createReferral() async{
    progressButtonKey.currentState!.show();
    var prefs = await SharedPreferences.getInstance();
    ReferralRequest payload = ReferralRequest();
    payload.institutionId = prefs.getInt(Strings.instituteId);
    payload.adminStaffPersonId = selectedItem!.id;
    payload.referredByPersonId = prefs.getInt(Strings.userId);
    payload.referredByPersonMobileNumber = mobileNumber;
    payload.referredByUpiId = upiId;
    var data = jsonEncode(payload);
    Calls().call(data, context, Config.REFFERRAL_INSTITUTE).then((value) async {
      progressButtonKey.currentState!.hide();
      var response = ReferralResponse.fromJson(value);
      if(response.statusCode == Strings.success_code){
        showDialog(context: context,
            builder: (context) => DialogThankYouFillingDetails());
        // ToastBuilder().showToast(response.message, context, HexColor(AppColors.success));
        // Navigator.pop(context,true);
      }else{
        ToastBuilder().showToast(response.message!, context, HexColor(AppColors.information));
      }
    }).catchError((onError){
      progressButtonKey.currentState!.hide();
    });
  }
  
}