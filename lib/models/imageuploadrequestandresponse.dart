class ImageUpdateRequest {
  String? ownerType;
  int? ownerId;
  String? imageType;
  String? imagePath;

  ImageUpdateRequest(
      {this.ownerType, this.ownerId, this.imageType, this.imagePath});

  ImageUpdateRequest.fromJson(Map<String, dynamic> json) {
    ownerType = json['owner_type'];
    ownerId = json['owner_id'];
    imageType = json['image_type'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner_type'] = this.ownerType;
    data['owner_id'] = this.ownerId;
    data['image_type'] = this.imageType;
    data['image_path'] = this.imagePath;
    return data;
  }
}

class ImageUpdateResponse {
  String? statusCode;
  String? message;
  ImageUpdateUrls? rows;

  ImageUpdateResponse({this.statusCode, this.message, this.rows});

  ImageUpdateResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null
        ? new ImageUpdateUrls.fromJson(json['rows'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    return data;
  }
}

class ImageUpdateUrls {
  String? fileUrl;
  String? fileThumbnailUrl;
  List<OtherUrls>? otherUrls;

  ImageUpdateUrls({this.fileUrl, this.fileThumbnailUrl, this.otherUrls});

  ImageUpdateUrls.fromJson(Map<String, dynamic> json) {
    fileUrl = json['file_url'];
    fileThumbnailUrl = json['file_thumbnail_url'];
    if (json['other_urls'] != null) {
      otherUrls = [];//OtherUrls>();
      json['other_urls'].forEach((v) {
        otherUrls!.add(new OtherUrls.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file_url'] = this.fileUrl;
    data['file_thumbnail_url'] = this.fileThumbnailUrl;
    if (this.otherUrls != null) {
      data['other_urls'] = this.otherUrls!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OtherUrls {
  String? original;
  String? s128dp;
  String? s256dp;
  String? s512dp;
  String? s720dp;

  OtherUrls(
      {this.original, this.s128dp, this.s256dp, this.s512dp, this.s720dp});

  OtherUrls.fromJson(Map<String, dynamic> json) {
    original = json['original'];
    s128dp = json['128dp'];
    s256dp = json['256dp'];
    s512dp = json['512dp'];
    s720dp = json['720dp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['original'] = this.original;
    data['128dp'] = this.s128dp;
    data['256dp'] = this.s256dp;
    data['512dp'] = this.s512dp;
    data['720dp'] = this.s720dp;
    return data;
  }
}
