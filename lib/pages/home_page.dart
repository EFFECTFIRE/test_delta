import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    controller.stream.listen((event) {
      value = event;
    });
  }

  StreamController<int> controller = StreamController<int>.broadcast();
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('casino'),
        ),
        body: Column(
          children: [
            Expanded(
              child: FortuneWheel(
                  onAnimationEnd: () {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(title: Text((value + 1).toString())));
                  },
                  selected: controller.stream,
                  physics: CircularPanPhysics(
                      duration: const Duration(seconds: 1),
                      curve: Curves.decelerate),
                  items: numbers
                      .map((e) => FortuneItem(child: Text(e.toString())))
                      .toList()),
            ),
            TextButton(
                onPressed: () {
                  controller.add(Fortune.randomInt(0, numbers.length));
                },
                child: const Text("Start"))
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }
}
