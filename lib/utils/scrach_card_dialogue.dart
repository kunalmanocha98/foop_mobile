import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/regisration_module/welcomePage.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/models/scratch_card_response.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'TextStyles/TextStyleElements.dart';
import 'app_localization.dart';
import 'colors.dart';
import 'config.dart';


// ignore: must_be_immutable
class ScratchCardDialogue extends StatefulWidget {
  int? personId;
  int? scratchCardId;
  String? value;
  String? type;
  String? fromPage;
  Function? callBack;
  @override
  _ScratchCardDialogue createState() =>  _ScratchCardDialogue(personId,scratchCardId,value,type,fromPage: fromPage,callBack:callBack);
  ScratchCardDialogue(this.personId, this.scratchCardId,this.value,this.type,{this.fromPage,this.callBack});
}
// ignore: must_be_immutable
class _ScratchCardDialogue  extends State<ScratchCardDialogue> {
  int? personId;
  int? scratchCardId;
  String? value;
  String? type;
  String? name;
  String? fromPage;
  Function? callBack;
  SharedPreferences? prefs;
  late TextStyleElements styleElements;
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }


  bool isScrached =false;
  // ignore: missing_return
  Future<bool> _onBackPressed()  {
    return new Future(() => false);
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) =>  setpref());
  }
  setpref() async {
    prefs = await SharedPreferences.getInstance();
    if(prefs!=null)
    {
      name= prefs!.getString("createdSchool");
      setState(() {

      });
    }

  }
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    setpref();
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child:Stack(
                        children: [
                          Scratcher(
                            brushSize: 30,
                            threshold: 50,
                            color: HexColor(AppColors.appColorBlueGrey),
                            onChange: (value) {
                              setState(() {
                                isScrached=true;
                              });
                            },
                            onThreshold: () => print("Threshold reached, you won!"),
                            child: Container(
                              height: 300,
                              child:  Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(AppLocalizations.of(context)!.translate('you_won'), style: styleElements.headline5ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack85),fontWeight: FontWeight.bold),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text( type=="cash"?"₹"+  value!: value!+" coins", style: styleElements.headline5ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack85),fontWeight: FontWeight.bold),),
                                    ),


                                  ],
                                ),
                              ),
                              color: HexColor(AppColors.appColorWhite),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top:150),
                              child: Visibility(
                                visible: !isScrached,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 64,
                                        width: 64,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: AssetImage('assets/appimages/giftbox.png'),
                                            )
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(AppLocalizations.of(context)!.translate('scratch_here'), style: styleElements.subtitle1ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorWhite),fontWeight: FontWeight.bold),),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12, top: 30),
                      child: Text(
                        AppLocalizations.of(context)!.translate(fromPage=='buddy'?"thank_you_approving":"thank_you"),
                        style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )),
                Visibility(
                  visible:name!=null&& name!.isNotEmpty,
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          name??""   ,
                          style: styleElements.subtitle2ThemeScalable(context),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),

                Visibility(
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20,left: 16,right: 16),
                        child: Text(
                          AppLocalizations.of(context)!.translate(fromPage=='buddy'?"approve_message":"register_message"),
                          style: styleElements.subtitle1ThemeScalable(context),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),



                Container(
                  margin: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 20),
                  child: SizedBox(
                      width: double.infinity,
                      child: appProgressButton(
                        key: progressButtonKey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: HexColor(AppColors.appMainColor))),
                        onPressed: () {
                          update();

                        },
                        color: HexColor(AppColors.appMainColor),
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate("proceed"),
                          style: styleElements.subtitle2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),),
                      )),
                )
              ],
            ),
          )),
    );
  }
  void update() async {
    progressButtonKey.currentState!.show();
    final body = jsonEncode(
        {"all_persons_id":personId,
          "scratch_card_distribution_detail_id":scratchCardId}
    );
    Calls().call(body, context, Config.CARD_SCRATCHED).then((value) async {
      if (value != null) {

        var data = ScratchCardResult.fromJson(value);
        if(data!=null && data.statusCode==Strings.success_code) {
          if(fromPage!=null && fromPage=='buddy'){
            progressButtonKey.currentState!.hide();
            Navigator.pop(context);
            callBack!();
            // _getData();
          }else if (fromPage!=null && fromPage=='earn'){
            progressButtonKey.currentState!.hide();
            Navigator.pop(context);
            callBack!();
          } else if (fromPage!=null && fromPage=='post'){
            progressButtonKey.currentState!.hide();
            Navigator.pop(context);
            callBack!();
          }else {
            progressButtonKey.currentState!.hide();
            prefs!.setString("create_entity", "created");
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>
                      WelComeScreen(
                          isInstituteSelectedAlready:true

                      ),),
                    (Route<dynamic> route) => false);
          }
        }
        else{
          if(fromPage!=null && fromPage=='buddy'){
            progressButtonKey.currentState!.hide();
            Navigator.pop(context);
            callBack!();
            // _getData();
          }else if (fromPage!=null && fromPage=='earn'){
            progressButtonKey.currentState!.hide();
            Navigator.pop(context);
            callBack!();
          } else if (fromPage!=null && fromPage=='post'){
            progressButtonKey.currentState!.hide();
            Navigator.pop(context);
            callBack!();
          }else {
            progressButtonKey.currentState!.hide();
            prefs!.setString("create_entity", "created");
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>
                      WelComeScreen(
                          isInstituteSelectedAlready:true

                      ),),
                    (Route<dynamic> route) => false);
          }
        }
      }
    }).catchError((onError) async {
      progressButtonKey.currentState!.hide();
    });

  }
  _ScratchCardDialogue(this.personId, this.scratchCardId,this.value,this.type,{this.fromPage,this.callBack});

}
