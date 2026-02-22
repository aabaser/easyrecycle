import 'package:flutter/material.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/star_rating.dart';
import 'package:boltuix/widgets/toolbar.dart';

class CardDivider extends StatefulWidget {
  CardDivider();

  @override
  CardDividerState createState() => new CardDividerState();
}

class CardDividerState extends State<CardDivider> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: MyColors.grey_5,
      appBar: CommonAppBar.getPrimarySettingAppbar(context, "Divider")
          as PreferredSizeWidget?,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 35, left: 25, right: 25),
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15)), // Updated borderRadius
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    Img.get('image_001.png'), // Updated image
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Your title goes here", // Updated title
                          style: MyText.headline(context)!
                              .copyWith(color: MyColors.grey_80),
                        ),
                        Container(height: 5),
                        Row(
                          children: <Widget>[
                            StarRating(
                                starCount: 5,
                                rating: 4.5,
                                color: Colors.yellow,
                                size: 18), // Placeholder rating
                            Container(width: 5),
                            Text(
                              "4.5 (20)", // Placeholder rating
                              style: MyText.body1(context)!
                                  .copyWith(color: MyColors.grey_60),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Subtitle goes here", // Updated subtitle
                            style: MyText.medium(context)
                                .copyWith(color: MyColors.grey_80),
                          ),
                        ),
                        Container(
                          child: Text(
                            "This is a description. Replace this with general placeholder content.",
                            style: MyText.subhead(context)!
                                .copyWith(color: MyColors.grey_40),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(height: 0, color: Colors.lightGreenAccent),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Availability", // Updated title
                          style: MyText.medium(context)
                              .copyWith(color: MyColors.grey_80),
                        ),
                        Container(height: 5),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                              ),
                              child: Text("5:30PM",
                                  style: TextStyle(color: MyColors.grey_60)),
                              onPressed: () {},
                            ),
                            Container(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                              ),
                              child: Text("7:30PM",
                                  style: TextStyle(color: MyColors.grey_60)),
                              onPressed: () {},
                            ),
                            Container(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                              ),
                              child: Text("8:00PM",
                                  style: TextStyle(color: MyColors.grey_60)),
                              onPressed: () {},
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.transparent),
                      child: Text(
                        "RESERVE",
                        style: TextStyle(color: MyColors.primary),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Container(height: 5)
                ],
              ),
            ),
            Container(height: 10),
          ],
        ),
      ),
    );
  }
}
