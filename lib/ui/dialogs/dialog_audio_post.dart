import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class AudioPostDialog extends StatelessWidget{
  final String title;
  final Function okCallback;
  final Function cancelCallback;
  AudioPostDialog({this.title,this.okCallback,this.cancelCallback});
  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
       child: Padding(
         padding: const EdgeInsets.only(top:16.0,left: 24,right: 24,bottom: 8),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Text('Create talkshow',style: styleElements.headline6ThemeScalable(context).copyWith(
               fontWeight: FontWeight.bold
             ),),
             Padding(
               padding:  EdgeInsets.only(top:12.0,bottom: 24),
               child: Image.asset('assets/appimages/audio-icon.png',width:72 ,height: 72,fit: BoxFit.contain,),
             ),
             Text('Do you want to create a talkshow on',
               style: styleElements.subtitle1ThemeScalable(context).copyWith(),
               textAlign: TextAlign.center,
             ),
             Text("\"$title\"",
               style: styleElements.headline6ThemeScalable(context).copyWith(
                 fontWeight: FontWeight.bold
               ),
               textAlign: TextAlign.center,
             ),
             SizedBox(height: 12,),
             Row(
               children: [
                 Spacer(),
                 TricycleTextButton(
                     onPressed: (){
                       Navigator.pop(context);
                       cancelCallback();
                       },
                     shape: StadiumBorder(),
                     child: Text(AppLocalizations.of(context).translate('cancel'),
                     style: styleElements.captionThemeScalable(context).copyWith(
                       color: HexColor(AppColors.appMainColor)
                     ),)
                 ),
                 TricycleTextButton(
                     onPressed:(){
                       Navigator.pop(context);
                       okCallback();
                     },
                     shape: StadiumBorder(),
                     child: Text(AppLocalizations.of(context).translate('ok'),
                       style: styleElements.captionThemeScalable(context).copyWith(
                           color: HexColor(AppColors.appMainColor)
                       ),)
                 )
               ],
             )
           ],
         ),
       ),
    );
  }

}