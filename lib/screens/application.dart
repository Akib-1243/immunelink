class Application {
  String? id;
  String name;
  String nationality;
  String vaccineName;
  String nidNumber;
  String phoneNumber;
  DateTime submissionDate;
  String status;
  String? adminComment;

  Application({
    this.id,
    required this.name,
    required this.nationality,
    required this.vaccineName,
    required this.nidNumber,
    required this.phoneNumber,
    required this.submissionDate,
    this.status = 'Pending',
    this.adminComment,
  });

  // Convert Application to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nationality': nationality,
      'vaccineName': vaccineName,
      'nidNumber': nidNumber,
      'phoneNumber': phoneNumber,
      'submissionDate': submissionDate.millisecondsSinceEpoch,
      'status': status,
      'adminComment': adminComment,
    };
  }

  // Create Application from Firebase Map
  factory Application.fromMap(Map<String, dynamic> map, String id) {
    return Application(
      id: id,
      name: map['name'] ?? '',
      nationality: map['nationality'] ?? '',
      vaccineName: map['vaccineName'] ?? '',
      nidNumber: map['nidNumber'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      submissionDate: DateTime.fromMillisecondsSinceEpoch(map['submissionDate'] ?? 0),
      status: map['status'] ?? 'Pending',
      adminComment: map['adminComment'],
    );
  }

  // Create a copy of Application with updated fields
  Application copyWith({
    String? id,
    String? name,
    String? nationality,
    String? vaccineName,
    String? nidNumber,
    String? phoneNumber,
    DateTime? submissionDate,
    String? status,
    String? adminComment,
  }) {
    return Application(
      id: id ?? this.id,
      name: name ?? this.name,
      nationality: nationality ?? this.nationality,
      vaccineName: vaccineName ?? this.vaccineName,
      nidNumber: nidNumber ?? this.nidNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      submissionDate: submissionDate ?? this.submissionDate,
      status: status ?? this.status,
      adminComment: adminComment ?? this.adminComment,
    );
  }
}