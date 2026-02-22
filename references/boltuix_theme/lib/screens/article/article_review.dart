import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/data/my_strings.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/star_rating.dart';

class ArticleReview extends StatefulWidget {
  ArticleReview();

  @override
  ArticleReviewState createState() => new ArticleReviewState();
}

class ArticleReviewState extends State<ArticleReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        centerTitle: true,
        title: Text(
          "Toy Review",
          style: MyText.subhead(context)!
              .copyWith(color: MyColors.grey_80, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: MyColors.grey_80),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search_rounded, color: MyColors.grey_80),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 250,
              width: double.infinity,
              child: Image.asset(Img.get('b_image_7.png'), fit: BoxFit.cover),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              transform: Matrix4.translationValues(0.0, -70.0, 0.0),
              child: ReusableContentCard(
                title: "Cute Toy Headset",
                subtitle: "For Kids",
                description1:
                    "This toy headset is perfect for kids who love to play pretend. It's designed to be durable and fun.",
                description2:
                    "With vibrant colors and realistic features, this toy headset will keep your child entertained for hours.",
                longDescription: MyStrings.long_lorem_ipsum +
                    "\n\n" +
                    MyStrings.long_lorem_ipsum_2,
                onFavoritePressed: () {},
              ),
            ),
            Container(
              transform: Matrix4.translationValues(0.0, -50.0, 0.0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableCard(
                      title: "Specifications",
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• Durable plastic material",
                              style: MyText.body1(context)!
                                  .copyWith(color: MyColors.grey_60)),
                          Text("• Suitable for ages 3 and up",
                              style: MyText.body1(context)!
                                  .copyWith(color: MyColors.grey_60)),
                          Text("• Includes a microphone for interactive play",
                              style: MyText.body1(context)!
                                  .copyWith(color: MyColors.grey_60)),
                          Text("• Vibrant colors and realistic features",
                              style: MyText.body1(context)!
                                  .copyWith(color: MyColors.grey_60)),
                          Text("• Lightweight and easy to handle",
                              style: MyText.body1(context)!
                                  .copyWith(color: MyColors.grey_60)),
                          Text("• Battery operated for extended play",
                              style: MyText.body1(context)!
                                  .copyWith(color: MyColors.grey_60)),
                          Text("• Adjustable headband for a comfortable fit",
                              style: MyText.body1(context)!
                                  .copyWith(color: MyColors.grey_60)),
                          Text("• High-quality sound effects",
                              style: MyText.body1(context)!
                                  .copyWith(color: MyColors.grey_60)),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    ReusableCard(
                      title: "User Reviews",
                      content: Column(
                        children: [
                          UserReview(
                            userName: "John Doe",
                            userReview:
                                "My kids love this headset! It's very durable and the colors are vibrant. Highly recommended!",
                            userRating: 4.5,
                          ),
                          UserReview(
                            userName: "Jane Smith",
                            userReview:
                                "Great toy for pretend play. The microphone adds an extra layer of fun.",
                            userRating: 4.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReusableContentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description1;
  final String description2;
  final String longDescription;
  final VoidCallback onFavoritePressed;

  const ReusableContentCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.description1,
    required this.description2,
    required this.longDescription,
    required this.onFavoritePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title,
                        style: MyText.title(context)!
                            .copyWith(color: MyColors.grey_90)),
                    Text(subtitle,
                        style: MyText.body2(context)!
                            .copyWith(color: MyColors.grey_40)),
                  ],
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [MyColors.gradient1, MyColors.gradient2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: onFavoritePressed,
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey.withOpacity(0.3)),
            Container(height: 10),
            Text("Description",
                style: MyText.medium(context).copyWith(
                    color: MyColors.grey_90, fontWeight: FontWeight.w500)),
            Container(height: 10),
            Text(description1,
                textAlign: TextAlign.justify,
                style:
                    MyText.subhead(context)!.copyWith(color: MyColors.grey_60)),
            Container(height: 15),
            Text(description2,
                textAlign: TextAlign.justify,
                style:
                    MyText.body1(context)!.copyWith(color: MyColors.grey_60)),
            Container(height: 15),
            Text(longDescription,
                textAlign: TextAlign.justify,
                style:
                    MyText.body1(context)!.copyWith(color: MyColors.grey_60)),
          ],
        ),
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  final String title;
  final Widget content;

  const ReusableCard({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 20, horizontal: 15), // Adjusted padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: MyText.medium(context).copyWith(
                    color: MyColors.grey_90, fontWeight: FontWeight.w500)),
            Container(height: 10),
            content,
          ],
        ),
      ),
    );
  }
}

class UserReview extends StatelessWidget {
  final String userName;
  final String userReview;
  final double userRating;

  const UserReview({
    Key? key,
    required this.userName,
    required this.userReview,
    required this.userRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            StarRating(
                starCount: 5,
                rating: userRating,
                color: Colors.yellow,
                size: 18),
            SizedBox(width: 5),
            Text(userRating.toString(),
                style:
                    MyText.body2(context)!.copyWith(color: MyColors.grey_60)),
          ],
        ),
        Container(height: 5),
        Text(userName,
            style: MyText.medium(context).copyWith(
                color: MyColors.grey_90, fontWeight: FontWeight.w500)),
        Container(height: 5),
        Text(userReview,
            style: MyText.body1(context)!.copyWith(color: MyColors.grey_60)),
        Container(height: 15),
        Divider(color: MyColors.primaryLight.withOpacity(0.3)),
        Container(height: 15),
      ],
    );
  }
}
