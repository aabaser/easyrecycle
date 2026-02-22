import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class ToolbarLight extends StatefulWidget {
  ToolbarLight();

  @override
  ToolbarLightState createState() => new ToolbarLightState();
}

class ToolbarLightState extends State<ToolbarLight> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          backgroundColor: Colors.white,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          iconTheme: IconThemeData(color: MyColors.grey_60),
          title: Text("Toolbar",
              style: MyText.title(context)!.copyWith(color: MyColors.grey_60)),
          leading: IconButton(
              icon: Icon(Icons.menu_rounded),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search_rounded),
                onPressed: () {}), // overflow menu
            PopupMenuButton<String>(
              onSelected: (String value) {},
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "Settings",
                  child: Text("Settings"),
                ),
              ],
            )
          ]),
      body: Container(),
    );
  }
}
