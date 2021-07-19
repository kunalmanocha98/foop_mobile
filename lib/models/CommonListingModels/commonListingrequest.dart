class CommonListRequestPayload {
  String searchVal;
  List<String> personType;
  int pageNumber;
  int pageSize;
  String requestedByType;
  String listType;
  String personId;
  int institutionId;

  CommonListRequestPayload(
      {this.searchVal,
      this.personType,
      this.pageNumber,
      this.pageSize,
      this.requestedByType,
      this.listType,
      this.personId,
      this.institutionId});

  CommonListRequestPayload.fromJson(Map<String, dynamic> json) {
    searchVal = json['searchVal'];
    personType = json['person_type'].cast<String>();
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
    requestedByType = json['requested_by_type'];
    listType = json['list_type'];
    personId = json['person_id'];
    institutionId = json['institution_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchVal'] = this.searchVal;
    data['person_type'] = this.personType;
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    data['requested_by_type'] = this.requestedByType;
    data['list_type'] = this.listType;
    data['person_id'] = this.personId;
    data['institution_id'] = this.institutionId;
    return data;
  }
}

class CommonListResponse {
  String statusCode;
  String message;
  int total;
  List<CommonListResponseItem> rows;

  CommonListResponse({this.statusCode, this.message, this.rows, this.total});

  CommonListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    total = json['total'];
    if (json['rows'] != null) {
      rows = [];//CommonListResponseItem>();
      json['rows'].forEach((v) {
        rows.add(new CommonListResponseItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class CommonListResponseItem {
  int id;
  String avatar;
  String title;
  String institutionName;
  SubTitle1 subTitle1;
  SubTitle1 subTitle2;
  List<String> action;
  String dateTime;
  bool isFollower;
  bool isFollowing;
  bool isSelected=false;
  bool isLoading=false;

  CommonListResponseItem(
      {this.id,
      this.avatar,
      this.title,
      this.subTitle1,
      this.subTitle2,
        this.isLoading,
      this.action,
        this.institutionName,
        this.isSelected,
      this.dateTime,
      this.isFollower,
      this.isFollowing});

  CommonListResponseItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    institutionName=json['institution_name'];
    avatar = json['avatar'];
    title = json['title'];
    subTitle1 = json['sub_title_1'] != null
        ? new SubTitle1.fromJson(json['sub_title_1'])
        : null;
    subTitle2 = json['sub_title_2'] != null
        ? new SubTitle1.fromJson(json['sub_title_2'])
        : null;
    action = json['action']!=null ?json['action'].cast<String>():null;
    dateTime = json['date_time'];
    isFollower = json['is_follower'];
    isFollowing = json['is_following'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['institution_name']=this.institutionName;
    data['title'] = this.title;
    if (this.subTitle1 != null) {
      data['sub_title_1'] = this.subTitle1.toJson();
    }
    if (this.subTitle2 != null) {
      data['sub_title_2'] = this.subTitle2.toJson();
    }
    data['action'] = this.action;
    data['date_time'] = this.dateTime;
    data['is_following'] = this.isFollowing;
    data['is_follower'] = this.isFollower;
    return data;
  }
}

class SubTitle1 {
  String designation;
  String location;
  String status;
  String networkStatus;
  String lastMessageLine;
  String contact;

  SubTitle1(
      {this.designation,
      this.location,
      this.status,
      this.networkStatus,
      this.lastMessageLine,
      this.contact});

  SubTitle1.fromJson(Map<String, dynamic> json) {
    designation = json['designation'];
    location = json['location'];
    status = json['status'];
    networkStatus = json['network_status'];
    lastMessageLine = json['last_message_line'];
    contact = json['contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['designation'] = this.designation;
    data['location'] = this.location;
    data['status'] = this.status;
    data['network_status'] = this.networkStatus;
    data['last_message_line'] = this.lastMessageLine;
    data['contact'] = this.contact;
    return data;
  }
}
