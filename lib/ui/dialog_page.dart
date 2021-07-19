import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/utils/datasave.dart';
import 'package:oho_works_app/utils/dialogue_for_successfull_addition.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class DilaogPage extends StatelessWidget {
  String title;
  String subtitle;
  SharedPreferences prefs = locator<SharedPreferences>();
  String type;
  bool isVerified;

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


  DilaogPage(
      {Key key,
        @required this.type,
        @required this.title,
        @required this.subtitle,
        @required this.isVerified})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utility().refreshList(context);
      DataSaveUtils().getUserData(context, prefs);
      Future.delayed(Duration(seconds: 3), () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => CustomDialogue(
              type: type,
              isVerified: isVerified,
              title: title,
              subtitle: subtitle,
            ));
      });
    });

    return Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
