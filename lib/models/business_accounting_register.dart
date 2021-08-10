class BusinessAccountRegisterRequest {
  int? id;
  int? businessId;
  String? country;
  String? gst;
  String? pan;
  String? cin;
  String? tan;
  String? finStartMonth;
  String? finEndMonth;
  String? taxStartMonth;
  String? taxEndMonth;

  BusinessAccountRegisterRequest(
      {this.id,
        this.businessId,
        this.country,
        this.gst,
        this.pan,
        this.cin,
        this.tan,
        this.finStartMonth,
        this.finEndMonth,
        this.taxStartMonth,
        this.taxEndMonth});

  BusinessAccountRegisterRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'];
    country = json['country'];
    gst = json['gst'];
    pan = json['pan'];
    cin = json['cin'];
    tan = json['tan'];
    finStartMonth = json['fin_start_month'];
    finEndMonth = json['fin_end_month'];
    taxStartMonth = json['tax_start_month'];
    taxEndMonth = json['tax_end_month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.businessId;
    data['country'] = this.country;
    data['gst'] = this.gst;
    data['pan'] = this.pan;
    data['cin'] = this.cin;
    data['tan'] = this.tan;
    data['fin_start_month'] = this.finStartMonth;
    data['fin_end_month'] = this.finEndMonth;
    data['tax_start_month'] = this.taxStartMonth;
    data['tax_end_month'] = this.taxEndMonth;
    return data;
  }
}