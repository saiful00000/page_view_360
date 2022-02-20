import 'package:flutter/material.dart';
import 'package:page_view_360/page_view_360.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final colorsList = [
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.purple,
    Colors.blueGrey,
    Colors.amber,
    Colors.deepOrange
  ];

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.position.maxScrollExtent == _pageController.offset) {
        print('max => max');
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ThreeSixtyPageView(
        itemCount: colorsList.length,
        // pageMargin: const EdgeInsets.all(16),
        pageController: _pageController,
        itemBuilder: (context, index) {
          return Container(
            color: colorsList[index],
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: const TextStyle(
                fontSize: 56,
              ),
            ),
          );
        },
        onPageChanged: (page) {
          print('=> page = $page');
        },
      ),
    );
  }
}
