
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Contact with ChangeNotifier{

  final String id;
  String username;
  String email;

  Contact({required this.id, required this.username, required this.email});

}

class ContactsProvider with ChangeNotifier {
  List<Contact> _contacts = [
    Contact(id: '1', username: 'Alice', email: 'alice@example.com'),
    Contact(id: '2', username: 'Bob', email: 'bob@example.com'),
    Contact(id: "3", username: "dimer", email: 'dimer@dimer.com'),
    Contact(id: "4", username: "merdi", email: 'merdi@dimer.com'),
    Contact(id: "5", username: "oidni", email: 'oondi@dimer.com'),

  ];

  

   String _searchQuery = '';

  List<Contact> get contacts {
    if (_searchQuery.isEmpty) {
      return _contacts;
    } else {
      return _contacts.where((contact) => 
        contact.username.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchAndSetContacts(String currentUserId) async {
    final url = Uri.parse('https://flashcardapp-4627c-default-rtdb.firebaseio.com/users.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Contact> loadedContacts = [];
      extractedData.forEach((userId, userData) {
        if (userId != currentUserId) {
          loadedContacts.add(
            Contact(
              id: userId,
              username: userData['username'] ?? 'Unknown',
              email: userData['email'] ?? 'No email',
            ),
          );
        }
      });
      _contacts = loadedContacts;
      notifyListeners();
    } catch (error) {
      print('Error fetching contacts: $error');
      
    }
  }

Future<void> updateUsername(String userId, String newUsername) async {
 
  final url = Uri.parse('https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$userId.json');

  try {
    final response = await http.patch(url, body: json.encode({'username': newUsername}));
    if (response.statusCode == 200) {
      notifyListeners();
      print('Username updated successfully');
    } else {
      print('Failed to update username.');
    }
  } catch (error) {
    print('Error updating username: $error');
  }
}

Future<void> updateEmail(String userId, String newEmail) async {
  // 
  final url = Uri.parse('https://flashcardapp-4627c-default-rtdb.firebaseio.com/users/$userId.json');

  try {
    final response = await http.patch(url, body: json.encode({'email': newEmail}));
    if (response.statusCode == 200) {
      notifyListeners();
      print('Email updated successfully');
    } else {
      print('Failed to update email.');
    }
  } catch (error) {
    print('Error updating email: $error');
  }
}

}