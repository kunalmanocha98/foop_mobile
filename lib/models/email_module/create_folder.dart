class FolderCreateRequest {
  String? username;
  String? folder;
  String? destinationFolder;

  FolderCreateRequest({this.username, this.folder, this.destinationFolder});

  FolderCreateRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    folder = json['folder'];
    destinationFolder = json['destination_folder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['folder'] = this.folder;
    data['destination_folder'] = this.destinationFolder;
    return data;
  }
}

class FolderListResponse {
  String? statusCode;
  String? message;
  List<FolderListItem>? rows;
  int? total;

  FolderListResponse({this.statusCode, this.message, this.rows, this.total});

  FolderListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];
      json['rows'].forEach((v) {
        rows!.add(new FolderListItem.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class FolderListItem {
  List<String>? flags;
  String? delim;
  String? name;
  int? messages;
  int? recent;
  int? unseen;

  FolderListItem(
      {this.flags,
        this.delim,
        this.name,
        this.messages,
        this.recent,
        this.unseen});

  FolderListItem.fromJson(Map<String, dynamic> json) {
    flags = json['flags'].cast<String>();
    delim = json['delim'];
    name = json['name'];
    messages = json['messages'];
    recent = json['recent'];
    unseen = json['unseen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flags'] = this.flags;
    data['delim'] = this.delim;
    data['name'] = this.name;
    data['messages'] = this.messages;
    data['recent'] = this.recent;
    data['unseen'] = this.unseen;
    return data;
  }
}
class MoveFolderRequest {
  String? username;
  List<String>? uidsList;
  String? folder;
  String? moveToFolder;

  MoveFolderRequest(
      {this.username, this.uidsList, this.folder, this.moveToFolder});

  MoveFolderRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    uidsList = json['uids_list'].cast<String>();
    folder = json['folder'];
    moveToFolder = json['move_to_folder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['uids_list'] = this.uidsList;
    data['folder'] = this.folder;
    data['move_to_folder'] = this.moveToFolder;
    return data;
  }
}

