import 'package:oho_works_app/models/base_res.dart';
import 'package:flutter/material.dart';

class PrivateAccountCard extends StatelessWidget {
  final CommonCardData? data;
  PrivateAccountCard({this.data});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
          contentPadding: EdgeInsets.only(top: 0, bottom: 0),
          leading: Icon(Icons.lock_outline_rounded,size: 70,),
          title: Text("This Account is Private , Follow user to see profile"
              "",textAlign: TextAlign.start,)),
    );
  }
}
