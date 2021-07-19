class AppUpdateResponse {
  String statusCode;
  String message;
  AppUpdateModel rows;
  int total;

  AppUpdateResponse({this.statusCode, this.message, this.rows, this.total});

  AppUpdateResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new AppUpdateModel.fromJson(json['rows']) : null;
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

class AppUpdateModel {
  String androidVersion;
  String androidBuildNumber;
  bool isAndroidForceUpdate;
  String iosVersion;
  String iosBuildNumber;
  bool isIosForceUpdate;
  String androidNotes;
  String iosNotes;

  AppUpdateModel(
      {this.androidVersion,
        this.androidBuildNumber,
        this.isAndroidForceUpdate,
        this.iosVersion,
        this.iosBuildNumber,
        this.isIosForceUpdate,
        this.androidNotes,
        this.iosNotes});

  AppUpdateModel.fromJson(Map<String, dynamic> json) {
    androidVersion = json['android_version'];
    androidBuildNumber = json['android_build_number'];
    isAndroidForceUpdate = json['is_android_force_update'];
    iosVersion = json['ios_version'];
    iosBuildNumber = json['ios_build_number'];
    isIosForceUpdate = json['is_ios_force_update'];
    androidNotes = json['android_notes'];
    iosNotes = json['ios_notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['android_version'] = this.androidVersion;
    data['android_build_number'] = this.androidBuildNumber;
    data['is_android_force_update'] = this.isAndroidForceUpdate;
    data['ios_version'] = this.iosVersion;
    data['ios_build_number'] = this.iosBuildNumber;
    data['is_ios_force_update'] = this.isIosForceUpdate;
    data['android_notes'] = this.androidNotes;
    data['ios_notes'] = this.iosNotes;
    return data;
  }
}