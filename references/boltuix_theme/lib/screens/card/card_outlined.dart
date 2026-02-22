import 'package:flutter/material.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/toolbar.dart';

class CardOutlined extends StatefulWidget {
  CardOutlined();

  @override
  CardOutlinedState createState() => new CardOutlinedState();
}

class CardOutlinedState extends State<CardOutlined> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar.getPrimarySettingAppbar(context, "Outlined")
          as PreferredSizeWidget?,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Updated borderRadius
                side: BorderSide(color: MyColors.accent, width: 1),
              ),
              elevation: 0,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    Img.get('image_001.png'), // Updated image
                    height: 300, width: double.infinity, fit: BoxFit.cover,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Your title goes here",
                            style: TextStyle(
                                fontSize: 24, color: Colors.grey[800])),
                        Container(height: 10),
                        Container(
                          child: Text("Subtitle goes here",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[700])),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end, // Aligns children to the right
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.transparent),
                        child: Text("SHARE",
                            style: TextStyle(color: MyColors.primary)),
                        onPressed: () {},
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.transparent),
                        child: Text("EXPLORE",
                            style: TextStyle(color: MyColors.primary)),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Container(height: 5),
                ],
              ),
            ),
            Container(height: 5),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Updated borderRadius
                side: BorderSide(color: MyColors.primary, width: 2),
              ),
              elevation: 0,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Your title goes here",
                        style:
                            TextStyle(fontSize: 24, color: Colors.grey[800])),
                    Container(height: 10),
                    Container(
                      child: Text("Subtitle goes here",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700])),
                    ),
                    Container(height: 10),
                  ],
                ),
              ),
            ),
            Container(height: 5),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Updated borderRadius
                      side: BorderSide(color: MyColors.grey_20, width: 1),
                    ),
                    elevation: 0,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Image.asset(
                              Img.get('image_002.png'), // Updated image
                              height: 160, width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned.fill(
                              child: Container(
                                padding: EdgeInsets.all(15),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text("Title #1",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 23)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                            height: 0,
                            color: Colors.lightGreenAccent), // Updated divider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              icon:
                                  Icon(Icons.favorite, color: Colors.grey[500]),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon:
                                  Icon(Icons.bookmark, color: Colors.grey[500]),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.share, color: Colors.grey[500]),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(width: 2),
                Expanded(
                  flex: 1,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Updated borderRadius
                      side: BorderSide(color: MyColors.grey_20, width: 1),
                    ),
                    elevation: 0,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Image.asset(
                              Img.get('image_007.png'), // Updated image
                              height: 160, width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned.fill(
                              child: Container(
                                padding: EdgeInsets.all(15),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text("Title #2",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 23)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                            height: 0,
                            color: Colors.lightGreenAccent), // Updated divider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              icon:
                                  Icon(Icons.favorite, color: Colors.grey[500]),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon:
                                  Icon(Icons.bookmark, color: Colors.grey[500]),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.share, color: Colors.grey[500]),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(height: 10),
          ],
        ),
      ),
    );
  }
}
