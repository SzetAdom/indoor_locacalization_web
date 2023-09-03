import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indoor_localization_web/firebase_options.dart';
import 'package:indoor_localization_web/routes.dart';
import 'package:indoor_localization_web/utils/authentication.dart';
import 'package:indoor_localization_web/widgets/auth_dialog.dart';
import 'package:indoor_localization_web/widgets/create_map_dialog.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future getUserInfo() async {
    await getUser();
    setState(() {});
    log(uid.toString());
  }

  @override
  void initState() {
    getUserInfo();
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
          useMaterial3: true,
          colorScheme: const ColorScheme.light(),
          textTheme: const TextTheme()),
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
                  showDialog(
                      context: context,
                      builder: (context) => const CreateMap());
                }),
                child: const Text(
                  'Create new map',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Container(
              width: 200,
              height: 50,
              color: Theme.of(context).primaryColor,
              margin: const EdgeInsets.only(top: 20),
              child: TextButton(
                onPressed: (() {
                  context.go('/map-editor');
                }),
                child: const Text(
                  'Edit map',
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<QuerySnapshot?> loadMaps() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return null;
    }
    final mapsRef = FirebaseFirestore.instance.collection('maps');
    final res = await mapsRef
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    return res;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Home"),
                actions: [
                  if (snapshot.hasData)
                    IconButton(
                      onPressed: () {
                        signOut();
                      },
                      icon: const Icon(Icons.exit_to_app),
                    ),
                ],
              ),
              body: snapshot.hasData
                  ? SizedBox.expand(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              height: 50,
                              color: Theme.of(context).primaryColor,
                              margin: const EdgeInsets.only(top: 20),
                              child: TextButton(
                                onPressed: (() {
                                  showDialog(
                                      context: context,
                                      builder: (context) => const CreateMap());
                                }),
                                child: const Text(
                                  'Create new map',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                            FutureBuilder(
                                future: loadMaps(),
                                builder: (context, snapshot) {
                                  log('main page refresh');

                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData) {
                                    QuerySnapshot querySnapshot =
                                        snapshot.data as QuerySnapshot;
                                    if (querySnapshot.docs.isNotEmpty) {
                                      return SizedBox(
                                        width: 200,
                                        child: ListView(
                                            shrinkWrap: true,
                                            children: querySnapshot.docs.map(
                                                (DocumentSnapshot document) {
                                              Map<String, dynamic> data =
                                                  document.data()!
                                                      as Map<String, dynamic>;
                                              return Container(
                                                height: 50,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                margin: const EdgeInsets.only(
                                                    top: 20),
                                                child: TextButton(
                                                  onPressed: (() {
                                                    context.go('/map-editor');
                                                  }),
                                                  child: Text(
                                                    'Edit "${data['name']}"',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              );
                                            }).toList()),
                                      );
                                    }
                                  } else if (snapshot.hasError) {
                                    log(snapshot.error.toString());
                                    return const Text('Error');
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  return Container(
                                      margin: const EdgeInsets.only(top: 30),
                                      child: const Text('No maps yet'));
                                })
                          ]),
                    )
                  : const SizedBox.expand(
                      child: Center(
                        child: AuthDialog(),
                      ),
                    ));
        });
  }
}
