import 'package:flutter/material.dart';
import './signup_page.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart'; 
import '../pages/home.dart';


class LoginPage extends StatefulWidget {

  static const routename = '/loginPage';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

void _login(BuildContext context) async {
  final authProvider = Provider.of<Auth>(context, listen: false);
  String email = _usernameController.text; 
  String password = _passwordController.text;

  bool response = await authProvider.login(email, password);

  if (response) {
    String? userId = await authProvider.fetchUserIdByEmail(email);

    if (userId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connecté avec succès !'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigation vers MyHomePage en passant l'userId 
      Navigator.of(context).pushReplacementNamed(
        MyHomePage.routename,
        arguments: userId,
      );
    } else {
      // Affichage d'un message d'erreur si l'userId est null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de la récupération des informations de l\'utilisateur.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } else {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Échec de la connexion.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Icon(Icons.lock_outline, size: 88, color: Colors.white), 
              SizedBox(height: 20),
              Text(
                "Welcome back you've been missed!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, 
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                 
                  fillColor: Colors.grey.shade200,
                  filled :true,
                ),
                
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                 
                  fillColor: Colors.grey.shade200,
                  filled :true,
                ),
                
              ),
              SizedBox(height: 10),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _login(context);
                },
                child: Text('Sign In'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  elevation: 6,
                  primary: Colors.white, // Fond du bouton
                  onPrimary:Colors.blue[900], // Texte du bouton
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Don t have an account ?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextButton(
                onPressed: () {
                  
                  Navigator.of(context).pushNamed(SignUpScreen.routename);
                },
                child: Text(
                  'Register now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
