import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/models/email_module/email_user_create.dart';
import 'package:oho_works_app/models/email_module/email_user_list.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/dialogs/delete_confirmation_dilog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_email_page.dart';

class EmailUsersPage extends StatefulWidget {
  @override
  _EmailUsersPage createState() => _EmailUsersPage();
}

class _EmailUsersPage extends State<EmailUsersPage>
    with SingleTickerProviderStateMixin {
  List<CustomTabMaker> list = [];
  int currentPosition = 0;
  TabController? _tabController;
  BuildContext? sctx;
  SharedPreferences prefs = locator<SharedPreferences>();
  TextStyleElements? styleElements;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadPages());
  }

  onPositionChange() {
    if (!_tabController!.indexIsChanging && this.mounted) {
      setState(() {
        currentPosition = _tabController!.index;
      });
    }
  }

  loadPages() async {
    list.add(CustomTabMaker(
        statelessWidget: EmailUserList(
          type: 'active',
        ),
        tabName: AppLocalizations.of(context)!.translate('active')));

    list.add(CustomTabMaker(
        statelessWidget: EmailUserList(type: 'deleted'),
        tabName: AppLocalizations.of(context)!.translate('deleted')));

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
        appBar: OhoAppBar().getCustomAppBar(context,
            appBarTitle: AppLocalizations.of(context)!
                .translate('email_accounts'), onBackButtonPress: () {
              Navigator.pop(context);
            }, actions: [
              appTextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return CreateEmailPage();
                      }));
                },
                shape: StadiumBorder(),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(
                    Icons.add,
                    color: HexColor(AppColors.appMainColor),
                  ),
                  Text(
                    "Create",
                    style: styleElements!
                        .captionThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appMainColor)),
                  )
                ]),
              )
            ]),
        body: new Builder(builder: (BuildContext context) {
          this.sctx = context;
          return new DefaultTabController(
            length: list.length,
            child: CustomTabView(
              isTabVisible: true,
              marginTop: const EdgeInsets.all(16.0),
              currentPosition: currentPosition,
              itemCount: list != null && list.isNotEmpty ? list.length : 0,
              tabBuilder: (context, index) => appTabButton(
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
        }),
      ),
    );
  }
}

class EmailUserList extends StatefulWidget {
  final String type;

  EmailUserList({required this.type});

  @override
  _EmailUserList createState() => _EmailUserList();
}

class _EmailUserList extends State<EmailUserList> {
  TextStyleElements? styleElements;
  SharedPreferences prefs = locator<SharedPreferences>();
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  String searchVal="";

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: SearchBox(
                onvalueChanged: (value) {
                  searchVal = value;
                  refreshList();
                },
                hintText: 'Search mail',
              ),
            )
          ];
        },
        body: appListCard(
          child: Paginator<EmailUserListResponse>.listView(
            key: paginatorKey,
            pageLoadFuture: fetchList,
            pageItemsGetter: CustomPaginator(context).listItemsGetter,
            listItemBuilder: listItemBuilder,
            loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
            errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
            emptyListWidgetBuilder:
            CustomPaginator(context).emptyListWidgetMaker,
            totalItemsGetter: CustomPaginator(context).totalPagesGetter,
            pageErrorChecker: CustomPaginator(context).pageErrorChecker,
          ),
        ));
  }

  Future<EmailUserListResponse> fetchList(int page) async {
    EmailUserListRequest payload = EmailUserListRequest();
    payload.ownerId = prefs.getInt(Strings.userId)!;
    payload.ownerType = prefs.getString(Strings.ownerType)!;
    payload.pageSize = 10;
    payload.pageNumber = page;
    payload.searchVal = searchVal;
    payload.emailIdStatus = widget.type;
    var value = await Calls().call(
        jsonEncode(payload), context, Config.EMAIL_USER_LISTING,
        isMailToken: true);
    return EmailUserListResponse.fromJson(value);
  }

  Widget listItemBuilder(itemData, int index) {
    EmailUserListItem item = itemData;
    return appUserListTile(
      imageUrl: item.avtar,
      isFullImageUrl: false,
      title: item.title,
      subtitle1: item.subtitle,
      trailingWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: false,
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(4),
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(45)),
                child: Text(
                  "Upgrade",
                  style: styleElements!
                      .captionThemeScalable(context)
                      .copyWith(color: HexColor(AppColors.appMainColor)),
                ),
              ),
            ),
          ),
          simplePopup(item)
        ],
      ),
    );
  }

  Widget simplePopup(EmailUserListItem item) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.only(right: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      itemBuilder: (context) => getItems(),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context){
                  return CreateEmailPage(
                    data: item,
                    isUpdate: true,
                  );
                }
              )).then((value){
                if(value!=null && value){
                  refreshList();
                }
              });
              break;
            }
          case 'delete':
            {
              showDeleteDialog(item);
              break;
            }
        }
      },
      icon: Icon(
        Icons.more_vert,
        color: HexColor(AppColors.appColorBlack85),
      ),
    );
  }

  void showDeleteDialog(EmailUserListItem item) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDilog(
          cancelButton: () {},

          showCancelButton: true,
          updateButton: () {
            deleteUser(item);
          },
        );
      },
    );
  }

  void deleteUser(EmailUserListItem item) {
    var data = jsonEncode({"email_id": item.emailId, "id": item.id});
    Calls().call(data, context, Config.EMAIL_USER_DELETE,isMailToken:true).then((value){
      var res = CreateEmailUserResponse.fromJson(value);
      if(res.statusCode == Strings.success_code){
        refreshList();
      }
    });
  }

  List<PopupMenuEntry<String>> getItems() {
    List<PopupMenuEntry<String>> popupmenuList = [];
    popupmenuList.add(
      PopupMenuItem(
        value: 'edit',
        child: Row(children: [
          Icon(Icons.edit_outlined),
          SizedBox(
            width: 8,
          ),
          Text(
            'Edit',
          )
        ]),
      ),
    );
    popupmenuList.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(children: [
          Icon(Icons.delete_outline),
          SizedBox(
            width: 8,
          ),
          Text(
            'Delete',
          )
        ]),
      ),
    );
    return popupmenuList;
  }

  void refreshList() {
    paginatorKey.currentState!.changeState(resetState: true);
  }
}
