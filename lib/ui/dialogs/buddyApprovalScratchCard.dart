import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/widgets.dart';


class BuddyApprovalScratchCard extends StatefulWidget{
  final String? name;
  final String? value;
  final String? type;
  final Function? callback;
  BuddyApprovalScratchCard({this.name,this.value,this.type,this.callback});
  @override
  _BuddyApprovalScratchCard createState() =>_BuddyApprovalScratchCard();
}
class _BuddyApprovalScratchCard extends State<BuddyApprovalScratchCard>{

  bool isScrached = false;
  late TextStyleElements styleElements;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return WillPopScope(
      onWillPop: () async{return true;},
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
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(widget.value!, style: styleElements.headline2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack85),fontWeight: FontWeight.bold),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Text(AppLocalizations.of(context)!.translate('coins'), style: styleElements.headline4ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack65),fontWeight: FontWeight.bold),),
                                    )

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
                                        child: Image(
                                          height: 64,
                                          width: 64,
                                          fit: BoxFit.contain,
                                          image: AssetImage('assets/appimages/giftbox.png'),
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
                      child: Text(AppLocalizations.of(context)!.translate('thank_you_approving'),
                        style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )),
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Text(
                       widget.name!,
                        style: styleElements.subtitle2ThemeScalable(context),
                        textAlign: TextAlign.center,
                      ),
                    )),

                Visibility(
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.only(right: 16,bottom: 20,left:16),
                        child: Text(AppLocalizations.of(context)!.translate('approve_message'),
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
                      child: TricycleElevatedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: HexColor(AppColors.appMainColor))),
                        onPressed: (){
                          Navigator.pop(context);
                          widget.callback!();
                        },
                        color: HexColor(AppColors.appMainColor),

                        child: Text(AppLocalizations.of(context)!.translate('proceed'),
                          style: styleElements.subtitle2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),),
                      )),
                )
              ],
            ),
          )),
    );
  }

}