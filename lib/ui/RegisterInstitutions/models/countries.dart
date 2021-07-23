class Country {
  String? statusCode;
  String? message;
  List<List<dynamic>>? rows;
  int? total;

  Country({this.statusCode, this.message, this.rows, this.total});

  Country.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//List<dynamic>>();
      json['rows'].forEach((v) { rows!.add(v); });
    }
    total = json['total'];
  }

}


