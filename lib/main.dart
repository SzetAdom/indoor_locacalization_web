import 'dart:convert';
import 'dart:developer';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:indoor_localization_web/firebase_options.dart';
import 'package:indoor_localization_web/models/map_args.dart';
import 'package:indoor_localization_web/routes.dart';
import 'package:indoor_localization_web/utils/authentication.dart';
import 'package:indoor_localization_web/widgets/auth_dialog.dart';
import 'package:indoor_localization_web/widgets/create_map_dialog.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      builder: (context, child) {
        return MaterialApp(
          title: 'Beacon map',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          home: const MyHomePage(),
          routes: appRoutes,
          debugShowCheckedModeBanner: false,
        );
      },
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
    _future = loadMaps();
    super.initState();
  }

  late Future _future;

  void setSelectedMap(String id, String name, double width, double height) {
    Storage storage = window.localStorage;
    storage['mapArgs'] = jsonEncode(MapArgs(
                height: height,
                width: width,
                name: name,
                id: id,
                userId: FirebaseAuth.instance.currentUser?.uid ?? '')
            .toJson())
        .toString();
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
                                      ConnectionState.waiting) {
                                    return const Center(child: Text("Loading"));
                                  }
                                  if (snapshot.hasData) {
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
                                                    setSelectedMap(
                                                        document.id,
                                                        data['name'],
                                                        data['width'],
                                                        data['height']);
                                                    Navigator.pushNamed(context,
                                                        '/map-editor-new');
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
                                    return Container();
                                  }

                                  return const Center(
                                      child: Text('Something went wrong'));
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
