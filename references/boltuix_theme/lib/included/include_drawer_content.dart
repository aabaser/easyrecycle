import 'package:flutter/material.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_strings.dart';
import 'package:boltuix/widgets/my_text.dart';

class IncludeDrawerContent {
  static List<String> imagesPlaces = [
    "image_001.png",
    "image_002.png",
    "image_004.png",
    "image_005.png",
    "image_006.png",
    "image_007.png",
  ];
  static List<String> titlePlaces = [
    "Exploring the Beauty of Serene Landscapes",
    "Unveiling Hidden Gems in Urban Jungles",
    "A Journey Through Time and Culture",
    "Marvels of Modern Architecture and Design",
    "Captivating Sunsets Over Scenic Horizons",
    "Discovering Tranquility in Nature's Lap",
    "Captivating Sunrise Over Scenic Horizons",
  ];

  static Widget get(BuildContext context) {
    Widget widget;
    List<Widget> items = [];
    for (int i = 0; i < imagesPlaces.length; i++) {
      Widget w = Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(12.0), // Set corner radius
                  child: Image.asset(
                    Img.get(imagesPlaces[i]),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        titlePlaces[i],
                        style: MyText.medium(context).copyWith(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(height: 5),
                      Text(
                        "22 Feb 2024",
                        style: MyText.body1(context)!.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                      Container(height: 5),
                      Text(
                        MyStrings.lorem_ipsum,
                        maxLines: 2,
                        style: MyText.subhead(context)!.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0, color: Colors.grey[300], thickness: 0.5)
        ],
      );
      items.add(w);
    }

    widget = SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: items,
      ),
    );
    return widget;
  }
}
