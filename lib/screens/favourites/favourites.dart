import 'package:crypto_alert/data/crypto_home.dart';
import 'package:crypto_alert/data/crypto_list.dart';
import 'package:crypto_alert/screens/view_crypto/view_crypto.dart';
import 'package:flutter/material.dart';

Container favourites(Crypto_Home crypto) {
  return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1a1a1a),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      // alignment: Alignment.center,
      //height: 50,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(
                      "https://github.com/coinwink/cryptocurrency-logos/blob/master/coins/128x128/${crypto.logoId}.png?raw=true"),
                  fit: BoxFit.fill,
                )),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(
                  crypto.cryptonames,
                  //    + ' (' +
                  //     cryptosymbols[index] +
                  //     ')', // +cryptolist.length.toString(),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Montserrat'),
                ),
              ),
            ]),
            Column(
              children: [
                Text(
                  '${crypto.cryptoprices.toStringAsFixed(2)} \$',
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Montserrat'),
                ),
                Row(children: [
                  Icon(
                    crypto.daychange >= 0
                        ? Icons.arrow_drop_up_sharp
                        : Icons.arrow_drop_down_sharp,
                    size: 20,
                    color: crypto.daychange >= 0
                        ? Color(0xFF00D293)
                        : Color(0xFFFF493E),
                  ),
                  Text(
                    '${crypto.daychange.toStringAsFixed(2)}%',
                    style: TextStyle(
                        color: crypto.daychange >= 0
                            ? Color(0xFF00D293)
                            : Color(0xFFFF493E),
                        fontFamily: 'Montserrat'),
                  ),
                ]),
              ],
            )
          ]));
}
