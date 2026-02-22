import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class TimelineTwitter extends StatefulWidget {
  TimelineTwitter();

  @override
  TimelineTwitterState createState() => new TimelineTwitterState();
}

class TimelineTwitterState extends State<TimelineTwitter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        heroTag: "fab3",
        backgroundColor: Colors.green[500],
        elevation: 3,
        child: Icon(Icons.create, color: Colors.white),
        onPressed: () {
          print('Clicked');
        },
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
              backgroundColor: Colors.white,
              elevation: 2,
              title: Text("Twitter",
                  style:
                      MyText.title(context)!.copyWith(color: MyColors.grey_80)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: Colors.green[500]),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search_rounded, color: Colors.green[500]),
                  onPressed: () {},
                )
              ]),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(height: 0, color: Colors.lightGreenAccent),
                    buildTweetItem(
                      image: Img.get('image_001.png'),
                      username: "Victoria W.",
                      handle: "@VictoriaW",
                      time: "1m",
                      text:
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                    ),
                    Divider(height: 0, color: Colors.lightGreenAccent),
                    buildTweetItem(
                      image: Img.get('image_002.png'),
                      username: "Oliver T.",
                      handle: "@OliverT",
                      time: "2m",
                      text:
                          "Pellentesque habitant morbi tristique senectus et netus.",
                    ),
                    Divider(height: 0, color: Colors.lightGreenAccent),
                    buildTweetItem(
                      image: Img.get('image_004.png'),
                      username: "Charlotte P.",
                      handle: "@CharlotteP",
                      time: "4m",
                      text: "Phasellus viverra nulla ut metus varius laoreet.",
                    ),
                    Divider(height: 0, color: Colors.lightGreenAccent),
                    buildTweetItem(
                      image: Img.get('image_006.png'),
                      username: "Nathaniel W.",
                      handle: "@Nath",
                      time: "30m",
                      text: "Cras ultricies ligula sed magna dictum porta.",
                    ),
                    Divider(height: 0, color: Colors.lightGreenAccent),
                    buildTweetItem(
                      image: Img.get('image_007.png'),
                      username: "Homer J. Allen",
                      handle: "@Allen",
                      time: "43m",
                      text: "Nulla porttitor accumsan tincidunt.",
                    ),
                  ],
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTweetItem({
    required String image,
    required String username,
    required String handle,
    required String time,
    required String text,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(image, height: 90, width: 90, fit: BoxFit.cover),
          Container(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(username,
                        style: MyText.subhead(context)!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    Text(" $handle $time",
                        style: MyText.body1(context)!
                            .copyWith(color: MyColors.grey_40)),
                    Spacer(),
                    Icon(Icons.expand_more, color: MyColors.grey_40, size: 20),
                  ],
                ),
                Text(text,
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w300)),
                Container(height: 15),
                Row(
                  children: <Widget>[
                    Icon(Icons.undo, color: MyColors.grey_40, size: 15),
                    Text(" 1",
                        style: MyText.body1(context)!
                            .copyWith(color: MyColors.grey_40)),
                    Spacer(),
                    Icon(Icons.repeat, color: MyColors.grey_40, size: 15),
                    Text(" 5",
                        style: MyText.body1(context)!
                            .copyWith(color: MyColors.grey_40)),
                    Spacer(),
                    Icon(Icons.favorite, color: MyColors.grey_40, size: 15),
                    Text(" 10",
                        style: MyText.body1(context)!
                            .copyWith(color: MyColors.grey_40)),
                    Spacer(),
                    Icon(Icons.chat, color: MyColors.grey_40, size: 15),
                    Spacer(),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildTweetItemWithImage({
    required String image,
    required String username,
    required String handle,
    required String time,
    required String text,
    required String postImage,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(image, height: 50, width: 50, fit: BoxFit.cover),
          Container(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(username,
                        style: MyText.subhead(context)!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    Text(" $handle $time",
                        style: MyText.body1(context)!
                            .copyWith(color: MyColors.grey_40)),
                    Spacer(),
                    Icon(Icons.expand_more, color: MyColors.grey_40, size: 20),
                  ],
                ),
                Text(text,
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w300)),
                Container(height: 10),
                Image.asset(postImage,
                    height: 200, width: double.infinity, fit: BoxFit.cover),
                Container(height: 15),
                Row(
                  children: <Widget>[
                    Icon(Icons.undo, color: MyColors.grey_40, size: 15),
                    Text(" 3k",
                        style: MyText.body1(context)!
                            .copyWith(color: MyColors.grey_40)),
                    Spacer(),
                    Icon(Icons.repeat, color: MyColors.grey_40, size: 15),
                    Text(" 55",
                        style: MyText.body1(context)!
                            .copyWith(color: MyColors.grey_40)),
                    Spacer(),
                    Icon(Icons.favorite, color: MyColors.grey_40, size: 15),
                    Text(" 75",
                        style: MyText.body1(context)!
                            .copyWith(color: MyColors.grey_40)),
                    Spacer(),
                    Icon(Icons.chat, color: MyColors.grey_40, size: 15),
                    Spacer(),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
