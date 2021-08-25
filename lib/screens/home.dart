import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto_alert/screens/authentication/login_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = '';
  List cryptolist = [];
  List cryptoprice = [];
  List daychange = [];
  int index = 0;
  int _pageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
    getCryptos();
  }

  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  Future<void> getCryptos() async {
    // List names=[];
    String url =
        "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest";
    var response = await http.get(Uri.parse(url),
        headers: {"X-CMC_PRO_API_KEY": "1a7e4376-d437-4aa1-929b-a9e04968d593"});
    var jsonData = jsonDecode(response.body);
    // print(response.body);
    print(response.statusCode);
    print(jsonData["data"][0]["name"]);
    if (response.statusCode == 200) {
      jsonData["data"].forEach((element) {
        setState(() {
          cryptolist.add(element["name"]);
          cryptoprice.add(element["quote"]["USD"]["price"]);
          daychange.add(element["quote"]["USD"]["percent_change_24h"]);
        });
        print(element["name"]);

        // Article article = Article(
        //   title: element['title'],
        //   author: element['author'],
        //   description: element['description'],
        //   urlToImage: element['urlToImage'],
        //   // publishedAt: DateTime.parse(element['publishedAt']),
        //   content: element["content"],
        //   articleUrl: element["url"],
        // );
        // news.add(article);
      });
      // return names;
    }
    // return names;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    DatabaseReference dbRef =
        FirebaseDatabase.instance.reference().child('users');
    return FutureBuilder(
        future: dbRef.child(uid!).child('name').once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            name = (snapshot.data?.value).toString();
            return Scaffold(
              backgroundColor: Color(0xFF151515),
              appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Image.asset(
                    "assets/images/logoname.png",
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                  automaticallyImplyLeading: false,
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        _signOut(context);
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat Alternates',
                            fontWeight: FontWeight.w600),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                    ),
                  ]),
              body: PageView(
                  // children: tabPages,
                  onPageChanged: onPageChanged,
                  controller: _pageController,
                  children: [
                    ListView.builder(
                        itemCount: cryptolist.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Container(
                              // alignment: Alignment.center,
                              height: 50,
                              // color: Color(),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cryptolist[index],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat Alternates'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          cryptoprice[index].toStringAsFixed(2),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily:
                                                  'Montserrat Alternates'),
                                        ),
                                        Text(
                                          daychange[index].toStringAsFixed(2),
                                          style: TextStyle(
                                              color: daychange[index] >= 0
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontFamily:
                                                  'Montserrat Alternates'),
                                        ),
                                      ],
                                    )
                                  ]));
                        }),
                        Center(child: Text('Page 2'),)
                  ]),
              //Center(child: Text('Welcome' + name)),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _pageIndex,
                onTap: onTabTapped,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: new Icon(Icons.home),
                    title: new Text("Left"),
                  ),
                  BottomNavigationBarItem(
                    icon: new Icon(Icons.search),
                    title: new Text("Right"),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          }
        });
  }

  Future<void> _signOut(BuildContext context) async {
    // FirebaseAuth.instance.currentUsper.delete();
    await FirebaseAuth.instance.signOut();
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Login_Register()));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
