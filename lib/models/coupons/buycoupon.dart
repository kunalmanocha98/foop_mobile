class PurchaseCouponRequest {
  String allCouponsId;
  String personId;
  String purchaseDatetime;

  PurchaseCouponRequest(
      {this.allCouponsId, this.personId, this.purchaseDatetime});

  PurchaseCouponRequest.fromJson(Map<String, dynamic> json) {
    allCouponsId = json['all_coupons_id'];
    personId = json['person_id'];
    purchaseDatetime = json['purchase_datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all_coupons_id'] = this.allCouponsId;
    data['person_id'] = this.personId;
    data['purchase_datetime'] = this.purchaseDatetime;
    return data;
  }
}

class PurchaseCouponResponse {
  String statusCode;
  String message;
  dynamic rows;

  PurchaseCouponResponse({this.statusCode, this.message, this.rows});

  PurchaseCouponResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['rows'] = this.rows;
    return data;
  }
}
