import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/data/my_strings.dart';
import 'package:boltuix/widgets/my_text.dart';

class ToolbarCollapse extends StatefulWidget {
  ToolbarCollapse();

  @override
  ToolbarCollapseState createState() => new ToolbarCollapseState();
}

class ToolbarCollapseState extends State<ToolbarCollapse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background:
                    Image.asset(Img.get('image_001.png'), fit: BoxFit.cover),
              ),
              leading: IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () {},
                ), // overflow menu
                PopupMenuButton<String>(
                  onSelected: (String value) {},
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "Settings",
                      child: Text("Settings"),
                    ),
                  ],
                )
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  color: MyColors.primary,
                  child: Text(
                    "Your Label",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(height: 15),
                Text(MyStrings.short_lorem_ipsum,
                    style: MyText.headline(context)!.copyWith(
                        color: Colors.grey[900], fontWeight: FontWeight.bold)),
                Container(height: 5),
                Row(
                  children: <Widget>[
                    Icon(Icons.event, size: 20.0, color: Colors.grey),
                    Container(width: 5),
                    Text("22 Feb 2024",
                        style: MyText.body1(context)!
                            .copyWith(color: Colors.grey)),
                  ],
                ),
                Container(height: 20),
                Text(MyStrings.very_long_lorem_ipsum,
                    textAlign: TextAlign.justify)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
