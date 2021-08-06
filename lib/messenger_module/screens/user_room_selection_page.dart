
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/messenger_module/entities/connect_list_response_entity.dart';
import 'package:oho_works_app/messenger_module/screens/user_selection_messenger.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'chat_rooms_page.dart';

// ignore: must_be_immutable
class UserRoomSelectionPage extends StatefulWidget {

  IO.Socket? socket;
  bool? isForward;
  Null Function()? callBack;
  Null Function()? callBackNew;
  _UserRoomSelectionPage createState() =>
      _UserRoomSelectionPage(socket,isForward,callBack,callBackNew);

  UserRoomSelectionPage({this.socket,this.isForward,this.callBack,this.callBackNew});
}

class _UserRoomSelectionPage extends State<UserRoomSelectionPage> with SingleTickerProviderStateMixin {
  List<CustomTabMaker> list = [];
  late TabController _tabController;
  Null Function()? callBack;
  late TextStyleElements styleElements;
  String? type;
  int? id;
  List<ConnectionItem> connectionList = [];
  Null Function()? callBackNew;
  bool? isForward;
  IO.Socket? socket;
  late SharedPreferences prefs;
  String? ownerType;
  int? ownerId;
  int _currentPosition=0;
  String? pageTitle;
  Null Function()? callback;
  String title="";
  _UserRoomSelectionPage(this.socket,this.isForward,this.callback,this.callBackNew);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => setSharedPreferences());
  }

  onPositionChange() {
    if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
        _currentPosition = _tabController.index;
        _currentPosition==0?title=AppLocalizations.of(context)!.translate("select_user"):title=AppLocalizations.of(context)!.translate("select_room");
        print(_currentPosition.toString()+"050-----------------------------------------------------");
      });
    }
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    ownerType=prefs.getString("ownerType");
    ownerId=prefs.getInt("userId");
    title=AppLocalizations.of(context)!.translate("select_user");
    loadPages();
  }
  loadPages() {

    list.add(new CustomTabMaker(statelessWidget: new UserSelectionPageMessenger(type: "Users",

      isForward: isForward,
      socket: socket,
      callBack: callBack,
      callBackNew: callBackNew,
      addConnectionCallBack: (ConnectionItem c){

      if(!isLimitReached())
        connectionList.add(c);
      else
      {
        ToastBuilder().showToast(
            AppLocalizations.of(context)!.translate("max_five"),
            context,
            HexColor(AppColors.information));
      }


        setState(() {

        });
        },
      removeCallBack: (String? id){
        removeItem(id!);
        setState(() {

        });
      },



    ), tabName:AppLocalizations.of(context)!.translate("user")));
    list.add(new CustomTabMaker(statelessWidget: new ChatRoomsPage(type:"Rooms", isForward: isForward,
      socket: socket,
      callBack: callBack,
      callBackNew: callBackNew,

      addConnectionCallBack: (ConnectionItem c){
        if(!isLimitReached())
         { connectionList.add(c);}
        else
        {
          ToastBuilder().showToast(
              AppLocalizations.of(context)!.translate("max_five"),
              context,
              HexColor(AppColors.information));
        }
        setState(() {

        });
      },
      removeCallBack: (String id){
        removeItem(id);
        setState(() {

        });
      },),  tabName:AppLocalizations.of(context)!.translate("rooms")));

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

        appBar: appAppBar().getCustomAppBar(context,
            appBarTitle: title,
            onBackButtonPress: () {
              Navigator.pop(context);

            }),
        body: Stack(
          children: [DefaultTabController(
            length: list.length,
            child: CustomTabView(
              marginTop:const EdgeInsets.only(top:16.0,right: 16.0,left: 16.0 ),
              currentPosition: _currentPosition,
              itemCount: list!=null && list.isNotEmpty?list.length:0,
              tabBuilder: (context, index) => appTabButton(
                onPressed: () {
                  setState(() {
                    _currentPosition = index;
                    _currentPosition==0?title=AppLocalizations.of(context)!.translate("select_user"):title=AppLocalizations.of(context)!.translate("select_room");
                    print(_currentPosition.toString()+"020-----------------------------------------------------");
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
                  _currentPosition==0?title=AppLocalizations.of(context)!.translate("select_user"):title=AppLocalizations.of(context)!.translate("select_room");
                  print(_currentPosition.toString()+"00-----------------------------------------------------");
                });
              },
              onScroll: (position) => {


              },
            ),
          ),
            Visibility(
              visible: isForward!,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      color: HexColor(AppColors.appColorWhite),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(getNames(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: styleElements
                                    .subtitle1ThemeScalable(context)
                                    .copyWith(
                                  color:  HexColor(AppColors.appMainColor),),

                              ),
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.only(right:16.0),
                            child: appProgressButton(

                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color:  HexColor(AppColors.appMainColor),)),
                              onPressed: () async {

                                Navigator.of(context).pop({'result': getSelectedUsers()});
                              },
                              color:  HexColor(AppColors.appColorWhite),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('next')
                                    .toUpperCase(),
                                style: styleElements
                                    .subtitle2ThemeScalable(context)
                                    .copyWith(
                                  color:  HexColor(AppColors.appMainColor),),
                              ),
                            ),
                          )

                          ,

                        ],
                      ))),
            )],
        ),
      ),
    );
  }

  List<ConnectionItem> getSelectedUsers()
  {
    List<ConnectionItem> list=[];
    for(var item in connectionList)
    {
      if(item.isSelected!)
        list.add(item);
    }
    return list;

  }
  String getNames()
  {
    String selectedNames="";
    for(var item in connectionList)
    {
      if(item.isSelected!)
        selectedNames=selectedNames+(item.connectionName!+",");
    }
    return selectedNames;

  }
  bool isLimitReached()
  {
    if(connectionList.length<5)
      return false;
    else
      return true;

  }

  removeItem(String id)
  {
    for(var item in connectionList)
    {
      if(item.connectionId==id)
      {
        connectionList.remove(item);
        break;
      }

    }


  }



}

