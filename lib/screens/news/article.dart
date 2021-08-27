class Article{
  
  String title;
  String author;
  String description;
  String urlToImage;
  DateTime publishedAt;
  String content;
  String articleUrl;
  String source;

  Article({required this.title,required this.author,required this.description,required this.content,required this.publishedAt,
    required this.urlToImage, required this.articleUrl, required this.source});
}