import 'dart:convert';
import 'package:crypto_alert/data/crypto_list.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class View_Crypto extends StatefulWidget {
  final String cryptoid;
  View_Crypto(this.cryptoid, {Key? key}) : super(key: key);

  @override
  _ViewCrypto_State createState() => _ViewCrypto_State();
}

class _ViewCrypto_State extends State<View_Crypto> {
  List name = [];
  List<SalesData> closeprice = [];

  Future<List> getCryptoDetails() async {
    // List names=[];

    String url =
        "https://www.cryptocurrencychart.com/api/coin/history/${widget.cryptoid}/2019-08-30/2021-08-27/closePrice/USD";
    var response = await http.get(Uri.parse(url), headers: {
      "Key": "24a2c305453648b6e86655da8d99c7f8",
      "Secret": "8f77ce582d37f5507d8407d1b28f1715"
    });
    var jsonData = jsonDecode(response.body);
    // print(response.body);
    print(response.statusCode);
    // print(jsonData["data"][0]["name"]);
    if (response.statusCode == 200) {
      jsonData["data"].forEach((element) {
        SalesData article =
            SalesData(year: "2019", sales: element["closePrice"]);
        closeprice.add(article);
        print(element["closePrice"].toString());
      });
      return closeprice;
      // return jsonData["data"][0]["closePrice"].toString();
      // jsonData["data"].forEach((element) {
      //   setState(() {
      //     // cryptolist.add(element["name"]);
      //     // cryptoprice.add(element["quote"]["USD"]["price"]);
      //     // daychange.add(element["quote"]["USD"]["percent_change_24h"]);
      //     // cryptosymbols.add(element['symbol']);
      //   });
      //   print(element["name"]);
    } else {
      return closeprice;
    }
    // return names;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getCryptoDetails(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              closeprice = snapshot.data;
              // return ListView.builder(
              //     itemCount: closeprice.length,
              //     itemBuilder: (BuildContext ctxt, int index) {
              //       return Text(
              //         closeprice[index],
              //         style: TextStyle(color: Colors.black),
              //       );
              //     });
              return Container(
                  child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(
                          text: 'Half yearly sales analysis'), //Chart title.
                      legend: Legend(isVisible: true), // Enables the legend.
                      tooltipBehavior:
                          TooltipBehavior(enable: true), // Enables the tooltip.
                      series: <LineSeries<SalesData, String>>[
                    LineSeries<SalesData, String>(
                        dataSource: closeprice,
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true) // Enables the data label.
                        )
                  ]));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class SalesData {
  SalesData({required this.year, required this.sales});
  String year;
  double sales;
}
