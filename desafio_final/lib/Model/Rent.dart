class Rent {
  int? idRent;
  String client;
  int startDate;
  int endDate;
  int numberOfDays;
  double totalValue;
  String vehiclePlate;
  /// Construtor para a classe `Rent`
  Rent({
    this.idRent,
    required this.client,
    required this.startDate,
    required this.endDate,
    required this.numberOfDays,
    required this.totalValue,
    required this.vehiclePlate,
  });
  /// Converte um objeto `Rent` para um map
  Map<String, dynamic> toMap() {
    return {
      'idRent': idRent,
      'client': client,
      'startDate': startDate,
      'endDate': endDate,
      'numberOfDays': numberOfDays,
      'totalValue': totalValue,
      'vehiclePlate': vehiclePlate,
    };
  }
  /// Cria um objeto `Rent` a partir de um map
  factory Rent.fromMap(Map<String, dynamic> map) {
    return Rent(
      idRent: map['idRent'],
      client: map['client'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      numberOfDays: map['numberOfDays'],
      totalValue: map['totalValue'].toDouble(),
      vehiclePlate: map['vehiclePlate'],
    );
  }
}
