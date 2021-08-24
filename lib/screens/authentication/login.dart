import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './Register.dart';
import 'package:crypto_alert/screens/home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static bool _passwordVisible = false;
  static bool visible = false;
  static bool gvisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _emailidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void initState() {
    super.initState();
    visible = false;
    gvisible = false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return SafeArea(
      child: MaterialApp(
        home: Container(
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage("assets/images/newsbg2.jpg"), fit: BoxFit.cover, colorFilter:
          //               new ColorFilter.mode(Colors.black54, BlendMode.darken),)),     //Background Image
          child: Scaffold(
            key: _scaffoldKey,
            // backgroundColor:  Colors.transparent,
            backgroundColor: const Color(0xFF151515),
            // backgroundColor: Colors.black45,
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: [
                          Image.asset(
                            "assets/images/logoname.png",
                            width: MediaQuery.of(context).size.width / 2,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Search  .  Add  .  Follow',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        //height: MediaQuery.of(context).size.height / 0,
                        height: 40,
                      ),
                      TextField(
                        controller: _emailidController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat Alternates'),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat Alternates'),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              }),
                          filled: true,
                          fillColor: Colors.black12,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 2.5,
                        //height: 100,
                      ),
                      Container(
                        child: Column(children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                // primary: Colors.black45,
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                //side: BorderSide(color: Colors.white70,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  gvisible = load(gvisible);
                                });
                                googleSignIn(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Login with ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat Alternates',
                                    ),
                                  ),
                                  Image(
                                    image: AssetImage("assets/images/google_logo.png"),
                                    height: 20.0,
                                  ),
                                  Text(
                                    'oogle',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat Alternates',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                // primary: Colors.black45,
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              onPressed: () {
                                login();
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontFamily: 'Montserrat Alternates',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        height: 30,
                        width: 300,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat Alternates',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("users");

  Future<void> login() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        await auth.signInWithEmailAndPassword(
            email: _emailidController.text.trim(),
            password: _passwordController.text.trim());

        // SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Home()));
        //visible=!visible;
        // });

        //displayToastMessage('',context);
      } catch (e) {
        print(e);
        //visible=!visible;
        setState(() {
          visible = load(visible);
        });
        // displayToastMessage(e.message, context);
      }
    }
  }

  Future<void> googleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final User? currentuser =
          (await auth.signInWithCredential(credential)).user;
      if (currentuser != null) {
        dbRef.child(currentuser.uid);
        Map userDataMap = {
          'name': currentuser.displayName,
          'email': currentuser.email,
          'profile': currentuser.photoURL,
        };
        dbRef.child(currentuser.uid).set(userDataMap);

        // _formKey.currentState!.save();
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Home()));
        displayToastMessage('Welcome', context);
      } else {
        setState(() {
          gvisible = load(gvisible);
        });
        // displayToastMessage('Some error has occured', context);
      }
    } catch (e) {
      setState(() {
        gvisible = load(gvisible);
      });
      displayToastMessage('error', context);
      print('error is this:    $e');
    }
  }

  bool load(visible) {
    return visible = !visible;
  }

  @override
  void dispose() {
    _emailidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
