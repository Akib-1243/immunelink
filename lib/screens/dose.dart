class Dose {
  final String doseId;
  final String userId;
  final int doseNumber;
  final DateTime date;
  final String status;

  Dose({
    required this.doseId,
    required this.userId,
    required this.doseNumber,
    required this.date,
    required this.status,
  });
}
