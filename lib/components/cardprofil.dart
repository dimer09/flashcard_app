import 'package:flutter/material.dart';

class ProfileDetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final void Function()? onEdit;

  const ProfileDetailCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title),
        subtitle: Text(value),
        trailing: onEdit != null
            ? IconButton(
                icon: Icon(Icons.edit),
                onPressed: onEdit,
              )
            : null,
      ),
    );
  }
}
