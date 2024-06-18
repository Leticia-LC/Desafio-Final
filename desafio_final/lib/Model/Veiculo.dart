class Veiculo {
  String marca;
  String modelo;
  String placa;
  int anoFabricacao;
  int custo;
  String? imagemPath;

  Veiculo({
    required this.marca,
    required this.modelo,
    required this.placa,
    required this.anoFabricacao,
    required this.custo,
    required this.imagemPath,
  });

  factory Veiculo.fromMap(Map<String, dynamic> json) => Veiculo(
    marca: json["marca"],
    modelo: json["modelo"],
    placa: json["placa"],
    anoFabricacao: json["anoFabricacao"],
    custo: json["custo"],
    imagemPath: json["imagemPath"],
  );

  Map<String, dynamic> toMap() => {
    "marca": marca,
    "modelo": modelo,
    "placa": placa,
    "anoFabricacao": anoFabricacao,
    "custo": custo,
    "imagemPath": imagemPath,
  };
}
