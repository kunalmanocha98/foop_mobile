import 'package:flutter/material.dart';


class TricycleTextButton extends StatelessWidget {
  final Function? onPressed;
  final String? buttonText;
  final Widget? child;
  final Color? color;
  final OutlinedBorder? shape;
  final EdgeInsets? padding;
  final double? elevation;


  TricycleTextButton(
      {required this.onPressed, this.buttonText, this.child,this.color,this.shape,this.padding,this.elevation});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed as void Function()?,
        style: TextButton.styleFrom(
          shape: shape,
          backgroundColor: color,
          elevation: elevation,
        ),

        child:Padding(
          padding: padding ??  EdgeInsets.only(left:6,right: 6),
          child: child,
        ));
  }
}

class TricycleElevatedButton extends StatelessWidget {
  final Function? onPressed;
  final String? buttonText;
  final Widget? child;
  final Color? color;
  final OutlinedBorder? shape;
  final EdgeInsets? padding;
  final double? elevation;

  TricycleElevatedButton({required this.onPressed, this.buttonText, this.child,this.color,this.shape, this.padding, this.elevation
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed as void Function()?,
        style: ElevatedButton.styleFrom(
          shape: shape,
          primary: color,
          elevation: elevation,
        ),

        child:Padding(
          padding: padding ??  EdgeInsets.only(left:6,right: 6),
          child: child,
        ));
  }
}
//
// class ShopperOutlinedButton extends StatelessWidget {
//   final Function onPressed;
//   final String buttonText;
//   final Color textColor;
//
//   ShopperOutlinedButton(
//       {@required this.onPressed, this.buttonText, this.textColor});
//
//   @override
//   Widget build(BuildContext context) {
//     return OutlinedButton(
//         onPressed: onPressed,
//         child: Text(
//           buttonText ??
//               ShopperLocalizations(context).localization.button_placeholder,
//           style: ShopperTextStyles.caption
//               .copyWith(color: textColor ?? ShopperColor.appMainColor),
//         ));
//   }
// }
//
// class ShopperAppBarActionTextButton extends StatelessWidget {
//   final Function onPressed;
//   final String buttonText;
//   final Color textColor;
//
//   ShopperAppBarActionTextButton(
//       {@required this.onPressed, this.buttonText, this.textColor});
//
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//         onPressed: onPressed,
//         child: Text(
//           buttonText ??
//               ShopperLocalizations(context).localization.button_placeholder,
//           style: ShopperTextStyles.caption
//               .copyWith(color: textColor ?? ShopperColor.appMainColor),
//         ));
//   }
// }
