class CreateReferraResponselEntity {
  String? statusCode;
  String? message;
  Rows? rows;
  int? total;

  CreateReferraResponselEntity(
      {this.statusCode, this.message, this.rows, this.total});

  CreateReferraResponselEntity.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new Rows.fromJson(json['rows']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class Rows {
  int? id;
  int? institutionId;
  int? referredByPersonId;
  String? referredByPersonMobileNumber;
  String? referredByUpiId;
  Null referredDate;
  Null adminStaffPersonId;
  Null referralDate;
  String? firstName;
  String? lastName;
  String? gender;
  Null refferedByImageUrl;
  String? dateOfBirth;

  Rows(
      {this.id,
        this.institutionId,
        this.referredByPersonId,
        this.referredByPersonMobileNumber,
        this.referredByUpiId,
        this.referredDate,
        this.adminStaffPersonId,
        this.referralDate,
        this.firstName,
        this.lastName,
        this.gender,
        this.refferedByImageUrl,
        this.dateOfBirth});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    institutionId = json['business_id'];
    referredByPersonId = json['referred_by_person_id'];
    referredByPersonMobileNumber = json['referred_by_person_mobile_number'];
    referredByUpiId = json['referred_by_upi_id'];
    referredDate = json['referred_date'];
    adminStaffPersonId = json['admin_staff_person_id'];
    referralDate = json['referral_date'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    refferedByImageUrl = json['reffered_by_image_url'];
    dateOfBirth = json['date_of_birth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.institutionId;
    data['referred_by_person_id'] = this.referredByPersonId;
    data['referred_by_person_mobile_number'] =
        this.referredByPersonMobileNumber;
    data['referred_by_upi_id'] = this.referredByUpiId;
    data['referred_date'] = this.referredDate;
    data['admin_staff_person_id'] = this.adminStaffPersonId;
    data['referral_date'] = this.referralDate;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['reffered_by_image_url'] = this.refferedByImageUrl;
    data['date_of_birth'] = this.dateOfBirth;
    return data;
  }
}
