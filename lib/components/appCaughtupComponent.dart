import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class appCaughtUpComponent extends StatefulWidget{
  String? title, actionTitle;
  final Function? onClick;
  appCaughtUpComponent({this.onClick,this.title,this.actionTitle});

  @override
  appCaughtUpComponentState createState() => appCaughtUpComponentState(onClick: onClick,title: title,actionTitle: actionTitle);
}
class appCaughtUpComponentState extends State<appCaughtUpComponent>{
  Function? onClick;
  late TextStyleElements styleElements;
  String? title, actionTitle;
  appCaughtUpComponentState({this.onClick,this.title,this.actionTitle});

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return appCard(
        child: Column(
          children: [
            Icon(Icons.check_circle_rounded,size: 96,color: HexColor(AppColors.appMainColor),),
            Text(title??='You are done with new messages',style: styleElements.subtitle1ThemeScalable(context),),
            appTextButton(onPressed: onClick,
                child: Text(actionTitle??='view older messages',style: styleElements.captionThemeScalable(context),
                ),
              shape: RoundedRectangleBorder(),
            )
          ],
        )

    );
  }

}