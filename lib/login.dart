import 'package:bihar/controller/login_data.dart';
import 'package:bihar/controller/profile_controller.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginformKey = GlobalKey<FormState>();
  String? _ldap;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text('B.I.H.A.R')),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Acceso: ', style: TextStyle(fontSize: 24)),
          ),
          _loginForm(),
          _loginButton()
        ]
      ),
    );
  }

  Widget _loginForm(){
    return Form(
      key: _loginformKey,
        child:
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'LDAP',
                  hintText: 'Tu usuario LDAP de GAUR'
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'El usuario no puede estar vacío';
                  }
                  if (int.tryParse(value) == null) {
                    return 'El LDAP solo son números';
                  }
                  // if (value.length != 7) {
                  //   return 'El LDAP tiene que tener 7 dígitos';
                  // }
                  return null;
                },
                onSaved: (newValue) => _ldap = newValue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contraseña',
                    hintText: 'Tu contraseña de GAUR'
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'La contraseña no puede estar vacía';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _password = newValue,
              ),
            )
          ]
        )
      );
  }

  Widget _loginButton(){
    return Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(20)),
      child: ElevatedButton(
        onPressed: () async{
          if (!_loginformKey.currentState!.validate()) {
            return;
          }
          _loginformKey.currentState!.save();
          LoginData.setCredentials(_ldap!, _password!);
          switch (await ProfileController().login()) {
            case LoginResponse.ok:
              Navigator.of(context).pushReplacementNamed('/home');
              break;
            case LoginResponse.connectionError:
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error de conexión', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
              break;
            case LoginResponse.invalidCredentials:
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Credenciales incorrectas', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error desconocido', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        child: Text(
          'Login',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 25),
        ),
      ),
    );
  }
}
