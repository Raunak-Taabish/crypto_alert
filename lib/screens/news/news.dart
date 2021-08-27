import 'dart:convert';
import 'package:http/http.dart' as http;

class News {
  List newsname = [];

  Future<List> newss() async {
    String apikey = "1375eb2e9fae4898842e2658c0bb4299";
    String url =
        "https://newsapi.org/v2/everything?q=Crypto&from=2021-08-26&sortBy=popularity&apiKey=$apikey";
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body);

    if (response.statusCode == 200) {
      jsondata["data"].forEach((element) {
        setState(() {
          newsname.add(element["articles"][0]["source"]["name"]);
        });
        print(element["name"]);

        // Article article = Article(
        //   title: element['title'],
        //   author: element['author'],
        //   description: element['description'],
        //   urlToImage: element['urlToImage'],
        //   // publishedAt: DateTime.parse(element['publishedAt']),
        //   content: element["content"],
        //   articleUrl: element["url"],
        // );
        // news.add(article);
      });
      // return names;
    }
    return newsname;
  }

  void setState(Null Function() param0) {}
}
