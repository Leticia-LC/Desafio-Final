class User {
  int? id;
  String name;
  String lastname;
  String email;
  String password;

  User({
    this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastname': lastname,
      'email': email,
      'password': password,
    };
  }

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
