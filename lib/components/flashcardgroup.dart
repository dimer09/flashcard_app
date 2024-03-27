import 'package:flutter/material.dart';
import '../provider/flashcard.dart';

class FlashcardGroupItem extends StatelessWidget {
  final Flashcard flashcard;
  final VoidCallback onAddTap;
  final currentuserid;
  final contactid;

  const FlashcardGroupItem({
    Key? key,
    required this.flashcard,
    required this.onAddTap,
    required this.currentuserid,
    required this.contactid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(flashcard.title),
        trailing: IconButton(
          icon: currentuserid == contactid
              ? Icon(Icons.share, color: Colors.black)
              : Icon(Icons.add, color: Colors.black),
          onPressed: onAddTap,
        ),
      ),
    );
  }
}
