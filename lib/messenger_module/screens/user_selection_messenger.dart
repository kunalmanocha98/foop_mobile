import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/messenger_module/entities/connect_list_response_entity.dart';
import 'package:oho_works_app/messenger_module/entities/connection_list_entity.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'chat_history_page.dart';

// ignore: must_be_immutable
class UserSelectionPageMessenger extends StatefulWidget {
  IO.Socket socket;
  String type;
  bool isForward;
  Null Function() callBackNew;
  Null Function() callBack;
  Null Function(ConnectionItem) addConnectionCallBack;
  Null Function(String) removeCallBack;

  UserSelectionPageMessenger(
      {Key key,
        this.type, this.socket, this.isForward, this.callBack, this.callBackNew,this.addConnectionCallBack,this.removeCallBack})
      : super(key: key);
  @override
  _UserSelectionPageMessenger createState() => _UserSelectionPageMessenger(
      type, socket, isForward, callBack, callBackNew,addConnectionCallBack,removeCallBack);
}

class _UserSelectionPageMessenger extends State<UserSelectionPageMessenger>
    with AutomaticKeepAliveClientMixin<UserSelectionPageMessenger> {
  IO.Socket socket;
  String type;
  bool isForward;
  Null Function() callBack;
  int ownerId;
  String searchVal;
  Null Function() callback;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  SharedPreferences prefs;
  TextStyleElements styleElements;
  List<ConnectionItem> connectionList = [];
  List<ConnectionItem> selectedConnections = [];
  Null Function(ConnectionItem) addConnectionCallBack;
  Null Function(String) removeCallBack;
  @override
  bool get wantKeepAlive => true;

  void setSharedPreferences() async {
    refresh();
  }

  Future<void> _setPref() async {
    prefs = await SharedPreferences.getInstance();
    ownerId = prefs.getInt(Strings.userId);
  }

  @override
  void initState() {
    super.initState();

    _setPref();
  }

  void onsearchValueChanged(String text) {
    searchVal = text;
    refresh();
  }

  refresh() {
    paginatorKey.currentState.changeState(resetState: true);
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return Container(
        child: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: SearchBox(
              onvalueChanged: onsearchValueChanged,
              hintText: AppLocalizations.of(context).translate('search'),
            ),
          ),
        ];
      },
      body: Stack(
        children: [
          Container(
            color: HexColor(AppColors.appColorWhite),
            child: Paginator.listView(
                key: paginatorKey,
                padding: EdgeInsets.only(top: 8),
                scrollPhysics: BouncingScrollPhysics(),
                pageLoadFuture: getData,
                pageItemsGetter: CustomPaginator(context).listItemsGetter,
                listItemBuilder: listItemBuilder,
                loadingWidgetBuilder:
                    CustomPaginator(context).loadingWidgetMaker,
                errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                emptyListWidgetBuilder:
                    CustomPaginator(context).emptyListWidgetMaker,
                totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                pageErrorChecker: CustomPaginator(context).pageErrorChecker),
          ),
        ],
      ),
    ));
  }

  Future<ConnectionListResponseEntity> getData(int page) async {
    prefs = await SharedPreferences.getInstance();
    ConnectionListEntity connectionListEntity = ConnectionListEntity();
    connectionListEntity.searchValue = searchVal;
    connectionListEntity.connectionCategory = "contact";
    connectionListEntity.connectionOwnerType = "person";
    connectionListEntity.connectionOwnerId = ownerId.toString();
    connectionListEntity.pageNumber = page;
    connectionListEntity.pageSize = 50;

    var res = await Calls().call(
        jsonEncode(connectionListEntity), context, Config.GET_CONNECTIONS);
    return ConnectionListResponseEntity.fromJson(res);
  }

  Widget listItemBuilder(value, int index) {
    ConnectionItem item = value;

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (!isForward) {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => new ChatHistoryPage(
                        conversationItem: null,
                        connectionItem: item,
                        socket: socket,
                        type:"normal",
                        callBack: callBack,
                        callBackNew: callBackNew)));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: SizedBox(
                height: 54,
                width: 54,
                child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {},
                    child: TricycleAvatar(
                      size: 52,
                      imageUrl: item.connectionProfileThumbnailUrl ?? "",
                    )),
              ),
              title: Text(item.connectionName ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: styleElements.subtitle1ThemeScalable(context)),
              subtitle: (item.connectionSubTitle != null)
                  ? Text(item.connectionSubTitle ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: styleElements.captionThemeScalable(context))
                  : null,
              trailing: isForward
                  ? Checkbox(
                      activeColor: HexColor(AppColors.appMainColor),
                      value: item.isSelected,
                      onChanged: (val) {
                        if (this.mounted) {
                          setState(() {
                            if (val) {
                              item.isSelected = true;
                              if (isForward) addConnectionCallBack(item);
                              connectionList.add(item);
                              setState(() {});
                            } else {
                              item.isSelected = false;
                              if (isForward) removeCallBack(item.connectionId);
                              // removeItem(item.connectionId);
                              setState(() {});
                            }
                          });
                        }
                      },
                    )
                  : SizedBox(height: 2, width: 2, child: Container()),
            )
          ],
        ));
  }

  Null Function() callBackNew;

  _UserSelectionPageMessenger(
      this.type, this.socket, this.isForward, this.callBack, this.callBackNew,this.addConnectionCallBack,this.removeCallBack);
}
