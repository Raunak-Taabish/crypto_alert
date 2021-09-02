import 'package:crypto_alert/screens/authentication/login.dart';
import 'package:crypto_alert/screens/authentication/register.dart';
import 'package:crypto_alert/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../constant.dart';

class Login_Register extends StatefulWidget {
  Login_Register({Key? key}) : super(key: key);

  @override
  _Login_RegisterState createState() => _Login_RegisterState();
}

class _Login_RegisterState extends State<Login_Register> {
  static bool gvisible = false;

  void initState() {
    super.initState();
    gvisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF151515),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 30, 25, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Login();
                                },
                              ),
                            );
                          });
                        },
                        child: Text(
                          "Log in",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 9,
                    ),
                    Column(
                      children: [
                        Image.asset(
                          "assets/images/logoname.png",
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Search  .  Add  .  Follow',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
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
                          googleSignIn(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage("assets/images/google_logo.png"),
                              height: 20.0,
                            ),
                            Text(
                              'oogle',
                              style: TextStyle(fontWeight: FontWeight.w600),
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
                          primary: Color(0xFF151515),
                          onPrimary: Colors.white,
                          side: BorderSide(color: Color(0xFF636363)),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Register();
                                },
                              ),
                            );
                          });
                        },
                        child: Text(
                          "Sign Up with Email",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

        // currentState!.save();
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
}
