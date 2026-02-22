import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class MotionFabViewRoute extends StatefulWidget {
  MotionFabViewRoute();

  @override
  MotionFabViewRouteState createState() => new MotionFabViewRouteState();
}

class MotionFabViewRouteState extends State<MotionFabViewRoute> {
  static const List<Map<String, dynamic>> items = [
    {"name": "Share", "icon": Icons.share_rounded},
    {"name": "Download", "icon": Icons.download_rounded},
    {"name": "Review", "icon": Icons.rate_review_rounded},
    {"name": "Upload", "icon": Icons.upload_rounded},
    {"name": "Comment", "icon": Icons.comment_rounded},
  ];

  bool slow = true;
  bool transform = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          backgroundColor: Colors.white,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          titleSpacing: 0,
          iconTheme: IconThemeData(color: MyColors.grey_60),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.email),
              onPressed: () {},
            ),
            PopupMenuButton<String>(
              onSelected: (String value) {},
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "Settings",
                  child: Text("Settings"),
                ),
              ],
            )
          ]),
      body: new Builder(builder: (BuildContext context) {
        return Container(
          alignment: Alignment.center,
          child: Text(
            "Please click\nbutton below",
            textAlign: TextAlign.center,
            style: MyText.display1(context)!.copyWith(
              color: MyColors.grey_40,
            ),
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: transform
                ? SizedBox()
                : Container(
                    margin: EdgeInsets.all(10),
                    child: FloatingActionButton(
                      heroTag: "fab",
                      backgroundColor: Colors.lime[800],
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      elevation: 3,
                      onPressed: () {
                        setState(() {
                          transform = !transform;
                        });
                      },
                    ),
                  ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                  child: child,
                  scale: animation,
                  alignment: Alignment.bottomRight);
            },
            child: !transform
                ? SizedBox()
                : Container(
                    width: 210,
                    margin: EdgeInsets.all(20),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: items
                              .map((item) => InkWell(
                                    highlightColor:
                                        Colors.black.withOpacity(0.1),
                                    splashColor: Colors.black.withOpacity(0.1),
                                    onTap: () {
                                      setState(() {
                                        transform = !transform;
                                      });
                                    },
                                    child: Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 15),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.limeAccent,
                                            child: Icon(
                                              item['icon'],
                                              size: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Text(item['name'],
                                              style: MyText.medium(context)
                                                  .copyWith(
                                                color: MyColors.grey_80,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
