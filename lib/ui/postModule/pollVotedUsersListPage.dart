import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/postModule/polls%20userList.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PollsVotedUserListPage extends StatefulWidget{
  int? postId;
  List<Options>? optionsList;
  PollsVotedUserListPage({this.postId,this.optionsList});
  @override
  PollsVotedUserListPageState createState() => PollsVotedUserListPageState(
    postId: postId,
    optionsList: optionsList
  );
}
class PollsVotedUserListPageState extends State<PollsVotedUserListPage> with SingleTickerProviderStateMixin{

  List<CustomTabMaker> list = [];
  int _currentPosition = 0;
  late TabController _tabController;

  int? postId;
  List<Options>? optionsList;
  PollsVotedUserListPageState({this.postId,this.optionsList});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadPages());
  }
  loadPages() {
    for(int i=0; i<optionsList!.length; i++) {
      list.add(CustomTabMaker(
          tabName:optionsList![i].option,
        statelessWidget: PollsUserList(
          option: optionsList![i].option,
          sequence: optionsList![i].optionSequence,
          postId: postId,
        )
      ));
    }
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appAppBar().getCustomAppBar(
            context,
            appBarTitle: 'Votes',
            onBackButtonPress: (){
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
    );
  }



}