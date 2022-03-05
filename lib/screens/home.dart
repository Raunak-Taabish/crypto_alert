import 'dart:async';
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_alert/screens/menu/menu.dart';
import 'package:crypto_alert/screens/news/article.dart';
import 'package:crypto_alert/screens/news/news.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../data/constant.dart';
import 'alerts/alerts.dart';
import 'view_crypto/view_crypto.dart';
import 'package:crypto_alert/data/crypto_list.dart';
import 'package:intl/intl.dart';
import 'package:crypto_alert/data/constant.dart';
import 'dart:math';

class Home extends StatefulWidget {
  int pindex;
  Home({required this.pindex, Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _HomeState createState() => _HomeState(pageIndex: pindex);
}

class _HomeState extends State<Home> {
  int pageIndex;
  _HomeState({required this.pageIndex});
  // late Home getp;
  late Timer timer;
  late String id;
  String name = '';
  List logo = [];
  int index = 0;
  // int pageIndex = pgindex;
  late PageController _pageController;
  late Future getCryptoData;
  late Future getnews;
  late Future getFavourites;
  List<Crypto_Home> crypto = [];
  List<Crypto_Home> searchlist = [];
  List<Crypto_Home> crypto_fav = [];
  TextEditingController textController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  final databaseReference = FirebaseFirestore.instance;
  List<Alert_List> alert_list = [];
  bool _folded = true;
  bool _isSearching = false;
  String _searchText = '';
  String profile = '';
  late MaterialColor randomColor;

  late Future getfav, matchfav, getUserData;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: pageIndex);
    getCryptoData = getCryptos();
    getnews = getNews();
    getfav = getFavouriteList();
    _isSearching = false;
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Notifications'),
                  content: Text(
                      'We would like to take your permission to display Notifications'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Don\'t Allow')),
                    TextButton(
                        onPressed: () {
                          AwesomeNotifications()
                              .requestPermissionToSendNotifications()
                              .then((value) => Navigator.pop(context));
                        },
                        child: Text('Allow'))
                  ],
                ));
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience

      }
    });

    // notify();
    // AwesomeNotifications().actionStream.listen((receivedNotifiction) {
    //   Navigator.push(context, MaterialPageRoute(builder: (context) {
    //     return Home(pindex: 1);
    //   }));
    // });
    search();
    randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    // getfav = getFavouriteList();
  }

  // void notify() async {
  //------------------MAIN CODE FOR NOTIFICATION IS----------------------

  // String timezom = await AwesomeNotifications().getLocalTimeZoneIdentifier();

  // await AwesomeNotifications().createNotification(
  //   content: NotificationContent(
  //       id: 1,
  //       channelKey: 'key1',
  //       title: 'This is Notification title',
  //       body: 'This is Body of Noti',
  //       bigPicture:
  //           'https://protocoderspoint.com/wp-content/uploads/2021/05/Monitize-flutter-app-with-google-admob-min-741x486.png',
  //       notificationLayout: NotificationLayout.BigPicture),
  //   schedule:
  //       NotificationInterval(interval: 5, timeZone: timezom, repeats: false),
  // );
  // }
  // }

  void onPageChanged(int page) {
    setState(() {
      this.pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,
        duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  void searchCrypos(String searchText) {
    searchlist.clear();
    if (_isSearching != null) {
      crypto.forEach((element) {
        String data = element.cryptonames;
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchlist.add(element);
        }
      });
    }
  }

  search() {
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = searchController.text;
        });
      }
    });
  }

  Future<List> getFavouriteList() async {
    Alert_List data;
    List<Alert_List> dummy = [];

    try {
      print('Favourites working');
      // print(widget.crypto[0].cryptonames);
      // widget.crypto.forEach((element) async {

      var snapshot = await databaseReference
          .collection("users")
          .doc(user!.uid)
          .collection('alert_list')
          .get();

      snapshot.docs.forEach((element) {
        data = Alert_List(
            crypto: element.get('crypto_name'),
            riseAbove: element.get('rise_above').toString(),
            fallBelow: element.get('fall_below').toString());
        dummy.add(data);
        print(element.get('crypto_name'));
      });
      setState(() {
        alert_list = dummy;
      });
      matchfav = matchFav(alert_list);
      return alert_list;
    } catch (e) {
      print(e.toString());
      displayToastMessage(e.toString(), context);
      return [];
    }
  }

  Future<List<Crypto_Home>> matchFav(List<Alert_List> snap) async {
    print("Crypto data matched with DB");
    List names = [];
    snap.forEach((element) {
      names.add(element.crypto);
    });

    // List names=[];
    List<Crypto_Home> crypto_dummy = [];
    String key = 'aec925c7-3059-4a11-8592-b99deb474b47';
    // var key = '1a7e4376-d437-4aa1-929b-a9e04968d593';

    String url =
        "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest";
    var response =
        await http.get(Uri.parse(url), headers: {"X-CMC_PRO_API_KEY": key});

    var jsonData = jsonDecode(response.body);
    // print(response.body);
    print(response.statusCode);
    // print(jsonData["data"][0]["name"]);
    if (response.statusCode == 200) {
      jsonData["data"].forEach((element) {
        if (names.contains(element["name"].toString())) {
          Crypto_Home crypto_data = Crypto_Home(
              cryptonames: element["name"].toString(),
              cryptoprices: element["quote"]["USD"]["price"],
              cryptosymbols: element["symbol"].toString(),
              daychange: element["quote"]["USD"]["percent_change_24h"],
              logoId: element["id"]);
          // print(crypto_data.cryptoprices);
          crypto_dummy.add(crypto_data);
        }
      });
    }

    setState(() {
      if (snap.isNotEmpty) {
        cryptoid.forEach((element) {
          if (element[0] == crypto_dummy[index].cryptosymbols) {
            id = element[1];
            print(element[0]);
          }
        });
      }
      crypto_fav = crypto_dummy;
    });

    // print(crypto_dummy[0].cryptoprices);
    return crypto_fav;
  }

  Future<List<Crypto_Home>> getCryptos() async {
    print("Crypto data fetched");
    // List names=[];
    List<Crypto_Home> crypto_dummy = [];
    String key = 'aec925c7-3059-4a11-8592-b99deb474b47';
    // var key = '1a7e4376-d437-4aa1-929b-a9e04968d593';

    String url =
        "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest";
    var response =
        await http.get(Uri.parse(url), headers: {"X-CMC_PRO_API_KEY": key});

    var jsonData = jsonDecode(response.body);
    // print(response.body);
    // print(response.statusCode);
    // print(jsonData["data"][0]["name"]);
    if (response.statusCode == 200) {
      jsonData["data"].forEach((element) {
        Crypto_Home crypto_data = Crypto_Home(
            cryptonames: element["name"].toString(),
            cryptoprices: element["quote"]["USD"]["price"],
            cryptosymbols: element["symbol"].toString(),
            daychange: element["quote"]["USD"]["percent_change_24h"],
            logoId: element["id"]);
        // print(crypto_data.cryptoprices);
        crypto_dummy.add(crypto_data);
      });
    }
    setState(() {
      crypto = crypto_dummy;
    });
    print(crypto_dummy[0].cryptoprices);
    return crypto_dummy;
  }

  List<Article> news = [];

  Future<List> getNews() async {
    print('News data is fetched');
    List<Article> news_dummy = [];
    // String apikey = "1375eb2e9fae4898842e2658c0bb4299";
    String apikey = "ee7211708b0243d19ad32f561258a604";
    DateTime currentdate = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(currentdate);
    String url =
        "https://newsapi.org/v2/everything?q=Crypto&language=en&from=$today&sortBy=popularity&apiKey=$apikey";
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body);

    if (response.statusCode == 200) {
      jsondata["articles"].forEach((element) {
        // setState(() {
        //   newsname.add(element["articles"][0]["source"]["name"]);
        // });
        // print(element["name"]);
        setState(() {
          Article article = Article(
            title: element['title'].toString(), //
            author: element['author'].toString(),
            description: element['description'].toString(),
            urlToImage: element['urlToImage'].toString(),
            publishedAt: DateTime.parse(element['publishedAt']), //
            content: element["content"].toString(),
            articleUrl: element["url"].toString(),
            source: element["source"]["name"].toString(), //
          );
          news_dummy.add(article);
        });
      });
      setState(() {
        news = news_dummy;
      });
      // return names;
    }
    return news;
  }

  // GetData callapi = GetData();
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    DatabaseReference dbRef =
        FirebaseDatabase.instance.reference().child('users');
    return Scaffold(
      backgroundColor: Color(0xFF151515),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      // ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: pageIndex == 3
            ? Image.asset(
                "assets/images/logoname.png",
                width: MediaQuery.of(context).size.width / 3,
              )
            : FutureBuilder(
                future: dbRef.child(uid!).once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    profile = snapshot.data!.value['profile'].toString();
                    name = snapshot.data!.value['name'].toString();
                    print(profile);
                    print(name);
                    return Row(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: profile == 'default'
                              ? CircleAvatar(
                                  radius: 18,
                                  backgroundColor: randomColor,
                                  child: Text(
                                    name.substring(0, 1),
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(profile),
                                ),
                        ),
                        Flexible(
                            flex: 3,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                              child: Text(
                                name,
                                style: TextStyle(fontFamily: 'Montserrat'),
                              ),
                            )),
                      ],
                    );
                  } else {
                    return const Center();
                  }
                }),
        // title: Image.asset(
        //   "assets/images/logoname.png",
        //   width: MediaQuery.of(context).size.width / 3,
        // ),
        automaticallyImplyLeading: false,
        actions: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: pageIndex == 0
                  ? AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width:
                          _folded ? 46 : MediaQuery.of(context).size.width - 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: Color(0xFF1a1a1a),
                        boxShadow: kElevationToShadow[6],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: !_folded
                                      ? TextFormField(
                                          controller: searchController,
                                          onChanged: searchCrypos,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                          cursorColor: Colors.white,
                                          decoration: const InputDecoration(
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                            hintText: 'Search',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                        )
                                      : null)),
                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(_folded ? 32 : 0),
                                    topRight: const Radius.circular(32),
                                    bottomLeft:
                                        Radius.circular(_folded ? 32 : 0),
                                    bottomRight: const Radius.circular(32)),
                              ),
                              child: Icon(_folded ? Icons.search : Icons.close,
                                  color: Colors.white, size: 28),
                            ),
                            onTap: () {
                              setState(() {
                                if (_folded) {
                                  _isSearching = true;
                                  _folded = !_folded;
                                } else {
                                  _isSearching = false;
                                  _folded = !_folded;
                                  searchlist.clear();
                                  searchController.clear();
                                }
                              });
                            },
                          ),
                        ],
                      ))
                  : const Center()
              // child: AnimSearchBar(
              //     rtl: true,
              //     color: Color(0xFF1a1a1a),
              //     style: TextStyle(color: Colors.white),
              //     // suffixIcon: const Icon(Icons., color: Colors.white, size: 30),
              //     prefixIcon: const Icon(Icons.search_rounded,
              //         color: Colors.white, size: 30),
              //     width: MediaQuery.of(context).size.width - 20,
              //     textController: textController,
              //     helpText: 'Search....',
              //     closeSearchOnSuffixTap: true,
              //     onSuffixTap: () {
              //       setState(() {
              //         textController.clear();
              //       });
              //     }),
              )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: PageView(
            // children: tabPages,
            onPageChanged: onPageChanged,
            controller: _pageController,
            children: [
              RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  onRefresh: getCryptos,
                  child: FutureBuilder(
                      future: getCryptoData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // crypto = snapshot.data as List<Crypto_Home>;
                          return Container(
                            child: searchlist.isNotEmpty ||
                                    searchController.text.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    // physics: const ScrollPhysics(
                                    //     parent: BouncingScrollPhysics()),
                                    itemCount: searchlist.length,
                                    itemBuilder:
                                        (BuildContext ctxt, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            cryptoid.forEach((element) {
                                              if (element[0] ==
                                                  searchlist[index]
                                                      .cryptosymbols) {
                                                id = element[1];
                                                // print(element[0]);
                                              }
                                            });
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return View_Crypto(
                                                  cryptoid: id,
                                                  cryptoname: searchlist[index]
                                                      .cryptonames,
                                                  cryptoprice: searchlist[index]
                                                      .cryptoprices,
                                                  daychange: searchlist[index]
                                                      .daychange,
                                                  logoId:
                                                      searchlist[index].logoId,
                                                  alert: false);
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
                                            margin: EdgeInsets.fromLTRB(
                                                0, 20, 0, 0),
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
                                                          image:
                                                              DecorationImage(
                                                        image: NetworkImage(
                                                            "https://github.com/coinwink/cryptocurrency-logos/blob/master/coins/128x128/${searchlist[index].logoId}.png?raw=true"),
                                                        fit: BoxFit.fill,
                                                      )),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15, 0, 0, 0),
                                                      child: Text(
                                                        searchlist[index]
                                                            .cryptonames,
                                                        //    + ' (' +
                                                        //     cryptosymbols[index] +
                                                        //     ')', // +cryptolist.length.toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Montserrat'),
                                                      ),
                                                    ),
                                                  ]),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        '${searchlist[index].cryptoprices.toStringAsFixed(2)} \$',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Montserrat'),
                                                      ),
                                                      Row(children: [
                                                        Icon(
                                                          searchlist[index]
                                                                      .daychange >=
                                                                  0
                                                              ? Icons
                                                                  .arrow_drop_up_sharp
                                                              : Icons
                                                                  .arrow_drop_down_sharp,
                                                          size: 20,
                                                          color: searchlist[
                                                                          index]
                                                                      .daychange >=
                                                                  0
                                                              ? Color(
                                                                  0xFF00D293)
                                                              : Color(
                                                                  0xFFFF493E),
                                                        ),
                                                        Text(
                                                          '${searchlist[index].daychange.toStringAsFixed(2)}%',
                                                          style: TextStyle(
                                                              color: searchlist[
                                                                              index]
                                                                          .daychange >=
                                                                      0
                                                                  ? Color(
                                                                      0xFF00D293)
                                                                  : Color(
                                                                      0xFFFF493E),
                                                              fontFamily:
                                                                  'Montserrat'),
                                                        ),
                                                      ]),
                                                    ],
                                                  )
                                                ])),
                                      );
                                    })
                                : ListView.builder(
                                    shrinkWrap: true,
                                    // physics: const ScrollPhysics(
                                    //     parent: BouncingScrollPhysics()),
                                    itemCount: crypto.length,
                                    itemBuilder:
                                        (BuildContext ctxt, int index) {
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
                                                  cryptoid: id,
                                                  cryptoname:
                                                      crypto[index].cryptonames,
                                                  cryptoprice: crypto[index]
                                                      .cryptoprices,
                                                  daychange:
                                                      crypto[index].daychange,
                                                  logoId: crypto[index].logoId,
                                                  alert: false);
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
                                            margin: EdgeInsets.fromLTRB(
                                                0, 20, 0, 0),
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
                                                          image:
                                                              DecorationImage(
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
                                                        crypto[index]
                                                            .cryptonames,
                                                        //    + ' (' +
                                                        //     cryptosymbols[index] +
                                                        //     ')', // +cryptolist.length.toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Montserrat'),
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
                                                                'Montserrat'),
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
                                                              ? Color(
                                                                  0xFF00D293)
                                                              : Color(
                                                                  0xFFFF493E),
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
                                                                  'Montserrat'),
                                                        ),
                                                      ]),
                                                    ],
                                                  )
                                                ])),
                                      );
                                    }),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          ));
                        }
                      })),

              // Favourites(crypto),
              RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  onRefresh: getFavouriteList,
                  child: FutureBuilder(
                      future: getfav,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // List snap = snapshot.data as List;
                          return StreamBuilder(
                              stream: matchfav
                                  .asStream(), //matchFav(snap).asStream(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  // crypto = snapshot.data as List<Crypto_Home>;
                                  return crypto_fav.length != 0
                                      ? ListView.builder(
                                          itemCount: crypto_fav.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    cryptoid.forEach((element) {
                                                      if (element[0] ==
                                                          crypto_fav[index]
                                                              .cryptosymbols) {
                                                        id = element[1];
                                                        print(element[0]);
                                                      }
                                                    });
                                                  });
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return View_Crypto(
                                                        cryptoid: id,
                                                        cryptoname:
                                                            crypto_fav[index]
                                                                .cryptonames,
                                                        cryptoprice:
                                                            crypto_fav[index]
                                                                .cryptoprices,
                                                        daychange:
                                                            crypto_fav[index]
                                                                .daychange,
                                                        logoId:
                                                            crypto_fav[index]
                                                                .logoId,
                                                        alert: false);
                                                  }));
                                                },
                                                child: favourites(
                                                  id,
                                                  crypto_fav[index],
                                                  alert_list[index],
                                                  context,
                                                ));
                                          })
                                      : Center(
                                          child: Text(
                                              'Your list seems to be empty',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  );
                                }
                              });
                        } else {
                          return Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          );
                        }
                      })),
              RefreshIndicator(
                color: Colors.white,
                backgroundColor: Colors.black,
                onRefresh: getNews,
                child: FutureBuilder(
                    future: getnews,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return newspage(news);
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
              MenuPage(profile, name, randomColor)
            ]),
      ),
      //Center(child: Text('Welcome' + name)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF151515),
        currentIndex: pageIndex,
        onTap: onTabTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
              color: pageIndex == 0 ? Colors.white : Colors.grey,
              size: pageIndex == 0 ? 28 : 25,
            ),
            label:
                // Text(
                "Home",
            //   style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
            // ),
          ),
          BottomNavigationBarItem(
            // icon: Image.asset('assets/images/Icon.png', scale: pageIndex == 1 ? 3.5 : 4,color: pageIndex == 1 ? Colors.white : Colors.grey,),
            icon: Icon(
              Icons.notifications_active,
              color: pageIndex == 1 ? Colors.white : Colors.grey,
              size: pageIndex == 1 ? 28 : 25,
            ),
            label:
                //  Text(
                "Alerts",
            //   style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
            // ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_book_rounded,
              color: pageIndex == 2 ? Colors.white : Colors.grey,
              size: pageIndex == 2 ? 28 : 25,
            ),
            label:
                // Text(
                "News",
            //   style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
            // ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
              color: pageIndex == 3 ? Colors.white : Colors.grey,
              size: pageIndex == 3 ? 28 : 25,
            ),
            label:
                // Text(
                "Menu",
            //   style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
            // ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
