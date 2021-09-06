import 'package:crypto_alert/screens/authentication/login_register.dart';
import 'package:crypto_alert/screens/menu/about.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class MenuPage extends StatefulWidget {
  String profile, name;
  MenuPage(this.profile, this.name, {Key? key}) : super(key: key);

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
      body: Column(children: [
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
                  margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    image: widget.profile == ''
                        ? DecorationImage(image: NetworkImage(widget.profile))
                        : DecorationImage(
                            image:
                                AssetImage('assets/images/defaultAccount.png')),
                    color: Colors.white,
                    shape: BoxShape.circle,
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
                                  fontSize: 10,
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
            onTap: () {},
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
            onTap: () => _signOut(context),
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
}
