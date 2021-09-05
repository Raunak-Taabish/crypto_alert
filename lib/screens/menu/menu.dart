import 'package:crypto_alert/constant.dart';
import 'package:crypto_alert/screens/authentication/login_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF151515),
      body: Column(children: [
        Container(
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
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "User name",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontFamily: 'Montserrat'),
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 5,
              ),
              Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ],
          ),
        ),
        FlatButton(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            onPressed: () {},
            child: list(
                Icon(
                  Icons.info_rounded,
                  color: Colors.white,
                ),
                "About")),
        FlatButton(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            onPressed: () {},
            child: list(
                Icon(
                  Icons.call,
                  color: Colors.white,
                ),
                "Contact")),
        FlatButton(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            onPressed: () {},
            child: list(
                Icon(
                  Icons.feedback,
                  color: Colors.white,
                ),
                "Feedback")),
        FlatButton(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            onPressed: () {},
            child: list(
                Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                "Share App")),
        FlatButton(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            onPressed: () {},
            child: list(
                Icon(
                  Icons.link,
                  color: Colors.white,
                ),
                "Website link")),
        FlatButton(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            onPressed: () {},
            child: list(
                Icon(
                  Icons.link,
                  color: Colors.white,
                ),
                "Github link")),
        FlatButton(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            onPressed: () {},
            child: list(
                Icon(
                  Icons.power_settings_new,
                  color: Colors.white,
                ),
                "hello")),
      ]),
    );
  }

  Container list(
    Icon inconname,
    String textname,
  ) {
    return Container(
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
