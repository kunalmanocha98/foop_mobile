import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/menu/menulistmodels.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TricycleMenuItem extends StatefulWidget{
  Data item;
  Function(String code) onMenuItemClick;
  TricycleMenuItem({this.item,this.onMenuItemClick});
  @override
  TricycleMenuItemState createState() =>  TricycleMenuItemState(menuItem:item);
}

class TricycleMenuItemState extends State<TricycleMenuItem>{
  Data menuItem;
  TricycleMenuItemState({this.menuItem});
  TextStyleElements styleElements;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return TricycleListCard(
      padding: EdgeInsets.all(0),
      onTap: (){
        widget.onMenuItemClick(menuItem.code);
      },
        child: Container(
          child: Stack(

            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top:16,left: 16),
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(menuItem.imageUrl)
                      )
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding:  EdgeInsets.only(top:12.0,left: 12,right: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(child: Text(menuItem.title,maxLines: 2,overflow: TextOverflow.ellipsis,style: styleElements.subtitle1ThemeScalable(context))),
                          Flexible(child: Text(menuItem.description,maxLines: 2,overflow: TextOverflow.ellipsis,style: styleElements.subtitle2ThemeScalable(context).copyWith(
                            color: HexColor(AppColors.primaryTextColor35)
                          ),))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: false,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        color: HexColor(AppColors.appMainColor),
                        shape: BoxShape.circle
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

}