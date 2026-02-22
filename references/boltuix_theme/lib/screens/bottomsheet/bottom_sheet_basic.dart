import 'package:flutter/material.dart';

import '../../data/img.dart';

class BottomSheetBasic extends StatefulWidget {
  @override
  BottomSheetBasicState createState() => BottomSheetBasicState();
}

class BottomSheetBasicState extends State<BottomSheetBasic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Basic bottom sheet", style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Text(
          "Press button below",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], fontSize: 18),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "fab",
        backgroundColor: Colors.green,
        elevation: 3,
        child: Icon(Icons.arrow_upward_rounded, color: Colors.white),
        onPressed: () {
          showSheet(context);
        },
      ),
    );
  }
}

void showSheet(context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Wrap(
          spacing: 20,
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(Img.get('image_005.png')),
                ),
                SizedBox(width: 10),
                Text(
                  "John Smith",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Subtitle goes here. Use this space for a description or information.",
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),
            //Divider(height: 0, color: Colors.lightGreenAccent),
            SizedBox(height: 10),
            Row(
              children: [
                Image.asset(
                  Img.get('dialog_badge.png'),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "More information or content can go here.",
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                ),
              ],
            ),
            //Divider(height: 0, color: Colors.lightGreenAccent),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("CLOSE", style: TextStyle(color: Colors.green)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {},
                  child: Text("DETAILS", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
