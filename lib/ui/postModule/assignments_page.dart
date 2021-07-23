import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/enums/post_enums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/postModule/selectedPostListPage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AssignmentPage extends StatefulWidget {
  @override
  AssignmentPageState createState() => AssignmentPageState();
}

class AssignmentPageState extends State<AssignmentPage>
    with SingleTickerProviderStateMixin {
  List<CustomTabMaker> list = [];
  int currentPosition = 0;
  late TabController _tabController;
  TextStyleElements? styleElements;
  SharedPreferences? prefs = locator<SharedPreferences>();
  BuildContext? sctx;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadPages());
  }

  onPositionChange() {
    if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
        currentPosition = _tabController.index;
      });
    }
  }

  loadPages() async {
    list.add(CustomTabMaker(
        statelessWidget:  SelectedFeedListPage(
          isFromProfile:true,
          isOwnPost: true,
          appBarTitle: AppLocalizations.of(context)!.translate('assignment'),
          postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
          postType: POST_TYPE.ASSIGNMENT.status,
        ),
        tabName: AppLocalizations.of(context)!.translate('given')));
    list.add(CustomTabMaker(
        statelessWidget: SelectedFeedListPage(
          isFromProfile:true,
          isOwnPost: false,
          isReceivedPost: true,
          appBarTitle: AppLocalizations.of(context)!.translate('assignment'),
          postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
          postType: POST_TYPE.ASSIGNMENT.status,
        ),
        tabName: AppLocalizations.of(context)!.translate('received')));
    setState(() {
      _tabController = TabController(vsync: this, length: list.length);
      _tabController.addListener(onPositionChange);
    });
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: new Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: TricycleAppBar().getCustomAppBar(context,
              appBarTitle: AppLocalizations.of(context)!.translate("assignment"),
              onBackButtonPress: () {
                Navigator.pop(context);
              }),
          body: new Builder(builder: (BuildContext context) {
            this.sctx = context;
            return new DefaultTabController(
              length: list.length,
              child: CustomTabView(
                marginTop: const EdgeInsets.all(16.0),
                currentPosition: currentPosition,
                itemCount: list != null && list.isNotEmpty ? list.length : 0,
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
                    currentPosition = index!;
                  });
                },
                onScroll: (position) => print('$position'),
              ),
            );
          })),
    );
  }
}
