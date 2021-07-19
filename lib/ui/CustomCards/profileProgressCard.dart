
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/menu/profile_models.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/profile_module/pages/basic_profile.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProgressCard extends StatefulWidget {
  final int ownerId;
  final String ownerType;
  final Persondata persondata;
  final Function callback;
  ProfileProgressCard({this.ownerId,this.ownerType,this.persondata,this.callback});

  @override
  ProfileProgressCardState createState()=> ProfileProgressCardState();

}
class ProfileProgressCardState extends State<ProfileProgressCard>{
  int progress =0;
  TextStyleElements styleElements;
  SharedPreferences prefs = locator<SharedPreferences>();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {fetchDetails();});
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (widget.persondata != null) {
          var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => BasicInfo(widget.persondata,  widget.callback)));
          if (result != null && result['result'] == "success") {
            print("success------------------------------------------");
            fetchDetails();
          }
        }
      },
      child: (progress!=null && progress==100)?Container():TricycleListCard(
        padding: EdgeInsets.all(0),
          color: HexColor(AppColors.appColorRed50),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical:8.h,horizontal: 16),
                child: Container(
                    child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        child: CircularPercentIndicator(
                          lineWidth: 12,
                          radius: 72,
                          progressColor: HexColor(AppColors.appMainColor),
                          percent:double.parse("0."+progress.toString()),
                          center: Text(
                            progress.toString()+"%",
                            style: styleElements.headline6ThemeScalable(context).copyWith(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      flex: 1,
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(16.h),
                        child: Center(
                          child: Text(AppLocalizations.of(context).translate('complete_your_profile'),
                            style: styleElements.subtitle1ThemeScalable(context),
                          ),
                        ),
                      ),
                      flex: 3,
                    )
                  ],
                )),
              ),
            ],
          )),
    );
  }

  void fetchDetails() async{
    var data = jsonEncode({
      "owner_id": widget.ownerId,
      "owner_type": widget.ownerType
    });
    Calls().call(data, context, Config.GET_PROFILE_PROGRESS).then((value) {
      var response  = ProfileCardResponse.fromJson(value);
      if(response.statusCode == Strings.success_code){
        setState(() {
          progress = response.total;
        });
      }
    });
  }
}
