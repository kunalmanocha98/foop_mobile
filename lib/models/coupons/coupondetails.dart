class CouponDetailRequest {
  String? id;
  CouponDetailRequest({this.id});

  CouponDetailRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}



class CouponDetailResponse {
  String? statusCode;
  String? message;
  CouponDetailModel? rows;

  CouponDetailResponse({this.statusCode, this.message, this.rows});

  CouponDetailResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null
        ? new CouponDetailModel.fromJson(json['rows'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    return data;
  }
}

class CouponDetailModel {
  int? id;
  String? couponCode;
  String? couponProvider;
  String? couponProviderLogo;
  String? couponText;
  String? couponImage;
  String? couponDiscountType;
  int? couponDiscount;
  int? rewardPointsRequired;
  String? validFrom;
  String? validTill;
  String? couponStatus;
  String? createdDate;
  String? updatedDate;
  String? barCode;
  String? qrCode;
  String? couponTermsConditionsHeading;
  List<dynamic>? couponTermsConditionsPoints;

  CouponDetailModel(
      {this.id,
      this.couponCode,
      this.couponProvider,
      this.couponProviderLogo,
      this.couponText,
      this.couponImage,
      this.couponDiscountType,
      this.couponDiscount,
      this.rewardPointsRequired,
      this.validFrom,
      this.validTill,
      this.couponStatus,
      this.createdDate,
      this.updatedDate,
      this.qrCode,
      this.barCode,
      this.couponTermsConditionsHeading,
      this.couponTermsConditionsPoints});

  CouponDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponCode = json['coupon_code'];
    couponProvider = json['coupon_provider'];
    couponProviderLogo = json['coupon_provider_logo'];
    couponText = json['coupon_text'];
    couponImage = json['coupon_image'];
    couponDiscountType = json['coupon_discount_type'];
    couponDiscount = json['coupon_discount'];
    rewardPointsRequired = json['reward_points_required'];
    validFrom = json['valid_from'];
    validTill = json['valid_till'];
    couponStatus = json['coupon_status'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    barCode = json['bar_code'];
    qrCode = json['qr_code'];
    couponTermsConditionsHeading = json['coupon_terms_conditions_heading'];
    couponTermsConditionsPoints = json['coupon_terms_conditions_points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coupon_code'] = this.couponCode;
    data['coupon_provider'] = this.couponProvider;
    data['coupon_provider_logo'] = this.couponProviderLogo;
    data['coupon_text'] = this.couponText;
    data['coupon_image'] = this.couponImage;
    data['coupon_discount_type'] = this.couponDiscountType;
    data['coupon_discount'] = this.couponDiscount;
    data['reward_points_required'] = this.rewardPointsRequired;
    data['valid_from'] = this.validFrom;
    data['valid_till'] = this.validTill;
    data['coupon_status'] = this.couponStatus;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['bar_code'] = this.barCode;
    data['qr_code'] = this.qrCode;
    data['coupon_terms_conditions_heading'] = this.couponTermsConditionsHeading;
    data['coupon_terms_conditions_points'] = this.couponTermsConditionsPoints;
    return data;
  }
}
