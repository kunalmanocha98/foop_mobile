import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class TricycleEmptyWidget extends StatelessWidget{
  final String message;
  final String assetImage;
  TricycleEmptyWidget({this.message,this.assetImage});
  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage(assetImage!=null?assetImage:'assets/appimages/empty.png'),
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24,left: 24,right: 24),
              child: Text(message.isEmpty?AppLocalizations.of(context).translate('no_data'):message,

                textAlign: TextAlign.center,
              style: styleElements.subtitle1ThemeScalable(context).copyWith(
                color: HexColor(AppColors.appColorBlack35)
              ),),
            )
          ],
        ),
      ),
    );
  }

}


class TricycleEmptyWidgetForAudio extends StatelessWidget{
  final String message;
  final String assetImage;
  TricycleEmptyWidgetForAudio({this.message,this.assetImage});
  @override
  Widget build(BuildContext context) {

    TextStyleElements styleElements = TextStyleElements(context);
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(assetImage!=null?assetImage:'assets/appimages/avatar-default.png'),
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24,left: 24,right: 24),
              child:
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                        style: styleElements.subtitle1ThemeScalable(context).copyWith(
                            color: HexColor(AppColors.appColorBlack35)
                        ),
                    children: [
                      TextSpan(
                        text: 'No audience yet. please invite '
                      ),
                      WidgetSpan(
                      child: Icon(Icons.group_add_outlined,
                      color: HexColor(AppColors.appColorBlack35),)
                      ),
                      TextSpan(
                          text: ' your followers or share '
                      ),
                      WidgetSpan(
                          child: Icon(Icons.share_outlined,
                            color: HexColor(AppColors.appColorBlack35),)
                      ),
                      TextSpan(
                          text: ' this campus talk with your circle to have more audience.'
                      )
                    ]
                  ),
                )
              // Text(message.isEmpty?AppLocalizations.of(context).translate('no_data'):message,
              //
              //   textAlign: TextAlign.center,
              //   style: styleElements.subtitle1ThemeScalable(context).copyWith(
              //       color: HexColor(AppColors.appColorBlack35)
              //   ),),
            )
          ],
        ),
      ),
    );
  }

}



class TricycleEmptyWidgetForAudioList extends StatelessWidget{
  final String message;
  final String assetImage;
  TricycleEmptyWidgetForAudioList({this.message,this.assetImage});
  @override
  Widget build(BuildContext context) {

    TextStyleElements styleElements = TextStyleElements(context);
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(assetImage!=null?assetImage:'assets/appimages/avatar-default.png'),
                  )
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 24,left: 24,right: 24),
                child:
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: styleElements.subtitle1ThemeScalable(context).copyWith(
                          color: HexColor(AppColors.appColorBlack35)
                      ),
                      children: [
                        TextSpan(
                            text:AppLocalizations.of(context).translate('no_audio_events1')
                        ),
                        WidgetSpan(
                            child: Icon(Icons.add,
                              color: HexColor(AppColors.appColorBlack35),)
                        ),
                        TextSpan(
                            text:AppLocalizations.of(context).translate('no_audio_events2')
                        ),
                      ]
                  ),
                )
              // Text(message.isEmpty?AppLocalizations.of(context).translate('no_data'):message,
              //
              //   textAlign: TextAlign.center,
              //   style: styleElements.subtitle1ThemeScalable(context).copyWith(
              //       color: HexColor(AppColors.appColorBlack35)
              //   ),),
            )
          ],
        ),
      ),
    );
  }

}