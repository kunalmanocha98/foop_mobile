import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class AcceptRejectRequestWidget extends StatefulWidget {
  AcceptRejectRequestWidget(Key key) : super(key: key);

  @override
  AcceptRejectRequestWidgetState createState() =>
      AcceptRejectRequestWidgetState();
}

class AcceptRejectRequestWidgetState extends State<AcceptRejectRequestWidget> {
  int? id;
  late String message;
  HexColor? actionButtonColor;
  bool? isButtonView;
  late String okButtonText;
  late String cancelButtonText;
  Function? okButtonCallback;
  Function? cancelButtonCallback;
  Color textColor = Colors.white;
  Color? backgroundColor;
  bool? showCard = false;

  AcceptRejectRequestWidgetState();

  @override
  Widget build(BuildContext context) {
    return showCard!
        ? Container(
      padding: EdgeInsets.all(8),
      color: backgroundColor,
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
          isButtonView!
              ? Row(
            children: [
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: TricycleTextButton(
                    onPressed: cancelButtonCallback,
                    color:actionButtonColor!=null?actionButtonColor: HexColor(AppColors.appColorLightGreen),
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
                          color: HexColor(
                              AppColors.appColorBlack65),
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
    )
        : Container();
  }

  void update({
    required String message,
    String? okButtonText,
    String? cancelButtonText,
    Function? okButtonCallback,
    HexColor? actionButtonColor,
    Function? cancelButtonCallback,
    HexColor? backgroundColor,
    bool? isButtonView,
    bool? showCard,
    int? id
  }) {
    Future((){
      setState(() {
        this.actionButtonColor=actionButtonColor;
        this.message = message;
        this.okButtonText = okButtonText ?? "ok";
        this.cancelButtonText = cancelButtonText ?? "cancel";
        this.showCard = showCard;
        this.okButtonCallback = okButtonCallback;
        this.cancelButtonCallback = cancelButtonCallback;
        this.backgroundColor = backgroundColor;
        this.isButtonView = isButtonView;
        this.id = id;
      });
    });
  }

  void hideCard() {
    Future((){
      setState(() {
        print('hidecard');
        this.showCard = false;
      });
    });
  }

  void checkandHide(int? participantId) {
    if(id!=null && id == participantId) {
      Future(() {
        setState(() {
          print('hidecard');
          this.showCard = false;
        });
      });
    }
  }

}
