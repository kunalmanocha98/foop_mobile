import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/enums/post_enums.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/BottomSheets/CreateNewSheet.dart';
import 'package:oho_works_app/ui/postModule/postListPage.dart';
import 'package:oho_works_app/ui/postModule/selectedPostListPage.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../postcreatepage.dart';
import 'CampusNewsListPage.dart';

// ignore: must_be_immutable
class PollsListPage extends StatefulWidget{
  SharedPreferences? prefs;
  Null Function()? callBack;
  PollsListPage({this.prefs,this.callBack});

  @override
  PollsListPageState createState() => PollsListPageState(callBack);
}
class PollsListPageState extends State<PollsListPage> with SingleTickerProviderStateMixin{

  List<CustomTabMaker> list = [];
  int _currentPosition = 0;
  late TabController _tabController;
  PollsListPageState(this.callBack);
  Null Function()? callBack;
  GlobalKey<SelectedFeedPageState> pollsKey = GlobalKey();
  GlobalKey<SelectedFeedPageState> pollsKey2 = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadPages());
  }
  loadPages() {
      list.add(CustomTabMaker(
          tabName: AppLocalizations.of(context)!.translate('all_polls'),
          statelessWidget: SelectedFeedListPage(
            key: pollsKey,
            callBack: (){
              if(callBack!=null)
                callBack;
              Navigator.pop(context);
            },
              isFromProfile:true,
              appBarTitle: AppLocalizations.of(context)!.translate('poll'),
              postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
              postType: POST_TYPE.POLL.status,
            )
      ));
      list.add(CustomTabMaker(
          tabName: AppLocalizations.of(context)!.translate('my_polls'),
          statelessWidget: SelectedFeedListPage(
            key: pollsKey2,
            callBack: (){

              if(callBack!=null)
                callBack;
              Navigator.pop(context);
            },
            isFromProfile:true,
            isOwnPost: true,
            appBarTitle: AppLocalizations.of(context)!.translate('poll'),
            postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
            postType: POST_TYPE.POLL.status,
          )
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
  Widget _simplePopup() {
    // var name = headerData.title;
    return PopupMenuButton(
      icon: Icon(
        Icons.segment,
        color: HexColor(AppColors.appColorBlack85),
      ),
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
      ),
      color: HexColor(AppColors.appColorBackground),
      itemBuilder: (context)=> PostListMenu(context: context,type: POST_TYPE.POLL.status).menuList,
      onSelected: (dynamic value) {
        switch (value) {
          case 'notice':{
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SelectedFeedListPage(
                      callBack: (){
                        if(callBack!=null)
                          callBack;
                        Navigator.pop(context);
                      },
                      isFromProfile:false,
                      appBarTitle: AppLocalizations.of(context)!.translate('notice_board'),
                      postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
                      postType: POST_TYPE.NOTICE.status,)
            ));
            break;
          }
          case 'bookmark':{
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SelectedFeedListPage(
                      callBack: (){
                        if(callBack!=null)
                          callBack;
                        Navigator.pop(context);
                      },
                      isFromProfile:false,appBarTitle: 'Bookmarks',
                      postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,)
            ));
            break;
          }
          case 'news':{
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    CampusNewsListPage(
                      callBack: (){
                        if(callBack!=null)
                          callBack;
                        Navigator.pop(context);
                      },
                    )
            ));
            break;
          }
          case 'blog':{
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SelectedFeedListPage(
                      callBack: (){
                        if(callBack!=null)
                          callBack;
                        Navigator.pop(context);
                      },
                      isFromProfile:false,appBarTitle: AppLocalizations.of(context)!.translate('article'),
                      postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
                      postType: POST_TYPE.BLOG.status,)
            ));
            break;
          }
          case 'qa':{
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SelectedFeedListPage(
                      callBack: (){
                        if(callBack!=null)
                          callBack;
                        Navigator.pop(context);
                      },

                      isFromProfile:false,appBarTitle: AppLocalizations.of(context)!.translate('ask_expert'),
                      postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
                      postType: POST_TYPE.QNA.status,)
            ));
            break;
          }
          case 'poll':{
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    PollsListPage(
                      callBack: (){
                        if(callBack!=null)
                          callBack;
                        Navigator.pop(context);
                      },
                      prefs: widget.prefs,)
            ));
            break;
          }
          case 'old':{
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SelectedFeedListPage(
                      callBack: (){
                        if(callBack!=null)
                          callBack;
                        Navigator.pop(context);
                      },isFromProfile:false,appBarTitle: 'Older Posts',
                      postRecipientStatus: POST_RECIPIENT_STATUS.READ.status,)
            ));
            break;
          }
          case 'general':{
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SelectedFeedListPage(
                      callBack: (){
                        if(callBack!=null)
                          callBack;
                        Navigator.pop(context);
                      },isFromProfile:false,appBarTitle: AppLocalizations.of(context)!.translate('general'),
                      postRecipientStatus: POST_RECIPIENT_STATUS.READ.status,)
            ));
            break;
          }
          default:{
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SelectedFeedListPage(
                      callBack: (){
                        if(callBack!=null)
                          callBack;
                        Navigator.pop(context);
                      },isFromProfile:false,appBarTitle: AppLocalizations.of(context)!.translate('notice'),
                      postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
                      postType: POST_TYPE.NOTICE.status,)
            ));
            break;
          }
        }
      },

    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){  if(callBack!=null)
        callBack!();
      Navigator.pop(context);
      return new Future(() => false);} ,
      child: SafeArea(
        child: Scaffold(
          appBar: appAppBar().getCustomAppBar(
              context,
              actions: [ InkWell(
                  onTap: () {
                    _showModalSelectorSheet(context);
                  },
                  child: Icon(
                    Icons.add,
                    color: HexColor(AppColors.appColorBlack65),
                  )),
                _simplePopup()
              ],
              appBarTitle: AppLocalizations.of(context)!.translate('poll'),
              onBackButtonPress: (){
                if(callBack!=null)
                  callBack!();
                Navigator.pop(context);
              }),
          body:DefaultTabController(
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
            ),
          ) ,
        ),
      ),
    );
  }
  void _showModalSelectorSheet(BuildContext context) async {

    widget.prefs ??= await SharedPreferences.getInstance();
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      builder: (context) {
        return CreateNewBottomSheet(
          isRoomsVisible: false,
          prefs: widget.prefs,
          onClickCallback: (value) {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PostCreatePage(

                  callBack: (){
                    if(_currentPosition==0)
                      pollsKey.currentState!.refresh();
                    else
                      pollsKey2.currentState!.refresh();


                  },
                  type: value,
                )));
          },
        );
      },
    );
  }


}