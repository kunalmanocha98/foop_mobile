import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class TricycleProgressButton extends StatefulWidget{
  final double progressSize;
  final EdgeInsets padding;
  final Color progressColor;
  final ShapeBorder shape;
  final Function onPressed;
  final Color color;
  final Widget child;
  final Color splashColor;
  final double elevation;
  TricycleProgressButton({Key key,this.elevation,this.splashColor,this.progressColor,this.padding,this.progressSize,this.shape,this.onPressed,this.color,this.child}):super(key: key);
  @override
  TricycleProgressButtonState createState() => TricycleProgressButtonState();
}

class TricycleProgressButtonState extends State<TricycleProgressButton>{
  bool isProgress = false;
  TextStyleElements styleElements;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
      child: _getTricycleElevatedButton()
    );
  }

  Widget get _getChild{
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: isProgress,
            child: Padding(
          padding: EdgeInsets.only(left: 4,right: 8),
              child: SizedBox(
                height: widget.progressSize!=null?widget.progressSize:16,
                width: widget.progressSize!=null?widget.progressSize:16,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(widget.progressColor!=null?widget.progressColor:HexColor(AppColors.appMainColor)),
                ),
              ),
        )),
        widget.child,
      ],
    );
  }


  Widget _getTricycleElevatedButton(){
    return TricycleElevatedButton(
      onPressed: isProgress?(){}:widget.onPressed,
      child: _getChild,
      shape: widget.shape,
      color: widget.color,
      padding: widget.padding,
      elevation: widget.elevation,
    );
  }
  void show(){
    setState(() {
      isProgress = true;
    });
  }

  void hide(){
    setState(() {
      isProgress = false;
    });
  }

}