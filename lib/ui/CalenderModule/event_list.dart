import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/enums/calender_type_code.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/BottomSheets/create_new_event_sheet.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_event_page.dart';
import 'event_list_page.dart';


class EventList extends StatefulWidget{
@override
_EventList createState() => _EventList();
}
class _EventList extends State<EventList> with SingleTickerProviderStateMixin{
  List<CustomTabMaker> list = [];
  int _currentPosition = 0;
  late TabController _tabController;
  TextStyleElements? styleElements;
  SharedPreferences? prefs;
  DateTime selectedDate = DateTime.now();
  BuildContext? sctx;
  GlobalKey<EventListState> _allCalenderListKey = GlobalKey();
  GlobalKey<EventListState> _myCalenderListKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadPages());
  }

  void loadPages() async {
    prefs ??= await SharedPreferences.getInstance();
    list.add(CustomTabMaker(
        tabName: AppLocalizations.of(context)!.translate('all'),
        statelessWidget: EventListPage(key: _allCalenderListKey,date: selectedDate,)
    ));
    list.add(CustomTabMaker(
        tabName: AppLocalizations.of(context)!.translate('my_events'),
        statelessWidget: EventListPage(key: _myCalenderListKey,date: selectedDate)
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
      appBar: TricycleAppBar().getCustomAppBar(context,
        appBarTitle: AppLocalizations.of(context)!.translate('events'),
        onBackButtonPress: (){Navigator.pop(context);},
        actions: [
          IconButton(icon: Icon(Icons.add),color: HexColor(AppColors.appColorBlack65), onPressed: (){
            _showModalBottomSheet(context);
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
                tabBuilder: (context, index) => TricycleTabButton(
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
    if(_tabController.index==0){
      _allCalenderListKey.currentState!.update(date: selectedDate);
    }else{
      _myCalenderListKey.currentState!.update(date: selectedDate);
    }
  }


  onBottomSheetCallBack(String? value,int? stamdardEventId) {
    Navigator.pop(context);
    if(value == CALENDERTYPECODE.EVENT.type) {
      Navigator.push(
          context, MaterialPageRoute(builder: (BuildContext context) {
        return CreateEventPage(type: value!,standardEventId: stamdardEventId!);
      }));
    }
  }
}