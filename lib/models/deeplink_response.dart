class DeeplinkResponse {
  String? statusCode;
  String? message;
  Rows? rows;
  int? total;

  DeeplinkResponse({this.statusCode, this.message, this.rows, this.total});

  DeeplinkResponse.fromJson(Map<String, dynamic> json) {
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
  String? uniqueShareUrl;
  String? shortUrl;
  String? shareContentMessage;

  Rows({this.uniqueShareUrl, this.shortUrl,this.shareContentMessage});

  Rows.fromJson(Map<String, dynamic> json) {
    uniqueShareUrl = json['unique_share_url'];
    shortUrl = json['short_url'];
    shareContentMessage = json['share_content_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unique_share_url'] = this.uniqueShareUrl;
    data['short_url'] = this.shortUrl;
    data['share_content_message'] = this.shareContentMessage;
    return data;
  }
}
