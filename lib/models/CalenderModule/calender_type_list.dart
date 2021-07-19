class CalenderTypeList {
  String statusCode;
  String message;
  List<CalenderTypeItem> rows;
  int total;

  CalenderTypeList({this.statusCode, this.message, this.rows, this.total});

  CalenderTypeList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//CalenderTypeItem>();
      json['rows'].forEach((v) {
        rows.add(new CalenderTypeItem.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class CalenderTypeItem {
  String eventCode;
  String eventName;
  Null eventColorCode;
  Null eventIcon;
  bool showOnCalendar;
  Null eventDefaultImageUrl;
  int standardEventsId;

  CalenderTypeItem(
      {this.eventCode,
        this.eventName,
        this.eventColorCode,
        this.eventIcon,
        this.showOnCalendar,
        this.eventDefaultImageUrl,
        this.standardEventsId});

  CalenderTypeItem.fromJson(Map<String, dynamic> json) {
    eventCode = json['event_code'];
    eventName = json['event_name'];
    eventColorCode = json['event_color_code'];
    eventIcon = json['event_icon'];
    showOnCalendar = json['show_on_calendar'];
    eventDefaultImageUrl = json['event_default_image_url'];
    standardEventsId = json['standard_events_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_code'] = this.eventCode;
    data['event_name'] = this.eventName;
    data['event_color_code'] = this.eventColorCode;
    data['event_icon'] = this.eventIcon;
    data['show_on_calendar'] = this.showOnCalendar;
    data['event_default_image_url'] = this.eventDefaultImageUrl;
    data['standard_events_id'] = this.standardEventsId;
    return data;
  }
}