class Vehicle {
  String brand;
  String model;
  String plate;
  int yearOfManufacture;
  double cost;
  String? imagePath;
  /// Construtor para a classe `Vehicle`
  Vehicle({
    required this.brand,
    required this.model,
    required this.plate,
    required this.yearOfManufacture,
    required this.cost,
    this.imagePath,
  });
  /// Converte um objeto `Vehicle` para um map
  factory Vehicle.fromMap(Map<String, dynamic> json) => Vehicle(
        brand: json["brand"],
        model: json["model"],
        plate: json["plate"],
        yearOfManufacture: json["yearOfManufacture"],
        cost: json["cost"],
        imagePath: json["imagePath"],
      );
  /// Cria um objeto `Vehicle` a partir de um map
  Map<String, dynamic> toMap() => {
        "brand": brand,
        "model": model,
        "plate": plate,
        "yearOfManufacture": yearOfManufacture,
        "cost": cost,
        "imagePath": imagePath,
  };
}
