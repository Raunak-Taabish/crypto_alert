import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const boldText = TextStyle(
    fontFamily: 'Montserrat', fontWeight: FontWeight.w600, color: Colors.white);

const regularText = TextStyle(fontFamily: 'Montserrat', color: Colors.grey);

const blackboldText = TextStyle(
    fontFamily: 'Montserrat', fontWeight: FontWeight.w600, color: Colors.black);

const blackregularText =
    TextStyle(fontFamily: 'Montserrat', color: Colors.black);

displayToastMessage(String msg, BuildContext context) {
  Fluttertoast.showToast(msg: msg);
}

class Crypto_Home {
  String cryptonames, cryptosymbols;
  double daychange, cryptoprices;
  int logoId;
  Crypto_Home(
      {required this.cryptonames,
      required this.cryptoprices,
      required this.cryptosymbols,
      required this.daychange,
      required this.logoId});
}

class Alert_List {
  String crypto;
  String riseAbove, fallBelow;
  Alert_List(
      {required this.crypto, required this.riseAbove, required this.fallBelow});
}

class User_Details {
  String name, profile, email;
  User_Details(
      {required this.name, required this.profile, required this.email});
}
