import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StudentCard extends StatelessWidget {
  final CommonCardData data;
  BuildContext? context;
  TextStyleElements? styleElements;
  // Widget _simplePopup() => PopupMenuButton<int>(
  //       itemBuilder: (context) => [
  //         PopupMenuItem(
  //           value: 1,
  //           child: Text(
  //               AppLocalizations.of(context).translate('add_new_language')),
  //         ),
  //       ],
  //       onSelected: (value) {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => EditLanguage(),
  //             ));
  //       },
  //       icon: Icon(
  //         Icons.more_horiz,
  //         size: 30,
  //         color: HexColor(AppColors.appColorBlack85),
  //       ),
  //     );

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

  StudentCard({Key? key, required this.data,this.styleElements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    return GestureDetector(
      onTap: () {},
      child: TricycleListCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: ListTile(
                leading: Positioned(
                  left: 20,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image:
                              CachedNetworkImageProvider("https://picsum.photos/200/300"),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                title: Text(data.textOne ?? ""),
                subtitle: Text(data.textTwo ?? ""),
                trailing: Visibility(
                  child: Container(
                    child: TricycleElevatedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: BorderSide(
                            color:  HexColor(AppColors.appMainColor),
                          )),
                      onPressed: () {},
                      color:  HexColor(AppColors.appMainColor),
                      child: Text(
                          AppLocalizations.of(context)!.translate('follow'),
                          style: styleElements!.subtitle1ThemeScalable(context).copyWith(
                            color:  HexColor(AppColors.appColorWhite),
                          )),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
