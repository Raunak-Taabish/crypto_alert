import 'dart:convert';
import 'package:crypto_alert/constant.dart';
import 'package:crypto_alert/data/crypto_statistics.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:crypto_alert/backbutton.dart';
import 'package:crypto_alert/screens/news/article.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

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
  bool _visible = false;
  List name = [];
  List<SalesData> closeprice = [];
  late DateTime currentDate;
  late Future futureNews;
  late String desc;
  late Future getinfo, getcryptodetails, getcryptostatistics;
  late String CryptoURL;
  int selectedTab = 0;
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
    currentDate = DateTime.now();
    // cryptoid.forEach((element) {
    //   if (element[1] == widget.cryptoid) {
    //     cryptoname = element[0];
    //   }
    // });
    futureNews = pullNews();
    getinfo = getCryptoInfo();
    getcryptodetails = getCryptoGraphData();
    getcryptostatistics = getCryptoStatistics();
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
        "https://newsapi.org/v2/everything?qInTitle=${widget.cryptoname}&pageSize=4&from=$today&sortBy=popularity&apiKey=$apikey";
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
          child: FloatingActionButton.extended(
            backgroundColor: Colors.white,
            onPressed: () {
              showdiag(context);
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
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SingleChildScrollView(
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
                              fontFamily: 'Montserrat Alternates',
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
                                // emptyPointSettings: EmptyPointSettings(
                                //     mode: EmptyPointMode.average),
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
                              fontFamily: 'Montserrat Alternates',
                              color: Color(0xFF909090),
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "High",
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat Alternates',
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
                              fontFamily: 'Montserrat Alternates',
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          statistics.highprice.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Montserrat Alternates',
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
                          fontFamily: 'Montserrat Alternates',
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
                                  fontFamily: 'Montserrat Alternates',
                                  fontSize: 13),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
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
                      fontFamily: 'Montserrat Alternates'),
                ),
              ),
              FutureBuilder(
                  future: futureNews,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 3,
                        child: ListView.builder(
                            //physics: new NeverScrollableScrollPhysics(),
                            itemCount: pull.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                //color: Colors.amber,
                                child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.12,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      decoration: BoxDecoration(
                                        // border: Border.all(
                                        // width: 3, color: Colors.black87, style: BorderStyle.solid),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            pull[index].urlToImage,
                                          ),
                                          fit: BoxFit.cover,
                                          // colorFilter: new ColorFilter.mode(
                                          //     Colors.black45, BlendMode.darken),
                                        ),
                                        color: Colors.black87,
                                        // borderRadius: BorderRadius.only(
                                        //   topLeft: Radius.circular(10),
                                        //   topRight: const Radius.circular(10),
                                        // ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      //color: Colors.black,
                                      width: MediaQuery.of(context).size.width /
                                          1.48,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            pull[index].title,
                                            style: TextStyle(
                                              fontFamily:
                                                  'Montserrat Alternates',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
              )
            ],
          ),
        ));
  }

  void showdiag(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(10),
          content: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              // Positioned(
              //   right: -10.0,
              //   top: -10.0,
              //   child: Ink(
              //     width: 10,
              //     height: 10,
              //     child: InkResponse(
              //       onTap: () {
              //         Navigator.of(context).pop();
              //       },
              //       child: CircleAvatar(
              //         child: Icon(Icons.close),
              //         backgroundColor: Colors.red,
              //       ),
              //     ),
              //   ),
              // ),
              Text(
                "Add alert",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Montserrat Alternates",
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  children: [
                    Text(
                      widget.cryptoname,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: 'Montserrat Alternates',
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      //alignment: Alignment.centerLeft,
                      child: Text(
                        '\$ ' + '${widget.cryptoprice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat Alternates',
                            fontSize: 30,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Column alldata(String tag, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$tag",
          style: TextStyle(
              fontSize: 12,
              fontFamily: 'Montserrat Alternates',
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
              fontFamily: 'Montserrat Alternates',
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
              color: Colors.white,
              fontFamily: 'Montserrat Alternates',
              fontSize: 10),
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
}

class SalesData {
  SalesData({required this.year, required this.sales});
  DateTime year;
  double sales;
}
