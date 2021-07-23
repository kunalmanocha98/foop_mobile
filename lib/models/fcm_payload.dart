class FCMPayload {
  String? personId;
  String? applicationType;
  String? machineCode;
  String? fcmId;

  FCMPayload(
      {this.personId, this.applicationType, this.machineCode, this.fcmId});

  FCMPayload.fromJson(Map<String, dynamic> json) {
    personId = json['person_id'];
    applicationType = json['application_type'];
    machineCode = json['machine_code'];
    fcmId = json['fcm_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['person_id'] = this.personId;
    data['application_type'] = this.applicationType;
    data['machine_code'] = this.machineCode;
    data['fcm_id'] = this.fcmId;
    return data;
  }
}
