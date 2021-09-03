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
