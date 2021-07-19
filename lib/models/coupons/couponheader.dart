class CouponHeaderResponse {
  String statusCode;
  String message;
  CouponHeaderResponseModel rows;

  CouponHeaderResponse({this.statusCode, this.message, this.rows});

  CouponHeaderResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null
        ? new CouponHeaderResponseModel.fromJson(json['rows'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.toJson();
    }
    return data;
  }
}

class CouponHeaderResponseModel {
  int id;
  String personId;
  String currentBalance;
  String lifetimeEarned;
  String lifetimeBurn;

  CouponHeaderResponseModel(
      {this.id,
      this.personId,
      this.currentBalance,
      this.lifetimeEarned,
      this.lifetimeBurn});

  CouponHeaderResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personId = json['person_id'];
    currentBalance = json['current_balance'];
    lifetimeEarned = json['lifetime_earned'];
    lifetimeBurn = json['lifetime_burn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['person_id'] = this.personId;
    data['current_balance'] = this.currentBalance;
    data['lifetime_earned'] = this.lifetimeEarned;
    data['lifetime_burn'] = this.lifetimeBurn;
    return data;
  }
}
