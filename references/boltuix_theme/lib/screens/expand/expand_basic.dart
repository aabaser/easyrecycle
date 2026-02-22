import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../data/img.dart';
import '../../widgets/my_text.dart';

class ExpandablePanels extends StatefulWidget {
  @override
  _ExpandablePanelsState createState() => _ExpandablePanelsState();
}

class _ExpandablePanelsState extends State<ExpandablePanels>
    with TickerProviderStateMixin {
  bool expand1 = false;
  bool expand2 = false;
  late AnimationController controller1, controller2;
  late Animation<double> animation1, animation1View;
  late Animation<double> animation2, animation2View;
  String? gender;

  @override
  void initState() {
    super.initState();
    controller1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    controller2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    animation1 = Tween(begin: 0.0, end: 180.0).animate(controller1);
    animation1View =
        CurvedAnimation(parent: controller1, curve: Curves.easeInOut);

    animation2 = Tween(begin: 0.0, end: 180.0).animate(controller2);
    animation2View =
        CurvedAnimation(parent: controller2, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Expandable Panels", style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            buildPanel1(),
            SizedBox(height: 12),
            buildPanel2(),
          ],
        ),
      ),
    );
  }

  Widget buildPanel1() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: togglePanel1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    "Your title goes here",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Transform.rotate(
                    angle: animation1.value * math.pi / 180,
                    child: Icon(
                      Icons.expand_more_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: animation1View,
            child: Column(
              children: [
                Image.asset(Img.get('image_001.png'), fit: BoxFit.cover),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Subtitle goes here. Use this space for detailed information.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(8),
                  child: TextButton(
                    onPressed: togglePanel1,
                    child: Text("HIDE", style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPanel2() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: togglePanel2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    "Your title goes here",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Transform.rotate(
                    angle: animation2.value * math.pi / 180,
                    child: Icon(
                      Icons.expand_more_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: animation2View,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(Img.get('image_005.png'), fit: BoxFit.cover),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Enter your input",
                      labelStyle: TextStyle(color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Radio(
                        value: "Male",
                        groupValue: gender,
                        onChanged: (String? value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      Text("Male"),
                      SizedBox(width: 16),
                      Radio(
                        value: "Female",
                        groupValue: gender,
                        onChanged: (String? value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      Text("Female"),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: togglePanel2,
                          child: Text("CANCEL",
                              style: TextStyle(color: Colors.grey)),
                        ),
                        ElevatedButton(
                          onPressed: togglePanel2,
                          child: Text("SAVE",
                              style: MyText.button(context)!
                                  .copyWith(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void togglePanel1() {
    if (!expand1) {
      controller1.forward();
    } else {
      controller1.reverse();
    }
    expand1 = !expand1;
  }

  void togglePanel2() {
    if (!expand2) {
      controller2.forward();
    } else {
      controller2.reverse();
    }
    expand2 = !expand2;
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }
}
