class DoctorsModel {
  final String docID;
  final String docName;
  final String docType;
  final String description;
  final String specialization;

  DoctorsModel({
    required this.docID,
    required this.docName,
    required this.docType,
    required this.description,
    required this.specialization,
  });

  factory DoctorsModel.fromJson(Map<String, dynamic> json) {
    return DoctorsModel(
      docID: json['docID'],
      docName: json['docName'],
      docType: json['docType'],
      description: json['description'],
      specialization: json['specialization'],
    );
  }
}
