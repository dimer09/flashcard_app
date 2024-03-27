import 'package:flutter/material.dart';
import '../pages/flashcard_detail.dart';
import 'package:provider/provider.dart';
import '../provider/flashcard.dart';
import '../provider/contact.dart';
import '../provider/flashcards_provider.dart';

class Flashcard_item extends StatefulWidget {
  final String userid;
  // final String title;
  // final color;

  Flashcard_item({required this.userid});

  @override
  State<Flashcard_item> createState() => _Flashcard_itemState();
}

class _Flashcard_itemState extends State<Flashcard_item> {
  Color getColorFromString(String colorString) {
    Map<String, Color> colorMap = {
      'blue': Colors.blue,
      'red': Colors.red,
      'green': Colors.green,
    };

    return colorMap[colorString] ?? Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final flashcard_item = Provider.of<Flashcard>(context);
    final int numberOfCards = flashcard_item.flashcards.length;
    return Dismissible(
      key: Key(flashcard_item.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      onDismissed: (_) {
        Provider.of<FlaschCardsList>(context, listen: false)
            .removeFlashcard(widget.userid, flashcard_item.id)
            .then((success) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Flashcard supprimée avec succès')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Erreur lors de la suppression de la flashcard')),
            );
          }
        });
      },
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirmer"),
              content: const Text(
                  "Êtes-vous sûr de vouloir supprimer ce groupe de flashcards ?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Supprimer"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Annuler"),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        Flashcarddetailscreen.routename,
                        arguments: [flashcard_item.id, widget.userid]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: getColorFromString(flashcard_item.color),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                          color: getColorFromString(flashcard_item.color),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _showEditTitleDialog(
                                        context, flashcard_item);
                                  },
                                  child: Text(flashcard_item.title,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                )
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              )),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          flashcard_item
                                              .istoogle(widget.userid);
                                          print(flashcard_item.isPublic);
                                        });
                                      },
                                      icon: Icon(flashcard_item.isPublic
                                          ? Icons.lock
                                          : Icons.lock_open),
                                      iconSize: 30,
                                      color: Colors.white),
                                  Text(
                                    '$numberOfCards  cartes',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          final contacts =
                                              Provider.of<ContactsProvider>(
                                                      context,
                                                      listen: false)
                                                  .contacts;

                                          return AlertDialog(
                                            title: Text('Partager avec...'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children:
                                                    contacts.map((contact) {
                                                  return Card(
                                                    margin: EdgeInsets.all(5),
                                                    child: ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.black,
                                                        child: contact.username
                                                                .isEmpty
                                                            ? Text("A")
                                                            : Text(
                                                                contact
                                                                    .username[0]
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                      ),
                                                      title: Text(
                                                          contact.username),
                                                      onTap: () {
                                                        print(
                                                            "Partagé avec ${contact.username}");
                                                        Provider.of<FlaschCardsList>(
                                                                context,
                                                                listen: false)
                                                            .shareFlashcardWithUser(
                                                          flashcard_item.id,
                                                          widget.userid,
                                                          contact.id,
                                                        );
                                                        // Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.share),
                                    iconSize: 30,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ]),
                          )),
                    ]),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void _showEditTitleDialog(BuildContext context, Flashcard flashcard) {
    final titleController = TextEditingController(text: flashcard.title);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier le titre'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Entrez un nouveau titre',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sauvegarder'),
              onPressed: () {
                Provider.of<FlaschCardsList>(context, listen: false)
                    .updateFlashcardTitle(
                        widget.userid, flashcard.id, titleController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
