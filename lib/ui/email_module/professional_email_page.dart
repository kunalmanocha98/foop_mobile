
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_email_page.dart';
import 'manage_domain_page.dart';

class ProfessionalEmailActionPage extends StatelessWidget {
  final SharedPreferences prefs = locator<SharedPreferences>();
  final bool isAdmin;
  final bool haveDomain;
  ProfessionalEmailActionPage({this.isAdmin = true, this.haveDomain= true});

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        appBar: OhoAppBar().getCustomAppBar(
          context,
          appBarTitle:
          AppLocalizations.of(context)!.translate('profession_email'),
          onBackButtonPress: () {
            Navigator.pop(context);
          },
        ),
        body: Container(
          child: appListCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16,),
                Image.asset('assets/appimages/email.png',width: 240,height: 240,),
                SizedBox(height: 16,),
                Text(AppLocalizations.of(context)!.translate('profession_email'),
                style: styleElements.bodyText1ThemeScalable(context),),
                SizedBox(height: 12,),
                Text(prefs.getString(Strings.mailUsername)!,
                  style: styleElements.headline6ThemeScalable(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: HexColor(AppColors.appColorBlack85)
                  ),),
                SizedBox(height: 12,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text("It’s always great to have a professional-looking email instead of a free email. Now Tricycle provides an easy way to have your Professional email ID.",
                    textAlign: TextAlign.center,
                    style: styleElements.subtitle1ThemeScalable(context),),
                ),
                SizedBox(height: 12,),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 24),
                  child: Text(getContent(),
                    textAlign: TextAlign.center,
                    style: styleElements.subtitle1ThemeScalable(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: HexColor(AppColors.appColorBlack85)
                  ),),
                ),
                SizedBox(height: 24,),
                getButton(styleElements,context),
                SizedBox(height: 24,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getContent() {
    if(haveDomain){
      return "Your institute XYZ-ABC has allowed you to create an email for yourself.";
    }else{
      if(isAdmin){
        return "You do not have your domain name updated in our system. As an admin of your Institute you can manage your email domain.";
      }else{
        return "You do not have your domain name updated in our system. Neither you are admin of your institute. You cannot create an email. Contact the admin of your institute.";
      }
    }
  }

  Widget getButton(TextStyleElements styleElements, BuildContext context) {
    if(haveDomain){
      return appElevatedButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder:(BuildContext context){
            return CreateEmailPage();
          }));
        },
        padding: EdgeInsets.only(left:24,right: 24),
        child: Text('Create Email',style:styleElements.bodyText2ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorWhite)
        ),),
        color: HexColor(AppColors.appMainColor),
      );
    }else{
      if(isAdmin){
        return appElevatedButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder:(BuildContext context){
              return ManageDomainPage();
            }));
          },
          padding: EdgeInsets.only(left:24,right: 24),
          child: Text('Click to manage',style:styleElements.bodyText2ThemeScalable(context).copyWith(
              color: HexColor(AppColors.appColorWhite)
          ),),
          color: HexColor(AppColors.appMainColor),
        );
      }else{
        return appElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          padding: EdgeInsets.only(left:24,right: 24),
          child: Text('Close',style:styleElements.bodyText2ThemeScalable(context).copyWith(
              color: HexColor(AppColors.appColorWhite)
          ),),
          color: HexColor(AppColors.appMainColor),
        );
      }
    }
  }
}
