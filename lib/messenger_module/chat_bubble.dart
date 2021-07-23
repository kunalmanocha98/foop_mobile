import 'package:oho_works_app/messenger_module/chat_bubble_clipper_2.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';

import 'bubble_type.dart';


class ChatBubble extends StatelessWidget {
  final CustomClipper<Path> clipper;
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? backGroundColor;
  final Color? shadowColor;
  final Alignment? alignment;

  ChatBubble({
     required this.clipper,
     this.child,
     this.margin,
     this.elevation,
     this.backGroundColor,
     this.shadowColor,
     this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.topLeft,
      margin: margin ?? EdgeInsets.all(0),
      child: PhysicalShape(
        clipper: clipper,
        elevation: elevation ?? 2,
        color: backGroundColor ?? HexColor(AppColors.appMainColor),
        shadowColor: shadowColor ?? Colors.grey.shade200,
        child: Padding(
          padding: setPadding(),
          child: child ?? Container(),
        ),
      ),
    );
  }

  EdgeInsets setPadding() {
     if (clipper is ChatBubbleClipper2) {
      if ((clipper as ChatBubbleClipper2).type == BubbleType.sendBubble) {
        return EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 25);
      } else {
        return EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 10);
      }
    }

    return EdgeInsets.all(10);
  }
}
