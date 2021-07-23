import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TricycleUserImageList extends StatelessWidget {
  final int itemExtent=4;
  final List<String?>? listOfImages;
  int? totalItems;
  int? leftoveritems;
  TricycleUserImageList({this.listOfImages});
  late TextStyleElements styleElements;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    print(listOfImages);
    return (listOfImages != null && listOfImages!.length > 0)
        ? Container(
      height: 38,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: getLength(),
        itemBuilder: (BuildContext context, int index) {
          return (index!=totalItems)?Padding(
            padding: EdgeInsets.only(top:4,bottom: 4,left: 2,right: 2),
            child: TricycleAvatar(
              size: 30,
              key: UniqueKey(),
              resolution_type: RESOLUTION_TYPE.R64,
              service_type: SERVICE_TYPE.PERSON,
              imageUrl:listOfImages![index],
            ),
          ):Center(
            child: leftoveritems==0?Container():Text(
              " +$leftoveritems more",
              style: styleElements.captionThemeScalable(context).copyWith(
                  color: HexColor(AppColors.appColorBlack35)
              ),
            ),
          );
        },
      ),
    )
        : Container();
  }

  getLength() {
    if(listOfImages!=null && listOfImages!.length>0){
      if(listOfImages!.length<itemExtent){
        totalItems = listOfImages!.length;
        leftoveritems = 0;
        return listOfImages!.length+1;
      }else{
        leftoveritems = listOfImages!.length-itemExtent;
        totalItems = itemExtent;
        return itemExtent+1;
      }
    }else{
      leftoveritems=0;
      totalItems =0;
      return 0;
    }
  }
}
