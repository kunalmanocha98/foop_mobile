class PersonalProfile {
  String statusCode;
  String message;
  Persondata rows;
  int total;

  PersonalProfile({this.statusCode, this.message, this.rows, this.total});

  PersonalProfile.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new Persondata.fromJson(json['rows']) : null;
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

class Persondata {
  UserLocation userLocation;
  int id;
  String slug;
  String userName;
  String url;
  int userId;
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
  int institutionId;
  bool isVerified;
  List<Institutions> institutions;
  List<Permissions> permissions;
  Persondata(
      {this.id,
        this.slug,
        this.url,
        this.userId,
        this.title,
        this.email,
        this.permissions,
        this.userLocation,
        this.firstName,
        this.middleName,
        this.lastName,
        this.userName,
        this.shortBio,
        this.fullBio,
        this.message,
        this.isVerified,
        this.nickName,
        this.dateOfBirth,
        this.bloodGroup,
        this.dateOfAnniversary,
        this.gender,
        this.mobile,
        this.mobileCountryCode,
        this.profileImage,
        this.coverImage,
        this.institutionId,
        this.institutions});

  Persondata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isVerified = json['is_user_verified'];
    slug = json['slug'];
    url = json['url'];
    userName=json['user_name'];
    userId = json['user_id'];
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
    userLocation = json['user_location'] != null
        ? new UserLocation.fromJson(json['user_location'])
        : null;
    mobileCountryCode = json['mobile_country_code'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    institutionId = json['institution_id'];
    if (json['institutions'] != null) {
      institutions = [];//Institutions>();
      json['institutions'].forEach((v) {
        institutions.add(new Institutions.fromJson(v));
      });
    }

    if (json['permissions'] != null) {
      permissions = [];//Permissions>();
      json['permissions'].forEach((v) {
        permissions.add(new Permissions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name']=this.userName;
    data['slug'] = this.slug;
    data['url'] = this.url;
    data['is_user_verified']=this.isVerified;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['email'] = this.email;
    if (this.userLocation != null) {
      data['user_location'] = this.userLocation.toJson();
    }
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
    data['institution_id'] = this.institutionId;
    if (this.institutions != null) {
      data['institutions'] = this.institutions.map((v) => v.toJson()).toList();
    }
    if (this.permissions != null) {
      data['permissions'] = this.permissions.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Permissions {
  int id;
  String name;
  String roleCode;
  String roleName;
  String profileImage;

  Permissions(
      {this.id, this.name, this.roleCode, this.roleName, this.profileImage});

  Permissions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    roleCode = json['role_code'];
    roleName = json['role_name'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['role_code'] = this.roleCode;
    data['role_name'] = this.roleName;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
class UserLocation {
  String addressType;
  String country;
  String elevation;
  bool isPrimary;
  String latitude;
  String longitude;
  String locality;
  String postalCode;
  String region;
  String streetAddress;
  String subRegion;

  UserLocation(
      {this.addressType,
        this.country,
        this.elevation,
        this.isPrimary,
        this.latitude,
        this.longitude,
        this.locality,
        this.postalCode,
        this.region,
        this.streetAddress,
        this.subRegion});

  UserLocation.fromJson(Map<String, dynamic> json) {
    addressType = json['address_type'];
    country = json['country'];
    elevation = json['elevation'];
    isPrimary = json['is_primary'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    locality = json['locality'];
    postalCode = json['postal_code'];
    region = json['region'];
    streetAddress = json['street_address'];
    subRegion = json['sub_region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_type'] = this.addressType;
    data['country'] = this.country;
    data['elevation'] = this.elevation;
    data['is_primary'] = this.isPrimary;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['locality'] = this.locality;
    data['postal_code'] = this.postalCode;
    data['region'] = this.region;
    data['street_address'] = this.streetAddress;
    data['sub_region'] = this.subRegion;
    return data;
  }
}

class Institutions {
  int id;
  String name;
  String role;
  String personType;
  String profileImage;
  String type;

  Institutions({this.id, this.name, this.role,this.personType,this.profileImage,this.type});

  Institutions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    role = json['role'];
    personType = json['person_type'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['role'] = this.role;
    data['person_type'] = this.personType;
    data['profile_image'] = this.profileImage;
    return data;
  }
}















