class TermAndConditons {
  String? statusCode;
  String? message;
  List<DataTerms>? rows;
  int? total;

  TermAndConditons({this.statusCode, this.message, this.rows, this.total});

  TermAndConditons.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//DataTerms>();
      json['rows'].forEach((v) {
        rows!.add(new DataTerms.fromJson(v));
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

class DataTerms {
  int? id;
  String? heading;
  String? content;
  String? pubDate;
  String? version;
  String? topicsName;
  String? subtopicName;

  DataTerms(
      {this.id,
        this.heading,
        this.content,
        this.pubDate,
        this.version,
        this.topicsName,
        this.subtopicName});

  DataTerms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    heading = json['heading'];
    content = json['content'];
    pubDate = json['pub_date'];
    version = json['version'];
    topicsName = json['topics_name'];
    subtopicName = json['subtopic_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['heading'] = this.heading;
    data['content'] = this.content;
    data['pub_date'] = this.pubDate;
    data['version'] = this.version;
    data['topics_name'] = this.topicsName;
    data['subtopic_name'] = this.subtopicName;
    return data;
  }
}
