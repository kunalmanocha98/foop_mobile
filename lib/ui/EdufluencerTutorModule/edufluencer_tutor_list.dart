import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/Edufluencer_Tutor_modles/status.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/EdufluencerTutorModule/become_edufluencer_tutor_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all_edufluencer_tutor_list.dart';
import 'edufluencer_tutor_studentlist.dart';

class EdufluencerTutorList extends StatefulWidget {
  final edufluencer_type type;
  EdufluencerTutorList({this.type});
  @override
  _EdufluencerTutorList createState() => _EdufluencerTutorList();
}

class _EdufluencerTutorList extends State<EdufluencerTutorList>
    with SingleTickerProviderStateMixin {
  List<CustomTabMaker> list = [];
  int currentPosition = 0;
  TabController _tabController;
  TextStyleElements styleElements;
  SharedPreferences prefs = locator<SharedPreferences>();
  BuildContext sctx;
  EdufluencerStatus status;
  bool isLoading = true;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchStatus());
  }

  fetchStatus() async{
    var body = jsonEncode({
      "edufluencer_type": widget.type.type
    });

    Calls().call(body, context, Config.EDUFLUENCER_TUTOR_STATUS).then((value){
      var res = EdufluencerStatusResponse.fromJson(value);
      if(res.statusCode == Strings.success_code){
        status = res.rows;
        isLoading = false;
        loadPages();
      }else{
        status =EdufluencerStatus(
          myEdufluencerTutorCount: 0,
          myStudentCount: 0,
          isEdufluencer: false
        );
        isLoading = false;
        loadPages();
      }

    });
  }

  onPositionChange() {
    if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
        currentPosition = _tabController.index;
      });
    }
  }

  loadPages() async {
    list.add(CustomTabMaker(
        statelessWidget: AllEdufluencerAndTutors(type: widget.type,listType: 'all',isEdufluencer: status.isEdufluencer,),
        tabName: AppLocalizations.of(context).translate('all')));

    if(status.myEdufluencerTutorCount>0 && widget.type == edufluencer_type.E) {
      list.add(CustomTabMaker(
          statelessWidget: AllEdufluencerAndTutors(type: widget.type,listType: 'my',isEdufluencer: status.isEdufluencer),
          tabName: AppLocalizations.of(context).translate('my_edufluencer')));
    }
    if(status.myEdufluencerTutorCount>0 && widget.type == edufluencer_type.T) {
      list.add(CustomTabMaker(
          statelessWidget: AllEdufluencerAndTutors(type: widget.type, listType: 'my',isEdufluencer: status.isEdufluencer),
          tabName: AppLocalizations.of(context).translate('my_tutors')));
    }

    if(status.isEdufluencer && status.myStudentCount>0){
      list.add(CustomTabMaker(
          statelessWidget: EdufluencerTutorStudents(type: widget.type, listType: 'my',),
          tabName: AppLocalizations.of(context).translate('my_students')));
    }
    setState(() {
      _tabController = TabController(vsync: this, length: list.length);
      _tabController.addListener(onPositionChange);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TricycleAppBar().getCustomAppBar(context,
          appBarTitle: AppLocalizations.of(context).translate(widget.type == edufluencer_type.E ?'edufluencer':"tutor"),
          onBackButtonPress: () {
            Navigator.pop(context);
          }),
      body: isLoading?
          Container(
            child: Center(
              child: CustomPaginator(context).loadingWidgetMaker(),
            ),
          )
      :SafeArea(
        child: Builder(
          builder: (BuildContext context) {
            this.sctx = context;
            return DefaultTabController(
              length: list.length,
              child: CustomTabView(
                marginTop: const EdgeInsets.all(16.0),
                currentPosition: currentPosition,
                itemCount: list != null && list.isNotEmpty ? list.length : 0,
                tabBuilder: (context, index) => TricycleTabButton(
                  onPressed: () {
                    setState(() {
                      currentPosition = index;
                    });
                  },
                  tabName: list[index].tabName,
                  isActive: index == currentPosition,
                ),
                pageBuilder: (context, index) =>
                    Center(child: list[index].statelessWidget),
                onPositionChange: (index) {
                  setState(() {
                    currentPosition = index;
                  });
                },
                onScroll: (position) => print('$position'),
              ),
            );
          },
        ),
      ),
    );
  }


}
