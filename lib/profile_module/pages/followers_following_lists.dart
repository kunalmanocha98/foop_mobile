
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'followers_page.dart';
import 'following_page.dart';



// ignore: must_be_immutable
class FollowersFollowingPage extends StatefulWidget {
  String type;
  int id;

  int currentTab;
  String pageTitle;
  Null Function() callback;

  FollowersFollowingPage({
    Key? key,
    required this.type,
    required this.id,
    required this.pageTitle,
    required this.callback,
    required this.currentTab,
  }) : super(key: key);

  _FollowersFollowingPage createState() =>
      _FollowersFollowingPage(type, id, pageTitle, callback, currentTab);
}

class _FollowersFollowingPage extends State<FollowersFollowingPage> with SingleTickerProviderStateMixin {
  List<CustomTabMaker> list = [];
  TabController? _tabController;
  TextStyleElements? styleElements;
  String type;
  int id;
  late SharedPreferences prefs;
  String? ownerType;
  int? ownerId;
  int _currentPosition;
  String pageTitle;
  Null Function() callback;

  _FollowersFollowingPage(this.type, this.id, this.pageTitle, this.callback, this._currentPosition);
  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance!.addPostFrameCallback((_) => setSharedPreferences());
  }

  onPositionChange() {
    if (!_tabController!.indexIsChanging && this.mounted) {
      setState(() {
        _currentPosition = _tabController!.index;
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
    list.add(
        CustomTabMaker(statelessWidget: FollowersPage(pageTitle,type,id,ownerId,ownerType,callback), tabName: AppLocalizations.of(context)!.translate('followers')));
    list.add(CustomTabMaker(
        statelessWidget: FollowingPage(pageTitle,type,id,ownerId,ownerType,callback), tabName: AppLocalizations.of(context)!.translate('following')));

    setState(() {
      _tabController = TabController(vsync: this, length: list.length);
      _tabController!.addListener(onPositionChange);
    });
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: HexColor(AppColors.appColorBackground),
        appBar: TricycleAppBar().getCustomAppBar(context,
            appBarTitle: pageTitle,
            onBackButtonPress: () {

              callback();
              Navigator.pop(context);

            }),
        body: DefaultTabController(
          length: list.length,
          child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Visibility(
                        visible: list.length > 0 ? true : false,
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 0,
                            right: 0,
                          ),
                          alignment: Alignment.center,
                          child: TabBar(
                            labelColor: HexColor(AppColors.appColorWhite),
                            indicatorColor: HexColor(AppColors.appColorTransparent),
                            controller: _tabController,
                            labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                            isScrollable: true,
                            tabs: List<Widget>.generate(list.length, (int index) {
                              return TricycleTabButton(
                                tabName: list[index].tabName,
                                isActive: index==_currentPosition,
                                onPressed: (){
                                  _tabController!.animateTo(index);
                                  if (this.mounted) {
                                    setState(() {
                                      _currentPosition = index;
                                    });
                                  }
                                },
                              );
                            }),
                          ),
                        )),
                  ),
                ];
              },
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: List<Widget>.generate(list.length, (int index) {
                  return new Center(
                      child: list[_currentPosition].statelessWidget);
                }),
              )),
        ),
      ),
    );
  }
}

