class UserListRequest {
  String searchVal;
  int pageSize;
  int pageNumber;

  UserListRequest({this.searchVal, this.pageSize, this.pageNumber});

  UserListRequest.fromJson(Map<String, dynamic> json) {
    searchVal = json['searchVal'];
    pageSize = json['page_size'];
    pageNumber = json['page_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchVal'] = this.searchVal;
    data['page_size'] = this.pageSize;
    data['page_number'] = this.pageNumber;
    return data;
  }
}

class UserListResponse {
  String statusCode;
  String message;
  int total;
  List<UserListResponseItem> rows;

  UserListResponse({this.statusCode, this.message, this.rows, this.total});

  UserListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//UserListResponseItem>();
      json['rows'].forEach((v) {
        rows.add(new UserListResponseItem.fromJson(v));
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

class UserListResponseItem {
  int id;
  String title;
  String email;
  String firstName;
  String middleName;
  String lastName;
  String shortBio;
  String fullBio;
  String message;
  String nickName;
  String dateOfBirth;
  String bloodGroup;
  String dateOfAnniversary;
  int gender;
  String mobile;
  String mobileCountryCode;
  String profileImage;
  String coverImage;
  String mobileVerificationStatus;
  String emailVerificationStatus;
  bool selected = false;

  UserListResponseItem(
      {this.id,
      this.title,
      this.email,
      this.firstName,
      this.middleName,
      this.lastName,
      this.shortBio,
      this.fullBio,
      this.message,
      this.nickName,
      this.dateOfBirth,
      this.bloodGroup,
      this.dateOfAnniversary,
      this.gender,
      this.mobile,
      this.mobileCountryCode,
      this.profileImage,
      this.coverImage,
      this.mobileVerificationStatus,
      this.emailVerificationStatus,
      this.selected});

  UserListResponseItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    email = json['email'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    shortBio = json['short_bio'];
    fullBio = json['full_bio'];
    message = json['message'];
    nickName = json['nick_name'];
    dateOfBirth = json['date_of_birth'];
    bloodGroup = json['blood_group'];
    dateOfAnniversary = json['date_of_anniversary'];
    gender = json['gender'];
    mobile = json['mobile'];
    mobileCountryCode = json['mobile_country_code'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    mobileVerificationStatus = json['mobile_verification_status'];
    emailVerificationStatus = json['email_verification_status'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['short_bio'] = this.shortBio;
    data['full_bio'] = this.fullBio;
    data['message'] = this.message;
    data['nick_name'] = this.nickName;
    data['date_of_birth'] = this.dateOfBirth;
    data['blood_group'] = this.bloodGroup;
    data['date_of_anniversary'] = this.dateOfAnniversary;
    data['gender'] = this.gender;
    data['mobile'] = this.mobile;
    data['mobile_country_code'] = this.mobileCountryCode;
    data['profile_image'] = this.profileImage;
    data['cover_image'] = this.coverImage;
    data['mobile_verification_status'] = this.mobileVerificationStatus;
    data['email_verification_status'] = this.emailVerificationStatus;
    data['selected'] = this.selected;
    return data;
  }
}
