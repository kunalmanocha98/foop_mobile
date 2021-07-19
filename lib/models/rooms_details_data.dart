import 'Rooms/roomlistmodels.dart';

class RoomsDetailData {
  String statusCode;
  String message;
  RoomListItem rows;
  int total;

  RoomsDetailData({this.statusCode, this.message, this.rows, this.total});

  RoomsDetailData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new RoomListItem.fromJson(json['rows']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}


