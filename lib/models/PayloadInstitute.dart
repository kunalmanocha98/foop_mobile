class PayloadInstitute {
  int? institutionId;
  Null searchVal;

  PayloadInstitute({this.institutionId, this.searchVal});

  PayloadInstitute.fromJson(Map<String, dynamic> json) {
    institutionId = json['business_id'];
    searchVal = json['searchVal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.institutionId;
    data['searchVal'] = this.searchVal;
    return data;
  }
}
