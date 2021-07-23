class CouponListRequest {
  String? searchVal;
  int? pageNumber;
  int? pageSize;
  String? personId;
  String? ledgerType;

  CouponListRequest(
      {this.searchVal, this.pageNumber, this.pageSize, this.personId,this.ledgerType});

  CouponListRequest.fromJson(Map<String, dynamic> json) {
    ledgerType = json['ledger_type'];
    searchVal = json['search_val'];
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
    personId = json['person_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ledger_type'] = this.ledgerType;
    data['search_val'] = this.searchVal;
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    data['person_id'] = this.personId;
    return data;
  }
}

class CouponListResponse {
  String? statusCode;
  String? message;
  List<CouponListItem>? rows;
  int? total;

  CouponListResponse({this.statusCode, this.message, this.rows, this.total});

  CouponListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    total = json['total'];
    if (json['rows'] != null) {
      rows = [];//CouponListItem>();
      json['rows'].forEach((v) {
        rows!.add(new CouponListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CouponListItem {
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
  List<String>? couponTermsConditionsPoints;

  CouponListItem(
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

  CouponListItem.fromJson(Map<String, dynamic> json) {
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
    couponTermsConditionsPoints =
        json['coupon_terms_conditions_points'].cast<String>();
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

class CouponHistoryResponse {
  String? statusCode;
  String? message;
  List<CouponHistoryItem>? rows;
  int? total;

  CouponHistoryResponse({this.statusCode, this.message, this.rows, this.total});

  CouponHistoryResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    total = json['total'];
    if (json['rows'] != null) {
      rows = [];//CouponHistoryItem>();
      json['rows'].forEach((v) {
        rows!.add(new CouponHistoryItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CouponHistoryItem {
  int? id;
  String? userId;
  String? currencyCode;
  String? rewardsCr;
  String? rewardsDr;
  String? lineBalance;
  String? transactionType;
  String? transactionDatetime;
  String? createdDate;

  CouponHistoryItem(
      {this.id,
      this.userId,
      this.rewardsCr,
      this.rewardsDr,
      this.lineBalance,
      this.transactionType,
        this.currencyCode,
      this.transactionDatetime,
      this.createdDate});

  CouponHistoryItem.fromJson(Map<String, dynamic> json) {
    currencyCode = json['currency_code'];
    id = json['id'];
    userId = json['user_id'];
    rewardsCr = json['rewards_cr'];
    rewardsDr = json['rewards_dr'];
    lineBalance = json['line_balance'];
    transactionType = json['transaction_type'];
    transactionDatetime = json['transaction_datetime'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency_code'] = this.currencyCode;
     data['id'] = this.id;
    data['user_id'] = this.userId;
    data['rewards_cr'] = this.rewardsCr;
    data['rewards_dr'] = this.rewardsDr;
    data['line_balance'] = this.lineBalance;
    data['transaction_type'] = this.transactionType;
    data['transaction_datetime'] = this.transactionDatetime;
    data['created_date'] = this.createdDate;
    return data;
  }
}
