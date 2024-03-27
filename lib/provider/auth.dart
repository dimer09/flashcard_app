import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../provider/contact.dart';



class Auth with ChangeNotifier {

  Contact ? _contact;
  late String _token;
  late DateTime _expiryDate;
  late String _userId;

   Contact? get user => _contact;


  Future<bool> signup(String email, String password) async {
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA3NPRJ87DQGAxxNyzeuF6UWSwUKAAHVj4');
    
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
      
        print(responseData['error']['message']);
        return false;
  
        
      } else {
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now().add(
          Duration(
            seconds: int.parse(responseData['expiresIn']),
          ),
        );

        await createUserInDatabase(_userId, email);
        notifyListeners();
        return true;
      }
    } catch (error) {
      
      throw error;
      
    }
  
  }

  
  Future<void> createUserInDatabase(String userId, String email) async {
    final dbUrl = Uri.parse('https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$userId.json');
    await http.put(
      dbUrl,
      body: json.encode({
        'id': userId,
        'email': email,
        'username' : '',
 
      }),
    );
  }

   Future<bool> login(String username, String password) async {

  const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA3NPRJ87DQGAxxNyzeuF6UWSwUKAAHVj4';

  try {
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'email': username, 
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      final String errorMessage = responseData['error']['message'];
      return false;

    } else {
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      notifyListeners();
      
      return true;
    }
  } catch (error) {

    throw 'Could not authenticate you. Please try again later.';
    
  }

  
}


Future<String?> fetchUserIdByEmail(String email) async {
  final dbUrl = Uri.parse('https://flashcardapp-4627c-default-rtdb.firebaseio.com/users.json?orderBy="email"&equalTo="$email"');
  try {
    final response = await http.get(dbUrl);
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;
    print(extractedData);

    if (extractedData != null && extractedData.isNotEmpty) {
      final userId = extractedData.keys.first;
      return userId;  // Retourne l'ID de l'utilisateur
    }
    return null;  
  } catch (error) {
    print('Error fetching user ID: $error');
    return null;  
  }
}

Future<bool> isUsernameUnique(String username) async {
  final url = Uri.parse('https://flashcardapp-4627c-default-rtdb.firebaseio.com/users.json?orderBy="username"&equalTo="$username"');
  final response = await http.get(url);
  final data = json.decode(response.body);
  return data.isEmpty; 
}

Future<void> addUsername(String userId, String username) async {
  final isUnique = await isUsernameUnique(username);
  if (isUnique) {
    print('aucun username comme $username n a ete trouve');
    final url = Uri.parse('https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$userId.json');
    final response = await http.patch(url, body: json.encode({'username': username}));
    if (response.statusCode == 200) {
      print('Username added successfully');
    } else {
      print('Failed to add username');
    }
  } else {
    print(' $username is not unique');
  }
}



Future<Contact?> fetchUserDetailsById(String userId) async {
  final url = Uri.parse('https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$userId.json');
  try {
    final response = await http.get(url);
    final data = json.decode(response.body);
    if (data != null) {
      return Contact(
        id: userId,
        username: data['username'] ?? '',
        email: data['email'] ?? '',
      );
    }
    return null;
  } catch (error) {
    print('Error fetching user details: $error');
    return null;
  }
}


}
