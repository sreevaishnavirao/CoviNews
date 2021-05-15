import 'package:cohelp/webview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class NewsTemplate {
  final String source;
  final String title;
  final String description;
  final String imageURL;
  final String newsURL;

  NewsTemplate({
    this.source,
    this.title,
    this.description,
    this.imageURL,
    this.newsURL,
  });
}

class News extends StatefulWidget {
  News({Key key}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  List newsArray;

  Future<List<NewsTemplate>> getNews() async {
    var url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=IN&category=health&apiKey=${DotEnv.env['API_KEY']}');
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    List<NewsTemplate> newss = [];
    for (var tem in data['articles']) {
      String des = tem["description"];
      String im = tem["urlToImage"];
      if (des == null) {
        des = ' ';
      }
      if (im == null) {
        im =
            'https://www.vskills.in/certification/blog/wp-content/uploads/2015/01/structure-of-a-news-report.jpg';
      }
      NewsTemplate user = NewsTemplate(
          source: tem['source']['name'],
          title: tem["title"],
          description: des,
          imageURL: im,
          newsURL: tem["url"]);

      newss.add(user);
    }

    return newss;
  }

  Widget customList(source, title, description, imageURL, newsURL) {
    return InkWell(
      onTap: () {
        // print(newsURL);
        // _launchURL(newsURL);
        // var snackBar = SnackBar(content: Text(newsURL));
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Webview(newsURL, source)),
        );
      },
      child: Container(
        margin: EdgeInsets.all(12.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3.0,
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180.0,
              width: double.infinity,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: NetworkImage(imageURL),
              //     fit: BoxFit.cover,
              //   ),
              //   borderRadius: BorderRadius.circular(25.0),
              // ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Image.network(
                  imageURL,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: Image.asset(
                          'assets/news.jpg',
                          fit: BoxFit.cover,
                        ));
                  },
                ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Container(
              padding: EdgeInsets.all(9.0),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                source,
                style: TextStyle(
                  color: Colors.greenAccent,
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                fontSize: 16.0,
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(
              color: Colors.black,
              height: 10,
              thickness: 2,
              indent: 6,
              endIndent: 6,
            ),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.normal,
                height: 1.3,
                fontSize: 14.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.grey[900]),
        child: FutureBuilder(
          future: getNews(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (ctx, index) => customList(
                        snapshot.data[index].source,
                        snapshot.data[index].title,
                        snapshot.data[index].description,
                        snapshot.data[index].imageURL,
                        snapshot.data[index].newsURL,
                      ));
            }
          },
        ),
      ),
    );
  }
}
