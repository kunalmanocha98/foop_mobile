import 'package:flutter/material.dart';

class EmailListResponse {
  String? statusCode;
  String? message;
  List<EmailListItem>? rows;
  int? total;

  EmailListResponse({this.statusCode, this.message, this.rows, this.total});

  EmailListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//EmailListItem>();
      json['rows'].forEach((v) {
        rows!.add(new EmailListItem.fromJson(v));
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

class EmailListItem {
  String? uid;
  String? subject;
  String? from;
  List<String>? to;
  List<String>? cc;
  List<String>? replyTo;
  FromValues? fromValues;
  List<FromValues>? toValues;
  List<FromValues>? ccValues;
  List<FromValues>? replyToValues;
  List<Attachments>? attachments;
  int? date;
  String? dateStr;
  String? text;
  String? html;
  List<String>? flags;
  int? sizeRfc822;
  int? size;
  Color? color;

  EmailListItem(
      {this.uid,
        this.subject,
        this.from,
        this.to,
        this.cc,
        this.replyTo,
        this.fromValues,
        this.toValues,
        this.ccValues,
        this.replyToValues,
        this.date,
        this.dateStr,
        this.text,
        this.html,
        this.flags,
        this.sizeRfc822,
        this.attachments,
        this.color,
        this.size});

  EmailListItem.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    subject = json['subject'];
    from = json['from'];
    to = json['to'].cast<String>();
    cc = json['cc'].cast<String>();
    replyTo = json['reply_to'].cast<String>();
    fromValues = json['from_values'] != null
        ? new FromValues.fromJson(json['from_values'])
        : null;
    if (json['to_values'] != null) {
      toValues = [];//FromValues>();
      json['to_values'].forEach((v) {
        toValues!.add(new FromValues.fromJson(v));
      });
    }
    if (json['cc_values'] != null) {
      ccValues = [];//FromValues>();
      json['cc_values'].forEach((v) {
        ccValues!.add(new FromValues.fromJson(v));
      });
    }
    if (json['reply_to_values'] != null) {
      replyToValues = [];//FromValues>();
      json['reply_to_values'].forEach((v) {
        replyToValues!.add(new FromValues.fromJson(v));
      });
    }
    if (json['attachments'] != null) {
      attachments =  [];
      json['attachments'].forEach((v) {
        attachments!.add(new Attachments.fromJson(v));
      });
    }
    date = json['date'];
    dateStr = json['date_str'];
    text = json['text'];
    html = json['html'];
    flags = json['flags'].cast<String>();
    sizeRfc822 = json['size_rfc822'];
    size = json['size'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['subject'] = this.subject;
    data['from'] = this.from;
    data['to'] = this.to;
    data['cc'] = this.cc;
    data['reply_to'] = this.replyTo;
    if (this.fromValues != null) {
      data['from_values'] = this.fromValues!.toJson();
    }
    if (this.toValues != null) {
      data['to_values'] = this.toValues!.map((v) => v.toJson()).toList();
    }
    if (this.ccValues != null) {
      data['cc_values'] = this.ccValues!.map((v) => v.toJson()).toList();
    }
    if (this.replyToValues != null) {
      data['reply_to_values'] =
          this.replyToValues!.map((v) => v.toJson()).toList();
    }
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    data['date'] = this.date;
    data['date_str'] = this.dateStr;
    data['text'] = this.text;
    data['html'] = this.html;
    data['flags'] = this.flags;
    data['size_rfc822'] = this.sizeRfc822;
    data['size'] = this.size;

    return data;
  }
}

class FromValues {
  String? email;
  String? name;
  String? full;

  FromValues({this.email, this.name, this.full});

  FromValues.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    full = json['full'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['full'] = this.full;
    return data;
  }
}
class Attachments {
  String? filename;
  String? payload;
  String? contentId;
  String? contentType;
  String? contentDisposition;
  int? size;

  Attachments(
      {this.filename,
        this.payload,
        this.contentId,
        this.contentType,
        this.contentDisposition,
        this.size});

  Attachments.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    payload = json['payload'];
    contentId = json['content_id'];
    contentType = json['content_type'];
    contentDisposition = json['content_disposition'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filename'] = this.filename;
    data['payload'] = this.payload;
    data['content_id'] = this.contentId;
    data['content_type'] = this.contentType;
    data['content_disposition'] = this.contentDisposition;
    data['size'] = this.size;
    return data;
  }
}

class EmailDetailResponse {
  String? statusCode;
  String? message;
  EmailListItem? rows;
  int? total;

  EmailDetailResponse({this.statusCode, this.message, this.rows, this.total});

  EmailDetailResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new EmailListItem.fromJson(json['rows']) : null;
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