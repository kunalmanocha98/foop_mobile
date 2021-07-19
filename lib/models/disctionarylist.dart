class DictionaryListResponse {
  String statusCode;
  String message;
  List<DictionaryListItem> rows;

  DictionaryListResponse({this.statusCode, this.message, this.rows});

  DictionaryListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//DictionaryListItem>();
      json['rows'].forEach((v) {
        rows.add(new DictionaryListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DictionaryListItem {
  int id;
  String code;
  String description;
  bool isSelected = false;

  DictionaryListItem({this.id, this.code, this.description, this.isSelected});

  DictionaryListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['description'] = this.description;
    return data;
  }
}
