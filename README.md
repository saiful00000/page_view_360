<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

An improved version of PageView.builder(). Scrollable in 4 direction

## Features

[comment]: <> (TODO: List what your package can do. Maybe include images, gifs, or videos.)
> A PageView.builder() for vertical and Horizontal scrolling at same time
> Or you can say a quad directional slide-able PageView
## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

```dart
import 'package:page_view_360/page_view_360.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ThreeSixtyPageView(
        itemCount: colorsList.length,
        // pageMargin: const EdgeInsets.all(16),
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
      ),
    );
  }
}
```

## Additional information

Contribution or any suggestion are warm welcome. Please keep eay on git repo for any kind of information update.

[comment]: <> (TODO: Tell users more about the package: where to find more information, how to )

[comment]: <> (contribute to the package, how to file issues, what response they can expect )

[comment]: <> (from the package authors, and more.)
