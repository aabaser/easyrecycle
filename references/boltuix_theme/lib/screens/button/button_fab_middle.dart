import 'package:flutter/material.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/star_rating.dart';

import '../../data/img.dart';

class ButtonFabMiddle extends StatefulWidget {
  ButtonFabMiddle();

  @override
  ButtonFabMiddleState createState() => new ButtonFabMiddleState();
}

class ButtonFabMiddleState extends State<ButtonFabMiddle> {
  PersistentBottomSheetController? sheetController;
  bool showSheet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Img.get('image_002.png')), // Background Image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground Content
          Column(
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.transparent, // Transparent AppBar
                elevation: 0,
                title: Text("FAB Middle"),
              ),
              Spacer(),
              ReusableBottomSheetContent(),
            ],
          ),
        ],
      ),
    );
  }
}

class ReusableBottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment(0.9, 1.6),
                heightFactor: 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [MyColors.gradient1, MyColors.gradient2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: FloatingActionButton(
                    onPressed: null,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    child: Icon(Icons.share_rounded),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Coffee Day",
                            style: MyText.headline(context)!
                                .copyWith(color: Colors.grey[800])),
                        Container(height: 20),
                        Row(
                          children: <Widget>[
                            StarRating(
                                starCount: 5,
                                rating: 4.7,
                                color: Colors.orange,
                                size: 18),
                            Container(width: 5),
                            Text("5.0 (1k)",
                                style: MyText.medium(context)
                                    .copyWith(color: Colors.grey[400])),
                          ],
                        ),
                        Container(height: 5),
                        Divider(
                            color: Colors.lightGreen[100],
                            height: 0,
                            thickness: 0.5),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text("5 min away",
                              style: MyText.medium(context)
                                  .copyWith(color: MyColors.primary)),
                        ),
                        Text(
                            "Central Plaza is the bustling hub of the city, filled with shops, cafes, and entertainment venues.",
                            style: MyText.body1(context)
                                ?.copyWith(color: Colors.grey[600])),
                        Container(height: 10),
                        Text("Mountain View Trail",
                            style: MyText.medium(context)
                                .copyWith(color: Colors.grey[600])),
                        Container(height: 10),
                        Text(
                            "A popular spot for hikers, Mountain View Trail offers breathtaking views of the surrounding landscape.",
                            style: MyText.body1(context)
                                ?.copyWith(color: Colors.grey[600])),
                        Container(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
