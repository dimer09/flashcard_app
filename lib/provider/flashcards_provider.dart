import 'package:flutter/material.dart';
import 'flashcard.dart';
import '../provider/cartes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';

class FlaschCardsList with ChangeNotifier {
  // List<Flashcard> _items = [];

  // FlashCardsList() {
  //   _initItems();
  // }

  // void _initItems() {
  //   final carteItem1 = CarteItem(flashcardid: '1', question: 'Quelle est la capitale de la France ?', reponse: 'Paris');
  //   final carteItem2 = CarteItem(flashcardid: '2', question: 'Quelle est la formule chimique de l eau ?', reponse: 'H2O');
  //   final carteItem3 = CarteItem(flashcardid: '3', question: 'Qui a écrit Les Misérables ?', reponse: 'Victor Hugo');
  //   final carteItem4 = CarteItem(flashcardid: '4', question: 'Quelle est la plus grande planète du système solaire ?', reponse: 'Jupiter');
  //   final carteItem5 = CarteItem(flashcardid: '5', question: 'Quel est le produit de 7 par 8 ?', reponse: '56');

  //   _items = [
  //     Flashcard(id: '1', title: 'Géographie', color: Colors.blue, isPublic: true, flashcards: [carteItem1], sharedWithUserIds: []),
  //     Flashcard(id: '2', title: 'Science', color: Colors.green, isPublic: false, flashcards: [carteItem2], sharedWithUserIds: []),
  //     Flashcard(id: '3', title: 'Littérature', color: Colors.red, isPublic: true, flashcards: [carteItem3], sharedWithUserIds: []),
  //     Flashcard(id: '4', title: 'Astronomie', color: Colors.purple, isPublic: false, flashcards: [carteItem4], sharedWithUserIds: []),
  //     Flashcard(id: '5', title: 'Mathématiques', color: Colors.yellow, isPublic: true, flashcards: [carteItem5], sharedWithUserIds: []),
  //   ];

  // }

  List<Flashcard> _items = [
    Flashcard(
        id: '1',
        title: 'Géographie',
        color: "blue",
        isPublic: true,
        flashcards: [
          CarteItem(
              flashcardid: '2',
              question: 'Quelle est la capitale de la France ?',
              reponse: 'Paris'),
          CarteItem(
              flashcardid: '1',
              question: 'Quelle est la capitale de la Belgique ?',
              reponse: 'Liege')
        ],
        sharedWithUserIds: []),
    Flashcard(
        id: '2',
        title: 'Science',
        color: 'green',
        isPublic: false,
        flashcards: [
          CarteItem(
              flashcardid: '2',
              question: 'Quelle est la formule chimique de l eau ?',
              reponse: 'H2O')
        ],
        sharedWithUserIds: []),
    Flashcard(
        id: '3',
        title: 'Littérature',
        color: 'red',
        isPublic: false,
        flashcards: [
          CarteItem(
              flashcardid: '3',
              question: 'Qui a écrit Les Misérables ?',
              reponse: 'Victor Hugo')
        ],
        sharedWithUserIds: []),
    Flashcard(
        id: '4',
        title: 'Astronomie',
        color: 'purple',
        isPublic: false,
        flashcards: [
          CarteItem(
              flashcardid: '4',
              question:
                  'Quelle est la plus grande planète du système solaire ?',
              reponse: 'Jupiter')
        ],
        sharedWithUserIds: []),
    Flashcard(
        id: '5',
        title: 'Mathématiques',
        color: 'yellow',
        isPublic: false,
        flashcards: [
          CarteItem(
              flashcardid: '5',
              question: 'Quel est le produit de 7 par 8 ?',
              reponse: '56')
        ],
        sharedWithUserIds: []),
  ];

  var showprivate = false;
  List<Flashcard> _allItems = [];
  List<Flashcard> _filteredItems = [];
  List<Flashcard> _public_items = [];

  List<Flashcard> _userFlashcards = [];
  List<Flashcard> _otherUserPublicFlashcards = [];

  var uuid = Uuid();



  // }
  String _searchQuery = '';
  List<Flashcard> get items {
    if (_searchQuery.isEmpty) {
      if (showprivate) {
        return _items.where((element) => element.isPublic).toList();
      } else if (!showprivate) {
        return _items.where((element) => !element.isPublic).toList();
      }
      return [..._items];
    } else {
      return _items
          .where((item) =>
              item.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  List<Flashcard> get privateitems {
    return _items.where((element) => element.isPublic).toList();
  }

  List<Flashcard> get publicFlashcards => _public_items;

  List<Flashcard> getUserFlashcards() => _userFlashcards;
  List<Flashcard> getPublicFlashcards() => _otherUserPublicFlashcards;

  Flashcard findById(String id) {
    return _items.firstWhere((flashId) => flashId.id == id);
  }

  Future<bool> addCarteToFlashcard(
      String userId, String flashcardId, CarteItem carteItem) async {
    if (userId.isEmpty || flashcardId.isEmpty) {
      return false;
    }

    var UUID = Uuid();

    var flashcard = _items.firstWhere((fc) => fc.id == flashcardId);
    if (flashcard == null) {
      return false;
    }

    flashcard.flashcards.add(carteItem);
    notifyListeners();

    final url = Uri.parse(
        'https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$userId/flashcards/$flashcardId/flashcards.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': UUID.v4().toString(),
          'question': carteItem.question,
          'reponse': carteItem.reponse,
        }),
      );

      if (response.statusCode >= 400) {
        flashcard.flashcards
            .removeWhere((item) => item.flashcardid == carteItem.flashcardid);
        notifyListeners();
        return false;
      }
      return true;
    } catch (error) {
      flashcard.flashcards
          .removeWhere((item) => item.flashcardid == carteItem.flashcardid);
      notifyListeners();
      return false;
    }
  }

  void showprivateOnly() {
    showprivate = true;
    notifyListeners();
  }

  void showpublicOnly() {
    showprivate = false;
    notifyListeners();
  }

  Color getColorFromString(String colorString) {
    Map<String, Color> colorMap = {
      'blue': Colors.blue,
      'red': Colors.red,
      'green': Colors.green,
   
    };

    return colorMap[colorString] ??
        Colors.blue;
  }

  Future<bool> fetchAndSetFlashcards(String userId) async {
    if (userId.isEmpty) {
      return false;
    }

    final url = Uri.parse(
        'https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$userId/flashcards.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return true;
      }
      print(extractedData);
      final List<Flashcard> loadedFlashcards = [];
      extractedData.forEach((flashcardId, flashcardData) {
        List<CarteItem> flashcardItems = [];
        var flashcardsData = flashcardData['flashcards'];
        if (flashcardsData is Map) {
          flashcardsData.forEach((cardId, cardData) {
            flashcardItems.add(CarteItem(
              flashcardid: cardId,
              question: cardData['question'],
              reponse: cardData['reponse'],
            ));
          });
        } else if (flashcardsData is List) {
          flashcardItems = flashcardsData
              .map((item) => CarteItem(
                    flashcardid: item['id'],
                    question: item['question'],
                    reponse: item['reponse'],
                  ))
              .toList();
        }

        loadedFlashcards.add(Flashcard(
          id: flashcardId,
          title: flashcardData['title'],
          color: flashcardData['color'],
          isPublic: flashcardData['isPublic'],
          flashcards: flashcardItems,
          sharedWithUserIds: flashcardData['sharedWithUserIds'] != null
              ? List<String>.from(flashcardData['sharedWithUserIds'])
              : [],
        ));
      });

      _items = loadedFlashcards;
      notifyListeners();
      return true;
    } catch (error) {
      print('Error fetching flashcards: $error');
      return false;
    }
  }

  Future<void> fetchUserFlashcards(String userId) async {
    if (userId.isEmpty) {
      _userFlashcards.clear();
      return;
    }

    final url = Uri.parse(
        'https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$userId/flashcards.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      _userFlashcards.clear();
      if (extractedData != null) {
        extractedData.forEach((flashcardId, flashcardData) {
          List<CarteItem> flashcardItems = [];
          var flashcardsData = flashcardData['flashcards'];
          if (flashcardsData is Map) {
            flashcardsData.forEach((cardId, cardData) {
              flashcardItems.add(CarteItem(
                flashcardid: cardId,
                question: cardData['question'],
                reponse: cardData['reponse'],
              ));
            });
          } else if (flashcardsData is List) {
            flashcardItems = flashcardsData
                .map((item) => CarteItem(
                      flashcardid: item['id'],
                      question: item['question'],
                      reponse: item['reponse'],
                    ))
                .toList();
          }

          _userFlashcards.add(Flashcard(
            id: flashcardId,
            title: flashcardData['title'],
            color: flashcardData['color'],
            isPublic: flashcardData['isPublic'],
            flashcards: flashcardItems,
            sharedWithUserIds: flashcardData['sharedWithUserIds'] != null
                ? List<String>.from(flashcardData['sharedWithUserIds'])
                : [],
          ));
        });
      }
      notifyListeners();
    } catch (error) {
      print('Error fetching user flashcards: $error');
    }
  }

  Future<void> fetchPublicFlashcards(String userId) async {
    if (userId.isEmpty) {
      _otherUserPublicFlashcards.clear();
      return;
    }

    final url = Uri.parse(
        'https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$userId/flashcards.json?orderBy="isPublic"&equalTo="true"');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      _otherUserPublicFlashcards.clear();
      if (extractedData != null) {
        extractedData.forEach((flashcardId, flashcardData) {
          List<CarteItem> flashcardItems = [];
          var flashcardsData = flashcardData['flashcards'];
          if (flashcardsData is Map) {
            flashcardsData.forEach((cardId, cardData) {
              flashcardItems.add(CarteItem(
                flashcardid: cardId,
                question: cardData['question'],
                reponse: cardData['reponse'],
              ));
            });
          } else if (flashcardsData is List) {
            flashcardItems = flashcardsData
                .map((item) => CarteItem(
                      flashcardid: item['id'],
                      question: item['question'],
                      reponse: item['reponse'],
                    ))
                .toList();
          }

          _otherUserPublicFlashcards.add(Flashcard(
            id: flashcardId,
            title: flashcardData['title'],
            color: flashcardData['color'],
            isPublic: flashcardData['isPublic'],
            flashcards: flashcardItems,
          ));
        });
      }
      notifyListeners();
    } catch (error) {
      print('Error fetching public flashcards: $error');
    }
  }

  Future<bool> addFlashcard(Flashcard flashcard, String userId) async {
    if (userId.isEmpty) {
      return false;
    }

    final url = Uri.parse(
        'https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$userId/flashcards.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': flashcard.title,
          'color': flashcard.color,
          'isPublic': flashcard.isPublic,
          'sharedWithUserIds': flashcard.sharedWithUserIds,
          'flashcards': flashcard.flashcards.map((ci) {
            var uuid = Uuid();
            return {
              'id': uuid.v4(), // Génère un UUID unique pour chaque CarteItem
              'question': ci.question,
              'reponse': ci.reponse,
            };
          }).toList(),
        }),
      );

      if (response.statusCode == 200) {
        final newFlashcardId =
            json.decode(response.body)['name']; // ID généré par Firebase
        Flashcard newFlashcard = Flashcard(
          id: newFlashcardId,
          title: flashcard.title,
          color: flashcard.color,
          isPublic: flashcard.isPublic,
          flashcards: flashcard.flashcards,
          sharedWithUserIds: flashcard.sharedWithUserIds,
        );
        _items.add(newFlashcard);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error adding flashcard: $error');
      return false;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> addFlashcardToUser(String userId, Flashcard flashcard) async {
    final newFlashcard = Flashcard(
      id: flashcard.id,
      title: flashcard.title,
      color: flashcard.color,
      isPublic: flashcard.isPublic,
      flashcards: flashcard.flashcards,
      sharedWithUserIds: flashcard.sharedWithUserIds,
    );

    // Ajout de  la flashcard à la liste des flashcards de l'utilisateur actuel
    _items.add(newFlashcard);
    notifyListeners();

    final url = Uri.parse(
        'https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$userId/flashcards.json');
    try {
      await http.post(
        url,
        body: json.encode({
          'title': newFlashcard.title,
          'color': newFlashcard.color,
          'isPublic': newFlashcard.isPublic,
      
          'flashcards': newFlashcard.flashcards
              .map((ci) => {
                    'id': uuid.v4(),
                    'question': ci.question,
                    'reponse': ci.reponse,
                  })
              .toList(),
        }),
      );
    } catch (error) {
      print('Error adding flashcard to user: $error');
    }
  }



  Future<bool> removeFlashcard(String userId, String flashcardId) async {
    if (userId.isEmpty || flashcardId.isEmpty) {
      return false;
    }

    final url = Uri.parse(
        'https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$userId/flashcards/$flashcardId.json');
    final existingFlashcardIndex =
        _items.indexWhere((flashcard) => flashcard.id == flashcardId);
    var existingFlashcard = _items[existingFlashcardIndex];

    _items.removeAt(existingFlashcardIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingFlashcardIndex, existingFlashcard);
      notifyListeners();
      return false; // Échec de la suppression
    }
    return true; // Suppression réussie
  }

  Future<void> shareFlashcardWithUser(
      String flashcardId, String currentUserId, String contactUserId) async {
 
    final flashcardUrl = Uri.parse(
        'https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$currentUserId/flashcards/$flashcardId.json');
    try {

      final flashcardResponse = await http.get(flashcardUrl);
      final flashcardData = json.decode(flashcardResponse.body);
      List<dynamic> sharedWithUserIds =
          flashcardData['sharedWithUserIds'] != null
              ? List.from(flashcardData['sharedWithUserIds'])
              : [];
      if (!sharedWithUserIds.contains(contactUserId)) {
        sharedWithUserIds.add(contactUserId);
      }

  
      await http.patch(flashcardUrl,
          body: json.encode({'sharedWithUserIds': sharedWithUserIds}));

      // Ajouter la flashcard aux flashcards du contact
      final contactFlashcardUrl = Uri.parse(
          'https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$contactUserId/flashcards/$flashcardId.json');
      await http.put(contactFlashcardUrl, body: json.encode(flashcardData));

      print('Flashcard shared successfully with ${contactUserId}');
    } catch (error) {
      print('Error sharing flashcard: $error');
      throw Exception('Failed to share the flashcard.');
    }
  }

  Future<bool> updateFlashcardTitle(
      String userId, String flashcardId, String newTitle) async {
    if (userId.isEmpty || flashcardId.isEmpty) {
      return false;
    }

    final url = Uri.parse(
        'https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$userId/flashcards/$flashcardId.json');
    try {
      final response =
          await http.patch(url, body: json.encode({'title': newTitle}));

      if (response.statusCode >= 400) {
        print('Failed to update flashcard title: ${response.body}');
        return false; // Échec de la mise à jour
      }

      final flashcardIndex =
          _items.indexWhere((flashcard) => flashcard.id == flashcardId);
      if (flashcardIndex >= 0) {
        _items[flashcardIndex].title = newTitle;
        notifyListeners();
      }
      return true; // Mise à jour réussie
    } catch (error) {
      print('Error updating flashcard title: $error');
      return false; // Erreur lors de la mise à jour
    }
  }

  Future<bool> removeCarteItem(
      String userId, String flashcardId, String carteItemId) async {
 
    if (userId.isEmpty) {
      return false;
    }

    var flashcard = _items.firstWhere((fc) => fc.id == flashcardId);
    flashcard.flashcards
        .removeWhere((carte) => carte.flashcardid == carteItemId);
    notifyListeners();
    final url = Uri.parse(
        'https://flashcardapp-4627c-default-rtdb.firebaseio.com/users.json');

    try {
      final response = await http.put(
        url,
        body: json.encode(
          flashcard.flashcards
              .map((ci) => {
                    'question': ci.question,
                    'reponse': ci.reponse,
                  })
              .toList(),
        ),
      );

      if (response.statusCode >= 400) {
        return false; // Échec de la mise à jour
      }
      return true; // Mise à jour réussie
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> updateCarteItem(String userId, String flashcardId,
      String carteItemId, String newQuestion, String newAnswer) async {
    if (userId.isEmpty) {
      return false;
    }

    var flashcard = _items.firstWhere((fc) => fc.id == flashcardId);
    var carteItemIndex =
        flashcard.flashcards.indexWhere((ci) => ci.flashcardid == carteItemId);

    if (carteItemIndex == -1) {
      return false; // CarteItem non trouvé
    }

    flashcard.flashcards[carteItemIndex].question = newQuestion;
    flashcard.flashcards[carteItemIndex].reponse = newAnswer;
    notifyListeners();

    final url = Uri.parse(
        'https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$userId/flashcards/$flashcardId/flashcards.json');

    try {
      final response = await http.put(
        url,
        body: json.encode(
          flashcard.flashcards
              .map((ci) => {
                    'question': ci.question,
                    'reponse': ci.reponse,
                  })
              .toList(),
        ),
      );

      if (response.statusCode >= 400) {
        return false; // Échec de la mise à jour
      }
      return true; // Mise à jour réussie
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<void> fetchAllPublicFlashcards(String currentUserId) async {
    Uri url = Uri.parse(
        'https://flashcardapp-4627c-default-rtdb.firebaseio.com/flashcards.json');

    try {
      final response = await http.get(url);
      print(response.body);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Flashcard> loadedFlashcards = [];

      extractedData.forEach((userId, userFlashcards) {
        if (userId != currentUserId) {
          userFlashcards.forEach((flashcardId, flashcardData) {
            if (flashcardData['isPublic'] == true) {
              List<CarteItem> flashcardItems = [];
              var flashcardsData = flashcardData['flashcards'];
              if (flashcardsData != null) {
                flashcardsData.forEach((cardId, cardData) {
                  flashcardItems.add(CarteItem(
                    flashcardid: cardId,
                    question: cardData['question'],
                    reponse: cardData['reponse'],
                  ));
                });
              }

              loadedFlashcards.add(Flashcard(
                id: flashcardId,
                title: flashcardData['title'],
                color: flashcardData['color'],
                isPublic: flashcardData['isPublic'],
                flashcards: flashcardItems,
                sharedWithUserIds: flashcardData['sharedWithUserIds'] != null
                    ? List<String>.from(flashcardData['sharedWithUserIds'])
                    : [],
              ));
            }
          });
        }
      });

      _public_items = loadedFlashcards;
      notifyListeners();
    } catch (error) {
      print('Error fetching public flashcards: $error');
    }
  }
}
