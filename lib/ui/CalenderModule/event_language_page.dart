import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/expertise_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class EventLanguagePage extends StatefulWidget {
   List<String>? selectedLanguages;
  EventLanguagePage({this.selectedLanguages});
  @override
  _EventLanguagePage createState() => _EventLanguagePage(selectedList: selectedLanguages);
}

class _EventLanguagePage extends State<EventLanguagePage> {
  String? searchVal;
  SharedPreferences? prefs = locator<SharedPreferences>();
  List<LanguageItem>? languageList = [];
  List<String?>? selectedList ;
  late TextStyleElements styleElements ;
  _EventLanguagePage({this.selectedList});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getList());
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        appBar: OhoAppBar().getCustomAppBarWithSearch(context,
            onSearchValueChanged: (value){
          searchVal = value;
          refresh();
            },
            actions: [
              appTextButton(
                onPressed: () {
                  if(selectedList!.length>0){
                    Navigator.pop(context,selectedList);
                  }else{
                    ToastBuilder().showToast(AppLocalizations.of(context)!.translate('please_select_language'),
                        context,
                        HexColor(AppColors.information));
                  }
                },
                child: Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.translate('next'),
                      style: styleElements
                          .subtitle2ThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appMainColor)),
                    ),
                    Icon(Icons.keyboard_arrow_right,
                        color: HexColor(AppColors.appMainColor))
                  ],
                ),
                shape: CircleBorder(),
              )
            ],
            appBarTitle: AppLocalizations.of(context)!
                .translate('select_language'), onBackButtonPress: () {
              Navigator.pop(context);
            }),
        body: appListCard(child:
        ListView.builder(
          itemCount: languageList!.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(languageList![index].expertiseTypeCode!,
              style: styleElements.subtitle1ThemeScalable(context),),
              trailing: Checkbox(
                value: languageList![index].isSelected ?? false,
                onChanged: (bool? value) {
                  if (value!) {
                    _addSelection(index);
                  } else {
                    _removeSelection(index);
                  }
                },
              ),
            );
          },
        )),
      ),
    );
  }
  void refresh() {
    languageList!.clear();
    getList();
  }

  void getList() async {
    final body = jsonEncode({
      "search_val": searchVal,
      "expertise_category_code": 'Languages',
      "page_number": 1,
      "page_size": 100,
      "person_id": null
    });
    Calls().call(body, context, Config.EXPERTISE_API).then((value) {
      var data = ExpertiseList.fromJson(value);
      if (data.statusCode == Strings.success_code) {
        selectedList ??= [];
        languageList = data.rows;
        languageList = languageList ??= [];
        setState(() {
          for (var item in selectedList!) {
            for (LanguageItem it  in languageList!){
              if(it.expertiseTypeCode == item){
                it.isSelected = true;
              }
            }
          }
        });
      }
    });
  }

  void _addSelection(int index) {
    setState(() {
      selectedList!.add(languageList![index].expertiseTypeCode);
      languageList![index].isSelected = true;
    });
  }

  void _removeSelection(int index) {
    setState(() {
      selectedList!.remove(languageList![index].expertiseTypeCode);
      languageList![index].isSelected = false;
    });
  }


}
