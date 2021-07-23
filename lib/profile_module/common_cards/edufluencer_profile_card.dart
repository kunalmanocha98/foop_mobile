import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class EdufluemcerProfileCard extends StatefulWidget {
  @override
  EdufluemcerProfileCardState createState() => EdufluemcerProfileCardState();
}

class EdufluemcerProfileCardState extends State<EdufluemcerProfileCard> {
  late TextStyleElements styleElements;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return TricycleListCard(
      padding: EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16,left: 24,right: 24,bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "I'm an edufluencer(mentor)",
                        style: styleElements.subtitle1ThemeScalable(context).copyWith(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    TricycleTextButton(
                      onPressed: () {},
                      child: Text(
                        AppLocalizations.of(context)!.translate('message'),
                        style: styleElements
                            .captionThemeScalable(context)
                            .copyWith(color: HexColor(AppColors.appMainColor)),
                      ),
                    )
                  ],
                ),
                Text(
                  "Ex-Deputy chairman Planning commission of India, GOI, India",
                  style: styleElements.bodyText2ThemeScalable(context),
                ),
                Padding(
                  padding: EdgeInsets.only(top:8.0,bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Years of experience',style: styleElements.bodyText2ThemeScalable(context),),
                            Text('5+',style: styleElements.subtitle1ThemeScalable(context),)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Work days',style: styleElements.bodyText2ThemeScalable(context),),
                            Text('M-T-W-T-F-S-S',style: styleElements.subtitle1ThemeScalable(context),)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: HexColor(AppColors.appColorBackground),
                ),
                Padding(
                  padding: EdgeInsets.only(top:8.0,bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Trail hours',style: styleElements.bodyText2ThemeScalable(context),),
                            Text('2+',style: styleElements.subtitle1ThemeScalable(context),)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fee/ hour',style: styleElements.bodyText2ThemeScalable(context),),
                            Text('500',style: styleElements.subtitle1ThemeScalable(context),)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(top:8.0),
                    child: Text("My objectives are This is about me, I’m the best candidate of the Asdasd asdasasdasd asdas. Asdas. Asdas asd Asdasda asdas Asda aasde. Aard"+
                        "My objectives are This is about me, I’m the best candidate of the Asdasd asdasasdasd asdas. Asdas. Asdas asd Asdasda asdas Asda aasde. Aard"+
                      "My objectives are This is about me, I’m the best candidate of the Asdasd asdasasdasd asdas. Asdas. Asdas asd Asdasda asdas Asda aasde. Aard",
                      maxLines: isExpanded?null:3, 
                      overflow: isExpanded?null:TextOverflow.ellipsis,
                      style: styleElements.subtitle2ThemeScalable(context),),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: !isExpanded,
            child: Container(
              width: double.infinity,
              height: 1,
              color: HexColor(AppColors.appColorBackground),
            ),
          ),
          Visibility(
            visible: !isExpanded,
            child: GestureDetector(
              onTap: (){
                setState(() {
                  isExpanded = true;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(top: 8,bottom: 8,left: 16,right: 16),
                child: Text('Expand',style: styleElements.subtitle1ThemeScalable(context),),
              ),
            ),
          )
        ],
      ),
    );
  }
}
