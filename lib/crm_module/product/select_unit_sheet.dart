import 'package:flutter/cupertino.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/crm_module/product/set_pricing_sheet.dart';
import 'package:oho_works_app/crm_module/term_and_condition_sheet.dart';
import 'package:oho_works_app/enums/personType.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnitTypeSheet extends StatelessWidget {
  final Function(String value)? onClickCallback;
  final SharedPreferences? prefs;
  final isRoomsVisible;
  final String ?type;
  List<dynamic>? countryCodeList = [];
  int? selectedTab;
  UnitTypeSheet({this.onClickCallback,this.prefs,this.isRoomsVisible=true,this.selectedTab,this.type});
  @override
  Widget build(BuildContext context) {

    List<DropdownMenuItem> countryCodes = [];
    TextStyleElements styleElements = TextStyleElements(context);
    _getCountryCodes() {
      for (int i = 0; i < countryCodeList!.length; i++) {
        countryCodes.add(DropdownMenuItem(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                countryCodeList![i].flagIconUrl??"",
                style: styleElements.bodyText2ThemeScalable(context),
              ),
              Padding(
                padding: const EdgeInsets.only(left:4.0,right: 4.0),
                child: Text(
                  countryCodeList![i].dialCode,
                  style: styleElements.bodyText2ThemeScalable(context),
                ),
              ),
            ],
          ),
          value: countryCodeList![i].dialCode,
        ));
      }
      return countryCodes;
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50.0,left: 16,right: 16,top: 16),
        child: Container(
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.only(
                  topLeft:  Radius.circular(20.0),
                  topRight:  Radius.circular(20.0))),
          child:  Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //Center Row contents vertically,

                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        child: Text(
                       AppLocalizations.of(context)!.translate("back"),
                          textAlign: TextAlign.center,
                          style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appMainColor)),
                        ),
                      ),),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Text(
                            AppLocalizations.of(context)!.translate("select_unit"),
                            textAlign: TextAlign.center,
                            style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                          showModalBottomSheet<void>(
                            context: context,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                            ),

                            isScrollControlled: true,
                            builder: (context) {
                              return TermAndConditionSheet(
                                prefs: prefs,
                                selectedTab:selectedTab,
                                onClickCallback: (value) {

                                },
                              );
                              // return BottomSheetContent();
                            },
                          );
                        },
                        child: InkWell(
                          onTap: (){

                            Navigator.pop(context);
                            showModalBottomSheet<void>(
                              context: context,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                              ),

                              isScrollControlled: true,
                              builder: (context) {
                                return PricingSheet(
                                  prefs: prefs,
                                  type: type,
                                  onClickCallback: (value) {

                                  },
                                );
                                // return BottomSheetContent();
                              },
                            );
                          },
                          child: Container(
                            child: Text(
                              AppLocalizations.of(context)!.translate("next"),
                              textAlign: TextAlign.center,
                              style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appMainColor)),
                            ),
                          ),
                        ),
                      ),)
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top:8.0,bottom:8.0),
                child: Column(
                  children: [

                    Row(
                      children: [
                        Expanded(
                          child: SearchBox(
                            onvalueChanged: (s){},
                            hintText: AppLocalizations.of(context)!.translate('search'),
                          ),
                        ),
                        InkWell(
                          onTap: (){


                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate('new'),
                                  textAlign: TextAlign.center,
                                  style: styleElements
                                      .subtitle1ThemeScalable(context)
                                      .copyWith(
                                      color: HexColor(AppColors.appColorBlack65)),
                                ),
                                Icon(
                                  Icons.add,
                                  color: HexColor(AppColors.appColorBlack65),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),


                    ListTile(
                      title:Text("Kg"),
                      trailing:  Checkbox(value: false, onChanged: (bool? value) {  },)
                    ),
                    ListTile(
                      title:Text("grams"),
                        trailing:  Checkbox(value: false, onChanged: (bool? value) {  },)
                    ),
                    ListTile(
                      title:Text("cms"),
                        trailing:  Checkbox(value: false, onChanged: (bool? value) {  },)
                    ),
                    ListTile(
                        title:Text("Liters"),
                        trailing:  Checkbox(value: false, onChanged: (bool? value) {  },)
                    ),
                      ListTile(
                        title:Text("Liters"),
                        trailing:  Checkbox(value: false, onChanged: (bool? value) {  },)
                    ),
                    ListTile(
                        title:Text("Liters"),
                        trailing:  Checkbox(value: false, onChanged: (bool? value) {  },)
                    ),
                    ListTile(
                        title:Text("Liters"),
                        trailing:  Checkbox(value: false, onChanged: (bool? value) {  },)
                    ),



                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              )
            ],
          ),
        ),
      ),
    );
  }
}