import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_alert/data/crypto_home.dart';
import 'package:crypto_alert/data/crypto_list.dart';
import 'package:crypto_alert/screens/view_crypto/view_crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constant.dart';

class Favourites extends StatefulWidget {
  List<Crypto_Home> crypto;
  Favourites(this.crypto, {Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  late String id;
  List<Crypto_Home> crypto = [];
  late Future getfav;
  late Future matchfav;
  List snap = [];
  final User? user = FirebaseAuth.instance.currentUser;
  final databaseReference = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getfav = getFavouriteList();
    // matchfav = matchFav(snap);
  }

  Future<List> getFavouriteList() async {
    List fav = [];
    try {
      print('Favourites working');
      // print(widget.crypto[0].cryptonames);
      // widget.crypto.forEach((element) async {

      var snapshot = await databaseReference
          .collection("users")
          .doc(user!.uid)
          .collection('fav_cryptos') //.doc('Cardano')
          // .where('crypto_name', isEqualTo: 'Cardano')
          .get();

      snapshot.docs.forEach((element) {
        fav.add(element.get('crypto_name'));
        print(element.get('crypto_name'));
      });
      setState(() {
        snap = fav;
      });

      matchfav = matchFav(snap);
      return fav;
    } catch (e) {
      print(e.toString());
      displayToastMessage(e.toString(), context);
      return [];
    }
  }

  Future<List<Crypto_Home>> matchFav(List snap) async {
    print("Crypto data matched with DB");
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
        if (snap.contains(element["name"].toString())) {
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
      crypto = crypto_dummy;
    });
    // print(crypto_dummy[0].cryptoprices);
    return crypto;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: getFavouriteList,
        child: FutureBuilder(
            future: getfav,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // List snap = snapshot.data as List;
                return StreamBuilder(
                    stream: matchfav.asStream(),//matchFav(snap).asStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // crypto = snapshot.data as List<Crypto_Home>;
                        return ListView.builder(
                            itemCount: crypto.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                  cryptoid.forEach((element) {
                                    if (element[0] ==
                                        crypto[index]
                                            .cryptosymbols) {
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    // alignment: Alignment.center,
                                    //height: 50,
                                    padding:
                                        EdgeInsets.fromLTRB(15, 15, 15, 15),
                                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 0, 0, 0),
                                              child: Text(
                                                crypto[index].cryptonames,
                                                //    + ' (' +
                                                //     cryptosymbols[index] +
                                                //     ')', // +cryptolist.length.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Montserrat'),
                                              ),
                                            ),
                                          ]),
                                          Column(
                                            children: [
                                              Text(
                                                '${crypto[index].cryptoprices.toStringAsFixed(2)} \$',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Montserrat'),
                                              ),
                                              Row(children: [
                                                Icon(
                                                  crypto[index].daychange >= 0
                                                      ? Icons
                                                          .arrow_drop_up_sharp
                                                      : Icons
                                                          .arrow_drop_down_sharp,
                                                  size: 20,
                                                  color:
                                                      crypto[index].daychange >=
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
                                                          ? Color(0xFF00D293)
                                                          : Color(0xFFFF493E),
                                                      fontFamily: 'Montserrat'),
                                                ),
                                              ]),
                                            ],
                                          )
                                        ])),
                              );
                            });
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
