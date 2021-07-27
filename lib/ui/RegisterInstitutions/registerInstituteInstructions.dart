import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/components/tricycle_earn_card.dart';
import 'package:oho_works_app/models/buddyApprovalModels/buddyServiceList.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/confirm_details_institute.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class RegisterInstituteInstructions extends StatelessWidget{
  SharedPreferences? prefs;
  BuddyServiceListItem? buddyServiceListItem;
  RegisterInstituteInstructions({this.buddyServiceListItem});
  @override
  Widget build(BuildContext context) {
    getPrefrences();
    var styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBar(context,
            appBarTitle: 'Tricycle',
            onBackButtonPress: (){Navigator.pop(context);}),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TricycleEarnCard(
                title: buddyServiceListItem!.heading,
                imageUrl: buddyServiceListItem!.imageUrl,
                coinsValue: buddyServiceListItem!.coins,
                moneyVal: buddyServiceListItem!.moneyVal,
                quote: '',
                isClickable: false,
                type: buddyServiceListItem!.cardName,
              ),

              TricycleCard(
                margin: EdgeInsets.only(top:2,left:10,right: 10,bottom: 45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.translate('entity_registration'),
                      style: styleElements.headline6ThemeScalable(context).copyWith(
                        fontWeight: FontWeight.bold
                      ),),
                    Text(AppLocalizations.of(context)!.translate('requirement'),
                      style: styleElements.subtitle1ThemeScalable(context).copyWith(
                        fontWeight: FontWeight.bold
                      ),),
                    SizedBox(height: 10,),
                    Text(AppLocalizations.of(context)!.translate('entity_reg_des'),
                      style: styleElements.bodyText2ThemeScalable(context),),
                    SizedBox(height: 4,),
                    Text(AppLocalizations.of(context)!.translate('what_to_do'),
                      style: styleElements.subtitle1ThemeScalable(context).copyWith(
                        fontWeight: FontWeight.bold
                      ),),
                    SizedBox(height: 10,),
                    Text(AppLocalizations.of(context)!.translate('if_you_student'),
                      style: styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),),
                    SizedBox(height: 6,),
                    RichText(text: TextSpan(
                      children: [
                        TextSpan(text: 'Step1: ',style: styleElements.subtitle2ThemeScalable(context).copyWith(
                          fontWeight: FontWeight.w600
                        )),
                        TextSpan(text: 'Talk to the staff who you think will be the administrator of your institution.',style: styleElements.bodyText2ThemeScalable(context)),
                      ]
                    )),
                    SizedBox(height: 4,),
                    RichText(text: TextSpan(
                        children: [
                          TextSpan(text: 'Step2: ',style: styleElements.subtitle2ThemeScalable(context).copyWith(
                              fontWeight: FontWeight.w600
                          )),
                          TextSpan(text: 'Fill the form with the details of the staff who will register and administer your institution',style: styleElements.bodyText2ThemeScalable(context)),
                        ]
                    )),
                    SizedBox(height: 4,),
                    RichText(text: TextSpan(
                        children: [
                          TextSpan(text: 'Step3: ',style: styleElements.subtitle2ThemeScalable(context).copyWith(
                              fontWeight: FontWeight.w600
                          )),
                          TextSpan(text: 'Help the staff to login through web https://www.tricycle.life and click on Manage institution.',style: styleElements.bodyText2ThemeScalable(context)),
                        ]
                    )),
                    SizedBox(height: 4,),
                    RichText(text: TextSpan(
                        children: [
                          TextSpan(text: 'Step4: ',style: styleElements.subtitle2ThemeScalable(context).copyWith(
                              fontWeight: FontWeight.w600
                          )),
                          TextSpan(text: 'Staff is expected to upload the invitation Details of students, staffs and parents.',style: styleElements.bodyText2ThemeScalable(context)),
                        ]
                    )),
                    SizedBox(height: 10,),
                    Text(AppLocalizations.of(context)!.translate('staff_des'),
                      style: styleElements.bodyText2ThemeScalable(context),),
                    SizedBox(height: 10,),
                    Text(AppLocalizations.of(context)!.translate('if_you_staff'),
                      style: styleElements.subtitle2ThemeScalable(context).copyWith(
                        fontWeight: FontWeight.bold
                      ),),
                    SizedBox(height: 6,),
                    RichText(text: TextSpan(
                        children: [
                          TextSpan(text: AppLocalizations.of(context)!.translate('reg_step1'),style: styleElements.subtitle2ThemeScalable(context).copyWith(
                            fontWeight: FontWeight.w600
                          )),
                          TextSpan(text: AppLocalizations.of(context)!.translate('reg_step1_des'),style: styleElements.bodyText2ThemeScalable(context)),
                        ]
                    )),
                    SizedBox(height: 4,),
                    RichText(text: TextSpan(
                        children: [
                          TextSpan(text: AppLocalizations.of(context)!.translate('reg_step2'),style: styleElements.subtitle2ThemeScalable(context).copyWith(
                              fontWeight: FontWeight.w600
                          )),
                          TextSpan(text: AppLocalizations.of(context)!.translate('reg_step2_des'),style: styleElements.bodyText2ThemeScalable(context)),
                        ]
                    )),
                    SizedBox(height: 4,),
                    RichText(text: TextSpan(
                        children: [
                          TextSpan(text: AppLocalizations.of(context)!.translate('reg_step3'),style: styleElements.subtitle2ThemeScalable(context).copyWith(
                              fontWeight: FontWeight.w600
                          )),
                          TextSpan(text: AppLocalizations.of(context)!.translate('upload_details'),style: styleElements.bodyText2ThemeScalable(context)),
                        ]
                    )),
                    SizedBox(height: 10,),
                    Text(AppLocalizations.of(context)!.translate('staff_des'),
                      style: styleElements.bodyText2ThemeScalable(context),),
                    SizedBox(height: 10,),
                    Text(AppLocalizations.of(context)!.translate('what_next'),
                      style: styleElements.subtitle1ThemeScalable(context).copyWith(
                        fontWeight: FontWeight.w600
                      ),),
                    SizedBox(height: 6,),
                    Text(AppLocalizations.of(context)!.translate('upi_des'),
                    style: styleElements.bodyText2ThemeScalable(context),),
                    SizedBox(height: 24,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TricycleElevatedButton(onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => ConfirmDetails(
                          instId:  prefs!.getInt(Strings.instituteId),
                           fromPage: 'earn'
                          ))).then((value){
                            if(value){
                              Navigator.pop(context);
                            }
                          });
                        },
                        child: Padding(
                          padding:  EdgeInsets.only(left:8.0,right: 8.0),
                          child: Text(AppLocalizations.of(context)!.translate('fill_details'),style: styleElements.bodyText2ThemeScalable(context).copyWith(
                            color: HexColor(AppColors.appColorWhite)
                          ),),
                        ),),
                      ],
                    ),
                    SizedBox(height: 24,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void getPrefrences() async{
    prefs??=await SharedPreferences.getInstance();
  }

}