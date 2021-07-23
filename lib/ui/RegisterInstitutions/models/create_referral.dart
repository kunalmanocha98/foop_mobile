class CreateReferralEntity {
  int? id;
  int? institutionId;
  int? referredByPersonId;
  String? referredByPersonMobileNumber;
  String? referredByUpiId;
  String? referredDate;
  int? adminStaffPersonId;
  String? referralDate;
  String? firstName;
  String? lastName;
  String? gender;
  String? refferedByImageUrl;
  String? dateOfBirth;

  CreateReferralEntity(
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

  CreateReferralEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    institutionId = json['institution_id'];
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
    data['institution_id'] = this.institutionId;
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
