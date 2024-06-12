class Cliente {
  String clientName;
  int clientPhoneNumber;
  int cnpj;
  String city;
  String clientState;

  Cliente({
    required this.clientName,
    required this.clientPhoneNumber,
    required this.cnpj,
    required this.city,
    required this.clientState,
  });

  Map<String, dynamic> toMap() {
    return {
      'clientName': clientName,
      'clientPhoneNumber': clientPhoneNumber,
      'cnpj': cnpj,
      'city': city,
      'clientState': clientState,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      clientName: map['clientName'],
      clientPhoneNumber: map['clientPhoneNumber'],
      cnpj: map['cnpj'],
      city: map['city'],
      clientState: map['clientState'],
    );
  }
}
