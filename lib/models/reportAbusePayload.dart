class ReportAbusePayload {
  String reportedByType;
  int reportedById;
  String reportedContextType;
  int reportedContextId;
  String abuseType;
  String abuseDetails;

  ReportAbusePayload(
      {this.reportedByType,
      this.reportedById,
      this.reportedContextType,
      this.reportedContextId,
      this.abuseType,
      this.abuseDetails});

  ReportAbusePayload.fromJson(Map<String, dynamic> json) {
    reportedByType = json['reported_by_type'];
    reportedById = json['reported_by_id'];
    reportedContextType = json['reported_context_type'];
    reportedContextId = json['reported_context_id'];
    abuseType = json['abuse_type'];
    abuseDetails = json['abuse_details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reported_by_type'] = this.reportedByType;
    data['reported_by_id'] = this.reportedById;
    data['reported_context_type'] = this.reportedContextType;
    data['reported_context_id'] = this.reportedContextId;
    data['abuse_type'] = this.abuseType;
    data['abuse_details'] = this.abuseDetails;
    return data;
  }
}
