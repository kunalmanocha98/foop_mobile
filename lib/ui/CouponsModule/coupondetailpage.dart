import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/models/coupons/buycoupon.dart';
import 'package:oho_works_app/models/coupons/couponlisting.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'couponlistitem.dart';

// ignore: must_be_immutable
class CouponDetailPage extends StatefulWidget {
  CouponListItem couponData;
  bool showQr;

  CouponDetailPage({required this.couponData, required this.showQr});

  @override
  _CouponDetailPage createState() =>
      _CouponDetailPage(couponData: couponData, showQr: showQr);
}

class _CouponDetailPage extends State<CouponDetailPage> {
  CouponListItem couponData;
  late SharedPreferences prefs;
  // CouponDetailModel item;
  bool showQr;
  List<String> listPoints = [];
  late TextStyleElements styleElements;
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();


  _CouponDetailPage({required this.couponData, required this.showQr});

  // @override
  // void initState() {
  //   super.initState();
  //   // styleElements = TextStyleElements(context);
  //   // pr = ToastBuilder().setProgressDialog(context);
  //   // WidgetsBinding.instance.addPostFrameCallback((_) => fetchDetails());
  // }
  // void fetchDetails() async {
  //   pr = ToastBuilder().setProgressDialog(context);
  //   await pr.show();
  //   prefs = await SharedPreferences.getInstance();
  //   CouponDetailRequest payload = CouponDetailRequest();
  //   payload.id = couponId.toString();
  //   var data = jsonEncode(payload);
  //   Calls().call(data, context, Config.COUPON_DETAIL).then((value) {
  //     await pr.hide();
  //     var res = CouponDetailResponse.fromJson(value);
  //     if (res.statusCode == Strings.success_code) {
  //       setState(() {
  //         item = res.rows;
  //         if (item.couponTermsConditionsPoints != null &&
  //             item.couponTermsConditionsPoints.length > 0) {
  //           listPoints = item.couponTermsConditionsPoints;
  //         }
  //       });
  //     }
  //   }).catchError((onError) {
  //     await pr.hide();
  //     print(onError);
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return SafeArea(
      child: Scaffold(
        appBar: appAppBar().getCustomAppBar(context, appBarTitle: 'Coupon Detail', onBackButtonPress: (){Navigator.pop(context);}),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [CommonComponents().getShadowforBox()],
            ),
            margin: EdgeInsets.all(16),
            child: Card(
              elevation: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    child: CouponListItemCard(
                      imageWidth: 92,
                      imageHeight: 92,
                      title: couponData != null ? couponData.couponProvider : "",
                      imageUrl: couponData != null ? couponData.couponImage : "",
                      discount: couponData != null ? couponData.couponDiscount : 0,
                      discountType: couponData != null ? couponData.couponDiscountType : "",
                      rewardPoints: couponData != null ? couponData.rewardPointsRequired : 0,
                      validTill: Utility().getDateFormat(
                          "dd-MMM-yyyy",
                          // ignore: unnecessary_null_comparison
                          couponData != null
                              ? DateTime.parse(couponData.validTill!)
                              : DateTime.now()),
                      isDividerHide: true,
                      isActive: false,
                      isCoinsHide: true,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24, left: 48, right: 48),
                    child: Text(
                      (couponData.couponTermsConditionsHeading != null)
                          ? couponData.couponTermsConditionsHeading!
                          : "Terms and Conditions",
                      textAlign: TextAlign.center,
                      style:  styleElements.headline6ThemeScalable(context),
                    ),
                  ),
                  Visibility(
                    visible: couponData.couponTermsConditionsPoints!.length > 0,
                    child: ListView.builder(
                      shrinkWrap: true,
                        padding:
                            EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                        itemCount: couponData.couponTermsConditionsPoints!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.only(top: 8, left: 16, right: 16),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: HexColor(AppColors.appColorBlack65),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  couponData.couponTermsConditionsPoints![index],
                                  style:  styleElements.bodyText2ThemeScalable(context),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  Spacer(),
                  Container(
                      margin: EdgeInsets.only(top: 100, bottom: 40),
                      child: getBottomWidgets())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getBottomWidgets() => Stack(
        children: [
          Visibility(
            visible: !showQr,
            child: appProgressButton(
              key: progressButtonKey,
              child: Text(
                getButtonText(),
                style:  styleElements.subtitle1ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorWhite)),
              ),
              onPressed: () {
                purchaseCoupon();
              },
              shape: StadiumBorder(),
              color: HexColor(AppColors.appMainColor),
              splashColor: HexColor(AppColors.appMainColor),
              padding: EdgeInsets.only(left: 56, right: 56, top: 16, bottom: 16),
            ),
          ),
          Visibility(
            visible: showQr,
            child:
            BarcodeWidget(
              barcode: Barcode.code128(),
              data: (couponData != null&&couponData.qrCode!=null) ? couponData.qrCode! : "a",
              height: 90,
              drawText: true,
            )

          ),
        ],
      );

  // String getdes() {
  //   if (item != null){
  //     String name = item.couponText;
  //   String discountAmnt = "₹" + item.couponDiscount.toString();
  //   String discountPercent = item.couponDiscount.toString() + "%";
  //   StringBuffer text = StringBuffer();
  //   text.write("Purchase any $name's products and receive ");
  //   text.write(item.couponDiscountType == COUPON_DISCOUNT_TYPE.Percentage.type
  //       ? discountPercent
  //       : discountAmnt);
  //   text.write(" discount");
  //   return text.toString();
  // }else{
  //   return "";
  // }

  // }

  String getButtonText() {
    // ignore: unnecessary_null_comparison
    if (couponData != null) {
      String coins = couponData.rewardPointsRequired.toString();
      return "Redeem @$coins coins";
    } else {
      return "";
    }
  }


  void purchaseCoupon() async{
    prefs= await SharedPreferences.getInstance();
   progressButtonKey.currentState!.show();
    PurchaseCouponRequest payload = PurchaseCouponRequest();
    payload.personId = prefs.getInt(Strings.userId).toString();
    payload.allCouponsId = couponData.id.toString();
    payload.purchaseDatetime = DateTime.now().millisecondsSinceEpoch.toString();
    var data = jsonEncode(payload);
    Calls().call(data, context, Config.COUPON_PURCHASE).then((value) async {
      progressButtonKey.currentState!.hide();
      var res = PurchaseCouponResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        Navigator.pop(context);
        ToastBuilder().showToast(res.message!, context,HexColor(AppColors.information));
        // setState(() {
        //   showQr = true;
        // });
        // fetchDetails();
      } else {
        ToastBuilder().showToast(res.message!, context,HexColor(AppColors.information));
      }
    }).catchError((onError) async {
      progressButtonKey.currentState!.hide();
      print(onError);
    });
  }
}
