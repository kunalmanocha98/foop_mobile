import 'package:flutter/material.dart';
import 'package:oho_works_app/components/app_account_detail_add.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';

class AccountDetailCard extends StatelessWidget{
  final CommonCardData data;
  AccountDetailCard(this.data);
  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    return appListCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16,top:12,bottom:12),
                        child: Text(
                          data.title ?? "",
                          style: styleElements.headline6ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appColorBlack85)),
                          textAlign: TextAlign.left,
                        ),
                      )),
                  flex: 3,
                ),
                Spacer(),
                appTextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                      return AddAccountDetails();
                    }));
                  },
                  child: Text(AppLocalizations.of(context)!.translate('edit')),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 5, right: 5,bottom: 20),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 16, top: 20),
                                  child: Text(
                                    data.textOne ??= "",
                                    style: styleElements.subtitle2ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                )),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 16, top: 8, right: 16),
                                  child: Text(
                                    capitalize(data.textTwo??"---") ,
                                    style: styleElements.bodyText1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.left,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                        child:
                        Container(
                            margin: const EdgeInsets.only(left: 30),
                            child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, top: 20, right: 20),
                                      child: Text(
                                        data.textThree ??= "",
                                        style: styleElements.subtitle2ThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      ),
                                    )),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, top: 8, right: 20),
                                      child: Text(
                                        data.textFour ??= "",
                                        style: styleElements.bodyText1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.left,
                                      ),
                                    )),
                              ],
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 16, top: 20),
                                  child: Text(
                                    data.textFive ??= "",
                                    style: styleElements.subtitle2ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                )),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 16, top: 8, right: 16),
                                  child: Text(
                                    capitalize(data.textSix??"---") ,
                                    style: styleElements.bodyText1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.left,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                        child:
                        Container(
                            margin: const EdgeInsets.only(left: 30),
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, top: 20, right: 20),
                                      child: Text(
                                        data.textSeven ??= "",
                                        style: styleElements.subtitle2ThemeScalable(context),
                                        textAlign: TextAlign.right,
                                      ),
                                    )),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, top: 8, right: 20),
                                      child: Text(
                                        data.textEight ??= "",
                                        style: styleElements.bodyText1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.left,
                                      ),
                                    )),
                              ],
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 16, top: 20),
                                  child: Text(
                                    data.textNine ??= "",
                                    style: styleElements.subtitle2ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                )),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 16, top: 8, right: 16),
                                  child: Text(
                                    capitalize(data.textEight??"---") ,
                                    style: styleElements.bodyText1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.left,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                        child:
                        Container(
                            margin: const EdgeInsets.only(left: 30),
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, top: 20, right: 20),
                                      child: Text(
                                        data.textSeven ??= "",
                                        style: styleElements.subtitle2ThemeScalable(context),
                                        textAlign: TextAlign.right,
                                      ),
                                    )),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, top: 8, right: 20),
                                      child: Text(
                                        data.textEight ??= "",
                                        style: styleElements.bodyText1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.left,
                                      ),
                                    )),
                              ],
                            )),
                      )
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 20.0,bottom: 16),
                    child: Text(
                      data.textNine ??= "",
                      style: styleElements.subtitle2ThemeScalable(context),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],

              )
              ,
            )
            ,

          ],
        ));
  }
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}