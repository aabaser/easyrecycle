import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/circle_image.dart';
import 'package:boltuix/widgets/my_text.dart';

class ArticleMedium extends StatefulWidget {
  ArticleMedium();

  @override
  ArticleMediumState createState() => new ArticleMediumState();
}

class ArticleMediumState extends State<ArticleMedium> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.grey_5,
      floatingActionButton: FloatingActionButton(
        heroTag: "fab1",
        backgroundColor: Colors.white,
        elevation: 3,
        child: Icon(Icons.thumb_up, color: Colors.grey[900]),
        onPressed: () {
          print('Clicked');
        },
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
            ),
            backgroundColor: MyColors.grey_10,
            floating: true,
            pinned: false,
            snap: false,
            title: Row(
              children: <Widget>[
                CircleImage(
                  imageProvider: AssetImage(
                    Img.get('b_image_5.png'),
                  ),
                  size: 40,
                ),
                Container(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("John Smith",
                        style: MyText.body2(context)!
                            .copyWith(color: MyColors.grey_80)),
                    Container(height: 2),
                    Row(
                      children: <Widget>[
                        Text("Jul 13",
                            style: MyText.caption(context)!
                                .copyWith(color: MyColors.grey_60)),
                        Container(
                          width: 6,
                          height: 6,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: MyColors.grey_40,
                              borderRadius: BorderRadius.circular(15.0)),
                        ),
                        Text("5 min read",
                            style: MyText.caption(context)!
                                .copyWith(color: MyColors.grey_60)),
                      ],
                    ),
                  ],
                )
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: MyColors.grey_60),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.share, color: MyColors.grey_60),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.bookmark_border, color: MyColors.grey_60),
                  onPressed: () {}),
            ],
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("3 Cute Apple PC Family Store",
                          style: MyText.medium(context).copyWith(
                              color: MyColors.grey_90,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(height: 5),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                          "Discover the charm and innovation of Apple's family of PCs.",
                          style: MyText.body1(context)!
                              .copyWith(color: MyColors.grey_40)),
                    ),
                    Container(height: 20),
                    Container(
                      child: Image.asset(Img.get('bg_image1.jpg'),
                          fit: BoxFit.cover),
                      width: double.infinity,
                      height: 250,
                    ),
                    Container(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Apple has always been at the forefront of technology, and their PC family store is no exception. "
                        "From the sleek design of the iMac to the powerful performance of the Mac Pro, each member of the Apple PC family offers something unique. "
                        "The MacBook series, known for its portability and efficiency, is perfect for those on the go. "
                        "Whether you're a professional looking for a robust machine or a student needing a reliable laptop, Apple has got you covered.",
                        textAlign: TextAlign.justify,
                        style: MyText.body1(context)
                            ?.copyWith(color: MyColors.grey_80),
                      ),
                    ),
                    Container(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "One of the highlights of the Apple PC family store is the customer service experience. "
                        "Knowledgeable staff are always on hand to provide personalized advice and support, ensuring you find the perfect PC to meet your needs. "
                        "With a focus on innovation and user experience, Apple continues to set the standard in the tech industry.",
                        textAlign: TextAlign.justify,
                        style: MyText.body1(context)
                            ?.copyWith(color: MyColors.grey_80),
                      ),
                    ),
                    Container(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Visit your nearest Apple PC family store today to explore the latest models and take advantage of exclusive deals. "
                        "Experience the future of computing with Apple, where technology meets style and functionality.",
                        textAlign: TextAlign.justify,
                        style: MyText.body1(context)
                            ?.copyWith(color: MyColors.grey_80),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(width: 15),
                          Text("3,556 Likes",
                              textAlign: TextAlign.center,
                              style: MyText.body2(context)!
                                  .copyWith(color: MyColors.grey_80)),
                          Spacer(),
                          IconButton(
                              icon: const Icon(Icons.more_vert_rounded,
                                  color: MyColors.grey_60),
                              onPressed: () {}),
                        ],
                      ),
                    ),
                    Container(height: 50),
                  ],
                ),
              );
            }, childCount: 1),
          )
        ],
      ),
    );
  }
}
