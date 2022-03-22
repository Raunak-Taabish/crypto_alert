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
          .doc(crypto.cryptonames)
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
      // height: MediaQuery.of(context).size.height * 0.4,
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
                      alert_list.crypto,
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
                          // showdiag(context, crypto, alert_list);

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
