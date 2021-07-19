import 'package:oho_works_app/models/deeplinking_payload.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/button_filled.dart';
import '../components/button_outline.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  Home({Key key, this.title,this.deepLinkingPayload}) : super(key: key);
  final String title;
  final DeepLinkingPayload deepLinkingPayload;
  MyHomePage createState() => MyHomePage(title);
}

// ignore: must_be_immutable
class MyHomePage extends State<Home> {
  TextStyleElements styleElements;
  MyHomePage(this.title);

  final String title;
  SharedPreferences prefs;
  BuildContext context;

  @override
  void initState() {
    // ignore: invalid_use_of_visible_for_testing_member
    super.initState();
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    print(prefs.getString("token").toString() +
        "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    this.context = context;
    setSharedPreferences();
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomInset: false,

      //  appBar: AppBar(title: Text("Product Listing")),
      body: Stack(children: <Widget>[
        Container(
            alignment: Alignment(0, -0.6),
            child: Image.asset("assets/appimages/logo.png",
                height: 128.w, width: 128.w)),
        Container(
            alignment: Alignment(0, -0.2),
            child: Text(
              AppLocalizations.of(context).translate("logo_main"),
              style: styleElements.headline5ThemeScalable(context),
            )),
        Container(
            alignment: Alignment(0, -0.1),
            child: Text(
              AppLocalizations.of(context).translate("logo_slogan"),
              style: styleElements.subtitle1ThemeScalable(context),
            )),
        Container(
          alignment: Alignment(0, 0.5),
          child: LargeButton(
              name: AppLocalizations.of(context).translate("get_onboard"),
              offsetX: 95.0,
              offsetY: 14.33,
          callback: (){
            Navigator.pushNamed(context, '/signup');
          },),
        ),
        Container(
          alignment: Alignment(0, 0.75),
          child: Component51(
            name: AppLocalizations.of(context).translate("sign_in"),
            callback: (){
              print("Tapped Sign In");
              Navigator.pushNamed(context, '/login');
            },
          ),
        )
      ]),
    ));
  }
}
