import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'data/constant.dart';
import 'data/crypto_list.dart';
import 'screens/authentication/login_register.dart';
import 'screens/authentication/login.dart';
import 'package:http/http.dart' as http;
import 'screens/home.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await isUserLoggedIn();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  });
  Workmanager().initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    // isInDebugMode:
    //     true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  runApp(MyApp());

  // if (initialroute == 'homepage') {
  //   {

  //   }
  // }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp();
    final User? user = FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseFirestore.instance;
    Alert_List data;
    List<Alert_List> alertCrypto = [];

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
        alertCrypto.add(data);
        print(element.get('crypto_name'));
      });

      List names = [];
      alertCrypto.forEach((element) {
        names.add(element.crypto);
      });

      // List names=[];
      String id;
      List<Crypto_Home> liveCrypto = [];
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
            liveCrypto.add(crypto_data);
          }
        });
      }

      if (alertCrypto.isNotEmpty) {
        for (int i = 0; i < liveCrypto.length; i++) {
          cryptoid.forEach((element) {
            if (element[0] == liveCrypto[i].cryptosymbols) {
              id = element[1];
              print(element[0]);
            }
          });
        }
      }
      // crypto_fav = crypto_dummy;

      // print(crypto_dummy[0].cryptoprices);
      bool setAlert = false;
      List notifyAlerts = [];
      int notifyID=0;
      for (int i = 0; i < alertCrypto.length; i++,notifyID++) {
        liveCrypto.forEach((element) {
          if (element.cryptonames == alertCrypto[i].crypto) {
            if (element.cryptoprices > double.parse(alertCrypto[i].riseAbove) ||
                element.cryptoprices < double.parse(alertCrypto[i].fallBelow)) {
              setAlert = true;
              notifyAlerts.add([notifyID,element.cryptonames, element.cryptoprices]);
            }
          }
        });
      }

      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('your channel id', 'your channel name',
              channelDescription: 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker');
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      setAlert
          ? notifyAlerts.forEach((element) async {
              await flutterLocalNotificationsPlugin.show(
                  element[0],
                  'Alert for ${element[1]}',
                  '\$${element[2]}',
                  platformChannelSpecifics,
                  payload: 'item x');
                  print(element[0].toString()+element[1]);
            })
          : null;
      // return alert_list;
    } catch (e) {
      print(e.toString());
      // displayToastMessage(e.toString(), context);
      // return [];
    } //simpleTask will be emitted here.
    return Future.value(true);
  });
}

late String initialroute;
Future<void> isUserLoggedIn() async {
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user == null) {
      print('User is currently signed out!');
      initialroute = 'login';
    } else {
      print('User is signed in!');
      initialroute = 'homepage';
      print(initialroute);
    }
  });
}

class MyApp extends StatelessWidget {
  // @override
  // _Splashscreen createState() => _Splashscreen();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Montserrat', backgroundColor: Color(0xFF151515)),
      home: _Splashscreen(),
      debugShowCheckedModeBanner: true,
    );
  }
}

class _Splashscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'swd',
      home: AnimatedSplashScreen(
          duration: 500,
          splash: Image.asset(
            'assets/images/logo.png',
          ),
          nextScreen: SecondScreen(),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.black),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Login(), initialRoute: initialroute, routes: {
      'homepage': (context) => Home(
            pindex: 0,
          ),
      'login': (context) => Login_Register(),
    });
  }
}
