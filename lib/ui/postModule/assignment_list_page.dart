import 'package:flutter/material.dart';

class AssignmentListPage extends StatefulWidget {
  @override
  AssignmentListPageState createState() => AssignmentListPageState();
}

class AssignmentListPageState extends State<AssignmentListPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (BuildContext context, int index){
        return ListTile(
          title: Text(
            "index $index"
          ),
        );
      },
    );
    // return Paginator.listView(
    //   pageLoadFuture: fetchList,
    //   pageItemsGetter: CustomPaginator(context).listItemsGetter,
    //   listItemBuilder: listItemBuilder,
    //   loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
    //   errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
    //   emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
    //   totalItemsGetter: CustomPaginator(context).totalPagesGetter,
    //   pageErrorChecker: CustomPaginator(context).pageErrorChecker,
    // );
  }
}
