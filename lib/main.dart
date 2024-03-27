import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/flashcards_provider.dart';
import './provider/contact.dart'; 
import './pages/home.dart';
import './pages/flashcard_detail.dart';
import './pages/communauty.dart';
import './pages/addflashcard.dart';
import './pages/login_page.dart';
import './pages/signup_page.dart';
import './pages/setusername_page.dart';
import './provider/auth.dart';
import 'pages/upload_file.dart';



void main()  {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => FlaschCardsList()),
        ChangeNotifierProvider(
            create: (context) =>
                ContactsProvider()), //
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: LoginPage(),
        routes: {
          Flashcarddetailscreen.routename: (ctx) => Flashcarddetailscreen(),
          Communauty_page.routename: (ctx) => Communauty_page(),
          CreateFlashcardPage.routename: (ctx) => CreateFlashcardPage(),
          LoginPage.routename : (ctx) => LoginPage(),
          SignUpScreen.routename : (ctx) => SignUpScreen(),
          SetUsernameScreen.routename : (ctx) => SetUsernameScreen(),
          MyHomePage.routename : (ctx) => MyHomePage(title: "dede",),
          UploadFilePage.routename : (ctx) => UploadFilePage(),
         
        },
      ),
      );
   
  }
}
