import 'dart:convert';
import 'dart:developer';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:indoor_localization_web/models/map_args.dart';
import 'package:indoor_localization_web/pages/map_editor.dart';
import 'package:indoor_localization_web/providers/map_object_provider.dart';
import 'package:provider/provider.dart';

class MapEditorFrame extends StatefulWidget {
  const MapEditorFrame({Key? key}) : super(key: key);

  @override
  State<MapEditorFrame> createState() => _MapEditorFrameState();
}

class _MapEditorFrameState extends State<MapEditorFrame> {
  MapArgs? loadMapArgs() {
    Storage localStorage = window.localStorage;
    var res = localStorage['mapArgs'];
    return MapArgs.fromJson(jsonDecode(res ?? ''));
  }

  Future<QuerySnapshot?> loadMapObjects() async {
    final mapsRef = FirebaseFirestore.instance.collection('mapObjects');
    var id = mapArgs?.id ?? '';
    final res = await mapsRef.where('map_id', isEqualTo: id).get();
    return res;
  }

  String? map;
  MapArgs? mapArgs;
  ValueNotifier<String?> mapObjectsId = ValueNotifier(null);
  late Future _future;

  @override
  void initState() {
    mapArgs = loadMapArgs();
    _future = loadMapObjects();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapObjectProvider>(
      create: (context) => MapObjectProvider("Map1"),
      child: Consumer<MapObjectProvider>(builder: (context, provider, child) {
        return Scaffold(
            backgroundColor: Colors.grey,
            appBar: AppBar(
              title: const Text('Edit map'),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () async {
                      var map = provider.exportAll(mapArgs?.id ?? '');

                      try {
                        if (mapObjectsId.value == null) {
                          var res = await FirebaseFirestore.instance
                              .collection("mapObjects")
                              .add(map);
                          mapObjectsId.value = res.id;
                        } else {
                          FirebaseFirestore.instance
                              .collection("mapObjects")
                              .doc(mapObjectsId.value ?? '')
                              .set(map);
                        }
                      } catch (e) {
                        log(e.toString());
                      }

                      // .then((value) => {
                      //       print("Map saved"),
                      //     });

// Add a new document with a generated ID
                    },
                    icon: const Icon(Icons.save),
                  ),
                )
              ],
            ),
            body: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
                  for (DocumentSnapshot item in querySnapshot.docs) {
                    var data = item.data() as Map<String, dynamic>;
                    mapObjectsId.value = item.id;
                    log(data.toString());
                    List<dynamic> objects = data['objects'] as List<dynamic>;
                    provider.importAll(objects);
                  }
                  return MapEditor(
                      width: mapArgs?.width ?? 500,
                      height: mapArgs?.height ?? 500);
                }
                return const Center(
                  child: Text('No data'),
                );
              },
            ));
      }),
    );
  }
}
