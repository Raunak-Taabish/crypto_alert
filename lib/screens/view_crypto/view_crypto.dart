import 'dart:convert';
import 'package:crypto_alert/constant.dart';
import 'package:crypto_alert/data/crypto_list.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:crypto_alert/screens/news/news.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:crypto_alert/backbutton.dart';
import 'package:crypto_alert/screens/news/article.dart';

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

  List<Article> pull = [];

  Future<List> pullNews() async {
    DateTime now = new DateTime.now();
    String date = now.toString();
    String apikey = "1375eb2e9fae4898842e2658c0bb4299";
    DateTime currentdate = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(currentdate);
    String url =
        "https://newsapi.org/v2/everything?q=Crypto&from=$today&sortBy=popularity&apiKey=$apikey";
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body);

    if (response.statusCode == 200) {
      jsondata["articles"].forEach((element) {
        // setState(() {
        //   newsname.add(element["articles"][0]["source"]["name"]);
        // });
        // print(element["name"]);
        Article article = Article(
          title: element['title'].toString(), //
          author: element['author'].toString(),
          description: element['description'].toString(),
          urlToImage: element['urlToImage'].toString(),
          publishedAt: DateTime.parse(element['publishedAt']), //
          content: element["content"].toString(),
          articleUrl: element["url"].toString(),
          source: element["source"]["name"].toString(), //
        );
        pull.add(article);
      });
      // return names;
    }
    return pull;
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
          automaticallyImplyLeading: false,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              child: Row(
                children: [
                  Container(
                    child: BackWhiteButton(),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(05, 0, 0, 0),
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: NetworkImage(
                          "https://github.com/coinwink/cryptocurrency-logos/blob/master/coins/128x128/${widget.logoId}.png?raw=true"),
                      fit: BoxFit.fill,
                    )),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      widget.cryptoname,
                      //    + ' (' +
                      //     cryptosymbols[index] +
                      //     ')', // +cryptolist.length.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat Alternates'),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 30,
                height: 30,
                child: Icon(Icons.favorite_border_sharp),
                // child: IconButton(
                //   icon: Icon(Icons.favorite_border_sharp),
                //   onPressed: () {
                //     setState(() {
                //       selected = !selected;
                //     });
                //   },
                // ),
              ),
            )
          ]),
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF151515),
        ),
        backgroundColor: const Color(0xFF151515),
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton.extended(
                backgroundColor: Colors.white,
                onPressed: () {},
                isExtended: true,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                icon: Image.asset(
                  'assets/images/convert.png',
                  width: 15,
                  height: 15,
                ),
                label: Text(
                  'Converter',
                  style: blackboldText,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.white,
                onPressed: () {},
                isExtended: true,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                icon: Image.asset(
                  'assets/images/add.png',
                  width: 15,
                  height: 15,
                ),
                label: Text(
                  'Add Alert',
                  style: blackboldText,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(25, 0, 0, 5),
                      child: Text(
                        widget.cryptoname,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: 'Montserrat Alternates'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          //alignment: Alignment.centerLeft,
                          child: Text(
                            '\$ ' + '${widget.cryptoprice.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat Alternates',
                                fontSize: 40,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          decoration: BoxDecoration(
                              color: widget.daychange >= 0
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Icon(
                                widget.daychange >= 0
                                    ? Icons.arrow_drop_up_sharp
                                    : Icons.arrow_drop_down_sharp,
                                size: 20,
                                color: Colors.white,
                                //widget.daychange >= 0 ? Colors.green : Colors.red,
                              ),
                              Text(
                                '${widget.daychange.toStringAsFixed(2)}%',
                                style: TextStyle(
                                    color: Colors
                                        .white, //widget.daychange >= 0 ? Colors.green : Colors.red,
                                    fontFamily: 'Montserrat Alternates',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF202020),
                      ),
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                                    labelStyle: TextStyle(
                                        color: Colors.grey, fontSize: 10),
                                    isVisible: true,
                                    //Hide the gridlines of x-axis
                                    majorGridLines:
                                        const MajorGridLines(width: 0),
                                    //Hide the axis line of x-axis
                                    axisLine: const AxisLine(width: 0),
                                  ),
                                  primaryYAxis: NumericAxis(
                                      labelStyle: TextStyle(
                                          color: Colors.grey, fontSize: 10),
                                      majorTickLines:
                                          const MajorTickLines(width: 0),
                                      // isVisible: false,
                                      //Hide the gridlines of y-axis
                                      majorGridLines:
                                          const MajorGridLines(width: 0),
                                      //Hide the axis line of y-axis
                                      axisLine: const AxisLine(width: 0)),
                                  // plotAreaBackgroundColor: Colors.black,
                                  // borderColor: Colors.white,
                                  // borderWidth: 0,
                                  plotAreaBorderWidth: 0,
                                  // enableSideBySideSeriesPlacement: false,
                                  backgroundColor: const Color(0xFF202020),
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
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            widget.daychange >= 0
                                                ? Color(0xFF00FFB3)
                                                : Color(0xFFC01010),
                                            Color(0xFF2F9FDB),
                                          ]),
                                      // name: 'Price in \$',
                                      emptyPointSettings: EmptyPointSettings(
                                          mode: EmptyPointMode.average),
                                      dataSource: closeprice,
                                      xValueMapper: (SalesData sales, _) =>
                                          DateFormat('d/MMM')
                                              .format(sales.year),
                                      yValueMapper: (SalesData sales, _) =>
                                          sales.sales,
                                      animationDuration: 3000,
                                      markerSettings: const MarkerSettings(
                                          height: 2,
                                          width: 2,
                                          isVisible: false),
                                      // dataLabelSettings: const DataLabelSettings(
                                      //     isVisible: true), // Enables the data label.
                                      enableTooltip: true,
                                      opacity: 0.8,
                                    )
                                  ]);
                            } else {
                              return const Center();
                            }
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(onTap: () {}, child: dayChange("24 H")),
                        GestureDetector(onTap: () {}, child: dayChange("7 D")),
                        GestureDetector(onTap: () {}, child: dayChange("1 M")),
                        GestureDetector(onTap: () {}, child: dayChange("1 Y")),
                        GestureDetector(onTap: () {}, child: dayChange("3 Y")),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              alldata('low', '15.36'),
                              alldata('low', '15.36'),
                              alldata('low', '15.36'),
                            ],
                          ),
                          SizedBox(
                            width: 130,
                          ),
                          Column(
                            children: [
                              alldata('low', '15.36'),
                              alldata('low', '15.36'),
                              alldata('low', '15.36'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      //width: MediaQuery.of(context).size.width / 2.5,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFF202020),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "What is " + widget.cryptoname,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat Alternates',
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla .....",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat Alternates',
                                fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //width: MediaQuery.of(context).size.width / 2.5,
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFF202020),
                      ),
                      child: FutureBuilder(
                          future: pullNews(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: pull.length,
                                  itemBuilder: (context, index) {
                                    return Text(
                                      pull[index].title,
                                      style: TextStyle(color: Colors.white),
                                    );
                                  });
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 8,
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Container alldata(String tag, String value) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$tag",
            style: TextStyle(
                fontSize: 12,
                fontFamily: 'Montserrat Alternates',
                color: Color(0xFF909090),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "$value",
            style: TextStyle(
                fontSize: 17,
                fontFamily: 'Montserrat Alternates',
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Container dayChange(String daychange) {
    return Container(
      width: 45,
      height: 30,
      child: Center(
        child: Text(
          daychange,
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat Alternates',
              fontSize: 10),
        ),
      ),
      decoration: BoxDecoration(
        color: Color(0xFF202020),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class SalesData {
  SalesData({required this.year, required this.sales});
  DateTime year;
  double sales;
}
