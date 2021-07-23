class UserStatusPayload {
  String? personId;
  bool? isOnline;

  UserStatusPayload({this.personId, this.isOnline});

  UserStatusPayload.fromJson(Map<String, dynamic> json) {
    personId = json['personId'];
    isOnline = json['isOnline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personId'] = this.personId;
    data['isOnline'] = this.isOnline;
    return data;
  }
}
