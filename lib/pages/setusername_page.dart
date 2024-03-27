import 'package:flutter/material.dart';
import '../provider/contact.dart';
import 'package:provider/provider.dart';
import '../pages/home.dart';

import '../provider/auth.dart';

class SetUsernameScreen extends StatefulWidget {
  static const routename = '/setusername';
  @override
  _SetUsernameScreenState createState() => _SetUsernameScreenState();
}

class _SetUsernameScreenState extends State<SetUsernameScreen> {
  final _usernameController = TextEditingController();

  void _saveUsername(
      BuildContext context, String userId, String username) async {
    try {
      await Provider.of<Auth>(context, listen: false)
          .addUsername(userId, username);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Log in With Successs"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushNamed(MyHomePage.routename, arguments: userId);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contact_email = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      backgroundColor: Colors.blue[600],
      // appBar: AppBar(
      //   title: Text(''),
      // ),
      body: FutureBuilder<String?>(
        future: Provider.of<Auth>(context, listen: false)
            .fetchUserIdByEmail(contact_email ?? ""),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final contactid = snapshot.data;
            print(contactid);
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Please Choose A username",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        labelText: 'Username',
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Save username
                        _saveUsername(
                            context, contactid!, _usernameController.text);
                      },
                      child: Text('Save Username'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        elevation: 6,
                        primary: Colors.white, 
                        onPrimary: Colors.blue[900], 
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No user found with this email'));
          }
        },
      ),
    );
  }
}
