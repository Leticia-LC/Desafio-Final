class Aluguel{
  int id;
  String cliente;
  int dataInicio;
  int dataTermino;
  int numeroDias;
  int valorTotal;

  Aluguel({
    required this.id,
    required this.cliente,
    required this.dataInicio,
    required this.dataTermino,
    required this.numeroDias,
    required this.valorTotal,

  });

  Map<String, dynamic> toMap(){
    return{
      'id' : id,
      'cliente' : cliente,
      'datainicio' : dataInicio,
      'datatermino' : dataTermino,
      'numeroDias' : numeroDias,
      'valorTotal' : valorTotal,

    };
  }

  factory Aluguel.fromMap(Map<String, dynamic> map){
    return Aluguel(
      id: map['id'],
      cliente: map['cliente'],
      dataInicio: map['dataincio'],
      dataTermino: map['dataTermino'],
      numeroDias: map['numeroDias'],
      valorTotal: map['valorTotal'],

    );
  }
}