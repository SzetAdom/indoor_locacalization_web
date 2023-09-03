import 'package:flutter/material.dart';

class MapEditorPage extends StatefulWidget {
  const MapEditorPage({
    Key? key,
    required this.mapId,
  }) : super(key: key);

  final String mapId;

  @override
  State<MapEditorPage> createState() => _MapEditorPageResetState();
}

class _MapEditorPageResetState extends State<MapEditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Editor'),
      ),
      body: Center(
        child: Text('Map Editor ${widget.mapId}'),
      ),
    );
  }
}
