import 'package:flutter/material.dart';
import 'package:boltuix/widgets/toolbar.dart';

class ToolbarBasic extends StatefulWidget {
  ToolbarBasic();

  @override
  ToolbarBasicState createState() => new ToolbarBasicState();
}

class ToolbarBasicState extends State<ToolbarBasic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CommonAppBar.getPrimarySettingAppbar(context, "Toolbar")
          as PreferredSizeWidget?,
      body: Container(),
    );
  }
}
