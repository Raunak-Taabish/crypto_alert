import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';


//import './main.dart';
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

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _emailidController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
            backgroundColor: Colors.blueGrey[900],
            // backgroundColor: Colors.black45,
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _emailidController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.mail_outline_rounded,
                              color: Colors.white70,
                            ),
                            filled: true,
                            fillColor: Colors.black12,
                            enabledBorder: OutlineInputBorder(
                              //borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              //borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.5),
                            ),
                            labelText: 'Email',
                            hintText: ''),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10.0, bottom: 30.0),
                      //padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              color: Colors.white70,
                            ),
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
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            labelText: 'Password',
                            hintText: ''),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 350,
                      // decoration: BoxDecoration(
                      //     color: Colors.deepPurple[900],
                      //     borderRadius: BorderRadius.circular(30)),
                      child: ElevatedButton(
                        onPressed: () {
                            login();
                        },
                        child: Text(
                          'Login',
                          //style: TextStyle(color: Colors.white, fontSize: 20,),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black45,
                          onPrimary: Colors.white,
                          shadowColor: Colors.black45,
                          elevation: 8,
                          //side: BorderSide(color: Colors.white70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.white70,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: visible,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Container(
                                width: 320,
                                margin: EdgeInsets.only(),
                                child: LinearProgressIndicator(
                                  minHeight: 2,
                                  backgroundColor: Colors.blueGrey[800],
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )))),
                    Container(
                      height: 30,
                      width: 300,
                      child: TextButton(
                        onPressed: () {
                        },
                        child: Text(
                          'Forgot Password?',
                          
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 350,
                      padding: EdgeInsets.only(top: 10),
                      // decoration: BoxDecoration(
                      //     color: Colors.deepPurple[900],
                      //     borderRadius: BorderRadius.circular(30)),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            gvisible = load(gvisible);
                          });
                          googleSignIn(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Row(
                            children: <Widget>[
                              Image(
                                image: AssetImage("assets/google_logo.png"),
                                height: 30.0,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, right: 55),
                                child: Text(
                                  'Sign in with Google',
                                ),
                              )
                            ],
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          // primary: Colors.black45,
                          primary: Colors.transparent,
                          onPrimary: Colors.white,
                          shadowColor: Colors.black45,
                          elevation: 8,
                          //side: BorderSide(color: Colors.white70,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.white70,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: gvisible,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Container(
                                width: 320,
                                margin: EdgeInsets.only(),
                                child: LinearProgressIndicator(
                                  minHeight: 2,
                                  backgroundColor: Colors.blueGrey[800],
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )))),
                    Container(
                      height: 30,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Register()));
                        },
                        child: Text(
                          'New User? Create Account',
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

        _formKey.currentState!.save();
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Home()));
        // displayToastMessage('Welcome', context);
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
      // displayToastMessage(e.message, context);
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
