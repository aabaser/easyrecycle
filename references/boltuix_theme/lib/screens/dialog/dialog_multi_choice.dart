import 'package:flutter/material.dart';

class MultiChoiceDialog extends StatefulWidget {
  MultiChoiceDialog({Key? key}) : super(key: key);

  @override
  MultiChoiceDialogState createState() => new MultiChoiceDialogState();
}

class MultiChoiceDialogState extends State<MultiChoiceDialog> {
  List<String> colors = ["Red", "Green", "Blue", "Purple", "Olive"];

  List<bool> status = [false, false, false, false, false];

  bool getValue(String val) {
    int index = colors.indexOf(val);
    if (index == -1) return false;
    return status[index];
  }

  void toggleValue(String name) {
    int index = colors.indexOf(name);
    if (index == -1) return;
    setState(() {
      status[index] = !status[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text("Your preferred color"),
      contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      content: Wrap(
        direction: Axis.vertical,
        children: colors
            .map((c) => InkWell(
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: getValue(c),
                        onChanged: (bool? value) {
                          setState(() {
                            toggleValue(c);
                          });
                        },
                      ),
                      Text(c),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      toggleValue(c);
                    });
                  },
                ))
            .toList(),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
