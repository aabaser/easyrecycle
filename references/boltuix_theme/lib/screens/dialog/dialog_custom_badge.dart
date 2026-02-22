import 'package:flutter/material.dart';

import '../../data/img.dart';
import '../../data/my_colors.dart';
import '../../widgets/my_text.dart';

class CustomLevelDialog extends StatefulWidget {
  CustomLevelDialog({Key? key}) : super(key: key);

  @override
  CustomLevelDialogState createState() => new CustomLevelDialogState();
}

class CustomLevelDialogState extends State<CustomLevelDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 160,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Wrap(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Container(height: 50),
                    Image.asset(
                      Img.get('dialog_badge.png'),
                      fit: BoxFit.cover,
                      height: 150,
                      width: 150,
                    ),
                    Container(height: 15),
                    Text("New badge!",
                        style: MyText.title(context)!
                            .copyWith(color: Colors.black)),
                    Container(height: 10),
                    Text("You reached level 3 badge.",
                        textAlign: TextAlign.center,
                        style: MyText.subhead(context)!
                            .copyWith(color: MyColors.grey_40)),
                    Container(height: 10),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
