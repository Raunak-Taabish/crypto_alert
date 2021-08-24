import 'package:crypto_alert/screens/authentication/login_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name='';

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
            return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
        actions: [ElevatedButton(onPressed: () {_signOut(context);}, child: Text('Logout'))]
      ),
       body: Center(child: Text('Welcome'+name)),
    );}
    else{return const Center(child: CircularProgressIndicator());}
        });
  }
  Future<void> _signOut(BuildContext context) async {
  // FirebaseAuth.instance.currentUsper.delete();
  await FirebaseAuth.instance.signOut();
  Navigator.push(
      context, MaterialPageRoute(builder: (BuildContext context) => Login_Register()));
}
}