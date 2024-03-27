import 'package:flutter/material.dart';
import '../pages/addflashcard.dart';

class Popup extends StatelessWidget {
  final userId;
  Popup({this.userId});

  void showCreationOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Créer une Flashcard'),
          content: Text('Choisissez la méthode de création :'),
          actions: <Widget>[
            TextButton(
              child: Text('Par soi-même'),
              onPressed: () {
                Navigator.of(context).pushNamed(CreateFlashcardPage.routename,
                    arguments: userId);
                // Navigation vers la page de création manuelle
              },
            ),
            TextButton(
              child: Text('Avec IA'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigation vers la page de création avec IA
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      color: Colors.white,
      iconSize: 20,
      onPressed: () => showCreationOptions(context),
    );
  }
}
