import 'package:flutter/cupertino.dart';
import 'package:oho_works_app/components/appAttachmentComponent.dart';
import 'package:oho_works_app/components/searchBox.dart';
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



class DescribeTaxSheet extends StatelessWidget {
  final Function(String value)? onClickCallback;
  final SharedPreferences? prefs;
  final isRoomsVisible;
  String ? type;
  GlobalKey<appAttachmentsState> attachmentKey = GlobalKey();
  List<dynamic>? countryCodeList = [];
  int? selectedTab;
  DescribeTaxSheet({this.onClickCallback,this.prefs,this.isRoomsVisible=true,this.selectedTab,this.type});
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

                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        child: Text(
                            AppLocalizations.of(context)!.translate("skip"),
                          textAlign: TextAlign.center,
                          style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appMainColor)),
                        ),
                      ),),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Text(
                           AppLocalizations.of(context)!.translate("tax_remark"),
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
                  padding: EdgeInsets.only(bottom: 0),

                  child: Column(
                    children: [

                      Container(
                        padding: EdgeInsets.only(bottom: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: HexColor(AppColors.appColorBackground),
                        ),
                        child: TextFormField(
                          validator: EditProfileMixins().validateEmail,
                          initialValue: "",
                          maxLines: 5,
                          onSaved: (value) {

                          },

                          decoration: InputDecoration(
                            hintText: "",
                            contentPadding: EdgeInsets.only(
                                left: 12, top: 16, bottom: 8),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,



                          ),
                        ),
                      ),


                      appAttachments(
                        attachmentKey,
                        isMentionVisible: false,
                        mentionCallback: (value) {

                        },
                        hashTagCallback: (value) {

                        },
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