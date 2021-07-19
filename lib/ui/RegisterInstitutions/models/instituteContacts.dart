class InstituteContactDetail {
  int institutionId;
  String email;
  int phone;
  int mobile;
  String website;

  InstituteContactDetail(
      {this.institutionId, this.email, this.phone, this.mobile, this.website});

  InstituteContactDetail.fromJson(Map<String, dynamic> json) {
    institutionId = json['institution_id'];
    email = json['email'];
    phone = json['phone'];
    mobile = json['mobile'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['institution_id'] = this.institutionId;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['mobile'] = this.mobile;
    data['website'] = this.website;
    return data;
  }
}
