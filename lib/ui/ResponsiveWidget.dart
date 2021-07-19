import 'package:oho_works_app/utils/sizing_info.dart';
import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final AppBar appBar;
  final Widget Function(BuildContext context, SizingInfo sizingInfo) builder;

  ResponsiveWidget(this.builder, this.appBar);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var orientation = MediaQuery.of(context).orientation;
    SizingInfo sizingInfo = SizingInfo(height, orientation, width);
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: builder(context, sizingInfo),
    ));
  }
}
