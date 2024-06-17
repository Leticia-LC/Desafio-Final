class Gerente {
  String managerName;
  String cpf;
  String managerState;
  String managerphoneNumber;
  int percentage;

  Gerente({
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

  factory Gerente.fromMap(Map<String, dynamic> map) {
    return Gerente(
      managerName: map['managerName'],
      cpf: map['cpf'],
      managerState: map['managerState'],
      managerphoneNumber: map['managerphoneNumber'],
      percentage: map['percentage'],
    );
  }
}
