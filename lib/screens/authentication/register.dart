iimport 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crypto_alert/screens/onboarding/onboarding.dart';
// import 'package:flutter/scheduler.dart';

// import 'main.dart';
import './Login.dart';
import 'package:crypto_alert/screens/home.dart';

FirebaseAuth auth = FirebaseAuth.instance;
DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("users");

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: _RegisterPage(), routes: {
      'homepage': (context) => Home(),
      'login': (context) => Login(),
    });
  }
}

class _RegisterPage extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<_RegisterPage> {
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;
  static bool visible = false;

  void initState() {
    super.initState();
    visible = false;
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _userPasswordController1 = TextEditingController();
  TextEditingController _userPasswordController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return SafeArea(
      child: Scaffold(
        body: Container(
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage("assets/images/newsbg2.jpg"), fit: BoxFit.cover, colorFilter:
          //               new ColorFilter.mode(Colors.black54, BlendMode.darken),)),
          child: Scaffold(
            backgroundColor: Color(0xFF151515),
            // appBar: AppBar(
            //   title: Text("Login Page", ),
            // ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: [
                          Image.asset(
                            "images/logoname.png",
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
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat Alternates',
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.name,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat Alternates',
                          ),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: _userPasswordController1,
                        obscureText: !_passwordVisible1,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible1 = !_passwordVisible1;
                                });
                              }),
                          filled: true,
                          fillColor: Colors.transparent,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          labelText: 'New Password',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat Alternates',
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _userPasswordController2,
                        obscureText: !_passwordVisible2,
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible2
                                    ? Icons.visibility
                                    : Icons
                                        .visibility_off, // Based on passwordVisible state choose the icon
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible2 =
                                      !_passwordVisible2; // Update the state i.e. toogle the state of passwordVisible variable
                                });
                              }),
                          filled: true,
                          fillColor: Colors.transparent,
                          hintStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.5),
                          ),
                          labelText: 'Confirm New Password',
                          labelStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat Alternates'),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
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
                            if (!_emailController.text.contains('@')) {
                              displayToastMessage(
                                  'Enter a valid Email', context);
                            } else if (_usernameController.text.isEmpty) {
                              displayToastMessage('Enter your name', context);
                            } else if (_userPasswordController1.text.length <
                                8) {
                              displayToastMessage(
                                  'Password should be a minimum of 8 characters',
                                  context);
                            } else if (_userPasswordController1.text !=
                                _userPasswordController2.text) {
                              displayToastMessage(
                                  'Passwords don\'t match', context);
                            } else {
                              setState(() {
                                load();
                              });
                              registerNewUser(context);
                            }
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontFamily: 'Montserrat Alternates',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      // Container(
                      //   color: Colors.white,
                      //   height: 50,
                      //   width: 350,
                      //   //padding: const EdgeInsets.only(bottom: 50.0),
                      //   // decoration: BoxDecoration(
                      //   //     color: Colors.deepPurple[900],
                      //   //     borderRadius: BorderRadius.circular(30)),
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       if (!_emailController.text.contains('@')) {
                      //         displayToastMessage('Enter a valid Email', context);
                      //       } else if (_usernameController.text.isEmpty) {
                      //         displayToastMessage('Enter your name', context);
                      //       } else if (_userPasswordController1.text.length < 8) {
                      //         displayToastMessage(
                      //             'Password should be a minimum of 8 characters',
                      //             context);
                      //       } else if (_userPasswordController1.text !=
                      //           _userPasswordController2.text) {
                      //         displayToastMessage(
                      //             'Passwords don\'t match', context);
                      //       } else {
                      //         setState(() {
                      //           load();
                      //           //   showInSnackBar('Processing...',context);
                      //         });
                      //         registerNewUser(context);
                      //       }
                      //     },
                      //     child: Text(
                      //       'Register',
                      //       //style: TextStyle(color: Colors.white, fontSize: 20,),
                      //     ),
                      //     style: ElevatedButton.styleFrom(
                      //       primary: Colors.black45,
                      //       onPrimary: Colors.white,
                      //       shadowColor: Colors.black45,
                      //       elevation: 8,
                      //       //side: BorderSide(color: Colors.white70),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10.0),
                      //         side: BorderSide(
                      //           color: Colors.white70,
                      //           width: 2,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: visible,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Container(
                                width: 290,
                                margin: EdgeInsets.only(),
                                child: LinearProgressIndicator(
                                  minHeight: 2,
                                  backgroundColor: Colors.blueGrey[800],
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ))),
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

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    _userPasswordController1.dispose();
    _userPasswordController2.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  //final FirebaseAuth auth = FirebaseAuth.instance ;
  Future<void> registerNewUser(BuildContext context) async {
    User currentuser;
    try {
      currentuser = (await auth.createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _userPasswordController1.text.trim()))
          .user!;
      if (currentuser != null) {
        dbRef.child(currentuser.uid);
        Map userDataMap = {
          'name': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
        };
        dbRef.child(currentuser.uid).set(userDataMap);
        _formKey.currentState!.save();
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => OnBoarding()));
        // }
        // );
        displayToastMessage('Account Created', context);
      } else {
        setState(() {
          load();
          //   showInSnackBar('Processing...',context);
        });
        displayToastMessage('Account has not been created', context);
      }
    } catch (e) {
      setState(() {
        load();
        //   showInSnackBar('Processing...',context);
      });
      // displayToastMessage(e.message, context);
    }
  }

  void load() {
    visible = !visible;
  }
}

displayToastMessage(String msg, BuildContext context) {
  Fluttertoast.showToast(msg: msg);
}

void showInSnackBar(String value, BuildContext context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(new SnackBar(content: new Text(value)));
}
