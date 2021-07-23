class ConnectionListEntity {
  String? connectionOwnerId;
  String? connectionOwnerType;
  String? searchValue;
  String? connectionCategory;
  int? pageNumber;
  int? pageSize;

  ConnectionListEntity(
      {this.connectionOwnerId,
        this.connectionOwnerType,
        this.searchValue,
        this.connectionCategory,
        this.pageNumber,
        this.pageSize});

  ConnectionListEntity.fromJson(Map<String, dynamic> json) {
    connectionOwnerId = json['connectionOwnerId'];
    connectionOwnerType = json['connectionOwnerType'];
    searchValue = json['searchValue'];
    connectionCategory = json['connectionCategory'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connectionOwnerId'] = this.connectionOwnerId;
    data['connectionOwnerType'] = this.connectionOwnerType;
    data['searchValue'] = this.searchValue;
    data['connectionCategory'] = this.connectionCategory;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    return data;
  }
}
