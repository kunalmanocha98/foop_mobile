import 'package:oho_works_app/crm_module/bottom_sheet_address.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';

import 'appAvatar.dart';
import 'commonComponents.dart';

// ignore: must_be_immutable
class AppPaymentCard extends StatelessWidget{

  String? imageUrl;
  String? title;
  String? actionText;
  String? subTitle1;
  String? subTitle2;
  String? subTitle3;
  String? subTitle4;
  Function ? callBack;



  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  Function? onTap;
  Color? color;
  double borderRadius= 12.0;
  AppPaymentCard({required this.imageUrl,this.title,this.actionText,this.subTitle1,this.subTitle2,this.subTitle3,this.callBack,this.subTitle4});

  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    Utility().screenUtilInit(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [CommonComponents().getShadowforBox()],
      ),
      margin: margin??=EdgeInsets.only(left: 8, right: 8.0, top: 6.0, bottom: 6.0),
      padding: EdgeInsets.all(0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)
        ),
        margin: EdgeInsets.all(0),
        color: color,
        elevation: 0,
        child: InkWell(
          onTap: onTap as void Function()?,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding??=EdgeInsets.only(top: 8,bottom: 8,left: 16,right: 16),
            child: Column(

              children: [

                Row
                  (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:16.0),
                      child: Text(
                        title!,
                        style: styleElements.subtitle1ThemeScalable(context),
                      ),),

                    Padding(
                      padding: const EdgeInsets.only(top:16.0),
                      child: InkWell(
                        onTap: (){
                          callBack!();
                        },
                        child: Text(
                          actionText!,
                          style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),
                        ),
                      ),)



                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [


                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:16.0),
                          child: Text(
                              subTitle1!,
                              style: styleElements.subtitle1ThemeScalable(context)
                          ),),
                        Padding(
                          padding: const EdgeInsets.only(top:4.0),
                          child: Text(
                            subTitle2!,
                            style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
                          ),),
                        Padding(
                          padding: const EdgeInsets.only(top:4.0),
                          child: Text(
                            subTitle3!,
                            style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
                          ),),
                        Padding(
                          padding: const EdgeInsets.only(top:4.0,bottom: 16),
                          child: Text(
                            subTitle4!,
                            style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
                          ),)
                      ],
                    )



                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );

  }

}