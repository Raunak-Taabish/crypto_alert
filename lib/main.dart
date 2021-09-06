import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'screens/authentication/login_register.dart';
import 'screens/authentication/login.dart';
import 'screens/authentication/register.dart';
import 'screens/home.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'key1',
          channelName: 'Proto Coders Point',
          channelDescription: "Notification example",
          defaultColor: Color(0XFF9050DD),
          ledColor: Colors.white,
          playSound: true,
          enableLights:true,
          enableVibration: true
        )
      ]
  );
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
  if (!isAllowed) {
    // Insert here your friendly dialog box before call the request method
    // This is very important to not harm the user experience
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
});
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
