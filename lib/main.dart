import 'package:flutter/material.dart';
import 'package:indoor_localization_web/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beacon map',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(),
      routes: appRoutes,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
      ),
      body: SizedBox.expand(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                margin: const EdgeInsets.only(top: 20),
                child: TextButton(
                  onPressed: (() {
                    Navigator.pushNamed(context, '/map-editor-1');
                  }),
                  child: const Text(
                    'Térkép szerkesztő 1 megnyitása',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
