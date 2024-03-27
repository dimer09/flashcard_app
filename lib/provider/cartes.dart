import 'package:flutter/foundation.dart';

class CarteItem with ChangeNotifier {
  final String flashcardid;
  String question; 
  String reponse; 

  CarteItem({
    required this.flashcardid,
    required this.question,
    required this.reponse,
  });

  setQuestion(String newQuestion) {
    question = newQuestion;
    notifyListeners();
  }

    factory CarteItem.fromMap(Map<String, dynamic> data) {
    return CarteItem(
      flashcardid: data['id'],
      question: data['question'],
      reponse: data['reponse'],
    );
  }

  

  setReponse(String newReponse) {
    reponse = newReponse;
    notifyListeners();
  }
}
