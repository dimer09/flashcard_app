import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/flashcards_provider.dart';
import '../components/carte_item.dart';
import '../provider/cartes.dart';
import '../pages/signup_page.dart';
import "package:uuid/uuid.dart";

class Flashcarddetailscreen extends StatefulWidget {
  const Flashcarddetailscreen();
  static const routename = '/flashscreendetail';

  @override
  State<Flashcarddetailscreen> createState() => _FlashcarddetailscreenState();
}

class _FlashcarddetailscreenState extends State<Flashcarddetailscreen> {
  var uuid = Uuid();

  void _addNewCarte(BuildContext context, String flashcardId) {
    final TextEditingController questionController = TextEditingController();
    final TextEditingController answerController = TextEditingController();
    final arguments = ModalRoute.of(context)?.settings.arguments as List?;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ajouter une nouvelle carte'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: answerController,
              decoration: InputDecoration(labelText: 'Réponse'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Annuler'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: Text('Ajouter'),
            onPressed: () async {
              final newCarte = CarteItem(
                  flashcardid: flashcardId,
                  question: questionController.text,
                  reponse: answerController.text);
              final success = await Provider.of<FlaschCardsList>(context,
                      listen: false)
                  .addCarteToFlashcard(arguments![1], flashcardId, newCarte);
              Navigator.of(ctx).pop();

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Carte ajoutée avec succès')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Erreur lors de l\'ajout de la carte')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, CarteItem carteItem,
      String flashcardId, Function(String, String, String, String) onUpdate) {
    final questionController = TextEditingController(text: carteItem.question);
    final answerController = TextEditingController(text: carteItem.reponse);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier la carte'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: answerController,
              decoration: InputDecoration(labelText: 'Réponse'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Annuler'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Sauvegarder'),
            onPressed: () {
              onUpdate(flashcardId, carteItem.flashcardid,
                  questionController.text, answerController.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flashcardid = ModalRoute.of(context)?.settings.arguments as List?;

    // final flashitem = Provider.of<FlaschCardsList>(context, listen: false)
    //     .findById(flashcardid);
    if (flashcardid![0] == null) {
      Navigator.of(context).pushNamed(SignUpScreen.routename);
    }
    ;
    final String flashcardide = flashcardid[0] as String;
    final flashitem = Provider.of<FlaschCardsList>(context, listen: true)
        .findById(flashcardide);

    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                        color: Colors.white,
                        icon: Icon(Icons.keyboard_return),
                        iconSize: 20,
                      ),
                      SizedBox(width: 20),
                      Text(flashitem.title,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _addNewCarte(context, flashcardide);
                      });
                    },
                    color: Colors.white,
                    icon: Icon(Icons.add),
                    iconSize: 20,
                  ),
                ],
              ),
            ]),
          ),
          Expanded(
            child: Center(
              child: ListView.builder(
                  itemCount: flashitem.flashcards.length,
                  itemBuilder: (ctx, i) => Carte_Item(
                        id: flashitem.flashcards[i].flashcardid,
                        question: flashitem.flashcards[i].question,
                        answer: flashitem.flashcards[i].reponse,
                        onDelete: () {
                          Provider.of<FlaschCardsList>(context, listen: false)
                              .removeCarteItem(flashcardid[1], flashcardide,
                                  flashitem.flashcards[i].flashcardid)
                              .then((success) {
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Carte supprimee avec succès')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Erreur lors de la suppression de la Carte')),
                              );
                            }
                          });
                          ;
                        },
                        onEdit: () {
                          _showEditDialog(
                              context, flashitem.flashcards[i], flashcardide,
                              (String flashcardId, String carteId,
                                  String newQuestion, String newAnswer) {
                            Provider.of<FlaschCardsList>(context, listen: false)
                                .updateCarteItem(flashcardid[1], flashcardId,
                                    carteId, newQuestion, newAnswer)
                                .then((success) {
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Carte mis à jour avec succès')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Erreur lors de la mise à jour de la carte')),
                                );
                              }
                            });
                           
                          });
                        },
                      )),
            ),
          ),
        ]),
      ),
    );
  }
}
