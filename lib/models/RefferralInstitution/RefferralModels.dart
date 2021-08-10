class ReferralRequest {
  int? institutionId;
  int? referredByPersonId;
  String? referredByPersonMobileNumber;
  String? referredByUpiId;
  String? referredDate;
  int? adminStaffPersonId;
  String? referralDate;

  ReferralRequest(
      {this.institutionId,
        this.referredByPersonId,
        this.referredByPersonMobileNumber,
        this.referredByUpiId,
        this.referredDate,
        this.adminStaffPersonId,
        this.referralDate});

  ReferralRequest.fromJson(Map<String, dynamic> json) {
    institutionId = json['business_id'];
    referredByPersonId = json['referred_by_person_id'];
    referredByPersonMobileNumber = json['referred_by_person_mobile_number'];
    referredByUpiId = json['referred_by_upi_id'];
    referredDate = json['referred_date'];
    adminStaffPersonId = json['admin_staff_person_id'];
    referralDate = json['referral_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.institutionId;
    data['referred_by_person_id'] = this.referredByPersonId;
    data['referred_by_person_mobile_number'] =
        this.referredByPersonMobileNumber;
    data['referred_by_upi_id'] = this.referredByUpiId;
    data['referred_date'] = this.referredDate;
    data['admin_staff_person_id'] = this.adminStaffPersonId;
    data['referral_date'] = this.referralDate;
    return data;
  }
}


class ReferralResponse {
  String? statusCode;
  String? message;
  int? total;

  ReferralResponse({this.statusCode, this.message, this.total});

  ReferralResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['total'] = this.total;
    return data;
  }
}

