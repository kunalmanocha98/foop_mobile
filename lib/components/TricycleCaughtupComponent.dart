import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TricycleCaughtUpComponent extends StatefulWidget{
  String title, actionTitle;
  final Function onClick;
  TricycleCaughtUpComponent({this.onClick,this.title,this.actionTitle});

  @override
  TricycleCaughtUpComponentState createState() => TricycleCaughtUpComponentState(onClick: onClick,title: title,actionTitle: actionTitle);
}
class TricycleCaughtUpComponentState extends State<TricycleCaughtUpComponent>{
  Function onClick;
  TextStyleElements styleElements;
  String title, actionTitle;
  TricycleCaughtUpComponentState({this.onClick,this.title,this.actionTitle});

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return TricycleCard(
        child: Column(
          children: [
            Icon(Icons.check_circle_rounded,size: 96,color: HexColor(AppColors.appMainColor),),
            Text(title??='You are done with new messages',style: styleElements.subtitle1ThemeScalable(context),),
            TricycleTextButton(onPressed: onClick,
                child: Text(actionTitle??='view older messages',style: styleElements.captionThemeScalable(context),
                ),
              shape: RoundedRectangleBorder(),
            )
          ],
        )

    );
  }

}