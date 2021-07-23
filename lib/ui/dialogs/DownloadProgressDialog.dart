
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
late String dialogMessage;
double? percentProgress;
bool _isShowing = false;
BuildContext? context;
late BuildContext _dismissingContext;
_Body? dialog;
late bool dismissable;
 class UploadDownloadDialog {
  UploadDownloadDialog({
    String? message,
  double? progress,
    bool? barrierDismissable,
  BuildContext? buildContext}) {
     dialogMessage = message??='Please Wait....';
     percentProgress = progress??=0.0;
     context = buildContext;
     dismissable =  barrierDismissable ?? false;
  }
  bool isShowing() {
    return _isShowing;
  }

  Future<bool> hide() async {
    try {
      if (_isShowing) {
        _isShowing = false;
        Navigator.of(_dismissingContext).pop();
        // if (false) debugPrint('ProgressDialog dismissed');
        return Future.value(true);
      } else {
        // if (false) debugPrint('ProgressDialog already dismissed');
        return Future.value(false);
      }
    } catch (err) {
      debugPrint('Seems there is an issue hiding dialog');
      debugPrint(err.toString());
      return Future.value(false);
    }
  }
  Future<bool> show() async {
    try {
      if (!_isShowing) {
        _isShowing = true;
        dialog =  _Body();
        showDialog<dynamic>(
          context: context!,
          barrierDismissible: dismissable,
          builder: (BuildContext context) {
            _dismissingContext = context;
            return WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                  backgroundColor: HexColor(AppColors.appColorWhite),
                  insetAnimationDuration: Duration(milliseconds: 100),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(8))),
                  child: dialog),
            );
          },
        );
        // Delaying the function for 200 milliseconds
        // [Default transitionDuration of DialogRoute]
        // await Future.delayed(Duration(milliseconds: 200));
        // if (false) debugPrint('ProgressDialog shown');

        return true;
      } else {
        // if (false) debugPrint("ProgressDialog already shown/showing");
        return false;
      }
    } catch (err) {
      _isShowing = false;
      debugPrint('Exception while showing the dialog');
      debugPrint(err.toString());
      return false;
    }
  }

   void update({double? progress}){
    print("*********** Update Progress $progress****************");
    percentProgress = progress;
    if (_isShowing) dialog!.update();
  }
}

// ignore: must_be_immutable
class _Body extends StatefulWidget{
  _BodyState dialog = _BodyState();
  @override
  _BodyState createState()=> dialog;

  void update() {
    dialog.update();
  }

}
class _BodyState extends State<_Body>{
  @override
  void dispose() {
    _isShowing = false;
    // if (false) debugPrint('ProgressDialog dismissed by back button');
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    print("**********  Dialog Progress $percentProgress *************");
    return Container(
      padding: EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 8),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:  EdgeInsets.only(left:8.0),
            child: Text(dialogMessage,
              style: styleElements.headline6ThemeScalable(context),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LinearPercentIndicator(
              percent: percentProgress!/100,
              lineHeight: 24,
              animation: true,
              progressColor: HexColor(AppColors.appMainColor),
              animateFromLastPercent: true,
              center: Text(
                '$percentProgress%',
                style: styleElements.subtitle1ThemeScalable(context).copyWith(
                  color: percentProgress!>45?HexColor(AppColors.appColorWhite):HexColor(AppColors.appColorBlack85)
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      )
    );
  }

  void update() {
    setState(() {

    });
  }

}

