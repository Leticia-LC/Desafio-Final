class Rent {
  int? idRent;
  String client;
  int startDate;
  int endDate;
  int numberOfDays;
  double totalValue;
  String vehiclePlate;

  Rent({
    this.idRent,
    required this.client,
    required this.startDate,
    required this.endDate,
    required this.numberOfDays,
    required this.totalValue,
    required this.vehiclePlate,
  });

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
