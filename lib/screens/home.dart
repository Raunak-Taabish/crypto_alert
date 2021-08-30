import 'dart:async';
import 'dart:convert';
import 'package:crypto_alert/data/crypto_home.dart';
import 'package:crypto_alert/screens/menu/menu.dart';
import 'package:crypto_alert/screens/news/news.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_alert/screens/authentication/login_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'view_crypto/view_crypto.dart';
import 'package:crypto_alert/data/crypto_list.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Timer timer;
  late String id;
  String name = '';
  List<Crypto_Home> crypto = [];
  List logo = [];
  int index = 0;
  int _pageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
    // getCryptos();
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

  Future<List<Crypto_Home>> getCryptos() async {
    // List names=[];
    String key = 'aec925c7-3059-4a11-8592-b99deb474b47';
    // var key = '1a7e4376-d437-4aa1-929b-a9e04968d593';

    String url =
        "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest";
    var response =
        await http.get(Uri.parse(url), headers: {"X-CMC_PRO_API_KEY": key});

    var jsonData = jsonDecode(response.body);
    // print(response.body);
    print(response.statusCode);
    print(jsonData["data"][0]["name"]);
    if (response.statusCode == 200) {
      jsonData["data"].forEach((element) {
        // setState(() {
        Crypto_Home crypto_data = Crypto_Home(
            cryptonames: element["name"].toString(),
            cryptoprices: element["quote"]["USD"]["price"],
            cryptosymbols: element["symbol"].toString(),
            daychange: element["quote"]["USD"]["percent_change_24h"],
            logoId: element["id"]);
        crypto.add(crypto_data);
      });
    }
    return crypto;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    DatabaseReference dbRef =
        FirebaseDatabase.instance.reference().child('users');
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
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: PageView(
            // children: tabPages,
            onPageChanged: onPageChanged,
            controller: _pageController,
            children: [
              FutureBuilder(
                  future: dbRef.child(uid!).child('name').once(),
                  builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      name = (snapshot.data?.value).toString();
                      return FutureBuilder(
                          future: getCryptos(),
                          builder: (context,
                              AsyncSnapshot<List<Crypto_Home>> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: crypto.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          cryptoid.forEach((element) {
                                            if (element[0] ==
                                                crypto[index].cryptosymbols) {
                                              id = element[1];
                                              // print(element[0]);
                                            }
                                          });
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return View_Crypto(
                                                id,
                                                crypto[index].cryptonames,
                                                crypto[index].cryptoprices,
                                                crypto[index].daychange,
                                                crypto[index].logoId);
                                          }));
                                        });
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFF1a1a1a),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          // alignment: Alignment.center,
                                          //height: 50,
                                          padding: EdgeInsets.fromLTRB(
                                              15, 15, 15, 15),
                                          margin:
                                              EdgeInsets.fromLTRB(0, 20, 0, 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(children: [
                                                  Container(
                                                    height: 35,
                                                    width: 35,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                      image: NetworkImage(
                                                          "https://github.com/coinwink/cryptocurrency-logos/blob/master/coins/128x128/${crypto[index].logoId}.png?raw=true"),
                                                      fit: BoxFit.fill,
                                                    )),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            15, 0, 0, 0),
                                                    child: Text(
                                                      crypto[index].cryptonames,
                                                      //    + ' (' +
                                                      //     cryptosymbols[index] +
                                                      //     ')', // +cryptolist.length.toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'Montserrat Alternates'),
                                                    ),
                                                  ),
                                                ]),
                                                Column(
                                                  children: [
                                                    Text(
                                                      '${crypto[index].cryptoprices.toStringAsFixed(2)} \$',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'Montserrat Alternates'),
                                                    ),
                                                    Row(children: [
                                                      Icon(
                                                        crypto[index]
                                                                    .daychange >=
                                                                0
                                                            ? Icons
                                                                .arrow_drop_up_sharp
                                                            : Icons
                                                                .arrow_drop_down_sharp,
                                                        size: 20,
                                                        color: crypto[index]
                                                                    .daychange >=
                                                                0
                                                            ? Color(0xFF00D293)
                                                            : Color(0xFFFF493E),
                                                      ),
                                                      Text(
                                                        '${crypto[index].daychange.toStringAsFixed(2)}%',
                                                        style: TextStyle(
                                                            color: crypto[index]
                                                                        .daychange >=
                                                                    0
                                                                ? Color(
                                                                    0xFF00D293)
                                                                : Color(
                                                                    0xFFFF493E),
                                                            fontFamily:
                                                                'Montserrat Alternates'),
                                                      ),
                                                    ]),
                                                  ],
                                                )
                                              ])),
                                    );
                                  });
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator(
                                color: Colors.white,
                              ));
                            }
                          });
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      ));
                    }
                  }),
              Center(
                child: Text(
                  'Page 2',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Montserrat Alternates'),
                ),
              ),
              News(),
              MenuPage()
            ]),
      ),
      //Center(child: Text('Welcome' + name)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        backgroundColor: const Color(0xFF151515),
        currentIndex: _pageIndex,
        onTap: onTabTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
              color: _pageIndex == 0 ? Colors.white : Colors.grey,
                      size: _pageIndex == 0 ? 28 : 25,
                    ),
                    title: Text(
                      "Home",
                      style: TextStyle(
                  color: Colors.white, fontFamily: 'Montserrat Alternates'),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: _pageIndex == 1 ? Colors.white : Colors.grey,
                      size: _pageIndex == 1 ? 28 : 25,
                    ),
                    title: Text(
                      "Favorite",
                      style: TextStyle(
                  color: Colors.white, fontFamily: 'Montserrat Alternates'),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_book_rounded,
              color: _pageIndex == 2 ? Colors.white : Colors.grey,
              size: _pageIndex == 2 ? 28 : 25,
            ),
            title: Text(
              "News",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Montserrat Alternates'),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
              color: _pageIndex == 3 ? Colors.white : Colors.grey,
              size: _pageIndex == 3 ? 28 : 25,
            ),
            title: Text(
              "Menu",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Montserrat Alternates'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
