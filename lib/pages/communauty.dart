import 'package:flutter/material.dart';
import '../provider/contact.dart';
import '../components/contact_item.dart';
import 'package:provider/provider.dart';
import '../pages/profilpage.dart';
import '../pages/signup_page.dart';

class Communauty_page extends StatefulWidget {
  final userId;
  Communauty_page({super.key, this.userId});
  static const routename = '/communauty';

  @override
  State<Communauty_page> createState() => _Communauty_pageState();
}

class _Communauty_pageState extends State<Communauty_page> {
  final TextEditingController _searchController = TextEditingController();
  bool _isContactsLoaded = false;

  @override
  Widget build(BuildContext context) {
    if (!_isContactsLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ContactsProvider>(context, listen: false)
            .fetchAndSetContacts(widget.userId);
      });
      _isContactsLoaded = true;
    }

    final contacts = Provider.of<ContactsProvider>(context).contacts;
    return SafeArea(
        child: Column(children: [
      Padding(
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Communauty',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
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
                    Provider.of<ContactsProvider>(context, listen: false)
                        .setSearchQuery(value);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Meet FlashCard Makers',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ]),
            SizedBox(
              height: 15,
            ),
          ])),
      Expanded(
          child: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (ctx, i) => ContactItem(
          Username: contacts[i].username,
          email: contacts[i].email,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ContactDetailsPage(
                  contact: contacts[i], currentUserId: widget.userId),
            ));
          },
        ),
      )),
    ]));
  }
}
