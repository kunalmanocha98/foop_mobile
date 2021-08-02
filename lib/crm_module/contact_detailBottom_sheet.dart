import 'package:oho_works_app/enums/personType.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerContactDetailSheet extends StatelessWidget {
  final Function(String value)? onClickCallback;
  final SharedPreferences? prefs;
  final isRoomsVisible;
  List<dynamic>? countryCodeList = [];
  CustomerContactDetailSheet({this.onClickCallback,this.prefs,this.isRoomsVisible=true});
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
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Text(
                            "Contact Person Details",
                            textAlign: TextAlign.center,
                            style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        child: Text(
                          "Next",
                          textAlign: TextAlign.center,
                          style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appMainColor)),
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
                      "Enter Contact person's Email Id and Phone Number",
                      textAlign: TextAlign.left,
                      style: styleElements.subtitle1ThemeScalable(context),
                    ),
                  ),
                ),),


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
                              child: Icon(Icons.mail_outline,size: 30,),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: EditProfileMixins().validateEmail,
                              initialValue: "Email Id",
                              onSaved: (value) {

                              },


                              decoration: InputDecoration(
                                  hintText: "Email id",
                                  contentPadding: EdgeInsets.only(
                                      left: 12, top: 16, bottom: 8),
                                  border: UnderlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(12)),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  labelText:
                                  "Email Id of Company"),

                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
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
                              child: Icon(Icons.call_outlined,size: 30,),
                            ),
                          ),
                          /* Container(
                              width: 80,
                              child: codes,
                            ),*/
                          Expanded(
                            child: TextFormField(
                              validator: EditProfileMixins().validateEmail,
                              initialValue: "Mobil no",
                              onSaved: (value) {

                              },


                              decoration: InputDecoration(
                                  hintText: "Mobile No",
                                  contentPadding: EdgeInsets.only(
                                      left: 12, top: 16, bottom: 8),
                                  border: UnderlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(12)),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  labelText:
                                  "Mobile Number of the Company"),

                            ),
                          ),
                        ],
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