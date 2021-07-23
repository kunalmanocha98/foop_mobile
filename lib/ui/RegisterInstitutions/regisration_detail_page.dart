import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/components/tricycle_earn_card.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

import 'basic_institute_detail.dart';

class RegisInstruction extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBar(context,
            appBarTitle: 'Register Institute',
            onBackButtonPress: (){Navigator.pop(context);}),
        body:
        Stack(
          children: <Widget>[
            ListView(
              children: [
                TricycleEarnCard(
                  title: AppLocalizations.of(context)!.translate('register'),
                  imageUrl: "",
                  coinsValue: "100",
                  moneyVal: "1000",
                  quote: '',
                  isClickable: false,
                  type: "register_institute",
                ),
                TricycleCard(
                  margin: EdgeInsets.only(top:2,left:10,right: 10,bottom: 45),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.translate('instruct_to_reg'),
                        style: styleElements.headline6ThemeScalable(context).copyWith(
                            fontWeight: FontWeight.bold
                        ),),
                      Text(AppLocalizations.of(context)!.translate("regis_requirement"),
                        style: styleElements.bodyText1ThemeScalable(context),),

                    ],
                  ),
                ),
              ],
            ),
            Align(
                alignment: FractionalOffset.bottomCenter,
                child: GestureDetector(
                  child: Container(
                    height: 60,
                    color: HexColor(AppColors.appColorWhite),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Visibility(
                                visible: false,
                                child: Container(
                                  margin:
                                  const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0),
                                  child: TricycleElevatedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            18.0),
                                        side: BorderSide(
                                            color: Colors
                                                .redAccent)),
                                    onPressed: () async {

                                    },
                                    color: Colors
                                        .white,
                                    child: Text(
                                        AppLocalizations.of(
                                            context)!
                                            .translate(
                                            "next"),
                                        style: styleElements
                                            .buttonThemeScalable(
                                            context)
                                            .copyWith(
                                            color:  Colors
                                                .redAccent)),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Visibility(
                                child: Container(
                                  margin:
                                  const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0),
                                  child: TricycleElevatedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            18.0),
                                        side: BorderSide(
                                            color: Colors
                                                .redAccent)),
                                    onPressed: () async {


                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>BasicInstituteDetails()));

                                    },
                                    color: Colors
                                        .white,
                                    child: Text(
                                        AppLocalizations.of(
                                            context)!
                                            .translate(
                                            "next"),
                                        style: styleElements
                                            .buttonThemeScalable(
                                            context)
                                            .copyWith(
                                            color:  Colors
                                                .redAccent)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                ))
          ],
        )




      ),
    );
  }

}