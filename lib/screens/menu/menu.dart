import 'package:crypto_alert/screens/authentication/login_register.dart';
import 'package:crypto_alert/screens/menu/about.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class MenuPage extends StatefulWidget {
  String profile, name;
  MaterialColor randomColor;
  MenuPage(this.profile, this.name, this.randomColor, {Key? key})
      : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String email = '';
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    DatabaseReference dbRef =
        FirebaseDatabase.instance.reference().child('users');
    return Scaffold(
      backgroundColor: Color(0xFF151515),
      body: ListView(children: [
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFF202020),
            ),
            padding: EdgeInsets.symmetric(vertical: 30),
            //height: MediaQuery.of(context).size.height / 6.5,
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: widget.profile == 'default'
                      ? CircleAvatar(
                          radius: 22,
                          backgroundColor: widget.randomColor,
                          child: Text(
                            widget.name.substring(0, 1),
                            style: TextStyle(fontSize: 20.0),
                          ),
                        )
                      : CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(widget.profile),
                        ),
                ),
                Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.005,
                    ),
                    FutureBuilder(
                        future: dbRef.child(uid!).child('email').once(),
                        builder:
                            (context, AsyncSnapshot<DataSnapshot> snapshot) {
                          if (snapshot.hasData) {
                            email = (snapshot.data?.value).toString();
                            return Text(
                              email,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat'),
                            );
                          } else {
                            return Center();
                          }
                        })
                  ],
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return About();
              }));
            },
            child: list(
                Icon(
                  Icons.info_rounded,
                  color: Colors.white,
                ),
                "About")),
        GestureDetector(
            onTap: () {},
            child: list(
                Icon(
                  Icons.call,
                  color: Colors.white,
                ),
                "Contact")),
        GestureDetector(
            onTap: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  // backgroundColor: Colors.,
                  title: const Text('Feedback'),
                  content: const TextField(
                    decoration: InputDecoration(hintText: "Add feedback here"),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('Send'),
                    ),
                  ],
                ),
              );
            },
            child: list(
                Icon(
                  Icons.feedback,
                  color: Colors.white,
                ),
                "Feedback")),
        GestureDetector(
            onTap: () {},
            child: list(
                Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                "Share App")),
        GestureDetector(
            onTap: () {},
            child: list(
                Icon(
                  Icons.link,
                  color: Colors.white,
                ),
                "Website link")),
        GestureDetector(
            onTap: () {},
            child: list(
                Icon(
                  Icons.link,
                  color: Colors.white,
                ),
                "Github link")),
        GestureDetector(
            onTap: () {
              _displayDialog(context);
              //_signOut(context);
            },
            // AlertDialog(
            //       content: Text('Logout?'),
            //     ),
            child: list(
                Icon(
                  Icons.power_settings_new,
                  color: Colors.white,
                ),
                "LogOut")),
      ]),
    );
  }

  Container list(
    Icon inconname,
    String textname,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: inconname,
          ),
          SizedBox(
            width: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              textname,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    // FirebaseAuth.instance.currentUsper.delete();
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login_Register()),
        (Route<dynamic> route) => false);
  }

  _displayDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF202020),
          title: Row(
            children: [
              Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Logout?',
                style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
              ),
            ],
          ),
          // content: Text(
          //   'Logout?',
          //   style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
          // ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                _signOut(context);
              },
              child: Text(
                'Yes',
                style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
