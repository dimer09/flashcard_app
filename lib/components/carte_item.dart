import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class Carte_Item extends StatelessWidget {
  final String id;
  final String question;
  final String answer;
  final VoidCallback onDelete; // Callback pour gérer la suppression
  final VoidCallback onEdit; // Callback pour gérer l'édition

  const Carte_Item({
    Key? key,
    required this.id,
    required this.question,
    required this.answer,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete();
      },
      child: FlipCard(
        front: buildCardSide(context, question, true),
        back: buildCardSide(context, answer, false),
      ),
    );
  }

  Widget buildCardSide(BuildContext context, String text, bool isQuestion) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 6,
      color: Colors.blue[600],
      child: InkWell(
        onTap: () => onEdit(),
        splashColor: Colors.white.withAlpha(30),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
