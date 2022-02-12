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

  final colorsList = [Colors.blue, Colors.green, Colors.pink, Colors.purple, Colors.blueGrey, Colors.amber, Colors.deepOrange];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ThreeSixtyPageView(
        itemCount: colorsList.length,
        previousItemBuilder: (context, index){
          return Container(color: colorsList[index],);
        },
        nextItemBuilder: (context, index){
          return Container(color: colorsList[index],);
        },
        itemBuilder: (context, index){
          return Container(color: colorsList[index],);
        },
      ),
    );
  }
}
