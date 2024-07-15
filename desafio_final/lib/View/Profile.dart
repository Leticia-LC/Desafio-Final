import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/Database.dart';
import '../Controller/Theme_provider.dart';
import '../Model/User.dart';
import 'Login.dart';

/// Tela de perfil do usuário
class ProfileScreen extends StatefulWidget {
  /// Usuário atual, passado para a tela de perfil
  final User user;

  ProfileScreen({required this.user});

  @override
  /// Estado da tela de perfil
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  late TextEditingController _nameController;
  late TextEditingController _lastnameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }
  ///Inicializa os controladores de texto com os dados do usuário
  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.user.name);
    _lastnameController = TextEditingController(text: widget.user.lastname);
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController(text: widget.user.password);
  }
  /// Atualiza o perfil do usuário no banco de dados
  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      User updatedUser = User(
        id: widget.user.id,
        name: _nameController.text,
        lastname: _lastnameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      await _dbHelper.updateUser(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );

      setState(() {
        widget.user.name = _nameController.text;
        widget.user.lastname = _lastnameController.text;
        widget.user.email = _emailController.text;
        widget.user.password = _passwordController.text;
      });
    }
  }
  /// Deleta a conta do usuário do banco de dados
  void _deleteAccount() async {
    if (widget.user.id != null) {
      await _dbHelper.deleteUser(widget.user.id!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Conta deletada com sucesso!')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar conta: ID inválido')),
      );
    }
  }
  /// Altera o tema da aplicação
  void _changeTheme(ThemeMode themeMode) {
    context.read<ThemeProvider>().setTheme(themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    hintText: "Nome", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text('Sobrenome', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextFormField(
                controller: _lastnameController,
                decoration: InputDecoration(
                    hintText: "Sobrenome", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu sobrenome';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    hintText: "Email", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text('Senha', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "Senha",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
                obscureText: !_showPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                  ),
                  child: Text('Atualizar Perfil'),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _deleteAccount,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                  ),
                  child: Text('Deletar Conta'),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Tema',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text('Claro'),
                        leading: Radio(
                          value: ThemeMode.light,
                          groupValue: themeProvider.themeMode,
                          onChanged: (ThemeMode? value) {
                            if (value != null) {
                              _changeTheme(value);
                            }
                          },
                        ),
                      ),
                      ListTile(
                        title: Text('Escuro'),
                        leading: Radio(
                          value: ThemeMode.dark,
                          groupValue: themeProvider.themeMode,
                          onChanged: (ThemeMode? value) {
                            if (value != null) {
                              _changeTheme(value);
                            }
                          },
                        ),
                      ),
                      ListTile(
                        title: Text('Automático'),
                        leading: Radio(
                          value: ThemeMode.system,
                          groupValue: themeProvider.themeMode,
                          onChanged: (ThemeMode? value) {
                            if (value != null) {
                              _changeTheme(value);
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
