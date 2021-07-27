import 'dart:convert';

import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';

class CurrencySelectPage extends StatefulWidget {
  @override
  CurrencySelectPageState createState() => CurrencySelectPageState();
}

class CurrencySelectPageState extends State<CurrencySelectPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: appAppBar().getCustomAppBarWithSearch(context,
            onSearchValueChanged: (value) {},
            appBarTitle: 'Currency List', onBackButtonPress: () {Navigator.pop(context);},

          ),
          body: appListCard(
            child: Paginator.listView(
                pageLoadFuture: fetchList,
                pageItemsGetter: CustomPaginator(context).listItemsGetter,
                listItemBuilder: listItemBuilder,
                loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
                errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
                totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                pageErrorChecker: CustomPaginator(context).pageErrorChecker),
          ),
        ));
  }

  Future<PostCreateResponse> fetchList(int page) async{
    PostCreateResponse model = PostCreateResponse();
    model.statusCode ="S10003";
    model.rows = null;
    model.message ="SUCCESS";
    model.total=0;
    return PostCreateResponse.fromJson(jsonDecode(jsonEncode(model)));
  }

  Widget listItemBuilder(itemData, int index) {
    return Container();
  }
}
