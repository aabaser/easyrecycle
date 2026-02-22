import 'package:flutter/material.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class AboutAppSimple extends StatefulWidget {
  AboutAppSimple();

  @override
  AboutAppSimpleState createState() => new AboutAppSimpleState();
}

class AboutAppSimpleState extends State<AboutAppSimple> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 35),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [MyColors.gradient1, MyColors.gradient2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(
                height: 50), // Space between the close button and the content
            Text("BoltUix",
                style: MyText.display1(context)!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w300)),
            Container(height: 5),
            Container(width: 120, height: 3, color: Colors.white),
            Container(height: 15),
            Text("Version",
                style: MyText.body1(context)!.copyWith(color: MyColors.grey_3)),
            Text("1.2025.1",
                style: MyText.body1(context)!.copyWith(color: Colors.white)),
            Container(height: 15),
            Text("Last Update",
                style: MyText.body1(context)!.copyWith(color: MyColors.grey_3)),
            Text("2nd Jan 2024",
                style: MyText.body1(context)!.copyWith(color: Colors.white)),
            Container(height: 25),
            Text(
              "Flutter BoltUix App template is the ultimate app for Flutter developers. "
              "It offers a wide range of UI components, themes, and utilities to help you build stunning applications with ease. "
              "Whether you are a beginner or an experienced developer, FlutterUiX Pro provides all the tools you need to create beautiful and functional UIs.",
              style: MyText.body1(context)!.copyWith(color: Colors.white),
            ),
            Container(height: 25),
            Text("Term of Services",
                style: MyText.medium(context).copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
