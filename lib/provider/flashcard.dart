import 'package:flutter/foundation.dart';
import './cartes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Flashcard with ChangeNotifier {
  final String id;
  String title;
  final color;
  List<CarteItem> flashcards = [];
  List<String> sharedWithUserIds;
  bool isPublic;

  Flashcard(
      {required this.id,
      required this.title,
      required this.color,
      this.isPublic = false,
      required this.flashcards,
      this.sharedWithUserIds = const [],
      });

  Future<void> istoogle(String userId) async {
  final oldStatus = isPublic;
  isPublic = !isPublic;
  notifyListeners();

  
  final url = Uri.parse('https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$userId/flashcards/$id.json');

  try {
    final response = await http.patch(url, body: json.encode({'isPublic': isPublic}));

    if (response.statusCode >= 400) {
      isPublic = oldStatus; 
      notifyListeners();
      throw Exception('Failed to update the public status.');
    }
    print('Operation succeeded');
  } catch (error) {
    isPublic = oldStatus; 
    notifyListeners();
    throw Exception('Failed to update the public status: $error');
  }
}

 factory Flashcard.fromMap(Map<String, dynamic> data) {
    return Flashcard(
      id: data['id'],
      title: data['title'],
      color: data['color'],
      isPublic: data['isPublic'],
      flashcards: List<CarteItem>.from(
        data['flashcards'].values.map((item) => CarteItem.fromMap(item)),
      ),
    );
  }


  void shareWithUser(String userId) {
    if (!sharedWithUserIds.contains(userId)) {
      sharedWithUserIds.add(userId);
      notifyListeners();
    }
  }
}
