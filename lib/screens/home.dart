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
  List names = [];

  Future getCryptos() async {
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
        names.add(element["name"]);
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
      return names;
    }
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
                appBar: AppBar(title: Text('Hello'), actions: [
                  ElevatedButton(
                      onPressed: () {
                        _signOut(context);
                      },
                      child: Text('Logout'))
                ]),
                body: FutureBuilder(
                    future: getCryptos(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // names=snapshot.data!.value,
                        return ListView.builder(
                            itemCount: names.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Text(names[index]);
                            });
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }) //Center(child: Text('Welcome' + name)),
                );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<void> _signOut(BuildContext context) async {
    // FirebaseAuth.instance.currentUsper.delete();
    await FirebaseAuth.instance.signOut();
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Login_Register()));
  }
}
