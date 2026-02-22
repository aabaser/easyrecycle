import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_strings.dart';
import 'package:boltuix/widgets/circle_image.dart';

class TimelinePath extends StatefulWidget {
  TimelinePath();

  @override
  TimelinePathState createState() => new TimelinePathState();
}

class TimelinePathState extends State<TimelinePath> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.green[500],
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          title: Text("Path"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {},
            ),
          ]),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 55,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(width: 1, color: Colors.grey[300], height: 60),
                      Container(
                          child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.blue[400],
                        child: Icon(Icons.chat, size: 10, color: Colors.white),
                      ))
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    CircleImage(
                      imageProvider: AssetImage(Img.get('image_001.png')),
                      size: 40,
                    ),
                    Container(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Victoria W ",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.lightBlue[400],
                                    fontWeight: FontWeight.bold)),
                            Text("posted a",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[500])),
                            Container(width: 3),
                            Text("Note",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.lightBlue[400],
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        Container(height: 5),
                        Text("Just now",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[400])),
                      ],
                    )
                  ],
                )
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 55,
                  child:
                      Container(width: 1, color: Colors.grey[300], height: 60),
                ),
                Expanded(
                  child: Text(MyStrings.middle_lorem_ipsum,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ),
                Container(width: 10)
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 55,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(width: 1, color: Colors.grey[300], height: 60),
                      Container(
                          child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.green[400],
                        child:
                            Icon(Icons.person, size: 10, color: Colors.white),
                      ))
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    CircleImage(
                      imageProvider: AssetImage(Img.get('image_002.png')),
                      size: 40,
                    ),
                    Container(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Oliver T ",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green[400],
                                    fontWeight: FontWeight.bold)),
                            Text("is now following you ",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[500])),
                          ],
                        ),
                        Container(height: 5),
                        Text("22 minutes ago",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[400])),
                      ],
                    )
                  ],
                )
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 55,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(width: 1, color: Colors.grey[300], height: 60),
                      Container(
                          child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.orange[400],
                        child:
                            Icon(Icons.person, size: 10, color: Colors.white),
                      ))
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    CircleImage(
                      imageProvider: AssetImage(Img.get('image_004.png')),
                      size: 40,
                    ),
                    Container(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Charlotte ",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.orange[400],
                                    fontWeight: FontWeight.bold)),
                            Text("is now following you ",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[500])),
                          ],
                        ),
                        Container(height: 5),
                        Text("30 minutes ago",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[400])),
                      ],
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
