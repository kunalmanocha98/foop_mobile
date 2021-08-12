import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/enums/personType.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/profile_module/pages/directions.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomSheetAddress extends StatefulWidget {
  final Function(String? value)? onClickCallback;
  BottomSheetAddress({this.onClickCallback});
  @override
  BottomSheetAddressState createState()=> BottomSheetAddressState();
}


class BottomSheetAddressState extends State<BottomSheetAddress>{

  TextEditingController controller = TextEditingController();
 String addresses ="address" ;
  List<dynamic>? countryCodeList = [];

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
                            AppLocalizations.of(context)!.translate("Company_Address") ,
                            textAlign: TextAlign.center,
                            style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        child: Text(
                            AppLocalizations.of(context)!.translate("next") ,
                          textAlign: TextAlign.center,
                          style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appMainColor)),
                        ),
                      ),)
                  ],
                ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {    var result=await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPage()));
                if (result != null) {
                  if (result["address"] != null)

                  controller.text=result["address"];

                }


                },
                child: Container(
                  height: 48,
                  margin:  EdgeInsets.only(left: 16, right: 16, top: 2,bottom: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        HexColor(AppColors.appColorWhite),
                        HexColor(AppColors.appColorWhite),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    boxShadow: [CommonComponents().getShadowforBox_01_3()],
                  ),
                  child: Center(
                    child: Container(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.location_on_outlined, color: HexColor(AppColors.appColorGrey500)),
                            ),
                            Expanded(
                              child: Text("Search",
                                style: styleElements.bodyText2ThemeScalable(context).copyWith(
                                    color: HexColor(AppColors.appColorBlack35)
                                ),
                              ),
                            )

                          ],
                        )
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.only(bottom: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: HexColor(AppColors.appColorBackground),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Icon(Icons.location_on_outlined,size: 30,),
                              ),
                            ),
                            /* Container(
                                width: 80,
                                child: codes,
                              ),*/
                            Expanded(
                              child: TextField(
                                controller: controller,
                          
                                maxLines: 5,


                                decoration: InputDecoration(
                                    hintText: "Address",
                                    contentPadding: EdgeInsets.only(
                                        left: 12, top: 16, bottom: 8),
                                    border: UnderlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(12)),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                    labelText:
                                    "Enter company address"),

                              ),
                            ),
                          ],
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