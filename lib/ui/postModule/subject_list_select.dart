import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubjectTopicSelect extends StatefulWidget{
  final List<SubRow>? selectedList;
  SubjectTopicSelect({this.selectedList});
  @override
  SubjectTopicSelectState createState() => SubjectTopicSelectState(selectedList: selectedList);
}

class SubjectTopicSelectState extends State<SubjectTopicSelect>{
  late TextStyleElements styleElements;
  List<SubRow>? selectedList;
  List<SubRow> subjectList = [];
  SharedPreferences? prefs = locator<SharedPreferences>();
  SubjectTopicSelectState({
    this.selectedList
});

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
        child: Scaffold(
          appBar: TricycleAppBar().getCustomAppBar(
              context,
              appBarTitle: getAppBarTitle(),
              actions:[
                TricycleTextButton(
                  onPressed:() {
                    if(selectedList!=null && selectedList!.length>0){
                      Navigator.pop(context,selectedList);
                    }else{
                      ToastBuilder().showToast(AppLocalizations.of(context)!.translate('please_select_atleast'),
                          context,
                          HexColor(AppColors.information));
                    }
                  },
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children:[
                      Text( AppLocalizations.of(context)!.translate('next'),
                        style: styleElements
                            .subtitle2ThemeScalable(context)
                            .copyWith(color: HexColor(AppColors.appMainColor)),
                      ),
                      Icon(Icons.keyboard_arrow_right,
                          color: HexColor(AppColors.appMainColor))
                    ],
                  ),
                  shape: CircleBorder(),
                ),],
              onBackButtonPress: () {
                Navigator.pop(context);
              }),
          body: getBody(),
        )
    );
  }

  String getAppBarTitle() {
    return AppLocalizations.of(context)!.translate('select_topics');
  }

  Widget getBody() {
    return getTopicsList();
  }
  Widget getTopicsList() {
    return Paginator<BaseResponses>.listView(
        pageLoadFuture: fetchData,
        pageItemsGetter: listItemsGetter,
        listItemBuilder: listItemBuilder,
        loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
        errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
        emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
        totalItemsGetter: CustomPaginator(context).totalPagesGetter,
        pageErrorChecker: CustomPaginator(context).pageErrorChecker);
  }

  Future<BaseResponses> fetchData(int page) async{
    final body = jsonEncode({
      "person_id": prefs!.getInt(Strings.userId),
      "type":  "person",
      "all_institutions_id": prefs!.getInt(Strings.userId).toString(),
      "page_number": 1,
      "given_by_id": prefs!.getInt(Strings.userId),
      "page_size": 100
    });
    var value  = await Calls().call(body, context, Config.DETAILS_SUBJECTS);
    return BaseResponses.fromJson(value);
  }


  List<SubRow>? listItemsGetter(BaseResponses? pageData) {
    var itr = pageData!.rows![0].subRow!.where((element){
      return selectedList!.any((element1){
        return element1.textOne == element.textOne;
      });
    });
    itr.forEach((element) {
      element.isSelected = true;
    });
    subjectList.addAll(pageData.rows![0].subRow!);
    return pageData.rows![0].subRow;
  }

  Widget listItemBuilder(itemData, int index) {
    SubRow  item = itemData;
    return  ListTile(
      trailing: Checkbox(
        onChanged: (bool? value) {
          changeSelection(value!,item,index);
        },
        value: item.isSelected??=false,
      ),
      title: Text(item.textOne!,style: styleElements.subtitle1ThemeScalable(context),),
    );
  }


  void changeSelection(bool value,SubRow item,int index) {
    if(value){
      setState(() {
        selectedList!.add(item);
        subjectList[index].isSelected = value;
      });
    }else{
      setState(() {
        selectedList!.removeWhere((element){
          return element.textOne==item.textOne;
        });
        subjectList[index].isSelected = value;
      });
    }
  }

}