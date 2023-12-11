import 'package:flutter/material.dart';
import 'package:indoor_localization_web/reset/model/test_point_model.dart';

class AddTestPointPopUp extends StatefulWidget {
  const AddTestPointPopUp({Key? key}) : super(key: key);

  @override
  State<AddTestPointPopUp> createState() => _AddTestPointPopUpState();
}

class _AddTestPointPopUpState extends State<AddTestPointPopUp> {
  String id = '';
  String name = '';
  double x = 0;
  double y = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Column(
        children: [
          const Text('Tesztpont hozzáadása'),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
              labelText: 'ID',
            ),
            onChanged: (value) {
              id = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Név',
            ),
            onChanged: (value) {
              name = value;
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
                  Navigator.of(context).pop(TestPointModel(
                    id: id,
                    name: name,
                    point: Offset(x, y),
                  ));
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
