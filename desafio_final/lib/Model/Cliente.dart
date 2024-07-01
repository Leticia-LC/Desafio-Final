class Cliente {
  String cnpj;
  String clientName;
  int clientPhoneNumber;
  String city;
  String clientState;
  String cep;
  String? managerCpf;

  Cliente({
    required this.cnpj,
    required this.clientName,
    required this.clientPhoneNumber,
    required this.city,
    required this.clientState,
    required this.cep,
    this.managerCpf,
  });

  Map<String, dynamic> toMap() {
    return {
      'cnpj': cnpj,
      'clientName': clientName,
      'clientPhoneNumber': clientPhoneNumber,
      'city': city,
      'clientState': clientState,
      'cep': cep,
      'managerCpf': managerCpf,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      cnpj: map['cnpj'],
      clientName: map['clientName'],
      clientPhoneNumber: map['clientPhoneNumber'],
      city: map['city'],
      clientState: map['clientState'],
      cep: map['cep'],
      managerCpf: map['managerCpf'],
    );
  }
}
