import 'package:flutter/material.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/data/my_strings.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/toolbar.dart';

class ButtonHighEmphasis extends StatefulWidget {
  ButtonHighEmphasis();

  @override
  ButtonHighEmphasisState createState() => new ButtonHighEmphasisState();
}

class ButtonHighEmphasisState extends State<ButtonHighEmphasis> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.grey_5,
      appBar: CommonAppBar.getPrimaryAppbar(context, "3D Airplane")
          as PreferredSizeWidget?,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            ReusableCard(
              imageUrl: Img.get('b_image_4.png'),
              category: "3D FLIGHT",
              title: "Experience 3D Flight",
              description: MyStrings.middle_lorem_ipsum,
              primaryButtonText: "VIEW ENTRY",
              secondaryButtonText: "LEARN MORE",
              onPrimaryButtonPressed: () {},
              onSecondaryButtonPressed: () {},
            ),
            Container(height: 5),
            ReusableCardWithFAB(
              imageUrl: Img.get('b_image_4.png'),
              category: "3D FLIGHT",
              title: "Special Menu",
              fabLabel: "ADD ENTRY",
              fabIcon: Icons.add,
              onFabPressed: () {
                print('Clicked');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String description;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback onPrimaryButtonPressed;
  final VoidCallback onSecondaryButtonPressed;

  ReusableCard({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.description,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.onPrimaryButtonPressed,
    required this.onSecondaryButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            imageUrl,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(category,
                    style: MyText.button(context)!
                        .copyWith(color: MyColors.grey_20)),
                Container(height: 5),
                Text(title,
                    style: MyText.headline(context)!
                        .copyWith(color: MyColors.grey_80)),
                Container(height: 15),
                Text(description,
                    style: TextStyle(fontSize: 15, color: Colors.grey[600])),
                Container(height: 10),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: onPrimaryButtonPressed,
                      child: Text(primaryButtonText,
                          style: MyText.button(context)!
                              .copyWith(color: MyColors.primary)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: MyColors.primary),
                      ),
                    ),
                    Container(width: 10),
                    TextButton(
                      onPressed: onSecondaryButtonPressed,
                      child: Text(secondaryButtonText,
                          style: MyText.button(context)!
                              .copyWith(color: MyColors.primary)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReusableCardWithFAB extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String fabLabel;
  final IconData fabIcon;
  final VoidCallback onFabPressed;

  ReusableCardWithFAB({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.fabLabel,
    required this.fabIcon,
    required this.onFabPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.lightGreenAccent.withOpacity(0.2),
                      Colors.greenAccent.withOpacity(0.1)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              FloatingActionButton.extended(
                heroTag: "fab1",
                backgroundColor: MyColors.primary,
                label: Text(fabLabel),
                icon: Icon(fabIcon, color: Colors.white),
                onPressed: onFabPressed,
              )
            ],
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(category,
                    style: MyText.button(context)!
                        .copyWith(color: MyColors.grey_20)),
                Container(height: 5),
                Text(title,
                    style: MyText.headline(context)!
                        .copyWith(color: MyColors.grey_80)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
