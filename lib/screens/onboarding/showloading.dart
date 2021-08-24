import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:crypto_alert/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

class ShowLoading extends StatefulWidget {
  ShowLoading({Key? key}) : super(key: key);

  @override
  _ShowLoadingState createState() => _ShowLoadingState();
}

class _ShowLoadingState extends State<ShowLoading> {
  String name = '';

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
            return MaterialApp(
              // title: 'swd',
              home: AnimatedSplashScreen(
                  duration: 3000,
                  splash: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Container(
                      margin: EdgeInsets.only(left: 60),
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, $name\n",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat Alternates',
                              //fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Please wait we are\nsetting up",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat Alternates',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  nextScreen: Home(),
                  splashTransition: SplashTransition.fadeTransition,
                  backgroundColor: Color(0xFF151515)),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
