import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:oho_works_app/ui/dialogs/DownloadProgressDialog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastBuilder {
  ProgressDialog pr;

  void showSnackBar(String message, BuildContext context, Color color,
      {Color textColor}) {
    final snackBar = new SnackBar(
        content: new Text(
          message,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
          textAlign: TextAlign.center,
        ),
        backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackBar) ;

    /* Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor:color!=null ? color: HexColor(AppColors.information),
        textColor: HexColor(AppColors.appColorBlack85),
        fontSize: 16.0);*/
  }

  void showToast(String message, BuildContext context, Color color) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: color,
        textColor: HexColor(AppColors.appColorBlack85),
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        toastLength: Toast.LENGTH_SHORT);
  }

  ProgressDialog setProgressDialog(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: "Please Wait......",
        borderRadius: 8.0,
        backgroundColor: HexColor(AppColors.appColorWhite),
        progressWidget: Container(
          height: 20,
          width: 20,
          child: new Center(child: new CircularProgressIndicator()),
        ),
        elevation: 10.0,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: styleElements.subtitle2ThemeScalable(context),
        messageTextStyle: styleElements.headline6ThemeScalable(context));
    return pr;
  }

  UploadDownloadDialog setProgressDialogWithPercent(
      BuildContext context, String message,
      {bool barrierDismissable}) {
    // TextStyleElements styleElements = TextStyleElements(context);
    var pr = UploadDownloadDialog(
        progress: 0.0,
        buildContext: context,
        message: message,
        barrierDismissable: barrierDismissable);
    // pr = ProgressDialog(context,
    //     type: ProgressDialogType.Download, isDismissible: false, showLogs: false);
    // pr.style(
    //     message: message,
    //     borderRadius: 8.0,
    //     backgroundColor: HexColor(AppColors.appColorWhite),
    //     elevation: 10.0,
    //     progress: 0.0,
    //     maxProgress: 100.0,
    //     progressTextStyle: styleElements.subtitle2ThemeScalable(context),
    //     messageTextStyle: styleElements.headline6ThemeScalable(context));
    return pr;
  }

  Future<void> stopProgress(ProgressDialog pr) async {
    await pr.hide();
  }

  void showCustomSnackBar({
    @required String message,
    bool isButtonView = false,
    String okButtonText = "ok",
    String cancelButtonText = "cancel",
    Function okButtonCallback,
    Function cancelButtonCallback,
    BuildContext context,
    Color textColor = Colors.white,
    Color backGroundColor,
    Duration duration = const Duration(milliseconds: 4000),
  }) {
    backGroundColor ??= HexColor(AppColors.appMainColor);
    final snackBar = new SnackBar(
        duration: duration,
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: TextStyleElements(context)
                    .subtitle2ThemeScalable(context)
                    .copyWith(color: textColor, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              isButtonView
                  ? Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TricycleTextButton(
                        onPressed: cancelButtonCallback,
                        color: HexColor(AppColors.appColorLightGreen),
                        shape: StadiumBorder(),
                        child: Text(
                          cancelButtonText,
                          style: TextStyleElements(context)
                              .captionThemeScalable(context)
                              .copyWith(
                              color:
                              HexColor(AppColors.appColorWhite),
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TricycleTextButton(
                        onPressed: okButtonCallback,
                        color: HexColor(AppColors.appColorWhite),
                        shape: StadiumBorder(),
                        child: Text(
                          okButtonText,
                          style: TextStyleElements(context)
                              .captionThemeScalable(context)
                              .copyWith(
                              color:
                              HexColor(AppColors.appColorBlack65),
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                ],
              )
                  : Container(),
            ],
          ),
        ),
        backgroundColor: backGroundColor);
    ScaffoldMessenger.of(context).showSnackBar(snackBar) ;
  }
}
