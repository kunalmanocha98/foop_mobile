import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BlockUserListItem extends StatelessWidget {
  CommonCardData data;
  int position;
  BuildContext context;
  Null Function(int index) callback;
  TextStyleElements styleElements;

  BlockUserListItem({
    Key key,
    @required this.data,
    @required this.position,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.context = context;
    return Container(
      // child: Card(
      //   child: Padding(
      //       padding: EdgeInsets.all(10),
      //       child: Stack(
      //         children: [
      //           Row(
      //             children: [
      //               Align(
      //                 alignment: Alignment.centerLeft,
      //                 child: TricycleAvatar(
      //                   imageUrl: data.urlOne,
      //                   size: 52,
      //                 )
      //               ),
      //               Align(
      //                 alignment: AlignmentDirectional.topStart,
      //                 child: Container(
      //                   margin: EdgeInsets.only(
      //                       top: 0, left: 8, right: 8, bottom: 8),
      //                   child: Text(
      //                     data.textOne ?? "",
      //                     style: styleElements.subtitle1ThemeScalable(context),
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //           Align(
      //             alignment: Alignment.centerRight,
      //             child: GenericFollowUnfollowButton(
      //               actionByObjectType: "person",
      //               actionByObjectId: 66,
      //               actionOnObjectType: "person",
      //               actionOnObjectId: 2,
      //               engageFlag:  AppLocalizations.of(context).translate('unblock'),
      //               actionFlag: "F",
      //               isRoundedButton: true,
      //               actionDetails: [""],
      //               personName: "Savil",
      //               callback: (isCallSuccess) {
      //                 apiCallResponse(isCallSuccess);
      //               },
      //             ),
      //           ),
      //         ],
      //       )),
      // ),
    );
  }

  // void apiCallResponse(isCallSuccess) {
  //   if (isCallSuccess) callback(position);
  // }
}
