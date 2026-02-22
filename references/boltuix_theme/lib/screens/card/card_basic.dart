import 'package:flutter/material.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/toolbar.dart';

class CardBasic extends StatefulWidget {
  CardBasic();

  @override
  CardBasicState createState() => new CardBasicState();
}

class CardBasicState extends State<CardBasic> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: CommonAppBar.getPrimaryAppbar(context, "Basic")
          as PreferredSizeWidget?,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            // Card 1
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    Img.get('image_001.png'),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Your Title",
                          style:
                              TextStyle(fontSize: 24, color: Colors.grey[800]),
                        ),
                        Container(height: 10),
                        Container(
                          child: Text(
                            "Your short description goes here",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.transparent),
                        child: Text(
                          "SHARE",
                          style: TextStyle(color: MyColors.primary),
                        ),
                        onPressed: () {},
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.transparent),
                        child: Text(
                          "EXPLORE",
                          style: TextStyle(color: MyColors.primary),
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Container(height: 5)
                ],
              ),
            ),
            Container(height: 5),

            // Card 2
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.asset(
                        Img.get('image_002.png'),
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Your Title",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 23),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.favorite, color: Colors.grey[500]),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.bookmark, color: Colors.grey[500]),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.share, color: Colors.grey[500]),
                        onPressed: () {},
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(height: 5),

            // Card 3 - Gradient Background
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade800, Colors.green.shade200],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Your Title",
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                          Container(height: 10),
                          Container(
                            child: Text(
                              "Your short description goes here",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[200]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.transparent),
                      child: Text(
                        "LISTEN NOW",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 5),

            // Card 4 - Icon and Call to Action
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.green[800],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Your Title",
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                        Divider(color: Colors.white, thickness: 0.5, height: 0),
                        Row(
                          children: <Widget>[
                            Container(width: 15),
                            Text("March 19, 17",
                                style: TextStyle(color: Colors.white)),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.event, color: Colors.white),
                              onPressed: () {},
                            ),
                            Container(width: 4),
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
                        borderRadius: BorderRadius.circular(15)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.blue[800],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(width: 15),
                            Text("Call", style: TextStyle(color: Colors.white)),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.call, color: Colors.white),
                              onPressed: () {},
                            ),
                            Container(width: 4),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Your Title",
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
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
