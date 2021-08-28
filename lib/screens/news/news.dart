import 'dart:convert';
import 'package:crypto_alert/screens/news/article.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_alert/constant.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:url_launcher/url_launcher.dart';

class News extends StatefulWidget {
  News({Key? key}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  List<Article> news = [];

  Future<List> getNews() async {
    DateTime now = new DateTime.now();
    String date = now.toString();
    String apikey = "1375eb2e9fae4898842e2658c0bb4299";
    String url =
        "https://newsapi.org/v2/everything?q=Crypto&from=2021-08-26&sortBy=popularity&apiKey=$apikey";
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
        news.add(article);
      });
      // return names;
    }
    return news;
  }

  // Align(
  //                     alignment: Alignment.topLeft,
  //                     child: Text(
  //                       "News",
  //                       style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 30,
  //                           fontFamily: 'Montserrat Alternates'),
  //                     ),
  //                   ),

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getNews(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                    //         fontFamily: 'Montserrat Alternates'),
                    //   ),
                    // ),
                    Container(
                      child: Bounce(
                        duration: Duration(milliseconds: 110),
                        onPressed: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          //padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: 30),
                          child: Column(
                            children: [
                              Image.network(news[index].urlToImage),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      news[index].title,
                                      style: boldText,
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          news[index].source,
                                          style: regularText,
                                        ),
                                        Text(
                                          ' ' +
                                              news[index]
                                                  .publishedAt
                                                  .toString(),
                                          style: regularText,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      news[index].description,
                                      style: regularText,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      news[index].content,
                                      style: regularText,
                                    ),
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
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
