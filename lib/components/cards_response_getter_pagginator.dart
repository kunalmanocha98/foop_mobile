import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/empty_widget.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomResponseGetter {

  BuildContext context;
  List<SubRow>? listItemsGetter(BaseResponses response) {
    return response.rows![0].subRow;
  }


  Widget loadingWidgetMaker() {
    return Container(
      alignment: Alignment.center,
      height: 160.0,
      child: CircularProgressIndicator(
        valueColor:
        AlwaysStoppedAnimation<Color>(HexColor(AppColors.appMainColor)),
      ),
    );
  }

  Widget simmer() {
    return Container(

        child: PreloadingView(url: "assets/appimages/dice.png")
    );
  }

  Widget errorWidgetMaker(BaseResponses response, retryListener) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(AppLocalizations.of(context)!.translate('server_error'),
            style: TextStyle(
                fontSize: 16,
                color: HexColor(AppColors.appMainColor),
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        appTextButton(
          onPressed: retryListener,
          child: Text(AppLocalizations.of(context)!.translate('retry')),
        )
      ],
    );
  }

  Widget emptyListWidgetMaker(BaseResponses response) {
    return Center(
        child:EmptyWidget(AppLocalizations.of(context)!
            .translate('no_data'),
        )
    );
  }

  int? totalPagesGetter(BaseResponses response) {
    return response.total;
  }

  bool pageErrorChecker(BaseResponses response) {
    if (response.statusCode == Strings.success_code) {
      return false;
    } else {
      return false;
    }
  }

  CustomResponseGetter(this.context,);
}
