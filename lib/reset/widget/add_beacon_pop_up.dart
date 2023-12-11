import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/model/map_beacon_model.dart';

class AddBeaconPopUp extends StatefulWidget {
  const AddBeaconPopUp({Key? key}) : super(key: key);

  @override
  State<AddBeaconPopUp> createState() => _AddBeaconPopUpState();
}

class _AddBeaconPopUpState extends State<AddBeaconPopUp> {
  String uuid = '';
  double x = 0;
  double y = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Column(
        children: [
          const Text('Beacon hozzáadása'),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
              labelText: 'UUID',
            ),
            onChanged: (value) {
              uuid = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'X',
            ),
            onChanged: (value) {
              x = double.parse(value);
            },
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Y',
            ),
            onChanged: (value) {
              y = double.parse(value);
            },
          ),
          const Spacer(),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Mégse'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  final beacon = MapBeaconModel(
                    uuid: uuid,
                    point: Offset(x, y),
                  );
                  Navigator.of(context).pop(beacon);
                },
                child: const Text('Hozzáadás'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
