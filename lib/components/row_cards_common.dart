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
class AppRowCards extends StatelessWidget{



  String? subTitle1;
  String? subTitle2;
  String? subTitle3;
  String? subTitle4;
  String? subTitle5;
  String? subTitle6;

  Function ? callBack;
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  Function? onTap;
  Color? color;
  double borderRadius= 12.0;
  AppRowCards({this.subTitle1,this.subTitle2,this.subTitle3,this.callBack,this.subTitle4,this.subTitle5,this.subTitle6});

  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    Utility().screenUtilInit(context);
    return Container(


      padding: EdgeInsets.all(0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          Expanded(
            child: Card(
                child:
                Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8,bottom: 8),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                         subTitle1!,style: styleElements
                            .subtitle2ThemeScalable(
                            context)
                            .copyWith(
                            color: HexColor(
                                AppColors
                                    .appColorBlack35),
                            fontWeight:
                            FontWeight
                                .bold),),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(subTitle2!,style: styleElements
                            .headlinecustomThemeScalable(
                            context)
                            .copyWith(
                            color: HexColor(
                                AppColors
                                    .appColorBlack85),
                            fontWeight:
                            FontWeight
                                .bold),),
                      )
                    ],

                  ),
                )
            ),
          ),

          Expanded(
            child: Card(
                child:
                Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8,bottom: 8),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(subTitle3!,style: styleElements
                            .subtitle2ThemeScalable(
                            context)
                            .copyWith(
                            color: HexColor(
                                AppColors
                                    .appColorBlack35),
                            fontWeight:
                            FontWeight
                                .bold),),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(subTitle4!,style: styleElements
                            .headlinecustomThemeScalable(
                            context)
                            .copyWith(
                            color: HexColor(
                                AppColors
                                    .appColorBlack85),
                            fontWeight:
                            FontWeight
                                .bold),),
                      )
                    ],

                  ),
                )
            ),
          ),

          Expanded(
            child: Card(
                child:
                Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8,bottom: 8),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(subTitle5!,style: styleElements
                            .subtitle2ThemeScalable(
                            context)
                            .copyWith(
                            color: HexColor(
                                AppColors
                                    .appColorBlack35),
                            fontWeight:
                            FontWeight
                                .bold),),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(subTitle6!,style: styleElements
                            .headlinecustomThemeScalable(
                            context)
                            .copyWith(
                            color: HexColor(
                                AppColors
                                    .appColorBlack85),
                            fontWeight:
                            FontWeight
                                .bold),),
                      )
                    ],

                  ),
                )
            ),
          ),
        ],
      )
    );

  }

}