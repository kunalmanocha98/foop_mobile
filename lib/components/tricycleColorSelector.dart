import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/models/post/colorList.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TricycleColorSelector extends StatefulWidget{
  Function(String ? selectedColor)? onColorSelect;
  bool isHeadingShown;
  TricycleColorSelector({this.onColorSelect,this.isHeadingShown=true});
  @override
  _TricycleColorSelector createState() => _TricycleColorSelector(onColorSelect: onColorSelect);
}

class _TricycleColorSelector extends State<TricycleColorSelector> {
  Function(String? selectedColor)? onColorSelect;
  _TricycleColorSelector({this.onColorSelect});
  late TextStyleElements styleElements;
  List<ColorListItem>? colorList = [];


  @override
  void initState() {
    super.initState();
    fetchColors();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
      color: HexColor(AppColors.appColorWhite),
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: widget.isHeadingShown,
            child: Padding(
              padding: const EdgeInsets.only(left:16.0,right: 24),
              child: Text(AppLocalizations.of(context)!.translate('select_priority'),style: styleElements.captionThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack85)),),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: colorList!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: (){
                    onColorSelect!(colorList![index].code);
                  },
                  child: Container(
                      padding: EdgeInsets.only(top:12,bottom: 12,left: 12,right: 12),
                      height: 40,
                      width: 40,
                    child: Container(
                      decoration: BoxDecoration(
                          color: HexColor(colorList![index].code! ),
                          shape: BoxShape.circle
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void fetchColors() {
    var data = jsonEncode({"type":null});
    Calls().call(data, context,Config.COLOR_LIST).then((value){
      var res = ColorListResponse.fromJson(value);
      setState(() {
        colorList = res.rows;
      });
    });
  }

}