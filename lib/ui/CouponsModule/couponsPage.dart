import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/ui/CouponsModule/CouponsListPage.dart';
import 'package:oho_works_app/ui/CouponsModule/couponpageheadercard.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CouponsPage extends StatefulWidget {
  @override
  _CouponsPage createState() => _CouponsPage();
}

class _CouponsPage extends State<CouponsPage>
    with SingleTickerProviderStateMixin {
  List<CustomTabMaker> list = [];
  int _currentPosition = 0;
  TabController _tabController;
  TextStyleElements styleElements;
  GlobalKey<CouponPageHeaderCardState> couponPageHeaderKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadPages());
  }

  onPositionChange() {
    if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
        _currentPosition = _tabController.index;
      });
    }
  }

  loadPages() {
    list.add(CustomTabMaker(
        statelessWidget: CouponsListPage(headerKey: couponPageHeaderKey),
        tabName: AppLocalizations.of(context).translate('coupons')));
    list.add(CustomTabMaker(
        statelessWidget: RedeemedCouponsListPage(), tabName: AppLocalizations.of(context).translate('my_coupons')));
    list.add(CustomTabMaker(
        statelessWidget: CouponHistoryListPage(), tabName: AppLocalizations.of(context).translate('history')));
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
        appBar: TricycleAppBar().getCustomAppBar(context, appBarTitle: AppLocalizations.of(context).translate('rewards'),
            onBackButtonPress: () {
              Navigator.pop(context);
            }),
        body: DefaultTabController(
          length: list.length,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: TricycleCard(
                    child: CouponPageHeaderCard(
                      key: couponPageHeaderKey,
                    ),
                  ),
                ),
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
                          labelPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          isScrollable: false,
                          tabs: List<Widget>.generate(list.length, (int index) {
                            return new Tab(
                              child: TricycleTabButton(
                                onPressed: () {
                                  _tabController.animateTo(index);
                                  if (this.mounted) {
                                    setState(() {
                                      _currentPosition = index;
                                    });
                                  }
                                },
                                isActive: index == _currentPosition,
                                tabName: list[index].tabName,
                              ),
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
                return new Center(child: list[_currentPosition].statelessWidget);
              }),
            ),
          ),
        )
    ));
  }
}
