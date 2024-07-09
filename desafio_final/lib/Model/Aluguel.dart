class Aluguel {
  int? id;
  String cliente;
  int dataInicio;
  int dataTermino;
  int numeroDias;
  double valorTotal;

  Aluguel({
    this.id,
    required this.cliente,
    required this.dataInicio,
    required this.dataTermino,
    required this.numeroDias,
    required this.valorTotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cliente': cliente,
      'dataInicio': dataInicio,
      'dataTermino': dataTermino,
      'numeroDias': numeroDias,
      'valorTotal': valorTotal,
    };
  }

  factory Aluguel.fromMap(Map<String, dynamic> map) {
    return Aluguel(
      id: map['id'],
      cliente: map['cliente'],
      dataInicio: map['dataInicio'],
      dataTermino: map['dataTermino'],
      numeroDias: map['numeroDias'],
      valorTotal: map['valorTotal'],
    );
  }
}
