class Veiculo {
  String marca;
  String modelo;
  String placa;
  int anoFabricacao;
  int custo;

  Veiculo({
    required this.marca,
    required this.modelo,
    required this.placa,
    required this.anoFabricacao,
    required this.custo,
  });

  Map<String, dynamic> toMap() {
    return {
      'marca': marca,
      'modelo': modelo,
      'placa': placa,
      'anoFabricacao': anoFabricacao,
      'custo': custo,
    };
  }

  factory Veiculo.fromMap(Map<String, dynamic> map) {
    return Veiculo(
      marca: map['marca'],
      modelo: map['modelo'],
      placa: map['placa'],
      anoFabricacao: map['anoFabricacao'],
      custo: map['custo'],
    );
  }
}
