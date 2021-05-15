import 'package:cohelp/covid.dart';
import 'package:cohelp/news.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter/foundation.dart';

void main() async {
  await DotEnv.load(fileName: ".env");
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode)
      exit(1);
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation',
      
      theme: ThemeData(
        primaryColorDark: Colors.black,
          scaffoldBackgroundColor: Colors.black12, brightness: Brightness.dark),
      home: Nav(),
    );
  }
}

class Nav extends StatefulWidget {
  Nav({Key key}) : super(key: key);

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;

  List<String> subtitleOptions = ['Covid-19 Stats', 'News'];
  String subtitle = 'Covid-19 Stats';
  List<Widget> _widgetOptions = [CovidStats(), News()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      subtitle = subtitleOptions[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      "COVINEWS",
                      style: TextStyle(
                          color: Colors.white, fontSize: 35.0, letterSpacing: 4.5),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ]),
          ],
        ),
        elevation: 0,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(Icons.bar_chart, size: 30),
          Icon(Icons.book, size: 30)
        ],
        color: Colors.black,
        backgroundColor: Colors.grey[900],
        buttonBackgroundColor: Colors.black,
        onTap: _onItemTapped,
        height: 55,
        animationDuration: Duration(milliseconds: 300),
      ),
    );
  }
}
