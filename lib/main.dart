import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indoor_localization_web/routes.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      title: 'Beacon map',
      theme: ThemeData.from(
          colorScheme: const ColorScheme.light(), useMaterial3: true),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePageReset extends StatefulWidget {
  const MyHomePageReset({Key? key}) : super(key: key);

  @override
  State<MyHomePageReset> createState() => _MyHomePageResetState();
}

class _MyHomePageResetState extends State<MyHomePageReset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              width: 200,
              height: 50,
              color: Theme.of(context).primaryColor,
              margin: const EdgeInsets.only(top: 20),
              child: TextButton(
                onPressed: (() {
                  context.go('/map-editor/id');
                  // showDialog(
                  //     context: context,
                  //     builder: (context) => const CrateMapPopUpWidget());
                }),
                child: const Text(
                  'Create new map',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

