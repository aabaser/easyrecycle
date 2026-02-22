import 'package:flutter/material.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/star_rating.dart';

class BottomSheetFloatingAppRating extends StatefulWidget {
  BottomSheetFloatingAppRating();

  @override
  BottomSheetFloatingAppRatingState createState() =>
      new BottomSheetFloatingAppRatingState();
}

class BottomSheetFloatingAppRatingState
    extends State<BottomSheetFloatingAppRating> {
  late PersistentBottomSheetController sheetController;
  late BuildContext _scaffoldCtx;
  bool showSheet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.grey_20,
      appBar: AppBar(
        title: Text("App Rating", style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Builder(builder: (BuildContext ctx) {
        _scaffoldCtx = ctx;
        return Center(
          child: showSheet
              ? Container()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FloatingActionButton(
                        heroTag: "fab",
                        backgroundColor: Colors.green[500],
                        elevation: 3,
                        child: Icon(
                          Icons.star_rate_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            showSheet = !showSheet;
                            if (showSheet) {
                              _showSheet();
                            } else {
                              Navigator.pop(_scaffoldCtx);
                            }
                          });
                        }),
                    Container(height: 20),
                    Text("Rate our app",
                        textAlign: TextAlign.center,
                        style: MyText.display1(context)!
                            .copyWith(color: Colors.grey[600])),
                  ],
                ),
        );
      }),
    );
  }

  void _showSheet() {
    sheetController = showBottomSheet(
        context: _scaffoldCtx,
        builder: (BuildContext bc) {
          return Card(
            //elevation: 5, margin: EdgeInsets.all(10),
            child: Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("App Rating",
                                  style: MyText.title(context)!
                                      .copyWith(color: Colors.grey[800])),
                              Text("We value your feedback",
                                  style: MyText.caption(context)!
                                      .copyWith(color: Colors.grey[600]))
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.grey[600]),
                          onPressed: () {
                            sheetController.close();
                          },
                        ),
                      ],
                    ),
                    Container(height: 10),
                    Divider(height: 0, color: Colors.lightGreenAccent),
                    Container(height: 10),
                    Text("How would you rate your experience with our app?",
                        style: MyText.subhead(context)!
                            .copyWith(color: Colors.grey[800])),
                    Container(height: 10),
                    Row(
                      children: <Widget>[
                        Spacer(),
                        StarRating(
                            starCount: 5,
                            rating: 0,
                            color: Colors.orange[300],
                            size: 40),
                        Spacer()
                      ],
                    ),
                    Container(height: 10),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            backgroundColor: MyColors.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0)),
                            elevation: 0),
                        child: Text("SUBMIT RATING",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          // Handle submit rating action
                        },
                      ),
                    ),
                  ],
                )),
          );
        });
    sheetController.closed.then((value) {
      setState(() {
        showSheet = false;
      });
    });
  }
}
