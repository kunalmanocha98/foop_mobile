import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/profile_module/pages/basic_profile.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class OnlyTextCard extends StatelessWidget {
  final CommonCardData data;
  final String? type;
  Persondata? rows;
  Null Function()? callback;
  TextStyleElements? styleElements;
  int? userId;
  int? ownerId;
  OnlyTextCard({Key? key, required this.data, this.rows, this.callback,this.styleElements,this.type,this.ownerId,this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if(type=="person")
          {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BasicInfo(rows,callback)
                ));

            if(result!=null && result['result']=="success")
            {callback!();}

          }


        },
        child: appListCard(
          child: Container(
            padding: EdgeInsets.only(left: 16.w,right: 16.w,top: 12.h,bottom: 12.h),
            child:  Text(
               data.title!=null && data.title!="" ? data.title!: userId==ownerId?   " Add a quote":" ",
              style:styleElements!.headline6ThemeScalable(context) ,
              textAlign: TextAlign.left,
            ),
          ),
        ),
      )
      ;
  }
}
