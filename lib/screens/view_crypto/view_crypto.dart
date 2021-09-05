import 'dart:convert';
import 'package:crypto_alert/data/constant.dart';
import 'package:crypto_alert/data/crypto_list.dart';
import 'package:crypto_alert/data/crypto_statistics.dart';
import 'package:crypto_alert/screens/authentication/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:crypto_alert/backbutton.dart';
import 'package:crypto_alert/screens/news/article.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../home.dart';

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
  _ViewCrypto_State createState() => _ViewCrypto_State(price: cryptoprice);
}

class _ViewCrypto_State extends State<View_Crypto> {
  double price;
  _ViewCrypto_State({required this.price});

  // late int riseAbove = price.toInt(); //cryptoprice.toInt();
  // late int fallBelow = price.toInt(); //cryptoprice.toInt();
  bool isAlert = false;
  var age = 25;
  bool _visible = false;
  bool saved = false;
  List name = [];
  List<SalesData> closeprice = [];
  late TextEditingController _controllerFB;
  late TextEditingController _controllerRA;
  late DateTime currentDate;
  late Future futureNews;
  late String desc;
  late Future getinfo, getcryptodetails, getcryptostatistics, checkAlerts;
  late String CryptoURL;
  int selectedTab = 0;

  final User? user = FirebaseAuth.instance.currentUser;
  //final uid = user.uid;
  final databaseReference = FirebaseFirestore.instance;
  Crypto_Statistics statistics = Crypto_Statistics(
      lowprice: 0.0,
      highprice: 0.0,
      closeprice: 0.0,
      openprice: 0.0,
      marketcap: 0.0,
      volume: 0.0,
      supply: 0.0,
      rank: 0);

  @override
  void initState() {
    super.initState();
    _controllerFB = new TextEditingController(
        text: '${widget.cryptoprice.toStringAsFixed(2)}');
    _controllerRA = new TextEditingController(
        text: '${widget.cryptoprice.toStringAsFixed(2)}');
    currentDate = DateTime.now();
    // cryptoid.forEach((element) {
    //   if (element[1] == widget.cryptoid) {
    //     cryptoname = element[0];
    //   }
    // });
    // checksaved(context);
    futureNews = pullNews();
    getinfo = getCryptoInfo();
    getcryptodetails = getCryptoGraphData();
    getcryptostatistics = getCryptoStatistics();
    checkAlerts = checkAlert();
  }

  Future<void> addFav(BuildContext context) async {
    try {
      await databaseReference
          .collection("users")
          .doc(user!.uid)
          .collection('alert_list')
          .doc(widget.cryptoname)
          .set({
        'crypto_name': widget.cryptoname,
        'rise_above': _controllerRA.text,
        'fall_below': _controllerFB.text,
      });
      displayToastMessage('Your alerts are saved', context);
      if (mounted) {
        setState(() {
          // _loading = false;
          saved = true;
          // Home n=new Home();n.checksaved(title, context);
        });
      }
      // saved = true;
      // checksaved(title,context);
    } catch (e) {
      print(e.toString());
      displayToastMessage(e.toString(), context);
    }

    // DocumentReference ref = await databaseReference.collection("books").add({
    //   'title': 'Flutter in Action',
    //   'description': 'Complete Programming Guide to learn Flutter'
    // });
    // print(ref.id);
  }

  // Future<void> deleteFavs(BuildContext context) async {
  //   try {
  //     await databaseReference
  //         .collection("users")
  //         .doc(user!.uid)
  //         .collection('fav_cryptos')
  //         .doc(widget.cryptoname)
  //         .delete();
  //     displayToastMessage('Unsaved', context);
  //     if (mounted) {
  //       setState(() {
  //         // _loading = false;
  //         saved = false;
  //         // newslists.removeWhere((item) => item.title == this.title);
  //         // print(newslists);
  //         // if (saveview) {
  //         //   Navigator.pushReplacement(
  //         //       context,
  //         //       MaterialPageRoute(
  //         //           builder: (BuildContext context) => SavedNews()));
  //         //   // Saved sn=new Saved();
  //         //   // sn.getSavedNews();
  //         // }
  //         // Home n=new Home();n.checksaved(title, context);
  //       });
  //     }
  //     // ignore: unrelated_type_equality_checks

  //     // saved = true;
  //     // checksaved(title,context);
  //   } catch (e) {
  //     displayToastMessage(e.toString(), context);
  //   }

  //   // DocumentReference ref = await databaseReference.collection("books").add({
  //   //   'title': 'Flutter in Action',
  //   //   'description': 'Complete Programming Guide to learn Flutter'
  //   // });
  //   // print(ref.id);
  // }

  Future<void> checkAlert() async {
    //add index argument

    try {
      // ignore: await_only_futures
      var snap = await databaseReference
          .collection("users")
          .doc(user!.uid)
          .collection('alert_list')
          .where('crypto_name', isEqualTo: widget.cryptoname)
          .get();
      //((result) => {
      // print(value.data.contains(title));
      // for(var doc in snap.docs) {
      print(snap.docs.toList());
      if (snap.docs.isNotEmpty) {
        if (mounted) {
          setState(() => {saved = true});
        }
        // print(title);
      } else {
        if (mounted) {
          setState(() => {saved = false});
        }
        // print(title+'false');
      }
    } catch (e) {
      displayToastMessage(e.toString(), context);
    }
  }

  Future<Crypto_Statistics> getCryptoStatistics() async {
    // String key = 'aec925c7-3059-4a11-8592-b99deb474b47';
    // var key = '1a7e4376-d437-4aa1-929b-a9e04968d593';
    print('Crypto ID: ${widget.cryptoid}');
    String url =
        "https://www.cryptocurrencychart.com/api/coin/view/${widget.cryptoid}";

    var response = await http.get(Uri.parse(url), headers: {
      "Key": "24a2c305453648b6e86655da8d99c7f8",
      "Secret": "8f77ce582d37f5507d8407d1b28f1715"
    });

    var jsonData = jsonDecode(response.body);
    // print(response.body);
    print(response.statusCode);
    // print(jsonData["data"][0]["name"]);
    // print(widget.logoId);
    try {
      setState(() {
        statistics = Crypto_Statistics(
            lowprice: double.parse(jsonData["coin"]["lowPrice"]),
            highprice: double.parse(jsonData["coin"]["highPrice"]),
            closeprice: double.parse(jsonData["coin"]["closePrice"]),
            openprice: double.parse(jsonData["coin"]["openPrice"]),
            marketcap: double.parse(jsonData["coin"]["marketCap"]),
            volume: double.parse(jsonData["coin"]["tradeVolume"]),
            supply: double.parse(jsonData["coin"]["supply"]),
            rank: jsonData["coin"]["rank"]);
      });
      print('Low price:  ${statistics.lowprice}');
      return statistics;
    } catch (e) {
      print(e);
      return statistics;
    }
  }

  Future<String> getCryptoInfo() async {
    String key = 'aec925c7-3059-4a11-8592-b99deb474b47';
    // var key = '1a7e4376-d437-4aa1-929b-a9e04968d593';

    String url =
        "https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?id=${widget.logoId}";
    var response =
        await http.get(Uri.parse(url), headers: {"X-CMC_PRO_API_KEY": key});

    var jsonData = jsonDecode(response.body);
    // print(response.body);
    // print(response.statusCode);
    // print(jsonData["data"][0]["name"]);
    // print(widget.logoId);
    try {
      desc = jsonData["data"][widget.logoId.toString()]["description"];
      CryptoURL =
          jsonData["data"][widget.logoId.toString()]["urls"]["website"][0];
      // print(CryptoURL);
      // print(desc);
      return desc;
    } catch (e) {
      return '';
      print(e);
    }
  }

  List<Article> pull = [];

  Future<List> pullNews() async {
    // String apikey = "1375eb2e9fae4898842e2658c0bb4299";
    String apikey = "ee7211708b0243d19ad32f561258a604";
    DateTime currentdate = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(currentdate);
    String url =
        "https://newsapi.org/v2/everything?q=Crypto&language=en&from=$today&sortBy=popularity&pageSize=3&apiKey=$apikey";

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
        // print(article.title);
        setState(() {
          pull.add(article);
        });
      });
      // return names;
    }
    return pull;
  }

  Future<List> getCryptoGraphData() async {
    // List names=[];
    // print(widget.cryptoid);
    // print(currentDate);
    DateTime startDate;
    DateTime endDate = currentDate;
    switch (selectedTab) {
      case 1:
        startDate =
            DateTime(currentDate.year, currentDate.month - 1, currentDate.day);
        break;
      case 2:
        startDate =
            DateTime(currentDate.year, currentDate.month - 6, currentDate.day);
        break;
      case 3:
        startDate =
            DateTime(currentDate.year, currentDate.month - 11, currentDate.day);
        break;
      default:
        startDate =
            DateTime(currentDate.year, currentDate.month, currentDate.day - 7);
        break;
    }
    // String key = "XR3SJVKFPU7XT8FZ";
    // String url = "https://www.alphavantage.co/query?function=CRYPTO_INTRADAY&symbol=ETH&market=USD&interval=5min&apikey=$key";
    String url =
        "https://www.cryptocurrencychart.com/api/coin/history/${widget.cryptoid}/$startDate/$endDate/closePrice/USD";
    var response = await http.get(Uri.parse(url), headers: {
      "Key": "24a2c305453648b6e86655da8d99c7f8",
      "Secret": "8f77ce582d37f5507d8407d1b28f1715"
    });
    // var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    // print(response.body);
    // print(response.statusCode);
    // print(jsonData["data"][0]["name"]);

    if (response.statusCode == 200) {
      try {
        setState(() {
          closeprice.clear();
          jsonData["data"].forEach((element) {
            SalesData article = SalesData(
                year: DateFormat('yyyy-MM-dd').parse(element["date"]),
                sales: double.parse(element["closePrice"].toString()));
            closeprice.add(article);
            // print(element["closePrice"].toString());
          });
        });
      } catch (e) {
        print(e);
      }
      return closeprice;
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
                          color: Colors.white, fontFamily: 'Montserrat'),
                    ),
                  ),
                ],
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     saved ? deleteFavs(context) : addFav(context);
            //   },
            //   child: Container(
            //     width: 30,
            //     height: 30,
            //     child: Icon(
            //         saved ? Icons.favorite : Icons.favorite_border_sharp,
            //         color: saved ? Colors.red : Colors.white),
            //     // child: IconButton(
            //     //   icon: Icon(Icons.favorite_border_sharp),
            //     //   onPressed: () {
            //     //     setState(() {
            //     //       selected = !selected;
            //     //     });
            //     //   },
            //     // ),
            //   ),
            // )
          ]),
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF151515),
        ),
        backgroundColor: const Color(0xFF151515),
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 0),
          child: !isAlert
              ? saved
                  ? FloatingActionButton.extended(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          isAlert = !isAlert;
                        });
                      },
                      isExtended: true,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      icon: Icon(Icons.mode_edit_outline_outlined,
                          color: Colors.black),
                      // Image.asset(
                      //   'assets/images/add.png',
                      //   width: 15,
                      //   height: 15,
                      // ),
                      label: Text(
                        'Edit Alert',
                        style: blackboldText,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                    )
                  : FloatingActionButton.extended(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          isAlert = !isAlert;
                        });
                      },
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                    )
              : Center(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Stack(
          children: [
            // isAlert
            //     ? Center()
            //     :
            SingleChildScrollView(
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
                          fontFamily: 'Montserrat'),
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
                              fontFamily: 'Montserrat',
                              fontSize: 40,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        decoration: BoxDecoration(
                            color: widget.daychange >= 0
                                ? Color(0xFF00D293)
                                : Color(0xFFFF493E),
                            borderRadius: BorderRadius.circular(6)),
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
                                  fontFamily: 'Montserrat',
                                  fontSize: 13,
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
                        future: getcryptodetails,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            closeprice = snapshot.data;

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
                                    // cardinalSplineTension: 4,
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
                                        DateFormat('d/MMM').format(sales.year),
                                    yValueMapper: (SalesData sales, _) =>
                                        sales.sales,
                                    animationDuration: 3000,
                                    markerSettings: const MarkerSettings(
                                        borderColor: Colors.white,
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
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 0;
                              getCryptoGraphData();
                            });
                          },
                          child: dayChange("7 D", 0)),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 1;
                              getCryptoGraphData();
                            });
                          },
                          child: dayChange("1 M", 1)),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 2;
                              getCryptoGraphData();
                            });
                          },
                          child: dayChange("6 M", 2)),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 3;
                              getCryptoGraphData();
                            });
                          },
                          child: dayChange("1 Y", 3)),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Low",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Montserrat',
                                  color: Color(0xFF909090),
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "High",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Montserrat',
                                  color: Color(0xFF909090),
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          color: Colors.white,
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              statistics.lowprice.toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              statistics.highprice.toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                      future: getcryptostatistics,
                      builder: (context, snapshot) {
                        return Container(
                          margin: EdgeInsets.fromLTRB(30, 20, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  alldata(
                                    'Market cap',
                                    statistics.marketcap.toStringAsFixed(2),
                                  ),
                                  alldata(
                                    'Open',
                                    statistics.openprice.toStringAsFixed(2),
                                  ),
                                  alldata(
                                    'Previous close',
                                    statistics.closeprice.toStringAsFixed(2),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.08,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  alldata(
                                    'Volume',
                                    statistics.volume.toStringAsFixed(2),
                                  ),
                                  alldata(
                                    'Supply',
                                    statistics.supply.toStringAsFixed(2),
                                  ),
                                  alldata(
                                    'Rank',
                                    '#${statistics.rank.toString()}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    //width: MediaQuery.of(context).size.width / 2.5,
                    margin: EdgeInsets.fromLTRB(30, 15, 20, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      //color: Color(0xFF202020),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About " + widget.cryptoname,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        FutureBuilder(
                            future: getCryptoInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  desc,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: 13),
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white));
                              }
                            })
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 20, 0, 20),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0))),
                      color: Colors.white,
                      onPressed: () async {
                        if (await canLaunch(CryptoURL)) {
                          await launch(CryptoURL);
                        } else {
                          throw 'Error';
                        }
                      },
                      child: Text(
                        "Learn more",
                        style: blackboldText,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 20, 0, 0),
                    child: Text(
                      "${widget.cryptoname} News",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                  FutureBuilder(
                      future: futureNews,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            height: MediaQuery.of(context).size.height / 2.25,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: pull.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
                                    //color: Colors.amber,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.12,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.12,
                                          decoration: BoxDecoration(
                                            // border: Border.all(
                                            // width: 3, color: Colors.black87, style: BorderStyle.solid),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  pull[index].urlToImage,
                                                ),
                                                fit: BoxFit.cover
                                                // colorFilter: new ColorFilter.mode(
                                                //     Colors.black45, BlendMode.darken),
                                                ),
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 5, 0, 5),
                                            //color: Colors.black,
                                            // width: MediaQuery.of(context)
                                            //         .size
                                            //         .width /
                                            //     1.48,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  pull[index].title,
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                  maxLines: 2,
                                                ),
                                                Text(
                                                  pull[index].source,
                                                  style: regularText,
                                                ),
                                                Text(
                                                  DateFormat('hh:mm aaa')
                                                      .format(pull[index]
                                                          .publishedAt),
                                                  style: regularText,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          );
                        } else {
                          return const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          );
                        }
                      }),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 8,
                  )
                ],
              ),
            ),
            isAlert ? showdiag() : Center(),
          ],
        ));
  }

  Container showdiag() {
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
                              widget.cryptoname,
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
                                    '${widget.cryptoprice.toStringAsFixed(2)}',
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
                                    width:
                                        MediaQuery.of(context).size.width / 3,
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
                                          // borderRadius:
                                          // BorderRadius.circular(25.7),
                                          // borderRadius:
                                          // BorderRadius.circular(25.7),
                                          //hintText: 'Username',
                                          // contentPadding: const EdgeInsets.only(
                                          //     left: 14.0, bottom: 8.0, top: 8.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(
                                  //         color: Color(0xFF2E2E2E)),
                                  //     borderRadius: BorderRadius.circular(20),
                                  //     color: Color(0xFF202020)),
                                  // child:
                                  // child: NumberPicker(
                                  //     textStyle: TextStyle(
                                  //         color: Colors.white, fontSize: 15),
                                  //     selectedTextStyle: TextStyle(
                                  //       color: Color(0xFFFC5D53),
                                  //       fontSize: 25,
                                  //       fontWeight: FontWeight.w500,
                                  //     ),
                                  //     itemHeight: 50,
                                  //     itemWidth: 120,
                                  //     minValue: (price/2).toInt(),
                                  //     maxValue: price.toInt()*2,
                                  //     value: fallBelow,
                                  //     onChanged: (value) {
                                  //       setState(() {
                                  //         fallBelow = value;
                                  //       });
                                  //     }),
                                  // Text(
                                  //   "Fall below",
                                  //   style: TextStyle(
                                  //       color: Colors.white,
                                  //       fontSize: 15,
                                  //       fontFamily: 'Montserrat',
                                  //       fontWeight: FontWeight.w400),
                                  // ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
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
                                        labelStyle: TextStyle(
                                            color: Colors.greenAccent),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          // borderRadius:
                                          // BorderRadius.circular(25.7),
                                          // borderRadius:
                                          // BorderRadius.circular(25.7),
                                          // contentPadding: const EdgeInsets.only(
                                          //     left: 14.0, bottom: 8.0, top: 8.0),
                                        ),
                                      ),
                                    ),
                                    // child: NumberPicker(
                                    //     textStyle: TextStyle(
                                    //         color: Colors.white, fontSize: 15),
                                    //     selectedTextStyle: TextStyle(
                                    //       color: Color(0xFF00D293),
                                    //       fontSize: 25,
                                    //       fontWeight: FontWeight.w500,
                                    //     ),
                                    //     itemHeight: 50,
                                    //     itemWidth: 120,
                                    //     minValue: (price/2).toInt(),
                                    //     maxValue: price.toInt()*2,
                                    //     value: riseAbove,
                                    //     onChanged: (value) {
                                    //       setState(() {
                                    //         riseAbove = value;
                                    //       });
                                    //     }),
                                  ),
                                  // Text(
                                  //   "Rise above",
                                  //   style: TextStyle(
                                  //       color: Colors.white,
                                  //       fontSize: 15,
                                  //       fontFamily: 'Montserrat',
                                  //       fontWeight: FontWeight.w400),
                                  // )
                                ],
                              ),
                            ),
                          ],
                        ),
                        // width: 50,
                        // child: TextFormField(),
                      ),
                      Container(
                        // color: Colors.amber,
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isAlert = !isAlert;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width / 2.8,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF2E2E2E),
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                    isAlert = !isAlert;
                                    addFav(context);
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  )),
                            ]),
                      ),
                    ]))));
  }

  Column alldata(String tag, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$tag",
          style: TextStyle(
              fontSize: 12,
              fontFamily: 'Montserrat',
              color: Color(0xFF909090),
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "$value",
          style: TextStyle(
              fontSize: 17,
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Container dayChange(String daychange, int tab) {
    return Container(
      width: 45,
      height: 30,
      child: Center(
        child: Text(
          daychange,
          style: TextStyle(
              color: Colors.white, fontFamily: 'Montserrat', fontSize: 10),
        ),
      ),
      decoration: BoxDecoration(
          color: Color(0xFF202020),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              width: 1,
              color: selectedTab == tab ? Colors.white : Colors.transparent)),
    );
  }
  // @override
  // void dispose() {
  //   _controllerFB.dispose();
  //   _controllerFB.dispose();
  //   super.dispose();
  // }
}

class SalesData {
  SalesData({required this.year, required this.sales});
  DateTime year;
  double sales;
}
