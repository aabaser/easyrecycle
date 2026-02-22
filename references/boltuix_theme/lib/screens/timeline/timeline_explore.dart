import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/circle_image.dart';
import 'package:boltuix/widgets/my_text.dart';

class TimelineExplore extends StatefulWidget {
  TimelineExplore();

  @override
  TimelineExploreState createState() => new TimelineExploreState();
}

class TimelineExploreState extends State<TimelineExplore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
            ),
            backgroundColor: Colors.white,
            elevation: 2,
            title: Text(
              "Explore",
              style: MyText.title(context)!.copyWith(color: MyColors.grey_80),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: MyColors.grey_80),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search_rounded, color: MyColors.grey_80),
                onPressed: () {},
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          Container(width: 18),
                          Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 30,
                              )),
                          Container(width: 18),
                          CircleImage(
                              imageProvider: AssetImage(Img.get('user_1.png')),
                              size: 60),
                          Container(width: 18),
                          CircleImage(
                              imageProvider: AssetImage(Img.get('user_2.png')),
                              size: 60),
                          Container(width: 18),
                          CircleImage(
                              imageProvider: AssetImage(Img.get('user_3.png')),
                              size: 60),
                          Container(width: 18),
                          CircleImage(
                              imageProvider: AssetImage(Img.get('user_4.png')),
                              size: 60),
                          Container(width: 18),
                          CircleImage(
                              imageProvider: AssetImage(Img.get('user_5.png')),
                              size: 60),
                          Container(width: 18),
                          CircleImage(
                              imageProvider: AssetImage(Img.get('user_6.png')),
                              size: 60),
                          Container(width: 18),
                        ],
                      ),
                    ),
                    Container(height: 18),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        // Adjust the number of items per row based on screen width
                        int itemsPerRow = constraints.maxWidth > 600 ? 3 : 2;
                        return buildGrid(itemsPerRow);
                      },
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

  Widget buildGrid(int itemsPerRow) {
    List<String> images = [
      'image_001.png',
      'image_002.png',
      'image_004.png',
      'image_005.png',
      'image_006.png',
      'image_007.png',
    ];

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemsPerRow,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: 1, // Adjust aspect ratio if needed
      ),
      itemCount: images.length,
      padding: EdgeInsets.symmetric(horizontal: 18),
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 0,
          child: Container(
            color: MyColors.grey_5,
            child: Image.asset(
              Img.get(images[index]),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
