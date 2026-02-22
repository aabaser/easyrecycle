import 'package:flutter/material.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/data/my_strings.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/toolbar.dart';

class ButtonTextLabel extends StatefulWidget {
  ButtonTextLabel();

  @override
  ButtonTextLabelState createState() => new ButtonTextLabelState();
}

class ButtonTextLabelState extends State<ButtonTextLabel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.grey_5,
      appBar: CommonAppBar.getPrimaryAppbar(context, "Placement")
          as PreferredSizeWidget?,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ReusableCard(
              imageUrl: Img.get('b_image_6.png'),
              category: "3D FLIGHT",
              title: "Experience 3D Flight",
              description: MyStrings.short_lorem_ipsum,
              avatarUrl: Img.get("b_image_5.png"),
              buttonText: "LEARN MORE",
              onButtonPressed: () {
                // Add your button action here
              },
            ),
            // Add more ReusableCard widgets if needed
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
  final String avatarUrl;
  final String buttonText;
  final VoidCallback onButtonPressed;

  ReusableCard({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.description,
    required this.avatarUrl,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.all(15),
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
            padding: EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category,
                            style: MyText.button(context)!
                                .copyWith(color: MyColors.grey_20)),
                        Text(title,
                            style: MyText.headline(context)!
                                .copyWith(color: MyColors.grey_80)),
                      ],
                    ),
                    Spacer(),
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(avatarUrl),
                    )
                  ],
                ),
                Container(height: 15),
                Text(description,
                    style: TextStyle(fontSize: 17, color: MyColors.grey_40)),
                Row(
                  children: [
                    Spacer(),
                    TextButton(
                      onPressed: onButtonPressed,
                      child: Text(buttonText,
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
