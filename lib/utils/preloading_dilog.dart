import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';

import 'app_localization.dart';

// ignore: must_be_immutable
class PreloadingViewDilog extends StatelessWidget {
  bool enabled = true;
  String url;

  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }

  PreloadingViewDilog({
    Key? key,
    required this.url,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Shimmer.fromColors(
              baseColor: HexColor(AppColors.appColorGrey300),
              highlightColor: HexColor(AppColors.appColorGrey100),
              enabled: enabled,
              child:  Stack(
               children: [Container(
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: <Widget>[
                     Align(
                         alignment: Alignment.topCenter,
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Container(
                               margin: const EdgeInsets.only(left:16,bottom: 16, top: 20,right: 16),
                               child: Text(AppLocalizations.of(context)!.translate('loading'),
                                 textAlign: TextAlign.center,
                               ),
                             ),
          Center(
          child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator()),
    )
                           ],
                         )),
                     Visibility(

                         child: Flexible(
                           child: ListView(
                             shrinkWrap: true,
                             scrollDirection: Axis.vertical,
                             padding: EdgeInsets.all(8.0),
                             children: [CheckboxListTile(
                               title: Text(AppLocalizations.of(context)!.translate('pls_wait'),

                               ),
                               value: false,
                               onChanged: (val) {
                               },
                             ),
                               CheckboxListTile(
                                 title: Text(AppLocalizations.of(context)!.translate('pls_wait'),

                                 ),
                                 value: false,
                                 onChanged: (val) {
                                 },
                               ),



                             ],
                           ),
                         )),
                     Visibility(

                         child: Container(
                           margin: const EdgeInsets.only(top: 16, bottom: 16),
                           child: Column(
                             children: <Widget>[
                               RatingBar.builder(
                                 initialRating:
                                 0.0,
                                 minRating: 0,
                                 direction: Axis.horizontal,
                                 allowHalfRating: false,
                                 itemCount: 5,
                                 itemSize: 36.0,
                                 itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                 itemBuilder: (context, _) => Icon(
                                   Icons.star_border,
                                   color: HexColor(AppColors.appMainColor),
                                 ),
                                 onRatingUpdate: (rating) {
                                   print(rating);

                                 },
                               ),


                             ],
                           ),
                         )),
                     Divider(
                       height: 2,
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         GestureDetector(
                           onTap: () {
                             Navigator.pop(context, null);
                           },
                           child: Container(
                             margin:
                             const EdgeInsets.only(right: 30, top: 16, bottom: 16),
                             child: Text(
                               AppLocalizations.of(context)!.translate('cancel'),
                             ),
                           ),
                         ),
                         Container(
                             height: 50,
                             child: VerticalDivider(
                               color: HexColor(AppColors.appColorGrey500),
                               width: 2,
                             )),
                         GestureDetector(
                             onTap: () {

                             },
                             child: Container(
                               margin: const EdgeInsets.only(
                                   left: 30, top: 16, bottom: 16),
                               child: Text(
                                 AppLocalizations.of(context)!.translate('submit'),
                               ),
                             ))
                       ],
                     )
                   ],
                 ),
               )],
              )
            ),
          ),
        ],
      ),
    );
  }
}
