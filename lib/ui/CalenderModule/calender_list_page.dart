import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/enums/calender_type_code.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/BottomSheets/create_new_event_sheet.dart';
import 'package:oho_works_app/ui/CalenderModule/calender_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/Transitions/transitions.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'calender_view_page.dart';
import 'create_event_page.dart';

class CalenderPage extends StatefulWidget{
  @override
  CalenderPageState createState() => CalenderPageState();
}
class CalenderPageState extends State<CalenderPage> with SingleTickerProviderStateMixin{
  List<CustomTabMaker> list = [];
  int _currentPosition = 0;
  late TabController _tabController;
  TextStyleElements? styleElements;
  SharedPreferences? prefs;
  DateTime selectedDate = DateTime.now();
  BuildContext? sctx;
  GlobalKey<CalenderListPageState> _allCalenderListKey = GlobalKey();
  GlobalKey<CalenderListPageState> _myCalenderListKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadPages());
  }

  void loadPages() async {
    prefs ??= await SharedPreferences.getInstance();
    list.add(CustomTabMaker(
      tabName: AppLocalizations.of(context)!.translate('all'),
      statelessWidget: CalenderListPage(key: _allCalenderListKey,date: selectedDate,type:"all")
    ));
    list.add(CustomTabMaker(
        tabName: AppLocalizations.of(context)!.translate('my_calender'),
        statelessWidget: CalenderListPage(key: _myCalenderListKey,date: selectedDate,type:"my")
    ));
    setState(() {
      _tabController = TabController(vsync: this, length: list.length);
      _tabController.addListener(onPositionChange);
    });
  }

  onPositionChange() {
    if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
        _currentPosition = _tabController.index;
      });
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      builder: (context) {
        return CreateNewEventBottomSheet(onClickCallback:onBottomSheetCallBack,);
        // return BottomSheetContent();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(child: Scaffold(
      appBar: appAppBar().getCustomAppBar(context,
        appBarTitle: AppLocalizations.of(context)!.translate('calender'),
        onBackButtonPress: (){Navigator.pop(context);},
        actions: [
          IconButton(icon: Icon(Icons.calendar_today_rounded,color: HexColor(AppColors.appColorBlack65),), onPressed: (){
            Navigator.push(context, appRouteSlideRight(page: CalenderViewPage(selectedDate: selectedDate,))).then((value){
              if(value!=null){
                    setState(() {
                      selectedDate =value;
                      updateList();
                    });
                  }
            });

          }),
          IconButton(icon: Icon(Icons.add),color: HexColor(AppColors.appColorBlack65), onPressed: (){

            Navigator.push(
                context, MaterialPageRoute(builder: (BuildContext context) {
              return CreateEventPage(type: "talk",standardEventId: 5,refreshCallBack:(){

                updateList();
              });
            }));
          }),
        ],

      ),
      body: Builder(
        builder: (BuildContext context) {
        this.sctx = context;
        return DefaultTabController(
            length: list.length,
            child:  CustomTabView(
              marginTop:const EdgeInsets.all(16.0 ),
              currentPosition: _currentPosition,
              itemCount: list!=null && list.isNotEmpty?list.length:0,
              tabBuilder: (context, index) => appTabButton(
                onPressed: () {
                  setState(() {
                    _currentPosition = index;
                  });
                },
                tabName: list[index].tabName,
                isActive: index == _currentPosition,
              ),
              pageBuilder: (context, index) =>
                  Center(child: list[index].statelessWidget),
              onPositionChange: (index) {
                setState(() {
                  _currentPosition = index!;
                });
              },
              onScroll: (position) => print('$position'),
            )
        );
      },
      ),
    ));
  }

  void updateList() {
    if(_currentPosition==0){
      _allCalenderListKey.currentState!.update(date: selectedDate,searchVal: "");
    }else{
      _myCalenderListKey.currentState!.update(date: selectedDate,searchVal: "");
    }
  }


  onBottomSheetCallBack(String? value,int ?stamdardEventId) {
    Navigator.pop(context);
    if(value == CALENDERTYPECODE.EVENT.type) {
      Navigator.push(
          context, MaterialPageRoute(builder: (BuildContext context) {
        return CreateEventPage(type: "talk",standardEventId: 5,refreshCallBack:(){

          updateList();
        });
      }));
    }
  }
}