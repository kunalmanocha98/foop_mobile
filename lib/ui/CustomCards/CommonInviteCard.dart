import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/ui/invitations/invitation_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CommonInviteCard extends StatelessWidget {
  CommonCardData data;
  TextStyleElements? styleElements;
  String? type;
  CommonInviteCard({Key? key, required this.data,this.styleElements,this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return GestureDetector(
      behavior:HitTestBehavior.translucent,
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  InvitationPage(),
            ));
      },
      child: TricycleListCard(
          color: HexColor(AppColors.appMainColor),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Align(
                    alignment: Alignment.topLeft,
                    child: Image(
                      image:
                      AssetImage('assets/appimages/couple.png'),
                      fit: BoxFit.contain,
                      width: 92,
                      height: 92,
                    )
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(16.h),
                    child:  Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                            type=="S"?
                         AppLocalizations.of(context)!.translate("invite_parents"): AppLocalizations.of(context)!.translate("invite_friends"),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: styleElements!.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          )),
    );
  }
}
