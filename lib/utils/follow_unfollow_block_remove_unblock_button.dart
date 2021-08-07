import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'config.dart';
import 'follow_unfollow_block_dialogue.dart';

// ignore: must_be_immutable
class GenericFollowUnfollowButton extends StatefulWidget {
  String? personName;
  String? engageFlag;
  Color? textColor;
  Color? backGroundColor;
  String? actionByObjectType;
  int? actionByObjectId;
  String? actionOnObjectType;
  int? actionOnObjectId;
  String? actionFlag;
  List<String>? actionDetails;
  bool? isRoundedButton = true;
  Null Function()? clicked;
  EdgeInsets? padding;
  Null Function(bool isCallSuccess)? callback;

  GenericFollowUnfollowButton(
      {Key? key,
        this.actionByObjectType,
        this.actionByObjectId,
        this.actionOnObjectType,
        this.actionOnObjectId,
        this.engageFlag,
        this.callback,
        this.clicked,
        this.actionFlag,
        this.personName,
        this.actionDetails,
        this.isRoundedButton,
        this.textColor,
        this.padding,
        this.backGroundColor})
      : super(key: key);

  @override
  GenericFollowUnfollowButtonState createState() =>
      GenericFollowUnfollowButtonState(
        callback: callback,
        clicked: clicked,
      );
}

class GenericFollowUnfollowButtonState
    extends State<GenericFollowUnfollowButton> {
  GenericFollowUnfollowButtonState({
    this.callback,
    this.clicked,
  });

  late TextStyleElements styleElements;
  BuildContext? ctx;
  Null Function()? clicked;
  Null Function(bool isCallSuccess)? callback;
  bool inProgress = false;

  Widget _roundedCornerButton(BuildContext context) => Visibility(
    visible: widget.actionOnObjectId != widget.actionByObjectId,
    child: inProgress
        ? CircularProgressIndicator()
        : Container(
      child: appTextButton(
        padding: EdgeInsets.all(0),
        shape: StadiumBorder(
            side: BorderSide(color: HexColor(AppColors.appMainColor))),
        onPressed: () {
          if (widget.actionFlag == "U" ||
              widget.actionFlag == "B" ||
              widget.actionFlag == "R" ||
              widget.actionFlag == "M") {
            showDialog(
                context: context,
                builder: (BuildContext context) => DilogBlockUnfollow(
                  image: 'assets/appimages/Teacher-pana.png',
                  title: widget.actionFlag == "U"
                      ? "Unfollow"
                      : widget.actionFlag == "B"
                      ? "Block"
                      : widget.actionFlag == "R"
                      ? "Restrict"
                      : "Remove" +
                      " " +
                      widget.personName! +
                      "?",
                  subText: widget.actionFlag == "U"
                      ? AppLocalizations.of(ctx!)!
                      .translate("unfollow_content")
                      : widget.actionFlag == "B"
                      ? AppLocalizations.of(ctx!)!
                      .translate("block_content")
                      : widget.actionFlag == "M"
                      ? AppLocalizations.of(ctx!)!
                      .translate("remove_content")
                      : AppLocalizations.of(ctx!)!
                      .translate("restrict_content"),
                  clicked: () {
                    if (clicked != null) clicked!();
                  },
                  callback: (isCallSuccess) {
                    userButtonCLick(isCallSuccess);
                  },
                ));
          } else {
            apiCall();
            if (clicked != null) clicked!();
          }

          //
        },

        color: widget.backGroundColor != null
            ? widget.backGroundColor
            : HexColor(AppColors.appColorTransparent),
        child: Text(
          widget.engageFlag!,
          style: styleElements.captionThemeScalable(context).copyWith(
              color: widget.textColor != null
                  ? widget.textColor
                  : HexColor(AppColors.appMainColor)),
        ),
      ),
    ),
  );

  Widget _simpleappTextButton(BuildContext context) => Visibility(
    visible: widget.actionByObjectId != widget.actionOnObjectId,
    child: inProgress
        ? SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ))
        : Container(
      child: InkWell(
        onTap: () {
          if (widget.actionFlag == "U" ||
              widget.actionFlag == "B" ||
              widget.actionFlag == "R" ||
              widget.actionFlag == "M") {
            showDialog(
                context: context,
                builder: (BuildContext context) => DilogBlockUnfollow(
                  image: 'assets/appimages/Teacher-pana.png',
                  title: widget.actionFlag == "U"
                      ? "Unfollow"
                      : widget.actionFlag == "B"
                      ? "Block"
                      : widget.actionFlag == "R"
                      ? "Restrict"
                      : "Remove" +
                      " " +
                      widget.personName! +
                      "?",
                  subText: widget.actionFlag == "U"
                      ? AppLocalizations.of(ctx!)!
                      .translate("unfollow_content")
                      : widget.actionFlag == "B"
                      ? AppLocalizations.of(ctx!)!
                      .translate("block_content")
                      : widget.actionFlag == "M"
                      ? AppLocalizations.of(ctx!)!
                      .translate("remove_content")
                      : AppLocalizations.of(ctx!)!
                      .translate("restrict_content"),
                  callback: (isCallSuccess) {
                    userButtonCLick(isCallSuccess);
                  },
                ));
          } else
            apiCall();
          if (clicked != null) clicked!();
          //
        },
        child: Padding(
          padding:widget.padding!=null?widget.padding!:
          EdgeInsets.only(left: 8.0, right: 8, top: 4, bottom: 4),
          child: Text(
            widget.engageFlag!,
            style: styleElements
                .captionThemeScalable(context)
                .copyWith(color: HexColor(AppColors.appMainColor)),
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.ctx = context;
    return Stack(
      children: [
        Visibility(
          visible:
          widget.isRoundedButton != null ? widget.isRoundedButton! : true,
          child: _roundedCornerButton(context),
        ),
        Visibility(
          visible:
          widget.isRoundedButton != null ? !widget.isRoundedButton! : false,
          child: _simpleappTextButton(context),
        ),
      ],
    );
  }

  void apiCall() async {
    // ProgressDialog pr = ToastBuilder().setProgressDialog(ctx);
    final body = jsonEncode({
      "action_by_object_type": widget.actionByObjectType,
      "action_by_object_id": widget.actionByObjectId,
      "action_on_object_type": widget.actionOnObjectType,
      "action_on_object_id": widget.actionOnObjectId,
      "engage_flag": widget.actionFlag,
      "action_details": widget.actionDetails
    });
    Calls().call(body, ctx, Config.FOLLOW_UNFOLLOW_BLOCK).then((value) async {
      // await pr.hide();

      if (value != null) {
        var data = DynamicResponse.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          callback!(true);
        } else {
          ToastBuilder().showToast(data.message ?? "Please Try Again", ctx,
              HexColor(AppColors.information));
          callback!(false);
        }
      } else {
        ToastBuilder().showToast(
            "Please Try Again", ctx, HexColor(AppColors.information));
        callback!(false);
      }

      setState(() {
        inProgress = false;
      });
    }).catchError((onError) async {
      // ToastBuilder()
      //     .showToast(onError.toString(), ctx, HexColor(AppColors.information));
      // await pr.hide();
      setState(() {
        inProgress = false;
      });
      callback!(false);
    });

    setState(() {
      inProgress = true;
    });
  }

  void followUnfollowBlock(
      String actionByObjectType,
      int? actionByObjectId,
      String? actionOnObjectType,
      int? actionOnObjectId,
      String actionFlag,
      List<String> actionDetails,
      Function(bool isSuccess,)
      callback,
      BuildContext context) async {


    final body = jsonEncode({
      "action_by_object_type": actionByObjectType,
      "action_by_object_id": actionByObjectId,
      "action_on_object_type": actionOnObjectType,
      "action_on_object_id": actionOnObjectId,
      "engage_flag": actionFlag,
      "action_details": actionDetails
    });
    Calls().call(body, ctx, Config.FOLLOW_UNFOLLOW_BLOCK).then((value) async {

      if (value != null) {
        var data = DynamicResponse.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          ToastBuilder().showToast("Success", ctx, HexColor(AppColors.success));
          callback(true);
        } else {
          ToastBuilder().showToast(data.message ?? "Please Try Again", ctx,
              HexColor(AppColors.information));
          callback(false);
        }
      } else {
        ToastBuilder().showToast(
            "Please Try Again", ctx, HexColor(AppColors.information));
        callback(false);
      }
    }).catchError((onError) async {
      ToastBuilder()
          .showToast(onError.toString(), ctx, HexColor(AppColors.information));

      callback(false);
    });
  }

  void userButtonCLick(isCallSuccess) {
    if (isCallSuccess) apiCall();
  }
}
