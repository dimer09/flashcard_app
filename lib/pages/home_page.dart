import 'package:flutter/material.dart';
import '../components/flashcard_item.dart';
import 'package:provider/provider.dart';
import '../provider/flashcards_provider.dart';
import '../provider/auth.dart';
import '../components/popup.dart';
import '../provider/contact.dart';
import 'package:intl/intl.dart';
import '../pages/profilpage.dart';
import '../pages/signup_page.dart';

class HomePage extends StatefulWidget {
  static const routename = '/homepage';
  final userId;
  HomePage({super.key, this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  var _isLoading = false;
  var _isEmpty = false;
  Contact? _userDetails;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FlaschCardsList>(context, listen: false)
          .fetchAndSetFlashcards(widget.userId)
          .then((success) {
        setState(() => _isLoading = false);
        if (!success) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Erreur'),
              content: Text('Impossible de charger les données.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Données chargées avec succès')),
          );
        }
      });
    });
    _getUserInfo();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMM d, y');
    return formatter.format(date);
  }

  void _getUserInfo() async {
    final userDetails = await Provider.of<Auth>(context, listen: false)
        .fetchUserDetailsById(widget.userId);

    setState(() {
      _userDetails = userDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    final flashcardcontainer =
        Provider.of<FlaschCardsList>(context, listen: true);
    final flashcards = Provider.of<FlaschCardsList>(context);

    final flashcard_list = flashcards.items;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : SafeArea(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => ContactDetailsPage(
                                      contact: _userDetails!,
                                      currentUserId: widget.userId),
                                ));
                              },
                              color: Colors.white,
                              icon: Icon(Icons.person),
                              iconSize: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Bonjour ${_userDetails?.username}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Text(formatDate(DateTime.now()),
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: (){
                            Navigator.of(context).pushNamed(SignUpScreen.routename);
                          },
                          color: Colors.white,
                          icon :Icon(Icons.logout),
                          iconSize: 20,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search, color: Colors.white),
                            fillColor: Colors.blue[600],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(color: Colors.white),
                          onChanged: (value) {
                            Provider.of<FlaschCardsList>(context, listen: false)
                                .setSearchQuery(value);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Filters yours Cards',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          PopupMenuButton(
                            onSelected: (int selectedValue) {
                              setState(() {
                                if (selectedValue == 0) {
                                  flashcardcontainer.showprivateOnly();
                                } else if (selectedValue == 1) {
                                  flashcardcontainer.showpublicOnly();
                                }
                              });
                            },
                            icon: Icon(Icons.more_vert, color: Colors.white),
                            itemBuilder: (_) => [
                              PopupMenuItem(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(Icons.lock, color: Colors.blue),
                                        Text('Private',
                                            style:
                                                TextStyle(color: Colors.blue)),
                                      ]),
                                  value: 0),
                              PopupMenuItem(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(Icons.lock_open, color: Colors.blue),
                                      Text('Public',
                                          style: TextStyle(color: Colors.blue)),
                                    ]),
                                value: 1,
                              ),
                            ],
                          ),
                          Popup(userId: widget.userId),
                        ]),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              flashcard_list.length < 1
                  ? Expanded(
                      child: Container(
                          color: Colors.white,
                          child: Center(
                              child: Column(
                            children: [
                              Text('O flascards Founds',
                                  style: TextStyle(color: Colors.black)),
                              Icon(Icons.not_accessible, size: 30),
                            ],
                          ))),
                    )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: flashcard_list.length,
                          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                                value: flashcard_list[i],
                                child: Flashcard_item(userid: widget.userId),
                              ))),
            ]),
          );
  }
}
