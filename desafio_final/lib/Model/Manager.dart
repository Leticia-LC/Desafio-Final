class Manager {
  String managerName;
  String cpf;
  String managerState;
  String managerphoneNumber;
  int percentage;

  Manager({
    required this.managerName,
    required this.cpf,
    required this.managerState,
    required this.managerphoneNumber,
    required this.percentage,
  });

  Map<String, dynamic> toMap() {
    return {
      'managerName': managerName,
      'cpf': cpf,
      'managerState': managerState,
      'managerphoneNumber': managerphoneNumber,
      'percentage': percentage,
    };
  }

  factory Manager.fromMap(Map<String, dynamic> map) {
    return Manager(
      managerName: map['managerName'],
      cpf: map['cpf'],
      managerState: map['managerState'],
      managerphoneNumber: map['managerphoneNumber'],
      percentage: map['percentage'],
    );
  }
}
