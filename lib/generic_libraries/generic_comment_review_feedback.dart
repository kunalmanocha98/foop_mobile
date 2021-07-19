import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';


/*
Comments:
NOTE_TYPE = ['review', 'comment', 'feedback']
NOTE_CREATED_BY_TYPE = ['person', 'institution','class', 'subject', 'club', 'sports', 'campus','goal','project','rating']
NOTE_SUBJECT_TYPE = ['person', 'institution','class', 'subject', 'club', 'sports', 'campus','goal','project''rating']

"note_format":["T"] -- T-Text , M-Media

Note _status >A = Active
D – Deleted
R- Reported
M – Removed
*/

// ignore: must_be_immutable
class GenericCommentReviewFeedback {
  GenericCommentReviewFeedback(this.ctx, this.body);

  BuildContext ctx;
  String body;
  Null Function() callback;

  Future<bool> apiCreateRatings() async {
    print(body);
    var res  = await Calls().call(body, ctx, Config.CREATE_RATINGS);
    if (res != null) {
      var data = DynamicResponse.fromJson(res);
      if (data != null && data.statusCode == 'S10001') {

        return true;
      } else {
        ToastBuilder().showToast(data.message ?? "Please Try Again", ctx,HexColor(AppColors.information));
        return false;
      }
    } else {
      ToastBuilder().showToast("Please Try Again", ctx,HexColor(AppColors.information));
      return false;
    }
  }

  Future<bool> apiCallCreate() async {
   var res = await  Calls()
        .call(body, ctx, Config.CREATE_COMMENT_REVIEW_FEEDBACK);
   if (res != null) {
     var data = DynamicResponse.fromJson(res);
     if (data != null && data.statusCode == 'S10001') {

       return true;
     } else {
       ToastBuilder().showToast(data.message ?? "Please Try Again", ctx,HexColor(AppColors.information));
       return false;
     }
   } else {
     ToastBuilder().showToast("Please Try Again", ctx,HexColor(AppColors.information));
     return false;
   }


  }

  // ignore: missing_return
  Future<bool> apiCallUpdate() async {

    Calls().call(body, ctx, Config.UPDATE_COMMENT_REVIEW).then((value) async {

      if (value != null) {
        var data = DynamicResponse.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {


          return true;
        } else {
          ToastBuilder().showToast(data.message ?? "Please Try Again", ctx,HexColor(AppColors.information));

          return false;
        }
      } else {
        ToastBuilder().showToast("Please Try Again", ctx,HexColor(AppColors.information));

        return false;
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(onError.toString(), ctx,HexColor(AppColors.information));

      return false;
    });
  }

  void userButtonCLick(isCallSuccess) {
    if (isCallSuccess) apiCallCreate();
  }
}
