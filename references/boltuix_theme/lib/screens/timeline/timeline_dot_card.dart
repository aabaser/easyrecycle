import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/circle_image.dart';
import 'package:boltuix/widgets/my_text.dart';

class TimelineDotCard extends StatefulWidget {
  TimelineDotCard();

  @override
  TimelineDotCardState createState() => new TimelineDotCardState();
}

class TimelineDotCardState extends State<TimelineDotCard> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: MyColors.grey_5,
      appBar: AppBar(
          backgroundColor: Colors.green[500],
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
          ),
          title: Text("Timeline"),
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
            buildTimelineItem(
              image: 'image_001.png',
              username: "Victoria W.",
              action: "posted a Note",
              time: "Just now",
              content:
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            ),
            buildTimelineItem(
              image: 'image_002.png',
              username: "Oliver T.",
              action: "is now following you",
              time: "22 minutes ago",
              content: "",
            ),
            buildTimelineItem(
              image: 'image_004.png',
              username: "Charlotte P.",
              action: "is now following you",
              time: "30 minutes ago",
              content: "",
            ),
            buildTimelineItem(
              image: 'image_007.png',
              username: "Homer J. Allen",
              action: "posted a Note",
              time: "Yesterday",
              content: "Nulla porttitor accumsan tincidunt.",
            ),
            buildTimelineItem(
              image: 'image_006.png',
              username: "Lillie Hoyos",
              action: "in Jiangsu, China",
              time: "2 days ago",
              content: "",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTimelineItem({
    required String image,
    required String username,
    required String action,
    required String time,
    required String content,
  }) {
    return Row(
      children: <Widget>[
        Container(width: 10),
        Container(
          alignment: Alignment.center,
          width: 20,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                  width: 1,
                  color: Colors.grey[300],
                  height: content.isEmpty ? 64 : 115),
              Container(
                margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: content.isEmpty
                      ? Colors.lightBlue[400]
                      : Colors.lightGreen[400],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 1,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleImage(
                        imageProvider: AssetImage(Img.get(image)),
                        size: 35,
                      ),
                      Container(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("$username $action",
                              style: MyText.caption(context)!.copyWith(
                                  color: Colors.lightBlue[400],
                                  fontWeight: FontWeight.bold)),
                          Container(height: 5),
                          Text(time,
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey[400])),
                        ],
                      )
                    ],
                  ),
                  if (content.isNotEmpty) ...[
                    Container(height: 10),
                    Text(content,
                        style: MyText.caption(context)!
                            .copyWith(color: Colors.grey[600])),
                  ],
                ],
              ),
            ),
          ),
        ),
        Container(width: 5),
      ],
    );
  }

  Widget buildTimelineItemWithImage({
    required String image,
    required String username,
    required String action,
    required String time,
    required String content,
    required String postImage,
  }) {
    return Row(
      children: <Widget>[
        Container(width: 10),
        Container(
          alignment: Alignment.center,
          width: 20,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(width: 1, color: Colors.grey[300], height: 215),
              Container(
                margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: Colors.red[400],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 1,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleImage(
                        imageProvider: AssetImage(Img.get(image)),
                        size: 35,
                      ),
                      Container(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("$username $action",
                              style: MyText.caption(context)!.copyWith(
                                  color: Colors.lightBlue[400],
                                  fontWeight: FontWeight.bold)),
                          Container(height: 5),
                          Text(time,
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey[400])),
                        ],
                      )
                    ],
                  ),
                  Container(height: 10),
                  Text(content,
                      style: MyText.caption(context)!
                          .copyWith(color: Colors.grey[600])),
                  Container(height: 10),
                  Image.asset(Img.get(postImage),
                      height: 140, width: double.infinity, fit: BoxFit.cover),
                ],
              ),
            ),
          ),
        ),
        Container(width: 5),
      ],
    );
  }
}
