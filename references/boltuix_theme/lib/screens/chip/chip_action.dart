import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/my_toast.dart';

class ChipAction extends StatefulWidget {
  ChipAction();

  @override
  ChipActionState createState() => ChipActionState();
}

class ChipActionState extends State<ChipAction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        title: Text("Morning Overview"),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded), // Updated to _rounded variant
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 15, left: 10, right: 10),
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15), // Updated border radius
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Changed Image
                  Image.asset(
                    Img.get('image_003.png'),
                    height: 320,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(height: 5),
                        Text(
                          "Good Morning, Start Fresh!",
                          style: MyText.display1(context)!
                              .copyWith(color: MyColors.grey_80),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(height: 5),
                        Text(
                          "Tuesday, 7:30 AM, Bright and Sunny",
                          style: MyText.subhead(context)!
                              .copyWith(color: MyColors.grey_40),
                        ),
                        Container(height: 20),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons
                                  .wb_sunny_rounded, // Updated to _rounded variant
                              color: Colors.green,
                              size: 30,
                            ),
                            Container(width: 5),
                            Text(
                              "72 \u2109",
                              style: MyText.subhead(context)!
                                  .copyWith(color: MyColors.grey_60),
                            ),
                            Text(
                              "/ 22 \u2103",
                              style: MyText.subhead(context)!
                                  .copyWith(color: MyColors.grey_40),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ChoiceChip(
                            avatar: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(Icons.lightbulb_rounded,
                                  size: 22,
                                  color: Colors.green), // Updated icon color
                            ),
                            label: Text("Turn on lights"),
                            padding: EdgeInsets.only(right: 10, left: 5),
                            visualDensity: VisualDensity(
                                vertical: VisualDensity.maximumDensity),
                            selected: false,
                            labelPadding: EdgeInsets.symmetric(horizontal: 10),
                            labelStyle: TextStyle(
                                color: Colors.green, // Updated text color
                                fontWeight: FontWeight.w500),
                            backgroundColor:
                                Colors.white, // Updated background color
                            pressElevation: 1,
                            selectedColor: Colors.lightGreenAccent,
                            onSelected: (bool selected) {
                              onItemClick("Turn on lights");
                            },
                          ),
                          Container(width: 10),
                          ChoiceChip(
                            avatar: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(Icons.alarm_rounded,
                                  size: 22,
                                  color: Colors.green), // Updated icon color
                            ),
                            label: Text("Set alarm"),
                            padding: EdgeInsets.only(right: 10, left: 5),
                            visualDensity: VisualDensity(
                                vertical: VisualDensity.maximumDensity),
                            selected: false,
                            labelPadding: EdgeInsets.symmetric(horizontal: 10),
                            labelStyle: TextStyle(
                                color: Colors.green, // Updated text color
                                fontWeight: FontWeight.w500),
                            backgroundColor:
                                Colors.white, // Updated background color
                            pressElevation: 1,
                            selectedColor: Colors.lightGreenAccent,
                            onSelected: (bool selected) {
                              onItemClick("Set alarm");
                            },
                          ),
                          Container(width: 10),
                          ChoiceChip(
                            avatar: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(Icons.menu_rounded,
                                  size: 22,
                                  color: Colors.green), // Updated icon color
                            ),
                            label: Text("Clear Task"),
                            padding: EdgeInsets.only(right: 10, left: 5),
                            visualDensity: VisualDensity(
                                vertical: VisualDensity.maximumDensity),
                            selected: false,
                            labelPadding: EdgeInsets.symmetric(horizontal: 10),
                            labelStyle: TextStyle(
                                color: Colors.green, // Updated text color
                                fontWeight: FontWeight.w500),
                            backgroundColor:
                                Colors.white, // Updated background color
                            pressElevation: 1,
                            selectedColor: Colors.lightGreenAccent,
                            onSelected: (bool selected) {
                              onItemClick("Clear Task");
                            },
                          ),
                          Container(width: 10),
                          ChoiceChip(
                            avatar: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(Icons.edit_rounded,
                                  size: 22,
                                  color: Colors.green), // Updated icon color
                            ),
                            label: Text("Edit Reminder"),
                            padding: EdgeInsets.only(right: 10, left: 5),
                            visualDensity: VisualDensity(
                                vertical: VisualDensity.maximumDensity),
                            selected: false,
                            labelPadding: EdgeInsets.symmetric(horizontal: 10),
                            labelStyle: TextStyle(
                                color: Colors.green, // Updated text color
                                fontWeight: FontWeight.w500),
                            backgroundColor:
                                Colors.white, // Updated background color
                            pressElevation: 1,
                            selectedColor: Colors.lightGreenAccent,
                            onSelected: (bool selected) {
                              onItemClick("Edit Reminder");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(height: 10)
                ],
              ),
            ),
            Container(height: 10),
          ],
        ),
      ),
    );
  }

  void onItemClick(String name) {
    MyToast.show(name + " clicked", context, duration: MyToast.LENGTH_SHORT);
  }
}
