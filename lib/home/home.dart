import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oho_works_app/models/deeplinking_payload.dart';
import 'package:oho_works_app/profile_module/pages/directions.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/button_filled.dart';
import '../components/button_outline.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  Home({Key? key, this.title,this.deepLinkingPayload}) : super(key: key);
  final String? title;
  final DeepLinkingPayload? deepLinkingPayload;
  MyHomePage createState() => MyHomePage(title);
}

// ignore: must_be_immutable
class MyHomePage extends State<Home> {
  late TextStyleElements styleElements;
  MyHomePage(this.title);

  final String? title;
  late SharedPreferences prefs;
  late BuildContext context;

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
                height: 150.w, width: 200.w)),
        Container(
            alignment: Alignment(0, -0.4),
            child: Text(
              AppLocalizations.of(context)!.translate("logo_slogan"),
              style: styleElements.subtitle1ThemeScalable(context),
            )),
        Container(
            alignment: Alignment(0, -0.3),
            child: Text(
              AppLocalizations.of(context)!.translate("welcome_name"),
              style: styleElements.headline6ThemeScalable(context),
            )),



        Container(
          alignment: Alignment(0, 0.5),
          child: LargeButton(
              name: AppLocalizations.of(context)!.translate("get_onboard"),
              offsetX: 95.0,
              offsetY: 14.33,
          callback: (){

            Navigator.pushNamed(context, '/signup');
          },),
        ),
        Container(
          alignment: Alignment(0, 0.75),
          child: Component51(
            name: AppLocalizations.of(context)!.translate("sign_in"),
            callback: (){
              print("Tapped Sign In");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(
                        LatLng(28.7041, 77.1025),
                        28.7041,
                        77.1025),
                  ));
            //  Navigator.pushNamed(context, '/login');
            },
          ),
        )
      ]),
    ));
  }
}
