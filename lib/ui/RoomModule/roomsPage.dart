import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/RoomModule/rooms_listing.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'createRoomPage.dart';

class RoomsPage extends StatefulWidget {
  final int currentPosition;
  final bool hideAppBar;
  final bool hideTabs;
  final bool isSwipeDisabled;
  RoomsPage({
    Key key,
    this.currentPosition=0,this.hideAppBar=false,this.hideTabs=false,this.isSwipeDisabled=false})    : super(key: key);
  @override
  RoomsPageState createState() => RoomsPageState(currentPosition: currentPosition);
}

class RoomsPageState extends State<RoomsPage> with SingleTickerProviderStateMixin {
  List<CustomTabMaker> list = [];
  int currentPosition = 0;
  TabController _tabController;
  TextStyleElements styleElements;
  GlobalKey<AllRoomsListingState> allroomsKey = GlobalKey();
  GlobalKey<PublicRoomsListingState> publicroomsKey = GlobalKey();
  GlobalKey<PrivateRoomsListingState> privateroomsKey = GlobalKey();
  GlobalKey<SocialRoomsListingState> socialroomsKey = GlobalKey();
  GlobalKey<CampusRoomsListingState> campusroomsKey = GlobalKey();
  SharedPreferences prefs;
  BuildContext sctx;

  RoomsPageState({this.currentPosition});
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => loadPages());
  }
  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

  }
  onPositionChange() {
    if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
        currentPosition = _tabController.index;
      });
    }
  }

  loadPages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setSharedPreferences();
    list.add(CustomTabMaker(
        statelessWidget: AllRoomsListing(
            allroomsKey,
            prefs.getInt("userId"),
            prefs.getInt("instituteId"),
            prefs.getInt("userId"),
            prefs.getString("ownerType"),
            prefs.getString("ownerType"),
            null),
        tabName: AppLocalizations.of(context).translate('all')));
    list.add(CustomTabMaker(
        statelessWidget: PrivateRoomsListing(
            privateroomsKey,
            prefs.getInt("userId"),
            prefs.getInt("instituteId"),
            prefs.getInt("userId"),
            prefs.getString("ownerType"),
            prefs.getString("ownerType")),
        tabName: AppLocalizations.of(context).translate('private')));
    list.add(CustomTabMaker(
        statelessWidget: PublicRoomsListing(
            publicroomsKey,
            prefs.getInt("userId"),
            prefs.getInt("instituteId"),
            prefs.getInt("userId"),
            prefs.getString("ownerType"),
            prefs.getString("ownerType")),
        tabName: AppLocalizations.of(context).translate('public')));

    list.add(CustomTabMaker(
      statelessWidget: SocialRoomsListing(
          socialroomsKey,
          prefs.getInt("userId"),
          prefs.getInt("instituteId"),
          prefs.getInt("userId"),
          prefs.getString("ownerType"),
          prefs.getString("ownerType"),null),
        tabName: AppLocalizations.of(context).translate('social')));

    list.add(CustomTabMaker(
        statelessWidget: CampusRoomsListing(
            campusroomsKey,
            prefs.getInt("userId"),
            prefs.getInt("instituteId"),
            prefs.getInt("userId"),
            prefs.getString("ownerType"),
            prefs.getString("ownerType"),null),
        tabName: AppLocalizations.of(context).translate('campus')));

    setState(() {
      _tabController = TabController(vsync: this, length: list.length);
      _tabController.addListener(onPositionChange);
    });
  }

 void  setCurrentPage(int page)
  {
    setState(() {
      currentPosition=page;
    });

  }


  void refresh()
  {
    if (_tabController.index == 0) {
      allroomsKey.currentState.refresh();
    } else if (_tabController.index == 1) {
      publicroomsKey.currentState.refresh();
    } else if (_tabController.index ==2){
      privateroomsKey.currentState.refresh();
    }else if (_tabController.index ==3){
      socialroomsKey.currentState.refresh();
    }else{
      campusroomsKey.currentState.refresh();
    }
  }
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return widget.hideAppBar?
     SafeArea(
      child: new   Scaffold(
        resizeToAvoidBottomInset: false,

        body:
        new Builder(builder: (BuildContext context) {
          this.sctx = context;
          return new  DefaultTabController(
            length: list.length,
            child: CustomTabView(
              isTabVisible:!widget.hideTabs,
              isSwipeDisabled: widget.isSwipeDisabled,
              marginTop:const EdgeInsets.all(16.0 ),
              currentPosition: currentPosition,
              itemCount: list!=null && list.isNotEmpty?list.length:0,
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
        }
        )


      ),
    ):   SafeArea(
      child: new   Scaffold(
          resizeToAvoidBottomInset: false,
          appBar:
          TricycleAppBar().getCustomAppBar(context,
              appBarTitle: AppLocalizations.of(context).translate("rooms"),
              onBackButtonPress: () {
                Navigator.pop(context);
              }, actions: [
                GestureDetector(
                  onTap: () {

                    if(prefs.getBool(Strings.isVerified)!=null&&prefs.getBool(Strings.isVerified))
                    {  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateRoomPage(value: null,isEdit: false,callback:(){})))
                        .then((value) {
                      if (_tabController.index == 0) {
                        allroomsKey.currentState.refresh();
                      } else if (_tabController.index == 1) {
                        publicroomsKey.currentState.refresh();
                      } else if (_tabController.index ==2){
                        privateroomsKey.currentState.refresh();
                      }else if (_tabController.index ==3){
                        socialroomsKey.currentState.refresh();
                      }else{
                        campusroomsKey.currentState.refresh();
                      }
                    });}
                    else
                    {
                      ToastBuilder().showSnackBar(
                          AppLocalizations.of(context).translate("only_verirfied"), sctx, HexColor(AppColors.information));
                    }


                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.add, color: HexColor(AppColors.appColorBlack85)),
                  ),
                )
              ]),
          body:
          new Builder(builder: (BuildContext context) {
            this.sctx = context;
            return new  DefaultTabController(
              length: list.length,
              child: CustomTabView(
                marginTop:const EdgeInsets.all(16.0 ),
                currentPosition: currentPosition,
                itemCount: list!=null && list.isNotEmpty?list.length:0,
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
          }
          )


      ),
    );



  }
}
