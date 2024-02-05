class DateModel {
  final String id;
  final String docName;
  final String patientName;
  final DateTime schedule;

  DateModel({
    required this.id,
    required this.docName,
    required this.patientName,
    required this.schedule,
  });
  factory DateModel.fromJson(Map<String, dynamic> json) {
    return DateModel(
      id: json['id'],
      docName: json['docName'],
      patientName: json['patientName'],
      schedule: json['schedule'],
    );
  }
}
