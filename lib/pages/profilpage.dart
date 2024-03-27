import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/contact.dart';
import '../provider/flashcards_provider.dart';
import '../provider/flashcard.dart';
import '../components/cardprofil.dart';
import '../components/flashcardgroup.dart';

class ContactDetailsPage extends StatefulWidget {
  final Contact contact;
  final String currentUserId;

  ContactDetailsPage(
      {Key? key, required this.contact, required this.currentUserId})
      : super(key: key);

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  @override
  void initState() {
    super.initState();
    if (widget.currentUserId == widget.contact.id) {
      Provider.of<FlaschCardsList>(context, listen: false)
          .fetchUserFlashcards(widget.contact.id);
    } else {
      Provider.of<FlaschCardsList>(context, listen: false)
          .fetchPublicFlashcards(widget.contact.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final flashcardsProvider = Provider.of<FlaschCardsList>(context);
    final contacts = Provider.of<ContactsProvider>(context).contacts;

    bool isCurrentUser = widget.contact.id == widget.currentUserId;

    // Chargement de bonnes flashcards
    List<Flashcard> flashcards;
    if (isCurrentUser) {
      flashcards = flashcardsProvider.getUserFlashcards();
    } else {
      flashcards = flashcardsProvider.getPublicFlashcards();
    } 

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: widget.contact.id == widget.currentUserId
            ? Text('My Profile')
            : Text('Profil de ${widget.contact.username}'),
        backgroundColor: Colors.grey[200],
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Text(widget.contact.username[0].toUpperCase()),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(widget.contact.email),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileDetailCard(
                    icon: Icons.person,
                    title: 'Nom d’utilisateur',
                    value: widget.contact.username,
                    onEdit: widget.contact.id == widget.currentUserId
                        ? () => _showEditUsernameDialog(context, widget.contact)
                        : null,
                  ),
                  ProfileDetailCard(
                    icon: Icons.email,
                    title: 'Email',
                    value: widget.contact.email,
                    onEdit: widget.contact.id == widget.currentUserId
                        ? () => _showEditEmailDialog(context, widget.contact)
                        : null,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Groupes de Flashcards',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...flashcards
                      .map((flashcard) => FlashcardGroupItem(
                            contactid: widget.contact.id,
                            currentuserid: widget.currentUserId,
                            flashcard: flashcard,
                            onAddTap: () {
                              widget.contact.id != widget.currentUserId
                                  ? () {
                                      // Ajoute de la flashcard aux flashcards de l'utilisateur actuel
                                      Provider.of<FlaschCardsList>(context,
                                              listen: false)
                                          .addFlashcardToUser(
                                              widget.currentUserId, flashcard);
                                    }
                                  : null;
                            },
                          ))
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditUsernameDialog(BuildContext context, Contact contact) {
    final usernameController = TextEditingController(text: contact.username);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier le nom d’utilisateur'),
          content: TextField(
            controller: usernameController,
            decoration: InputDecoration(
                hintText: 'Entrez un nouveau nom d’utilisateur'),
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
                // Ici, insérez la logique pour mettre à jour le nom d'utilisateur dans votre base de données ou provider
                Provider.of<ContactsProvider>(context, listen: false)
                    .updateUsername(
                        widget.currentUserId, usernameController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditEmailDialog(BuildContext context, Contact contact) {
    final emailController = TextEditingController(text: contact.email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier l’email'),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(hintText: 'Entrez un nouvel email'),
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
                // Ici, insérez la logique pour mettre à jour l'email dans votre base de données ou provider
                Provider.of<ContactsProvider>(context, listen: false)
                    .updateEmail(widget.currentUserId, emailController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
