class Client {
  String cnpj;
  String clientName;
  int clientPhoneNumber;
  String city;
  String clientState;
  String cep;
  String? managerCpf;
  /// Construtor para a classe `Client`
  Client({
    required this.cnpj,
    required this.clientName,
    required this.clientPhoneNumber,
    required this.city,
    required this.clientState,
    required this.cep,
    this.managerCpf,
  });
  /// Converte um objeto `Client` para um map
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
  /// Cria um objeto `Client` a partir de um map
  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
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
