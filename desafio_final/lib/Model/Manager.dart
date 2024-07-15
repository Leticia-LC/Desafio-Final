class Manager {
  String managerName;
  String cpf;
  String managerState;
  String managerphoneNumber;
  int percentage;
  /// Construtor para a classe `Manager`
  Manager({
    required this.managerName,
    required this.cpf,
    required this.managerState,
    required this.managerphoneNumber,
    required this.percentage,
  });
  /// Converte um objeto `Manager` para um map
  Map<String, dynamic> toMap() {
    return {
      'managerName': managerName,
      'cpf': cpf,
      'managerState': managerState,
      'managerphoneNumber': managerphoneNumber,
      'percentage': percentage,
    };
  }
  /// Cria um objeto `Manager` a partir de um map
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
