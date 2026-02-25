enum LeadStatus {
  newLead,
  visitAdded,
  followUp,
  disqualified,
  converted,
}

class LeadModel {
  String name;
  String mobile;
  String email;
  String city;
  double revenue;
  String assignedTo;
  LeadStatus status;

  LeadModel({
    required this.name,
    required this.mobile,
    required this.email,
    required this.city,
    required this.revenue,
    required this.assignedTo,
    this.status = LeadStatus.newLead,
  });
}
