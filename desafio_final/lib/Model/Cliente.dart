class Cliente {
  String cnpj;
  String clientName;
  int clientPhoneNumber;
  String city;
  String clientState;

  Cliente({
    required this.cnpj,
    required this.clientName,
    required this.clientPhoneNumber,
    required this.city,
    required this.clientState,
  });

  Map<String, dynamic> toMap() {
    return {
      'cnpj': cnpj,
      'clientName': clientName,
      'clientPhoneNumber': clientPhoneNumber,
      'city': city,
      'clientState': clientState,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      cnpj: map['cnpj'],
      clientName: map['clientName'],
      clientPhoneNumber: map['clientPhoneNumber'],
      city: map['city'],
      clientState: map['clientState'],
    );
  }
}
