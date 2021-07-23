class DeviceInfo {
  String? fcmId;
  String? deviceInfo;
  String? deviceType;
  String? deviceVendor;
  String? macId;
  String? browserType;
  String? browserVersion;
  String? osType;
  String? osVersion;
  String? manufacturer;
  String? location;
  String? gpsInfo;
  String? machineCode;
  String? applicationType;

  DeviceInfo(
      {this.fcmId,
        this.deviceInfo,
        this.deviceType,
        this.deviceVendor,
        this.macId,
        this.browserType,
        this.browserVersion,
        this.osType,
        this.osVersion,
        this.manufacturer,
        this.location,
        this.gpsInfo,
        this.machineCode,
        this.applicationType});

  DeviceInfo.fromJson(Map<String, dynamic> json) {
    fcmId = json['fcm_id'];
    deviceInfo = json['device_info'];
    deviceType = json['device_type'];
    deviceVendor = json['device_vendor'];
    macId = json['mac_id'];
    browserType = json['browser_type'];
    browserVersion = json['browser_version'];
    osType = json['os_type'];
    osVersion = json['os_version'];
    manufacturer = json['manufacturer'];
    location = json['location'];
    gpsInfo = json['gps_info'];
    machineCode = json['machine_code'];
    applicationType = json['application_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fcm_id'] = this.fcmId;
    data['device_info'] = this.deviceInfo;
    data['device_type'] = this.deviceType;
    data['device_vendor'] = this.deviceVendor;
    data['mac_id'] = this.macId;
    data['browser_type'] = this.browserType;
    data['browser_version'] = this.browserVersion;
    data['os_type'] = this.osType;
    data['os_version'] = this.osVersion;
    data['manufacturer'] = this.manufacturer;
    data['location'] = this.location;
    data['gps_info'] = this.gpsInfo;
    data['machine_code'] = this.machineCode;
    data['application_type'] = this.applicationType;
    return data;
  }
}
