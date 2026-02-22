import 'package:flutter/material.dart';

class SingleChoiceDialog extends StatefulWidget {
  SingleChoiceDialog({Key? key}) : super(key: key);

  @override
  SingleChoiceDialogState createState() => new SingleChoiceDialogState();
}

class SingleChoiceDialogState extends State<SingleChoiceDialog> {
  String? selectedRingtone = "None";
  List<String> ringtone = ["None", "Callisto", "Ganymede", "Luna"];

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text("Phone Ringtone"),
      children: ringtone
          .map((r) => RadioListTile(
                title: Text(
                  r,
                  style: TextStyle(
                    color: r == selectedRingtone
                        ? Colors.green.shade800
                        : Colors.black,
                  ),
                ),
                groupValue: selectedRingtone,
                selected: r == selectedRingtone,
                value: r,
                onChanged: (dynamic val) {
                  setState(() {
                    selectedRingtone = val;
                  });
                },
              ))
          .toList(),
    );
  }
}
