class CurrencyFormat {
  String? statusCode;
  String? message;
  List<CurrencyFormatItem>? rows;

  CurrencyFormat({this.statusCode, this.message, this.rows});

  CurrencyFormat.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//CurrencyFormatItem>();
      json['rows'].forEach((v) {
        rows!.add(new CurrencyFormatItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrencyFormatItem {
  int? id;
  String? code;
  String? name;
  String? symbol;

  CurrencyFormatItem({this.id, this.code, this.name, this.symbol});

  CurrencyFormatItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    return data;
  }
}
