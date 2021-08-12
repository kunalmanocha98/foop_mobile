import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/paginator.dart';

class DepartmentListPage extends StatefulWidget {
  String? instituteId;

  DepartmentListPage({this.instituteId});

  @override
  _DepartmentListPage createState() => _DepartmentListPage();
}

class _DepartmentListPage extends State<DepartmentListPage> {
  @override
  Widget build(BuildContext context) {
    return Paginator.listView(
        pageLoadFuture: fetchList,
        pageItemsGetter: CustomPaginator(context).listItemsGetter,
        listItemBuilder: listItemBuilder,
        loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
        errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
        emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
        totalItemsGetter: CustomPaginator(context).totalPagesGetter,
        pageErrorChecker: CustomPaginator(context).pageErrorChecker);
  }

  Future fetchList(int page) async {
    final body = jsonEncode({
      "business_id": widget.instituteId,
      "search_val": null,
      "page_number": page,
      "page_size": 20
    });
  }

  Widget listItemBuilder(itemData, int index) {
    return Container();
  }
}
