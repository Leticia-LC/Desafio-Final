class Veiculo {
  String marca;
  String modelo;
  String placa;
  int anoFabricaco;
  int custo;

  Veiculo({
    required this.marca,
    required this.modelo,
    required this.placa,
    required this.anoFabricaco,
    required this.custo,
  });

  Map<String, dynamic> toMap() {
    return {
      'marca': marca,
      'modelo': modelo,
      'placa': placa,
      'anoFabricaco': anoFabricaco,
      'custo': custo,
    };
  }

  factory Veiculo.fromMap(Map<String, dynamic> map) {
    return Veiculo(
      marca: map['marca'],
      modelo: map['modelo'],
      placa: map['placa'],
      anoFabricaco: map['anoFabricaco'],
      custo: map['custo'],
    );
  }
}
