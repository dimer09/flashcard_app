import 'package:flutter/material.dart';

class ContactItem extends StatelessWidget {
  final String Username;
  final String email;
  final VoidCallback onTap;

  const ContactItem({
    required this.Username,
    required this.email,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[400],
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        elevation: 6,
        child: InkWell(
          onTap: onTap,
          child: ListTile(
            title: Text(Username),
            subtitle: Text(email),
            leading: CircleAvatar(
              backgroundColor: Colors.black,
              child: Username.isEmpty
                  ? Text("A")
                  : Text(
                      Username[0].toUpperCase(),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
