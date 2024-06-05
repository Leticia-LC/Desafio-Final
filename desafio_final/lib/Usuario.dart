class Usuario {
  int? id;
  String? name;
  String? lastname;
  String? email;
  String? password;

  Usuario({this.id, this.name, this.lastname, this.email, this.password});

  Map<String, dynamic> toMap() {
    var mapa = <String, dynamic>{
      'nome': name,
      'sobrenome': lastname,
      'email' : email,
      'senha' : password,

    };
    if (id != null) {
      mapa['id'] = id;
    }
    return mapa;
  }

  Usuario.fromMap(Map<String, dynamic> mapa) {
    id = mapa['id'];
    name = mapa['nome'];
    lastname = mapa['sobrenome'];
    email = mapa ['email'];
    password = mapa ['senha'];
  }
}