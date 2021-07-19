import 'package:flutter/cupertino.dart';

class CustomTabMaker {
  String tabName;
  Widget statelessWidget;

  CustomTabMaker({this.tabName, this.statelessWidget});
}

class CustomTabBarMaker<T>{
  String tabName;
  T statelessWidget;

  CustomTabBarMaker({this.tabName, this.statelessWidget});
}
