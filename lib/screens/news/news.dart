import 'dart:convert';
import 'package:crypto_alert/screens/news/article.dart';
import 'package:crypto_alert/screens/news/open_news.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_alert/data/constant.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

// class News extends StatefulWidget {
//   List<Article> news;
//   News(this.news, {Key? key}) : super(key: key);

//   @override
//   _NewsState createState() => _NewsState();
// }

// class _NewsState extends State<News> {
// List<Article> news = [];
// late Future getNewsData;

// @override
// void initState() {
//   super.initState();
//   getNewsData = getNews();
// }

// Future<List> getNews() async {
//   print('News data is fetched');
//   String apikey = "1375eb2e9fae4898842e2658c0bb4299";
//   DateTime currentdate = DateTime.now();
//   String today = DateFormat('yyyy-MM-dd').format(currentdate);
//   String url =
//       "https://newsapi.org/v2/everything?q=Crypto&language=en&from=$today&sortBy=popularity&apiKey=$apikey";
//   var response = await http.get(Uri.parse(url));
//   var jsondata = jsonDecode(response.body);

//   if (response.statusCode == 200) {
//     jsondata["articles"].forEach((element) {
//       // setState(() {
//       //   newsname.add(element["articles"][0]["source"]["name"]);
//       // });
//       // print(element["name"]);
//       Article article = Article(
//         title: element['title'].toString(), //
//         author: element['author'].toString(),
//         description: element['description'].toString(),
//         urlToImage: element['urlToImage'].toString(),
//         publishedAt: DateTime.parse(element['publishedAt']), //
//         content: element["content"].toString(),
//         articleUrl: element["url"].toString(),
//         source: element["source"]["name"].toString(), //
//       );
//       news.add(article);
//     });
//     // return names;
//   }
//   return news;
// }

@override
ListView newspage(List<Article> news) {
  // return
  // RefreshIndicator(
  //     onRefresh: getNews,
  //     child: FutureBuilder(
  //       future: getNewsData,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Text(
            //     "News",
            //     style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 30,
            //         fontFamily: 'Montserrat'),
            //   ),
            // ),
            Container(
              child: Bounce(
                duration: Duration(milliseconds: 110),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return OpenNews(news[index].articleUrl);
                  }));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF1a1a1a),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  //padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      Container(
                          height: 175,
                          decoration: BoxDecoration(
                              // border: Border.all(
                              // width: 3, color: Colors.black87, style: BorderStyle.solid),
                              image: DecorationImage(
                                image: NetworkImage(
                                  news[index].urlToImage,
                                ),
                                fit: BoxFit.cover,
                                // colorFilter: new ColorFilter.mode(
                                //     Colors.black45, BlendMode.darken),
                              ),
                              color: Colors.black87,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: const Radius.circular(10)))),

                      // BoxDecoration(
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                      // child: Image.network(news[index].urlToImage, fit: BoxFit.cover,)),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(news[index].title,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  news[index].source,
                                  style: regularText,
                                ),
                                Text(
                                    ' ' +
                                        DateFormat('hh:mm aaa')
                                            .format(news[index].publishedAt)
                                            .toString(),
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 13,
                                      color: Colors.grey,
                                    )),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(news[index].description,
                                maxLines: 3,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 13,
                                    color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
        //Text(
        //   news[index].title + '\n',
        //   style: TextStyle(color: Colors.white),
        // );
      });
}
// } else {
//   return const Center(
//     child: CircularProgressIndicator(),
//   );
// }
//         },
//       ));
// }
// }
