import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/models/buddyApprovalModels/buddyServiceList.dart';
import 'package:oho_works_app/ui/BuddyApproval/approvalListPage.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/regisration_detail_page.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/registerInstituteInstructions.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/datasave.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class appEarnCard extends StatelessWidget {
  final String? type;
  final String? moneyVal;
  final String? imageUrl;
  final String? quote;
  final String? title;
  final String? coinsValue;
  late TextStyleElements styleElements;
  SharedPreferences? prefs;
  bool? isClickable;

  appEarnCard(
      {this.moneyVal,
        this.imageUrl,
        this.quote,
        this.title,
        this.coinsValue,
        this.isClickable,
        this.type});


  @override
  Widget build(BuildContext context) {
     styleElements = TextStyleElements(context);
    return appListCard(
        onTap: () {
          clickAction(context);
        },
        child: Container(
          margin: EdgeInsets.only(left:12,right: 12,top:8,bottom: 8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title??"",
                            style: styleElements
                                .captionThemeScalable(context)
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Flexible(
                            child:
                            getContent(context),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                           type=="register__entity"?AppLocalizations.of(context)!.translate("either_student_teacher") :'Minimum Guaranteed $coinsValue coins',
                            style: styleElements
                                .captionThemeScalable(context)
                                .copyWith(),
                          )
                        ],
                      ),
                    ),
                    // Image(
                    //   image: AssetImage('assets/appimages/check.png'),
                    //   height: 100,
                    //   width: 100,
                    // )
                    type=="register__entity"?SizedBox(
                      height: 95,
                      width: 95,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          child: Image(
                            image: AssetImage('assets/appimages/giftbox.png'),
                          ),
                        ),
                      ),
                    ):  CachedNetworkImage(
                      imageUrl: imageUrl!,
                      width: 100,
                      height: 100,
                    )
                  ],
                ),
                Visibility(
                  visible: isClickable??=true,
                  child: Row(
                    children: [
                      Spacer(),
                      appElevatedButton(onPressed:(){
                        clickAction(context);
                      },
                      color: HexColor(AppColors.appMainColor),
                      child: Text(type=="register__entity"?"Register":'Verify',
                      style: styleElements.buttonThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),),)
                    ],
                  ),
                )

              ]
          ),
        )
    );
  }
  void clickAction(BuildContext context) async{
    prefs??=await SharedPreferences.getInstance();
     if(type=="register__entity" )
    {
      if(isClickable!)
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>RegisInstruction()));}
     else{
       if (type == 'Buddy_Approval') {
         var personData = await DataSaveUtils().getUserData(context, prefs);
         var isVerified = personData!=null?personData.isVerified! : prefs!.getBool(Strings.isVerified)!;
         if(isVerified) {
           Navigator.push(
               context,
               MaterialPageRoute(
                   builder: (BuildContext context) => ApprovalListPage()));
         }else{
           ToastBuilder().showSnackBar(AppLocalizations.of(context)!.translate('verified_buddy'), context, HexColor(AppColors.information));
         }
       }

       else {
         Navigator.push(
             context,
             MaterialPageRoute(
                 builder: (BuildContext context) =>
                     RegisterInstituteInstructions(
                       buddyServiceListItem: BuddyServiceListItem(
                           heading: title,
                           coins: coinsValue,
                           moneyVal: moneyVal,
                           imageUrl: imageUrl,
                           cardName: type,
                           quote: quote
                       ),
                     )));
       }
     }
  }

  Widget getContent(BuildContext context) {
    if(type=='Buddy_Approval'){
      return  RichText(
        text: TextSpan(children: [
          TextSpan(
              text:
              'Verify users and win upto ',
              style: styleElements
                  .subtitle1ThemeScalable(context)
                  .copyWith(
                  fontWeight: FontWeight.bold,
                  color: HexColor(AppColors.appColorBlack85))),
          TextSpan(
              text: "₹",
              style: styleElements
                  .subtitle1ThemeScalable(context)
                  .copyWith(
                  color: HexColor(AppColors.appMainColor),
                  fontWeight: FontWeight.w900)),
          TextSpan(
              text: moneyVal,
              style: styleElements
                  .subtitle1ThemeScalable(context)
                  .copyWith(
                  color: HexColor(AppColors.appMainColor),
                  fontWeight: FontWeight.w900)),
          TextSpan(
              text: ' per verification',
              style: styleElements
                  .subtitle1ThemeScalable(context)
                  .copyWith(
                  fontWeight: FontWeight.bold,
                  color: HexColor(AppColors.appColorBlack85))),
        ]),
      );
    }
   else if(type=='register__entity'){
      return  RichText(
        text: TextSpan(children: [
          TextSpan(
              text:
              AppLocalizations.of(context)!.translate("user_int_not_registered"),
              style: styleElements
                  .subtitle1ThemeScalable(context)
                  .copyWith(
                  fontWeight: FontWeight.bold,
                  color: HexColor(AppColors.appColorBlack85))),
          TextSpan(
              text: "₹",
              style: styleElements
                  .subtitle1ThemeScalable(context)
                  .copyWith(
                  color: HexColor(AppColors.appMainColor),
                  fontWeight: FontWeight.w900)),
          TextSpan(
              text: moneyVal,
              style: styleElements
                  .subtitle1ThemeScalable(context)
                  .copyWith(
                  color: HexColor(AppColors.appMainColor),
                  fontWeight: FontWeight.w900)),

        ]),
      );
    }

    else{
      return  RichText(
        text: TextSpan(children: [
          TextSpan(
              text:
              'Get your company validated and win upto',
              style: styleElements
                  .subtitle1ThemeScalable(context)
                  .copyWith(
                  fontWeight: FontWeight.bold,
                  color: HexColor(AppColors.appColorBlack85))),
          TextSpan(
              text: "₹",
              style: styleElements
                  .subtitle1ThemeScalable(context)
                  .copyWith(
                  color: HexColor(AppColors.appMainColor),
                  fontWeight: FontWeight.w900)),
          TextSpan(
              text: moneyVal,
              style: styleElements
                  .subtitle1ThemeScalable(context)
                  .copyWith(
                  color: HexColor(AppColors.appMainColor),
                  fontWeight: FontWeight.w900)),
        ]),
      );
    }
  }



}
