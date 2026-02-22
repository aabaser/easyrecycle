import 'package:flutter/material.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_strings.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/star_rating.dart';
import 'package:boltuix/widgets/toolbar.dart';

class SliderImageHeader extends StatefulWidget {
  SliderImageHeader();

  @override
  SliderImageHeaderState createState() => new SliderImageHeaderState();
}

class SliderImageHeaderState extends State<SliderImageHeader> {
  int page = 0;
  static const int MAX = 5;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[200],
      appBar:
          CommonAppBar.getPrimarySettingAppbar(context, "Header slider image")
              as PreferredSizeWidget?,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              elevation: 2,
              margin: EdgeInsets.all(0),
              child: Container(
                height: 280,
                child: Stack(
                  children: <Widget>[
                    PageView(
                      children: <Widget>[
                        Image.asset(Img.get('image_001.png'),
                            fit: BoxFit.cover),
                        Image.asset(Img.get('image_002.png'),
                            fit: BoxFit.cover),
                        Image.asset(Img.get('image_003.png'),
                            fit: BoxFit.cover),
                      ],
                      onPageChanged: onPageViewChange,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Colors.black.withOpacity(0.0),
                              Colors.black.withOpacity(0.5)
                            ])),
                        child: Align(
                          alignment: Alignment.center,
                          child: buildDots(context),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 2,
              margin: EdgeInsets.fromLTRB(20, 15, 20, 10),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Buy 3d Cute toys",
                        style: MyText.headline(context)!
                            .copyWith(color: Colors.grey[900])),
                    Container(height: 5),
                    Text("Shop Anything",
                        style: MyText.subhead(context)!
                            .copyWith(color: Colors.grey[600])),
                    Container(height: 20),
                    Row(
                      children: <Widget>[
                        StarRating(
                            starCount: 5,
                            rating: 3.5,
                            color: Colors.green,
                            size: 18),
                        Container(width: 5),
                        Text("500,547",
                            style: MyText.caption(context)!
                                .copyWith(color: Colors.grey[400])),
                        Spacer(),
                        Text("\$ 92.00",
                            style: MyText.headline(context)!.copyWith(
                                color: Colors.lightGreen[700],
                                fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 2,
              margin: EdgeInsets.fromLTRB(20, 10, 20, 15),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Description",
                        style: MyText.headline(context)!
                            .copyWith(color: Colors.grey[900])),
                    Container(height: 5),
                    Text(MyStrings.very_long_lorem_ipsum,
                        textAlign: TextAlign.justify,
                        style: MyText.subhead(context)!
                            .copyWith(color: Colors.grey[600])),
                    Container(height: 20),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onPageViewChange(int _page) {
    page = _page;
    setState(() {});
  }

  Widget buildDots(BuildContext context) {
    Widget widget;

    List<Widget> dots = [];
    for (int i = 0; i < MAX; i++) {
      Widget w = Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: 8,
        width: 8,
        child: CircleAvatar(
          backgroundColor: page == i ? Colors.green : Colors.grey[100],
        ),
      );
      dots.add(w);
    }
    widget = Row(
      mainAxisSize: MainAxisSize.min,
      children: dots,
    );
    return widget;
  }
}
