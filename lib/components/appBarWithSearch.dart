import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

// class AppBarWithSearch extends StatelessWidget implements PreferredSizeWidget {
//   TextStyleElements styleElements;
//   String appBarTitle;
//   double elevation;
//   Function onBackButtonPress;
//   Color backgroundColor;
//   List<Widget> actions;
//   bool centerTitle;
//   Widget icon;
//   double height;
//   Function(String value) searchValue;
//   bool isSearchVisible;
//   bool isIconVisible;
//
//   AppBarWithSearch({@required this.appBarTitle,
//     @required this.onBackButtonPress,
//     @required this.height,
//     this.backgroundColor,
//     this.elevation,
//     this.centerTitle,
//     this.icon,
//     this.searchValue,
//     this.isIconVisible,
//     this.actions,
//     this.isSearchVisible});
//
//   @override
//   Widget build(BuildContext context) {
//     styleElements = TextStyleElements(context);
//     return Container(
//       color: HexColor(AppColors.appColorTransparent),
//       child: Wrap(
//         children: [
//           AppBar(
//             iconTheme: IconThemeData(
//               color: HexColor(AppColors.appColorBlack35), //change your color here
//             ),
//             title: Text(
//               appBarTitle,
//               style: styleElements.headline5ThemeScalable(context),
//             ),
//             backgroundColor: HexColor(AppColors.appColorTransparent),
//             elevation: elevation ??= 0.0,
//             leading: Visibility(
//               visible: isIconVisible??=true,
//               child: GestureDetector(
//                 behavior: HitTestBehavior.translucent,
//                 onTap: onBackButtonPress,
//                   child: icon ??= Icon(
//                     Icons.keyboard_backspace_rounded,
//                     size: 20.h,
//                     // add custom icons also
//                   ),
//               ),
//             ),
//             actions: actions,
//             centerTitle: centerTitle ??= true,
//           ),
//           Visibility(
//             visible: isSearchVisible ??= false,
//             child: SearchBox(onvalueChanged: searchValue,
//               hintText: "search",),
//           )
//         ],
//       ),
//     );
//   }
//
//   @override

//   Size get preferredSize => Size.fromHeight(height);
//
// }

class TricycleAppBar {
  getCustomAppBarWithProfileImage(BuildContext context,
      {required String appBarTitle,
        required Function onBackButtonPress,
        Color? backgroundColor,
        double? elevation,
        required String imageUrl,
        bool? centerTitle,
        List<Widget>? actions,
        Widget? icon,
        bool? isIconVisible,
        bool? isNext,
        Color? appTitleColor,
        Color? iconColor}) {
    TextStyleElements styleElements = TextStyleElements(context);
    return AppBar(
      iconTheme: IconThemeData(
        color: iconColor ??=
            HexColor(AppColors.primaryTextColor), //change your color here
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Visibility(
              visible: isIconVisible ??= true,
              child: IconButton(
                icon: icon ??= Icon(
                  Icons.keyboard_backspace_rounded,
                  size: 20,
                  // add custom icons also
                ),
                onPressed: onBackButtonPress as void Function()?,
              )),
          Text(
            appBarTitle,
            // ignore: unnecessary_null_comparison
            style: appBarTitle != null
                ? styleElements
                .headline6ThemeScalable(context)
                .copyWith(color: appTitleColor,fontWeight: FontWeight.w600)
                : styleElements.headline5ThemeScalable(context),
          ),
        ],
      ),
      backgroundColor: backgroundColor ??= HexColor(AppColors.appColorTransparent),
      elevation: elevation ??= 0.0,
      leading: Visibility(
          visible: isIconVisible,
          child: IconButton(
            icon: icon,
            onPressed: onBackButtonPress as void Function()?,
          )),
      actions: actions,
      centerTitle: centerTitle ??= true,
      brightness: Brightness.light,
    );
  }


  getCustomAppBar(BuildContext context,
      {required String? appBarTitle,
      required Function? onBackButtonPress,
      Color? backgroundColor,
      double? elevation,
      bool? centerTitle,
      List<Widget>? actions,
      Widget? icon,
      bool? isIconVisible,
      bool? isNext,
      Color? appTitleColor,
        Widget? titleWidget,
      Color? iconColor}) {
    TextStyleElements styleElements = TextStyleElements(context);
    return AppBar(

      iconTheme: IconThemeData(
        color: iconColor ??=
            HexColor(AppColors.primaryTextColor), //change your color here
      ),
      brightness: Brightness.light,
      title: titleWidget!=null?titleWidget: Text(
        appBarTitle??"",
        style: appBarTitle != null
            ? styleElements
                .headline6ThemeScalable(context)
                .copyWith(color: appTitleColor,fontWeight: FontWeight.w600)
            : styleElements.headline5ThemeScalable(context),
      ),
      backgroundColor: backgroundColor ??= HexColor(AppColors.appColorTransparent),
      elevation: elevation ??= 0.0,
      leading: Visibility(
          visible: isIconVisible ??= true,
          child: IconButton(
            icon: icon ??= Icon(
              Icons.keyboard_backspace_rounded,
              // add custom icons also
            ),
            onPressed: onBackButtonPress as void Function()?,
          )),
      actions: actions,

      centerTitle: centerTitle ??= true,
    );
  }

  getCustomAppBarWithSearch(BuildContext context,
      {required String appBarTitle,
      required Function onBackButtonPress,
      required Function(String) onSearchValueChanged,
        TextEditingController? controller,
      String? hintText,
      Color? backgroundColor,
      double? elevation,
      bool? centerTitle,
      List<Widget>? actions,
      Widget? icon,
        Widget? titleWidget,
      bool? isIconVisible}) {
    TextStyleElements styleElements = TextStyleElements(context);
    return CustomPrefferedSizedWidget(
      height: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            iconTheme: IconThemeData(
              color: HexColor(AppColors.appColorBlack35), //change your color here
            ),
            title:titleWidget!=null?titleWidget: Text(
              appBarTitle,
              style: styleElements.headline6ThemeScalable(context)
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            brightness: Brightness.light,
            backgroundColor: backgroundColor ??= HexColor(AppColors.appColorTransparent),
            elevation: elevation ??= 0.0,
            leading: Visibility(
                visible: isIconVisible ??= true,
                child: IconButton(
                  icon: icon ??= Icon(
                    Icons.keyboard_backspace_rounded,
                    // add custom icons also
                  ),
                  onPressed: onBackButtonPress as void Function()?,
                )),
            actions: actions,
            centerTitle: centerTitle ??= true,
          ),
          SearchBox(
            controller: controller,
            onvalueChanged: onSearchValueChanged,
            hintText: hintText ??= "Search",
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomPrefferedSizedWidget extends StatelessWidget
    implements PreferredSizeWidget {
  double height;
  Widget child;

  CustomPrefferedSizedWidget({required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: HexColor(AppColors.appColorTransparent)),
      height: height,
      child: child,
    );
  }

  @override
 
  Size get preferredSize => Size.fromHeight(height);
}
