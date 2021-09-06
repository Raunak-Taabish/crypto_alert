import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_alert/data/crypto_list.dart';
import 'package:crypto_alert/screens/home.dart';
import 'package:crypto_alert/screens/view_crypto/view_crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/constant.dart';

Container favourites(
    String id, Crypto_Home crypto, Alert_List alert_list, context) {
  final User? user = FirebaseAuth.instance.currentUser;
  //final uid = user.uid;
  double wid = MediaQuery.of(context).size.width;
  final databaseReference = FirebaseFirestore.instance;
  Future<void> deleteAlerts() async {
    try {
      await databaseReference
          .collection("users")
          .doc(user!.uid)
          .collection('alert_list')
          .doc(alert_list.crypto)
          .delete();
      displayToastMessage('Your alert is deleted', context);
      // if (mounted) {
      //   setState(() {
      //     // _loading = false;
      //     saved = false;
      //   });
      // }
      // ignore: unrelated_type_equality_checks

      // saved = true;
      // checksaved(title,context);
    } catch (e) {
      displayToastMessage(e.toString(), context);
    }
  }

  return Container(
      //color: Colors.amber,
      // alignment: Alignment.center,
      //height: 50,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(
                            "https://github.com/coinwink/cryptocurrency-logos/blob/master/coins/128x128/${crypto.logoId}.png?raw=true"),
                        fit: BoxFit.fill,
                      )),
                    ),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * 0.03,
                    // ),
                    Text(
                      crypto.cryptonames,
                      //    + ' (' +
                      //     cryptosymbols[index] +
                      //     ')', // +cryptolist.length.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: 'Montserrat'),
                    ),
                  ],
                ),
              ),
            ]),
            Container(
              height: MediaQuery.of(context).size.height / 12,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.fromLTRB(35, 10, 0, 10),
              //height: 50,
              decoration: BoxDecoration(
                color: Color(0xFF1a1a1a),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 0, //MediaQuery.of(context).size.width / 5,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                width: 10,
                                height: 10,
                                decoration: new BoxDecoration(
                                  color: Color(0xFFFF493E),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Below",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            '  ${alert_list.fallBelow.toString()}  ',
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              width: 10,
                              height: 10,
                              decoration: new BoxDecoration(
                                color: Color(0xFF00D293),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              "Above",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            '  ${alert_list.riseAbove.toString()}  ',
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showdiag(context, crypto, alert_list);

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return View_Crypto(
                                cryptoid: id,
                                cryptoname: crypto.cryptonames,
                                cryptoprice: crypto.cryptoprices,
                                daychange: crypto.daychange,
                                logoId: crypto.logoId,
                                alert: true);
                          }));
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                          alignment: Alignment.topCenter,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.fromLTRB(25, 10, 25, 0),
                        child: GestureDetector(
                            onTap: () {
                              deleteAlerts();
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Home(
                                  pindex: 1,
                                );
                              }));
                            },
                            child:
                                Icon(Icons.delete_outline, color: Colors.red)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ]));
}

Container showdiag(
    BuildContext context, Crypto_Home crypto, Alert_List alert_list) {
  TextEditingController _controllerFB = TextEditingController();
  TextEditingController _controllerRA = TextEditingController();
  _controllerFB.text = alert_list.fallBelow;
  _controllerRA.text = alert_list.riseAbove;
  // showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  return Container(
      color: Colors.black87,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
          child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.only(bottom: 100),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF2E2E2E),
                ),
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF151515),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              // margin: EdgeIN,
              // color: Color(0xFF151515),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  //overflow: Overflow.visible,
                  children: <Widget>[
                    // Container(
                    //   margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    //   child: Text(
                    //     "Add alert",
                    //     style: TextStyle(
                    //         color: Colors.white,
                    //         fontFamily: "Montserrat",
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.w500),
                    //   ),
                    // ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 10),
                      color: Colors.transparent,
                      //width: MediaQuery.of(context).size.width / 1.4,
                      //height: MediaQuery.of(context).size.height * 0.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            crypto.cryptonames,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                            //alignment: Alignment.centerLeft,
                            child: Text(
                              '\$ ' +
                                  '${crypto.cryptoprices.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 35,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 20),
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  // margin: EdgeInsets.only(bottom: 10),
                                  child: TextField(
                                    onChanged: (value) {
                                      String fallBelowtext = value;
                                      print(fallBelowtext);
                                    },
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Color(0xFFbdc6cf)),
                                    controller: _controllerFB,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFF202020),
                                      labelText: "Fall below",
                                      labelStyle:
                                          TextStyle(color: Colors.redAccent),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  // margin: EdgeInsets.only(bottom: 10),
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(
                                  //         color: Color(0xFF2E2E2E)),
                                  //     borderRadius: BorderRadius.circular(20),
                                  //     color: Color(0xFF202020)),
                                  child: TextField(
                                    onChanged: (value) {
                                      String riseAbovetext = value;
                                      print(riseAbovetext);
                                    },
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Color(0xFFbdc6cf)),
                                    controller: _controllerRA,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFF202020),
                                      labelText: "Rise above",
                                      //hintText: widget.cryptoprice.toString(),
                                      labelStyle:
                                          TextStyle(color: Colors.greenAccent),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
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
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  // setState(() {
                                  //   isAlert = !isAlert;
                                  // });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width / 2.8,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF2E2E2E),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text('Cancel',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat',
                                        fontSize: 17,
                                      )),
                                )),
                            // SizedBox(width: 11),
                            GestureDetector(
                                onTap: () {
                                  // isAlert = !isAlert;
                                  // addFav(context);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Home(
                                      pindex: 1,
                                    );
                                  }));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width / 2.8,
                                  height: 50,
                                  child: Text('Save',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontSize: 17,
                                      )),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                )),
                          ]),
                    ),
                  ]))));
}
