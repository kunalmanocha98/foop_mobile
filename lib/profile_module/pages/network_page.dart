
import 'package:oho_works_app/components/appbar_with_profile%20_image.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FollowerFollowingPageALl.dart';
import 'common__page_network.dart';
import 'followers_suggestionPage.dart';
import 'following_suggestions.dart';



// ignore: must_be_immutable
class NetworkPage extends StatefulWidget {

bool hideTabs;
  String? type;
  int? id;
  int currentTab;
  String? pageTitle;
  Null Function() callback;
  String? imageUrl;
  final bool hideAppBar;
  final bool? isSwipeDisabled;
  NetworkPage({
    Key? key,
    this.hideAppBar=false,
    required this.type,
    required this.id,
    this.hideTabs=false,
    this.isSwipeDisabled,
    required this.pageTitle,
    required this.callback,
    required this.currentTab,
    required this.imageUrl
  }) : super(key: key);

  NetworkPageState createState() =>
      NetworkPageState(type, id, pageTitle, callback, currentTab,imageUrl);
}

class NetworkPageState extends State<NetworkPage> with SingleTickerProviderStateMixin {
  List<CustomTabMaker> list = [];
  late TabController _tabController;
  TextStyleElements? styleElements;
  String? type;
  int? id;
  late SharedPreferences prefs;
  String? ownerType;
  int? ownerId;
  int _currentPosition=0;
  String? pageTitle;
  Null Function() callback;
  String? imageUrl;


  NetworkPageState(this.type, this.id,this.pageTitle, this.callback, this._currentPosition,this.imageUrl);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => setSharedPreferences());
  }

  onPositionChange() {
    if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
        _currentPosition = _tabController.index;
      });
    }
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    ownerType=prefs.getString("ownerType");
    ownerId=prefs.getInt("userId");
    loadPages();
  }
  loadPages() {

    list.add(CustomTabMaker(statelessWidget: AllTabsNetwork(pageTitle,type,id,ownerId,ownerType,callback), tabName: AppLocalizations.of(context)!.translate('all')));
    list.add(CustomTabMaker(statelessWidget: FollowingSuggestionsPage(pageTitle,type,id,ownerId,ownerType,callback), tabName: AppLocalizations.of(context)!.translate('following')));
    list.add(CustomTabMaker(statelessWidget: FollowersSuggestionsPage(pageTitle,type,id,ownerId,ownerType,callback), tabName: AppLocalizations.of(context)!.translate('followers')));
    list.add(new CustomTabMaker(statelessWidget: new CommonListingPageNetwork(""), tabName: ""));

    setState(() {
      _tabController = TabController(vsync: this, length: list.length);
      _tabController.addListener(onPositionChange);
    });
  }

  void  setCurrentPage(int page)
  {
    setState(() {
      _currentPosition=page;
    });

  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return SafeArea(
      child:
      widget.hideAppBar? Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: HexColor(AppColors.appColorBackground),

        body: DefaultTabController(
          length: list.length,
          child: CustomTabView(
              isTabVisible:!widget.hideTabs,
            isSwipeDisabled: widget.isSwipeDisabled,
            marginTop:const EdgeInsets.only(top:16.0 ),
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
          ),
        ),
      ):

      Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: HexColor(AppColors.appColorBackground),
        appBar:  AppBarWithProfile(
              imageUrl:imageUrl,
              title: getPageTitle()+"'s "+AppLocalizations.of(context)!.translate('network'),
              isHomepage: false,
              backButtonPress: (){
                Navigator.pop(context);
              },
            ),

        body: DefaultTabController(
          length: list.length,
          child: CustomTabView(
            marginTop:const EdgeInsets.only(top:16.0 ),
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
          ),
        ),
      ),
    );
  }

  String getPageTitle(){
    var vals= pageTitle!.split(' ');
    if(vals.length>0)
      return vals[0];
    else
      return '';
  }
}

