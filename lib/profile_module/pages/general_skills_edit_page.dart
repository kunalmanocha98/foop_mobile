import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/profile_module/pages/skills_list_widget.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralSkillsEditPage extends StatefulWidget {
  _GeneralSkillsEditPage createState() => _GeneralSkillsEditPage();
}

class _GeneralSkillsEditPage extends State<GeneralSkillsEditPage> {

  SharedPreferences? prefs;
  late TextStyleElements styleElements;
  Widget build(BuildContext context) {

    ScreenUtil.init;
    styleElements=TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor(AppColors.appColorBackground),
        appBar: TricycleAppBar().getCustomAppBar(context,
            appBarTitle:  'General Skills',
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0, top: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(AppLocalizations.of(context)!.translate('see_all'),
                      style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),
                    ),
                  )),
            ],
            onBackButtonPress: null),
        body: SkillsListWidget(),
      ),
    );
  }
}
