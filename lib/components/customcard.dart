import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';

import 'commonComponents.dart';

// ignore: must_be_immutable
class TricycleCard extends StatelessWidget{

  Widget child;
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  Function? onTap;
  Color? color;
  double borderRadius= 12.0;
  TricycleCard({required this.child,this.margin,this.padding,this.onTap,this.color});

  @override
  Widget build(BuildContext context) {
    Utility().screenUtilInit(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [CommonComponents().getShadowforBox()],
      ),
      margin: margin??=EdgeInsets.only(left: 8, right: 8.0, top: 6.0, bottom: 6.0),
      padding: EdgeInsets.all(0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)
        ),
        margin: EdgeInsets.all(0),
        color: color,
        elevation: 0,
        child: InkWell(
          onTap: onTap as void Function()?,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding??=EdgeInsets.only(top: 8,bottom: 8,left: 16,right: 16),
            child: child,
          ),
        ),
      ),
    );

  }

}

// ignore: must_be_immutable
class TricycleListCard extends StatelessWidget{
  Widget child;
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  Function? onTap;
  Color? color;
  double borderRadius= 12.0;
  Clip? clip;
  TricycleListCard({required this.child,this.margin,this.padding,this.onTap,this.color,this.clip});

  @override
  Widget build(BuildContext context) {
    Utility().screenUtilInit(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [CommonComponents().getShadowforBox()],
      ),
      margin: margin??=EdgeInsets.only(left:8,right: 8,top:4,bottom: 4),
      padding: EdgeInsets.all(0),
      child: Card(
        clipBehavior: clip,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)
        ),
        margin: EdgeInsets.all(0),
        color: color,
        elevation: 0,
        child: InkWell(
          onTap: onTap as void Function()?,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding??=EdgeInsets.only(top: 8,bottom: 4,left: 8,right: 8),
            child: child,
          ),
        ),
      ),
    );

  }
}