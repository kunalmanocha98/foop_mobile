import 'package:oho_works_app/crm_module/tax/text_selection_page.dart';
import 'package:oho_works_app/enums/personType.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'discrive_product_sheet.dart';

class TaxSheet extends StatelessWidget {
  final Function(String value)? onClickCallback;
  final SharedPreferences? prefs;
  final isRoomsVisible;
  final String?type;
  List<dynamic>? countryCodeList = [];
  TaxSheet({this.onClickCallback,this.prefs,this.isRoomsVisible=true,this.type});
  @override
  Widget build(BuildContext context) {

    List<DropdownMenuItem> countryCodes = [];
    TextStyleElements styleElements = TextStyleElements(context);
    _getCountryCodes() {
      for (int i = 0; i < countryCodeList!.length; i++) {
        countryCodes.add(DropdownMenuItem(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
    final codes = DropdownButtonFormField<dynamic>(
      value: null,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(4.0, 15.0, 4.0, 15.0),

        border: InputBorder.none,

      ),
      hint: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(
            AppLocalizations.of(context)!.translate(""),
            style: styleElements.bodyText2ThemeScalable(context),)
      ),

      items: _getCountryCodes(),
      onChanged: (value) {

        value as String ;


      },
    );
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
                padding: const EdgeInsets.only(bottom: 30.0,left: 16,right: 16,top: 8),
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
                          "back",
                          textAlign: TextAlign.center,
                          style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appMainColor)),
                        ),
                      ),),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Text(
                            AppLocalizations.of(context)!.translate("Tax"),
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

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaxSelectionPage(
                                    id: 2,
                                    type: "person",
                                    hideTabs:true,

                                    selectedTab:type=="P"? 0:1,
                                    isSwipeDisabled:true,
                                    hideAppBar: true,
                                    currentTab: 0,
                                    pageTitle: "",
                                    imageUrl: "",
                                    callback: () {

                                    }),
                              ));
                        },
                        child: Container(
                          child: Text(
                       AppLocalizations.of(context)!.translate("next"),
                            textAlign: TextAlign.center,
                            style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appMainColor)),
                          ),
                        ),
                      ),)
                  ],
                ),
              ),




              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.only(bottom: 8),

                  child:   Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child:
                        Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 4),
                            child: Text(AppLocalizations.of(context)!.translate("inclusive_tax"))
                        ),
                      ),

                      Center(
                        child: Switch(
                          value: false,
                          onChanged: (value){

                          },
                          activeTrackColor:HexColor(AppColors.appMainColor10),
                          activeColor: HexColor(AppColors.appMainColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.only(bottom: 8),

                  child:   Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child:
                        Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 4),
                            child: Text(AppLocalizations.of(context)!.translate("exclusive_tax"))
                        ),
                      ),

                      Center(
                        child: Switch(
                          value: false,
                          onChanged: (value){

                          },
                          activeTrackColor:HexColor(AppColors.appMainColor10),
                          activeColor: HexColor(AppColors.appMainColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.only(bottom: 8),

                  child:   Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child:
                        Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 4),
                            child: Text(AppLocalizations.of(context)!.translate("no_tax"))
                        ),
                      ),

                      Center(
                        child: Switch(
                          value: false,
                          onChanged: (value){

                          },
                          activeTrackColor:HexColor(AppColors.appMainColor10),
                          activeColor: HexColor(AppColors.appMainColor),
                        ),
                      ),
                    ],
                  ),
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