/*
import 'package:oho_works_app/audio_confrence_module/participants.dart';
import 'package:oho_works_app/components/tricycle_bottom_selector.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/messenger_module/entities/user_status.dart';
import 'package:oho_works_app/services/deeplinking_service.dart';
import 'package:oho_works_app/tri_cycle_database/data_base_helper.dart';
import 'package:oho_works_app/ui/BottomSheets/CreateNewSheet.dart';
import 'package:oho_works_app/ui/RoomModule/roomsPage.dart';
import 'package:oho_works_app/ui/campus_talk/campus_talk_list.dart';
import 'package:oho_works_app/ui/postModule/postListPage.dart';
import 'package:oho_works_app/ui/postcreatepage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../RoomModule/createRoomPage.dart';
import '../appmenupage.dart';
import 'homePage2.0.dart';



class DashboardPageNew extends StatefulWidget {
  @override
  _DashBoardPageNew createState() => _DashBoardPageNew();
}

class _DashBoardPageNew extends State<DashboardPageNew> {
  SharedPreferences prefs;
  TextStyleElements styleElements;
  GlobalKey<PostListState> postListKey = GlobalKey();
  GlobalKey<AppMenuPageState> appMenuKey = GlobalKey();
  GlobalKey<TricycleBottomSelectorState> bottomSelectorKey = GlobalKey();
  final DynamicLinkService  dynamicLinkService =locator<DynamicLinkService>();
  final dbHelper = DatabaseHelper.instance;
  IO.Socket socket;


  int nCount=0;
  @override
  void initState() {
    super.initState();
    setupConnection();
    dynamicLinkService.handleDynamicLinks(context, prefs);
  }

  @override
  void dispose() {
    super.dispose();
  }
  joinChat(dynamic personId) {
    socket.emit('join', personId);
  }

  userStatus(dynamic payload) async {
    print("**************************payload");
    UserStatusPayload userStatusPayload = UserStatusPayload.fromJson(payload);
    */
/* ConversationItem item= await db.getConversationWithOnlineStatus(userStatusPayload.personId);
    if(item!=null && item.isOnline==0)
      joinChat(personId.toString());*//*

    await dbHelper.updateStatus(userStatusPayload.personId, userStatusPayload.isOnline?1:0);
  }

  setupConnection() async {
    prefs = await SharedPreferences.getInstance();

    socket = IO.io(Config.BASE_URL_MESSENGER, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.connect();
    socket.onConnect((_) {
      print("connected+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      socket.on('user_status', userStatus);
      UserStatusPayload userStatusPayload = UserStatusPayload();
      userStatusPayload.isOnline = true;
      userStatusPayload.personId = prefs.getInt("userId").toString();
      socket.emit('user_status', userStatusPayload);
      joinChat(prefs.getInt("userId").toString());
      setState(() {

      });
    });
    socket.onDisconnect((_) {
      print(
          "disconnected+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    });
    socket.onError((_) {
      print("errorr+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    });

    locator.registerSingleton(() => socket);
  }

  void setPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  int _selectedIndex = 0;


  List<Widget> _widgetOptions(){
    return <Widget>[
      HomePage2(),

      // PostListPage(key: postListKey,
      //   isFromProfile: false,
      //   isOthersPostList: false,),
     CampusTalkListPage(),
      Center(
        child: Text(
          'Create',
        ),
      ),

      Agora(),
  */
/*    ChatListsPage(
          " ",
          socket
      ),*//*

      // GlobalSearchPage(),
      AppMenuPage(key:appMenuKey,prefs:prefs)
    ];

  }

  void _onItemTapped(int index) {
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      _showModalBottomSheet(context);
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
        return CreateNewBottomSheet(prefs: prefs,onClickCallback: (value){
          if(value=='room'){
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder:(context)=> CreateRoomPage(isEdit: false,))).then((value2){
              if(value2!=null && value2==Strings.success_code){
                setState(() {
                  if (_selectedIndex == 4) {
                    appMenuKey.currentState.menuitemClick('room');
                  } else {
                    _selectedIndex = 4;
                    Navigator.of(context).push(MaterialPageRoute(builder:(context)=> RoomsPage()));
                  }
                });
                // Future.delayed(Duration(milliseconds: 500),(){
                //   Navigator.of(context).push(MaterialPageRoute(builder:(context)=> RoomsPage()));
                // });
              }
            });
          }else{
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder:(context)=> PostCreatePage(type: value,prefs: prefs,))).then((value){
              if(value!=null && value) {
                setState(() {
                  if (_selectedIndex == 1) {
                    postListKey.currentState.refresh();
                  } else {
                    _selectedIndex = 1;
                  }
                });
              }
            });
          }
        },
        );
        // return BottomSheetContent();
      },
    );
  }
  // ignore: missing_return
  Future<bool> _onBackPressed() {
    if(_selectedIndex==0)
      Navigator.of(context).pop(true);
    else
      setState(() {
        _selectedIndex=0;
      });
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    setPrefs();

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: _widgetOptions().elementAt(_selectedIndex),
          bottomNavigationBar:
            TricycleBottomSelector(
              onItemTapped: _onItemTapped,
              currentIndex: _selectedIndex,
              key: bottomSelectorKey,
            )
          // BottomNavigationBar(
          //   elevation: 0,
          //   backgroundColor: HexColor(AppColors.appColorBackground),
          //   type: BottomNavigationBarType.fixed,
          //   items: [
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.home_outlined,size: 20.h,),
          //       label: AppLocalizations.of(context).translate("home"),
          //       // title: GestureDetector(
          //       //   onLongPress: () {
          //       //     _showInstitutionBottomSheet(context);
          //       //   },
          //       //   child: Text(AppLocalizations.of(context).translate("home"),
          //       //     style: styleElements.bodyText2ThemeScalable(context),),
          //       // ),
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.supervised_user_circle_outlined,size: 20.h,),
          //       label: AppLocalizations.of(context).translate("circle"),
          //       // title: Text(AppLocalizations.of(context).translate("circle"),
          //       //   style: styleElements.bodyText2ThemeScalable(context),),
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.add_circle_outline,size: 36.h,),
          //       label: '',
          //       // title: Text(""),
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.search,size: 20.h,),
          //       label: AppLocalizations.of(context).translate("search"),
          //
          //       // title: Text(AppLocalizations.of(context).translate("messenger"),
          //       //   style: styleElements.bodyText2ThemeScalable(context),),
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.apps_outlined,size: 20.h,),
          //       label: 'Menu',
          //       // title: Text(AppLocalizations.of(context).translate('')'Menu",
          //       //   style: styleElements.bodyText2ThemeScalable(context),
          //       // ),
          //     )
          //   ],
          //   // selectedLabelStyle: styleElements.bodyText2ThemeScalable(context).copyWith(
          //   //   color: HexColor(AppColors.appMainColor)
          //   // ),
          //   currentIndex: _selectedIndex,
          //   selectedItemColor: HexColor(AppColors.appMainColor),
          //   unselectedItemColor: HexColor(AppColors.appColorBlack35),
          //   onTap: _onItemTapped,
          // ),
        ),
      )
      ,
    );
  }
}

*/
