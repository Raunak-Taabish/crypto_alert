import 'dart:convert';
import 'package:crypto_alert/data/crypto_list.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class View_Crypto extends StatefulWidget {
  final String cryptoid;
  final String cryptoname;
  final double cryptoprice;
  final double daychange;
  final int logoId;
  View_Crypto(this.cryptoid, this.cryptoname, this.cryptoprice, this.daychange,
      this.logoId,
      {Key? key})
      : super(key: key);

  @override
  _ViewCrypto_State createState() => _ViewCrypto_State();
}

class _ViewCrypto_State extends State<View_Crypto> {
  List name = [];
  List<SalesData> closeprice = [];
  late DateTime currentDate;
  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
    // cryptoid.forEach((element) {
    //   if (element[1] == widget.cryptoid) {
    //     cryptoname = element[0];
    //   }
    // });
  }

  Future<List> getCryptoDetails() async {
    // List names=[];
    print(widget.cryptoid);
    print(currentDate);
    DateTime endDate = currentDate;
    DateTime startDate =
        DateTime(currentDate.year, currentDate.month - 1, currentDate.day);
    String url =
        "https://www.cryptocurrencychart.com/api/coin/history/${widget.cryptoid}/$startDate/$endDate/closePrice/USD";
    var response = await http.get(Uri.parse(url), headers: {
      "Key": "24a2c305453648b6e86655da8d99c7f8",
      "Secret": "8f77ce582d37f5507d8407d1b28f1715"
    });
    var jsonData = jsonDecode(response.body);
    // print(response.body);
    print(response.statusCode);
    // print(jsonData["data"][0]["name"]);
    if (response.statusCode == 200) {
      try {
        jsonData["data"].forEach((element) {
          SalesData article = SalesData(
              year: DateFormat('yyyy-MM-dd').parse(element["date"]),
              sales: double.parse(element["closePrice"].toString()));
          closeprice.add(article);
          // print(element["closePrice"].toString());
        });
      } catch (e) {
        print(e);
      }
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
        appBar: AppBar(
          title: Row(children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    "https://github.com/coinwink/cryptocurrency-logos/blob/master/coins/128x128/${widget.logoId}.png?raw=true"),
                fit: BoxFit.fill,
              )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Text(
                widget.cryptoname,
                //    + ' (' +
                //     cryptosymbols[index] +
                //     ')', // +cryptolist.length.toString(),
                style: const TextStyle(
                    color: Colors.white, fontFamily: 'Montserrat Alternates'),
              ),
            ),
          ]),
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF151515),
        ),
        backgroundColor: const Color(0xFF151515),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                '${widget.cryptoprice.toStringAsFixed(2)}\$',
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat Alternates',
                    fontSize: 20),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 20),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(
                    widget.daychange >= 0
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 15,
                    color: widget.daychange >= 0 ? Colors.green : Colors.red,
                  ),
                  Text(
                    '${widget.daychange.toStringAsFixed(2)}%',
                    style: TextStyle(
                        color:
                            widget.daychange >= 0 ? Colors.green : Colors.red,
                        fontFamily: 'Montserrat Alternates',
                        fontSize: 15),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
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
                      return SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            labelStyle:
                                TextStyle(color: Colors.grey, fontSize: 10),
                            isVisible: true,
                            //Hide the gridlines of x-axis
                            majorGridLines: const MajorGridLines(width: 0),
                            //Hide the axis line of x-axis
                            axisLine: const AxisLine(width: 0),
                          ),
                          primaryYAxis: NumericAxis(
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                              majorTickLines: const MajorTickLines(width: 0),
                              // isVisible: false,
                              //Hide the gridlines of y-axis
                              majorGridLines: const MajorGridLines(width: 0),
                              //Hide the axis line of y-axis
                              axisLine: const AxisLine(width: 0)),
                          // plotAreaBackgroundColor: Colors.black,
                          // borderColor: Colors.white,
                          // borderWidth: 0,
                          plotAreaBorderWidth: 0,
                          // enableSideBySideSeriesPlacement: false,
                          backgroundColor: const Color(0xFF9999),
                          // primaryXAxis: CategoryAxis(),
                          // title: ChartTitle(
                          //     text: ''), //Chart title.
                          // legend: Legend(
                          //     isVisible: true,
                          //     position:
                          //         LegendPosition.bottom), // Enables the legend.
                          tooltipBehavior: TooltipBehavior(
                              enable: true), // Enables the tooltip.
                          series: <SplineAreaSeries<SalesData, String>>[
                            SplineAreaSeries<SalesData, String>(
                              cardinalSplineTension: 4,
                              color: Colors.white,
                              gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: const [Colors.indigo, Colors.purple]),
                              // name: 'Price in \$',
                              emptyPointSettings: EmptyPointSettings(
                                  mode: EmptyPointMode.average),
                              dataSource: closeprice,
                              xValueMapper: (SalesData sales, _) =>
                                  DateFormat('d/MMM').format(sales.year),
                              yValueMapper: (SalesData sales, _) => sales.sales,
                              animationDuration: 3000,
                              markerSettings: const MarkerSettings(
                                  height: 2, width: 2, isVisible: true),
                              // dataLabelSettings: const DataLabelSettings(
                              //     isVisible: true), // Enables the data label.
                              enableTooltip: true,
                              opacity: 0.6,
                            )
                          ]);
                    } else {
                      return const Center();
                    }
                  }),
            )
          ],
        ));
  }
}

class SalesData {
  SalesData({required this.year, required this.sales});
  DateTime year;
  double sales;
}
