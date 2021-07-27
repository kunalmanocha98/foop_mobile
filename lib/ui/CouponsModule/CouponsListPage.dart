import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/enums/couponenums.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/coupons/couponlisting.dart';
import 'package:oho_works_app/ui/CouponsModule/coupondetailpage.dart';
import 'package:oho_works_app/ui/CouponsModule/couponhistoryitem.dart';
import 'package:oho_works_app/ui/CouponsModule/couponlistitem.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'couponpageheadercard.dart';

// ignore: must_be_immutable
class CouponsListPage extends StatefulWidget {
  GlobalKey<CouponPageHeaderCardState>? headerKey;

  CouponsListPage({this.headerKey});

  @override
  _CouponsListPage createState() => _CouponsListPage(headerKey: headerKey);
}

class _CouponsListPage extends State<CouponsListPage> {
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  String? searchVal;
  List<CommonCardData> couponList = [];
  GlobalKey<CouponPageHeaderCardState>? headerKey;
  SharedPreferences? prefs;

  _CouponsListPage({this.headerKey});

  @override
  void initState() {
    super.initState();
  }

  // void setSharedPreferences() async {
  //   prefs = await SharedPreferences.getInstance();
  //   refresh();
  // }

  void onsearchValueChanged(String text) {
    searchVal = text;
    refresh();
  }

  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
  }
  Future<Null> refreshList() async {
    refresh();
    await new Future.delayed(new Duration(seconds: 2));

    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: refreshList,
        child: Paginator.listView(
            key: paginatorKey,
            scrollPhysics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 16),
            pageLoadFuture: fetchList,
            pageItemsGetter: CustomPaginator(context).listItemsGetter,
            listItemBuilder: listItemBuilder,
            loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
            errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
            emptyListWidgetBuilder: emptyListWidgetMaker,
            totalItemsGetter: CustomPaginator(context).totalPagesGetter,
            pageErrorChecker: CustomPaginator(context).pageErrorChecker),
      ),
    );
  }

  Future<CouponListResponse> fetchList(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    CouponListRequest payload = CouponListRequest();
    payload.pageNumber = page;
    payload.pageSize = 20;
    payload.personId = prefs!.getInt(Strings.userId).toString();
    var data = jsonEncode(payload);
    var res = await Calls().call(data, context, Config.ALLCOUPONLIST);

    return CouponListResponse.fromJson(res);
  }

  Widget listItemBuilder(value, int index) {
    CouponListItem item = value;
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CouponDetailPage(
                        couponData: item,
                        showQr: false,
                      ))).then((value) {
            headerKey!.currentState!.fetchData();
          });
        },
        child: Container(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: appListCard(
            // elevation: 3
            padding: EdgeInsets.all(0),
            child: CouponListItemCard(
              imageWidth: 124,
              imageHeight: 124,
              title: item.couponProvider,
              imageUrl: item.couponImage,
              discount: item.couponDiscount,
              discountType: item.couponDiscountType,
              rewardPoints: item.rewardPointsRequired,
              validTill: Utility()
                  .getDateFormat("dd-MMM-yyyy", DateTime.parse(item.validTill!)),
              isDividerHide: false,
              isActive: false,
            ),
          ),
        ));
  }

  Widget emptyListWidgetMaker(CouponListResponse? pageData) {
    return CustomPaginator(context).emptyListWidgetMaker(pageData,
        message: AppLocalizations.of(context)!.translate('coming_soon'));
  }
}

class RedeemedCouponsListPage extends StatefulWidget {
  @override
  _RedeemedCouponsListPage createState() => _RedeemedCouponsListPage();
}

class _RedeemedCouponsListPage extends State<RedeemedCouponsListPage> {
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  SharedPreferences? prefs;
  String? searchVal;
  List<CommonCardData> couponList = [];

  @override
  void initState() {
    super.initState();
  }

  void onsearchValueChanged(String text) {
    searchVal = text;
    refresh();
  }

  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
  }
  Future<Null> refreshList() async {
    refresh();
    await new Future.delayed(new Duration(seconds: 2));

    return null;
  }
  @override
  Widget build(BuildContext context) {
    // setSharedPreferences();
    return RefreshIndicator(
      onRefresh: refreshList,
      child: Paginator.listView(
          key: paginatorKey,
          scrollPhysics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 16),
          pageLoadFuture: fetchList,
          pageItemsGetter: CustomPaginator(context).listItemsGetter,
          listItemBuilder: listItemBuilder,
          loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
          errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
          emptyListWidgetBuilder: emptyListWidgetMaker,
          totalItemsGetter: CustomPaginator(context).totalPagesGetter,
          pageErrorChecker: CustomPaginator(context).pageErrorChecker),
    );
  }

  Future<CouponListResponse> fetchList(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    CouponListRequest payload = CouponListRequest();
    payload.pageNumber = page;
    payload.pageSize = 20;
    payload.personId = prefs!.getInt(Strings.userId).toString();
    var data = jsonEncode(payload);
    var res = await Calls().call(data, context, Config.MYCOUPONLIST);

    return CouponListResponse.fromJson(res);
  }

  Widget listItemBuilder(value, int index) {
    CouponListItem item = value;
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CouponDetailPage(
                        couponData: item,
                        showQr: true,
                      )));
          // Navigator.push(context, MaterialPageRoute(builder: (context)=> CouponDetailPage(item:item)));
        },
        child: Container(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: appListCard(
            // elevation: 3,
            padding: EdgeInsets.all(0),
            child: CouponListItemCard(
              imageWidth: 124,
              imageHeight: 124,
              title: item.couponProvider,
              imageUrl: item.couponImage,
              discount: item.couponDiscount,
              discountType: item.couponDiscountType,
              rewardPoints: item.rewardPointsRequired,
              isCoinsHide: true,
              validTill: Utility()
                  .getDateFormat("dd-MMM-yyyy", DateTime.parse(item.validTill!)),
              isActive: item.couponStatus == COUPON_STATUS.Active.type,
            ),
          ),
        ));
  }

  Widget emptyListWidgetMaker(CouponListResponse? pageData) {
    return CustomPaginator(context).emptyListWidgetMaker(pageData,
        message: AppLocalizations.of(context)!.translate('coming_soon'));
  }
}

class CouponHistoryListPage extends StatefulWidget {
  @override
  _CouponHistoryListPage createState() => _CouponHistoryListPage();
}

class _CouponHistoryListPage extends State<CouponHistoryListPage> {
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  SharedPreferences? prefs;
  String? searchVal;
  List<CommonCardData> couponList = [];

  @override
  void initState() {
    super.initState();
  }

  void onsearchValueChanged(String text) {
    searchVal = text;
    refresh();
  }

  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
  }

  Future<Null> refreshList() async {
    refresh();
    await new Future.delayed(new Duration(seconds: 2));

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return appListCard(
      child: RefreshIndicator(
        onRefresh: refreshList,
        child: Paginator.listView(
            key: paginatorKey,
            scrollPhysics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 8, bottom: 8),
            pageLoadFuture: fetchList,
            pageItemsGetter: CustomPaginator(context).listItemsGetter,
            listItemBuilder: listItemBuilder,
            loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
            errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
            emptyListWidgetBuilder:
                CustomPaginator(context).emptyListWidgetMaker,
            totalItemsGetter: CustomPaginator(context).totalPagesGetter,
            pageErrorChecker: CustomPaginator(context).pageErrorChecker),
      ),
    );
  }

  Future<CouponHistoryResponse> fetchList(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    CouponListRequest request = CouponListRequest();
    request.personId = prefs!.getInt(Strings.userId).toString();
    request.pageNumber = page;
    request.pageSize = 10;
    var data = jsonEncode(request);
    var res = await Calls().call(data, context, Config.COUPON_LEDGER_LIST);

    return CouponHistoryResponse.fromJson(res);
  }

  Widget listItemBuilder(value, int index) {
    CouponHistoryItem item = value;
    return GestureDetector(
        onTap: () {},
        child: CouponHistoryItemCard(
          title: item.transactionType,
          dayOfMonth:
              Utility().getDateFormat("d", DateTime.parse(item.createdDate!)),
          month: Utility()
              .getDateFormat("MMM", DateTime.parse(item.createdDate!))
              .toUpperCase(),
          rewardPoints: _rewardPoints(item),
          currencyCode: item.currencyCode,
          isDeduct: _isdeduct(item),
        ));
  }

  String _rewardPoints(CouponHistoryItem item) {
    var points;
    var cr = double.parse(item.rewardsCr!).round();
    var dr = double.parse(item.rewardsDr!).round();
    if (cr != 0) {
      points = cr;
    } else if (dr != 0) {
      points = dr;
    } else {
      points = 0;
    }
    return points.toString();
  }

  bool _isdeduct(CouponHistoryItem item) {
    var points;
    var cr = double.parse(item.rewardsCr!).round();
    var dr = double.parse(item.rewardsDr!).round();
    if (cr != 0) {
      points = false;
    } else if (dr != 0) {
      points = true;
    } else {
      points = false;
    }
    return points;
  }
}
