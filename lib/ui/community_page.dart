
import 'package:oho_works_app/components/appbar_with_profile%20_image.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/profile_module/pages/network_page.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RoomModule/createRoomPage.dart';
import 'RoomModule/roomsPage.dart';

// ignore: must_be_immutable
class CommunityPage extends StatefulWidget {
  _CommunityPage createState() => _CommunityPage();
}

class _CommunityPage extends State<CommunityPage>
    with SingleTickerProviderStateMixin {
  List<CustomTabMaker> list = [];
  TabController _tabController;
  TextStyleElements styleElements;

  SharedPreferences prefs;
  String ownerType;
  int ownerId;
  int _currentPosition = 0;
  String pageTitle;
  Null Function() callback;
  String imageUrl;
  List<PopupMenuItem> menuList = [];
  String type ;
  GlobalKey<RoomsPageState> roomsKey = GlobalKey();
  GlobalKey<NetworkPageState> networkKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setSharedPreferences());
  }

  onPositionChange() {

   if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
        _currentPosition = _tabController.index;

        setState(() {
          getMenuList();
        });
      });
    }
  }

  Future<void> getMenuList() async {
    type= _currentPosition ==0 ? "room": "network" ;
  print(type+"----------------------------------------------------------------------");
   menuList.clear();
    menuList =  getList(type);
    setState(() {
      print(menuList);
    });
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    ownerType = prefs.getString("ownerType");
    ownerId = prefs.getInt("userId");
    pageTitle = prefs.getString(Strings.firstName);
    imageUrl = Utility().getUrlForImage(
        prefs.getString(Strings.profileImage),
        RESOLUTION_TYPE.R64,
        prefs.getString("ownerType") == "institution"
            ? SERVICE_TYPE.INSTITUTION
            : SERVICE_TYPE.PERSON);
    getMenuList();
    loadPages();
  }

  loadPages() {
    list.add(CustomTabMaker(
        statelessWidget: RoomsPage(
            key:roomsKey,
            isSwipeDisabled:true,
            hideAppBar: true,hideTabs:true),
        tabName: AppLocalizations.of(context).translate('rooms')));
    list.add(CustomTabMaker(
        statelessWidget: NetworkPage(
          key:networkKey,
            id: ownerId,
            type: ownerType,
            hideTabs:true,
            isSwipeDisabled:true,
            hideAppBar: true,
            currentTab: 0,
            pageTitle: prefs.getString(Strings.firstName),
            imageUrl: Utility().getUrlForImage(
                prefs.getString(Strings.profileImage),
                RESOLUTION_TYPE.R64,
                prefs.getString("ownerType") == "institution"
                    ? SERVICE_TYPE.INSTITUTION
                    : SERVICE_TYPE.PERSON),
            callback: () {
              callback();
            }),
        tabName: AppLocalizations.of(context).translate('network')));

    setState(() {
      _tabController = TabController(vsync: this, length: list.length);
      _tabController.addListener(onPositionChange);
    });
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: HexColor(AppColors.appColorBackground),
        appBar: AppBarWithProfileNew(
          imageUrl: imageUrl,
          title: getPageTitle() +
              "'s " +
              AppLocalizations.of(context).translate('community'),
          isHomepage: false,
          centerTitle: false,
          backButtonPress: () {
            Navigator.pop(context);
          },
          actions: [
            Visibility(
              visible: _currentPosition==0,
              child: GestureDetector(
                onTap: () {

                  if(prefs.getBool(Strings.isVerified)!=null&&prefs.getBool(Strings.isVerified))
                  {  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateRoomPage(value: null,isEdit: false,callback:(){})))
                      .then((value) {
                    roomsKey.currentState.refresh();
                  });}
                  else
                  {
                    ToastBuilder().showToast(
                        AppLocalizations.of(context).translate("only_verirfied"), context, HexColor(AppColors.information));
                  }


                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.add, color: HexColor(AppColors.appColorBlack85)),
                ),
              ),
            ),


            simplePopup()],
        ),

        // TricycleAppBar().getCustomAppBar(context,
        //     appBarTitle: pageTitle+"'s "+AppLocalizations.of(context).translate('network'),
        //     onBackButtonPress: () {
        //       Navigator.pop(context);
        //     }),
        body: Padding(
          padding: const EdgeInsets.only(bottom:120.0),
          child: DefaultTabController(
            length: list.length,
            child: CustomTabView(
              marginTop: const EdgeInsets.only(top: 16.0),
              currentPosition: _currentPosition,
              itemCount: list != null && list.isNotEmpty ? list.length : 0,
              tabBuilder: (context, index) => TricycleTabButton(
                onPressed: () {
                  setState(() {
                    _currentPosition = index;
                    setState(() {

                      _currentPosition == 0 ? type = "room" : "network";
                      setState(() {
                        getMenuList();
                      });
                    });
                  });
                },
                tabName: list[index].tabName,
                isActive: index == _currentPosition,
              ),
              pageBuilder: (context, index) =>
                  Center(child: list[index].statelessWidget),
              onPositionChange: (index) {
                setState(() {

                  if (!_tabController.indexIsChanging && this.mounted) {
                    setState(() {
                      _currentPosition = index;

                      setState(() {
                        getMenuList();
                      });
                    });
                  }
                });
              },
              onScroll: (position) => print('$position'),
            ),
          ),
        ),
      ),
    );
  }

  Widget simplePopup() {
    // var name = headerData.title;
    return PopupMenuButton(
      icon: Icon(
        Icons.segment,
        size: 32,
        color: HexColor(AppColors.appColorBlack85),
      ),
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: HexColor(AppColors.appColorBackground),
      itemBuilder: (context) => menuList,
      onSelected: (value) {
        switch (value) {
          case 'all':
            {
              roomsKey.currentState.setCurrentPage(0);
              break;
            }
          case 'private':
            {
              roomsKey.currentState.setCurrentPage(1);
              break;
            }
          case 'public':
            {
              roomsKey.currentState.setCurrentPage(2);
              break;
            }
          case 'social':
            {
              roomsKey.currentState.setCurrentPage(3);
              break;
            }
          case 'campus':
            {
              roomsKey.currentState.setCurrentPage(4);
              break;
            }

          case 'networkAll':
            {
              networkKey.currentState.setCurrentPage(0);

              break;
            }

          case 'following':
            {
              networkKey.currentState.setCurrentPage(1);

              break;
            }
          case 'follower':
            {
              networkKey.currentState.setCurrentPage(2);

              break;
            }
          case 'teacher':
            {
              networkKey.currentState.setCurrentPage(3);

              break;
            }
          case 'parent':
            {
              networkKey.currentState.setCurrentPage(4);

              break;
            }
          case 'student':
            {
              networkKey.currentState.setCurrentPage(5);

              break;
            }
          case 'alumni':
            {
              networkKey.currentState.setCurrentPage(6);

              break;
            }
        }
      },
    );
  }





    String getPageTitle() {
    if (pageTitle != null) {
      var vals = pageTitle.split(' ');
      if (vals.length > 0)
        return vals[0];
      else
        return '';
    }
    return '';
  }

  List<PopupMenuItem> getList(String type) {
    List<PopupMenuItem> list = [];


    list.add(PopupMenuItem(
        enabled: true,
        value: type == "room" ? "all" : "networkAll",
        child: Center(
          child: Text(
            type == "room" ? "All" : "All",
            style: styleElements
                .subtitle1ThemeScalable(context)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        )));
    list.add(PopupMenuItem(
        enabled: true,
        value: type == "room" ? "private" : "following",
        child: Center(
          child: Text(
            type == "room" ? "Private" : "Following",
            style: styleElements
                .subtitle1ThemeScalable(context)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        )));
    list.add(PopupMenuItem(
        enabled: true,
        value: type == "room" ? "public" : "follower",
        child: Center(
          child: Text(
            type == "room" ? "Public" : "Follower",
            style: styleElements
                .subtitle1ThemeScalable(context)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        )));
    list.add(PopupMenuItem(
        enabled: true,
        value: type == "room" ? "social" : "teacher",
        child: Center(
          child: Text(
            type == "room" ? "Social" : "Teacher",
            style: styleElements
                .subtitle1ThemeScalable(context)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        )));
    list.add(PopupMenuItem(
        enabled: true,
        value: type == "room" ? "campus" : "parent",
        child: Center(
          child: Text(
            type == "room" ? "Campus" : "Parent",
            style: styleElements
                .subtitle1ThemeScalable(context)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        )));

    if (type != "room")
      {
        list.add(PopupMenuItem(
            enabled: true,
            value: "student",
            child: Center(
              child: Text(
                "Student",
                style: styleElements
                    .subtitle1ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            )));


        list.add(PopupMenuItem(
          enabled: true,
          value: "alumni",
          child: Center(
            child: Text(
              "Alumni",
              style: styleElements
                  .subtitle1ThemeScalable(context)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          )));}

    setState(() {});
    return list;
  }
}
