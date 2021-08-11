class BookmarkReadRequest {
  String? username;
  String? folder;
  List<String>? uidsList;
  String? flag;

  BookmarkReadRequest({this.username, this.folder, this.uidsList, this.flag});

  BookmarkReadRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    folder = json['folder'];
    uidsList = json['uids_list'].cast<String>();
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['folder'] = this.folder;
    data['uids_list'] = this.uidsList;
    data['flag'] = this.flag;
    return data;
  }
}