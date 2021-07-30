import 'package:oho_works_app/enums/personType.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateCustomerBottomSheet extends StatelessWidget {
  final Function(String value)? onClickCallback;
  final SharedPreferences? prefs;
  final isRoomsVisible;
  List<dynamic>? countryCodeList = [];
  CreateCustomerBottomSheet({this.onClickCallback,this.prefs,this.isRoomsVisible=true});
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
                            "Create Company",
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
                      "Select RelationShip",
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
                              "Customer",
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
                              "Supplier",
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
                              "Channel Partner",
                              style: styleElements.captionThemeScalable(context).copyWith(
                                  color: HexColor(AppColors.appColorBlack65)
                              ),
                            ),
                          ],
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
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  labelText:
                                  "Email Id of Company"),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: Divider(
                          height: 2,
                          color: HexColor(AppColors.appMainColor),
                          thickness: 1,
                          indent: 0,
                          endIndent: 0,
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
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  labelText:
                                  "Mobile Number of the Company"),
                            ),
                          ),
                        ],
                      ),

                       Padding(
                         padding: const EdgeInsets.only(top:8.0),
                         child: Divider(
                          height: 2,
                          color: HexColor(AppColors.appMainColor),
                          thickness: 1,
                          indent: 0,
                          endIndent: 0,
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
    );
  }
}