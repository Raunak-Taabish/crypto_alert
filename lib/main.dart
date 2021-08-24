import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'screens/authentication/login_register.dart';
import 'screens/authentication/login.dart';
import 'screens/authentication/register.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await isUserLoggedIn();
  runApp(MyApp());
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
        fontFamily: 'Montserrat Alternates',
      ),
      home: _Splashscreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _Splashscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'swd',
        home: Expanded(
          child: AnimatedSplashScreen(
              duration: 300,
              splash: Image.asset(
                'images/logo.png',
              ),
              nextScreen: Login_Register(),
              splashTransition: SplashTransition.fadeTransition,
              //pageTransitionType: PageTransitionType.scale,
              backgroundColor: Colors.black),
        ));
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Login(), initialRoute: initialroute, routes: {
      'homepage': (context) => Home(),
      'login': (context) => Login(),
    });
  }
}
