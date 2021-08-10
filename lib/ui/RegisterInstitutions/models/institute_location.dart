class InstituteLocationDetail {
  int? institutionId;
  String? address;
  String? country;
  String? state;
  String? city;
  String? area;
  String? postalCode;

  InstituteLocationDetail(
      {this.institutionId,
        this.address,
        this.country,
        this.state,
        this.city,
        this.area,
        this.postalCode});

  InstituteLocationDetail.fromJson(Map<String, dynamic> json) {
    institutionId = json['business_id'];
    address = json['address'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    area = json['area'];
    postalCode = json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.institutionId;
    data['address'] = this.address;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['area'] = this.area;
    data['postal_code'] = this.postalCode;
    return data;
  }
}
