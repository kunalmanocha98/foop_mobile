import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/profile_module/pages/basic_profile.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class BioCard extends StatelessWidget {
  final CommonCardData data;

  // int colorCode = 0xFFEF9A9A;
  Persondata persondata;
  Null Function() callback;
  BuildContext context;
  TextStyleElements styleElements;
  int userId;
  int ownerId;
String type;
  BioCard({Key key, @required this.data, this.persondata, this.callback,this.type,this.ownerId,this.userId})
      : super(key: key);

  // Widget _simplePopup() => PopupMenuButton<int>(
  //       itemBuilder: (context) => [
  //         PopupMenuItem(
  //           value: 1,
  //           child: Text("Update Bio"),
  //         ),
  //       ],
  //       onSelected: (value) async {
  //         var result = await Navigator.push(context,
  //             MaterialPageRoute(builder: (context) => BasicInfo(persondata,callback)));
  //
  //         if (result != null && result['result'] == "success") {
  //           callback();
  //         }
  //       },
  //       icon: Icon(
  //         Icons.more_horiz,
  //         size: 30,
  //         color: HexColor(AppColors.appColorBlack85),
  //       ),
  //     );

  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if(type=="person")
          {
            var result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => BasicInfo(persondata,callback)));

            if (result != null && result['result'] == "success") {
              callback();
            }
          }

      },
      child: TricycleListCard(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 16.0.h,
                          right: 16.h,
                          top: 12.h,
                          bottom: 12.h),
                      child: Text(
                        data.title ?? "",
                        style: styleElements
                            .headline6ThemeScalable(context)
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: HexColor(AppColors.appColorBlack85)),
                        textAlign: TextAlign.left,
                      ),
                    )),
                flex: 3,
              ),
              Visibility(
                visible: type=="person",
                child: Flexible(
                  child:
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                        alignment: Alignment.topRight,
                        child:  GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            var result = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) => BasicInfo(persondata,callback)));

                            if (result != null && result['result'] == "success") {
                              callback();
                            }

                          },
                          child: Icon(
                            Icons.add,
                            size: 30,
                            color: HexColor(AppColors.appColorBlack85),
                          ),
                        )),
                  ),

                  flex: 1,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h),
            child: Text(
            data.textOne!=null &&  data.textOne!=""?  data.textOne:userId==ownerId? "Write Something About You ":"  ",
              style: styleElements.subtitle1ThemeScalable(context),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      )),
    );
  }
}
