import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste/pages/login_page.dart';
import '../provider/auth.dart'; 
import '../pages/setusername_page.dart';


class SignUpScreen extends StatefulWidget {

  static const routename = '/SignUpPage';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _passwordController = TextEditingController();
  String _email = '';
  String _password = '';

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
 
      return;
    }
    _formKey.currentState!.save();
  
    bool success = await Provider.of<Auth>(context, listen: false)
        .signup(_email, _password);
    if (success) {
  
      print('authentification reussi');
      Navigator.of(context).pushNamed(SetUsernameScreen.routename, arguments:  _email );
    } else {

      print('authentification a echoue');
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Icon(Icons.lock_outline, size: 88, color: Colors.white), 
                SizedBox(height: 20),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      fillColor: Colors.grey.shade200,
                      filled : true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                         borderSide: BorderSide(color: Colors.grey.shade400)
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      _email = value!.trim();
                    },
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey.shade400)
                      ),
                    ),
                    obscureText: true,
                    controller: _passwordController,
                    onSaved: (value) {
                      _password = value!.trim();
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return 'Password must be at least 6 characters long.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey.shade400)
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, 
                      onPrimary: Colors.blue[900], 
                    ),
                    onPressed: _submit,
                    child: Text('Register'),
                  ),
                  TextButton(
                  onPressed: () {
                    
                    Navigator.of(context).pushNamed(LoginPage.routename);
                  },
                  child: Text(
                    'Login now ?',
                    style: TextStyle(color: Colors.white),
                  ),
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
