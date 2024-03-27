import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/flashcards_provider.dart';
import '../provider/cartes.dart';
import '../provider/flashcard.dart';

class CreateFlashcardPage extends StatefulWidget {
  static const routename = '/flashcardpagegen';
  @override
  _CreateFlashcardPageState createState() => _CreateFlashcardPageState();
}

class _CreateFlashcardPageState extends State<CreateFlashcardPage> {
  final TextEditingController _titleController = TextEditingController();
  bool _isPublic = true;
  bool _isLoading = false;
  List<CarteItem> _flashcardItems = [];

  void _addCarteItem() {
    setState(() {
      _flashcardItems.add(CarteItem(
          flashcardid: DateTime.now().toString(), question: '', reponse: ''));
    });
  }

  void _saveFlashcard() {
    setState(() {
      _isLoading = true;
    });
    final provider = Provider.of<FlaschCardsList>(context, listen: false);
    final userId = ModalRoute.of(context)?.settings.arguments as String?;

    if (userId == null) {
      print('User ID is null');
      return;
    }
    final newFlashcard = Flashcard(
      id: DateTime.now().toString(),
      title: _titleController.text,
      color: _isPublic ? 'green' : 'red',
      isPublic: _isPublic,
      flashcards: _flashcardItems,
      sharedWithUserIds: [],
    );

    provider.addFlashcard(newFlashcard, userId).then((success) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        // L'ajout a réussi
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ajout réussi'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ));
        Navigator.of(context).pop();
      } else {
        // L'ajout a échoué
        print("erreur durant lajout");
      }
      ;
      // Retour à l'écran précédent après la sauvegarde
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[600],
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: Text('Create FlashCards'),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.white),
            onPressed: _saveFlashcard,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.green,
            ))
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        labelText: 'Titre',
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                    ),
                    SwitchListTile(
                      title: Text('Public ?', style: TextStyle(color : Colors.white),),
                      value: _isPublic,
                      onChanged: (val) {
                        setState(() {
                          _isPublic = val;
                        });
                      },
                    ),
                    ..._flashcardItems.map((carte) {
                      return ListTile(
                        title: TextField(
                          onChanged: (val) => carte.setQuestion(val),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        labelText: 'Question',
                        fillColor: Colors.grey.shade200,
                        filled: true,
                            ),
                        ),
                        subtitle: TextField(
                          onChanged: (val) => carte.setReponse(val),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        labelText: 'Answer',
                        fillColor: Colors.grey.shade200,
                        filled: true,
                            ),
                        ),
                      );
                    }).toList(),
                    ElevatedButton(
                      
                      onPressed: _addCarteItem,
                      child: Text('Ajouter une carte'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
