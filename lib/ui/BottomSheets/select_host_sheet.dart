import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/campus_talk/host_list_models.dart';
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

class SelectHostSheet extends StatefulWidget {
  final int selectedId;
  final Function(HostListItem) onClickCallback;

  SelectHostSheet({this.selectedId, this.onClickCallback});

  @override
  _SelectHostSheet createState() => _SelectHostSheet();
}

class _SelectHostSheet extends State<SelectHostSheet> {
  TextStyleElements styleElements;
  SharedPreferences prefs = locator<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('select_host'),
                    style: styleElements.headline6ThemeScalable(context).copyWith(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
          )
        ];
      },
      body: Paginator<HostListResponse>.listView(
        shrinkWrap: true,
        pageLoadFuture: fetchList,
        pageItemsGetter: CustomPaginator(context).listItemsGetter,
        listItemBuilder: listItemBuilder,
        loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
        errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
        emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
        totalItemsGetter: CustomPaginator(context).totalPagesGetter,
        pageErrorChecker: CustomPaginator(context).pageErrorChecker,
      ),
    );
  }

  Future<HostListResponse> fetchList(int page) async {
    var payload = HostListRequest(
        pageNumber: page, pageSize: 10, personId: prefs.getInt(Strings.userId));
    var res = await Calls()
        .call(jsonEncode(payload), context, Config.EVENT_HOST_LIST);
    return HostListResponse.fromJson(res);
  }

  Widget listItemBuilder(itemData, int index) {
    HostListItem item = itemData;
    return Padding(
      padding: EdgeInsets.only(top: 4, bottom: 4),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          widget.onClickCallback(item);
        },
        child: ListTile(
          leading: TricycleAvatar(
            size: 48,
            resolution_type: RESOLUTION_TYPE.R64,
            service_type: item.eventOwnerType == 'person'
                ? SERVICE_TYPE.PERSON
                : item.eventOwnerType == 'room'
                ? SERVICE_TYPE.ROOM
                : SERVICE_TYPE.INSTITUTION,
            imageUrl: item.eventOwnerImageUrl,
          ),
          title: Text(
            item.eventOwnerName,
            style: styleElements.subtitle1ThemeScalable(context),
          ),
          trailing: (widget.selectedId == item.eventOwnerId)
              ? Icon(
            Icons.check_circle_rounded,
            color: HexColor(AppColors.appColorGreen),
          )
              : null,
        ),
      ),
    );
  }
}
