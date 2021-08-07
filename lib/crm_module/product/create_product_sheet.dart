import 'package:oho_works_app/crm_module/product/product_images_sheet.dart';
import 'package:oho_works_app/crm_module/product/select_unit_sheet.dart';
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

class CreateProductSheet extends StatelessWidget {
  final Function(String value)? onClickCallback;
  final SharedPreferences? prefs;
  final isRoomsVisible;
  final String? type;
  List<dynamic>? countryCodeList = [];
  CreateProductSheet({this.onClickCallback,this.prefs,this.isRoomsVisible=true,this.type=""});
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
      child: Padding(   padding: const EdgeInsets.only(bottom: 50.0,left: 16,right: 16,top: 16),
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
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Text(
                         type=="P" ?  AppLocalizations.of(context)!.translate("create_product"):AppLocalizations.of(context)!.translate("create_service"),
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


                          type=="P"?
                          showModalBottomSheet<void>(
                            context: context,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                            ),

                            isScrollControlled: true,
                            builder: (context) {
                              return MediaUploadSheet(
type: type,
                              );
                              // return BottomSheetContent();
                            },
                          ):

                          showModalBottomSheet<void>(
                            context: context,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                            ),

                             isScrollControlled: true,
                            builder: (context) {
                              return Describe_product_sheet(
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
                      ),)
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left:20.0,top: 8,bottom: 8),
                  child: Container(
                    child: Text(
                        type=="P" ?  AppLocalizations.of(context)!.translate("product_type"):AppLocalizations.of(context)!.translate("service_type"),
                      textAlign: TextAlign.left,
                      style: styleElements.subtitle1ThemeScalable(context),
                    ),
                  ),
                ),),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top:18,bottom: 18),
                    width: MediaQuery.of(context).size.width/4,
                    child: GestureDetector(
                      onTap: (){
                        onClickCallback!('feed');
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image(
                              image: AssetImage('assets/appimages/cart.png'),
                              fit: BoxFit.contain,
                              width: 80,
                              height: 80,
                            ),
                            SizedBox(height: 6,),
                            Text(
                              AppLocalizations.of(context)!.translate("for_sales"),
                              style: styleElements.captionThemeScalable(context).copyWith(
                                  color: HexColor(AppColors.appColorBlack65)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top:18,bottom: 18),
                    width: MediaQuery.of(context).size.width/4,
                    child: GestureDetector(
                      onTap: (){
                        onClickCallback!('qa');
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image(
                              image: AssetImage('assets/appimages/cart.png'),
                              fit: BoxFit.contain,
                              width: 80,
                              height: 80,
                            ),
                            SizedBox(height: 6,),
                            Text(
                              AppLocalizations.of(context)!.translate("internal_use"),
                              style: styleElements.captionThemeScalable(context).copyWith(
                                  color: HexColor(AppColors.appColorBlack65)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: type=="P",
                    child: Container(
                      margin: EdgeInsets.only(top:18,bottom: 18),
                      width: MediaQuery.of(context).size.width/4,
                      child: GestureDetector(
                        onTap: (){
                          onClickCallback!('blog');
                        },
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image(
                                image: AssetImage('assets/appimages/cart.png'),
                                fit: BoxFit.contain,
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(height: 6,),
                              Text(
                                AppLocalizations.of(context)!.translate("assets"),
                                style: styleElements.captionThemeScalable(context).copyWith(
                                    color: HexColor(AppColors.appColorBlack65)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: HexColor(AppColors.appColorBackground),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 4),
                              child: Icon(Icons.fifteen_mp,size: 30,),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: EditProfileMixins().validateEmail,
                              initialValue: "",
                              onSaved: (value) {

                              },



                              decoration: InputDecoration(
                                  hintText:  AppLocalizations.of(context)!.translate("name"),
                                  contentPadding: EdgeInsets.only(
                                      left: 12, top: 16, bottom: 8),
                                  border: UnderlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(12)),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  labelText:
                                type=="P"? AppLocalizations.of(context)!.translate("name_item"):AppLocalizations.of(context)!.translate("service_name_item")),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
              Visibility(
                visible: type=="P",
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: HexColor(AppColors.appColorBackground),
                    ),
                    child: Column(
                      children: [
                        Row(

                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0, right: 4),
                                child: Icon(Icons.bar_chart_sharp,size: 30,),
                              ),
                            ),
                            /* Container(
                                width: 80,
                                child: codes,
                              ),*/
                            Expanded(
                              child: TextFormField(
                                validator: EditProfileMixins().validateEmail,
                                initialValue: "",
                                onSaved: (value) {

                                },
                                decoration: InputDecoration(
                                    hintText:       AppLocalizations.of(context)!.translate("bar_code"),
                                    contentPadding: EdgeInsets.only(
                                        left: 12, top: 16, bottom: 8),

                                    border: UnderlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(12)),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                    labelText:
                                    AppLocalizations.of(context)!.translate("bar_code_enter")),
                              ),
                            ),
                          ],
                        ),


                      ],
                    ),
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