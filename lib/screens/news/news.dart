import 'dart:convert';
import 'package:crypto_alert/screens/news/article.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class News extends StatefulWidget {
  News({Key? key}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  List<Article> news = [];

  Future<List> getNews() async {
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
          title: element['title'].toString(),
          author: element['author'].toString(),
          description: element['description'].toString(),
          urlToImage: element['urlToImage'].toString(),
          publishedAt: DateTime.parse(element['publishedAt']),
          content: element["content"].toString(),
          articleUrl: element["url"].toString(),
          source: element["source"]["name"].toString(),
        );
        news.add(article);
      });
      // return names;
    }
    return news;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getNews(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                return Text(news[index].title+'\n', style: TextStyle(color: Colors.white),);
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
