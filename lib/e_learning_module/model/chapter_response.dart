class ChaptersResponse {
  String? statusCode;
  String? message;
  List<ChapterItem>? rows;
  int? total;

  ChaptersResponse({this.statusCode, this.message, this.rows, this.total});

  ChaptersResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//ChapterItem>();
      json['rows'].forEach((v) {
        rows!.add(new ChapterItem.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class ChapterItem {
  String? chapterName;
  int? id;

  ChapterItem({this.chapterName, this.id});

  ChapterItem.fromJson(Map<String, dynamic> json) {
    chapterName = json['chapter_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chapter_name'] = this.chapterName;
    data['id'] = this.id;
    return data;
  }
}
