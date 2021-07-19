import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/components/tricycleemptywidget.dart';
import 'package:oho_works_app/models/followersfollowinglistdata.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPaginator {

  BuildContext context;
  List<dynamic> listItemsGetter(dynamic response) {
    return response.rows;
  }
  List<dynamic> listItemsGetterPhotos(dynamic response) {
    return response.rows[0].subRow;
  }
  List<Persons> getPersons(FollowersListItemEntity response) {
    return response.rows!=null ?response.rows.persons:null;
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

  Widget errorWidgetMaker(dynamic response, retryListener) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      /*  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(AppLocalizations.of(context).translate('see_more')"There has been a server Error",
            style: TextStyle(
              fontSize: 16,
              color: HexColor(AppColors.appMainColor),
              fontWeight: FontWeight.bold
            ),
          ),
        ),*/
        TricycleElevatedButton(
          onPressed: retryListener,
          color: HexColor(AppColors.appColorWhite),
          child: Text(AppLocalizations.of(context).translate('retry'),style: TextStyleElements(context).buttonThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),),
        )
      ],
    );
  }
  Widget blank(dynamic response,retryListener) {
    return Center(
        child:
        Container(),
    );
  }

  Widget emptyListWidgetMaker(dynamic response,{String message,String assetImage}) {
    return Center(
      child: TricycleEmptyWidget(
          message: message!=null?message:AppLocalizations.of(context)
              .translate('no_data'),
        assetImage: assetImage,

        )
    );
  }

  int totalPagesGetter(dynamic response) {
    return response.total;
  }

  bool pageErrorChecker(dynamic response) {
    if (response!=null && (response.statusCode == Strings.success_code || response.statusCode == Strings.noData_code)) {
      return false;
    } else {
      // ToastBuilder().showToast(response.message??"", context, HexColor(AppColors.information));
      return true;
    }
  }

  CustomPaginator(this.context);
}
