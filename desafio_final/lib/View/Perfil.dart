import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/Theme_provider.dart';
import '../Model/Database.dart';
import '../Model/Usuario.dart';
import 'Login.dart';

class ProfileScreen extends StatefulWidget {
  final Usuario usuario;

  ProfileScreen({required this.usuario});

  @override
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

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.usuario.name);
    _lastnameController = TextEditingController(text: widget.usuario.lastname);
    _emailController = TextEditingController(text: widget.usuario.email);
    _passwordController = TextEditingController(text: widget.usuario.password);
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      Usuario updatedUser = Usuario(
        id: widget.usuario.id,
        name: _nameController.text,
        lastname: _lastnameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      await _dbHelper.updateUsuario(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );

      setState(() {
        widget.usuario.name = _nameController.text;
        widget.usuario.lastname = _lastnameController.text;
        widget.usuario.email = _emailController.text;
        widget.usuario.password = _passwordController.text;
      });
    }
  }

  void _deleteAccount() async {
    if (widget.usuario.id != null) {
      await _dbHelper.deleteUsuario(widget.usuario.id!);

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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nome',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _lastnameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Sobrenome',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu sobrenome';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
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
                        textStyle: TextStyle(fontSize: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
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
                        textStyle: TextStyle(fontSize: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
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
        ),
      ),
    );
  }
}
