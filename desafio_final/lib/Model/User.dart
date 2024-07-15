class User {
  int? id;
  String name;
  String lastname;
  String email;
  String password;
  /// Construtor para a classe `User`
  User({
    this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.password,
  });
  /// Converte um objeto `User` para um map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastname': lastname,
      'email': email,
      'password': password,
    };
  }
  /// Cria um objeto `User` a partir de um map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      lastname: map['lastname'],
      email: map['email'],
      password: map['password'],
    );
  }
}
