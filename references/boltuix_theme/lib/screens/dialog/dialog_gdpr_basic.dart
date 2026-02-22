import 'package:flutter/material.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/data/my_strings.dart';
import 'package:boltuix/widgets/my_text.dart';

class GdprBasicDialog extends StatefulWidget {
  GdprBasicDialog({Key? key}) : super(key: key);

  @override
  GdprBasicDialogState createState() => new GdprBasicDialogState();
}

class GdprBasicDialogState extends State<GdprBasicDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                height: 50,
                color: Colors.green[700],
                child: Text("Privacy & Policy",
                    style:
                        MyText.title(context)!.copyWith(color: Colors.white)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Text(MyStrings.gdpr_privacy_policy,
                    style: MyText.body1(context)!
                        .copyWith(color: MyColors.grey_60)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.transparent),
                    child: Text("DECLINE",
                        style: TextStyle(color: Colors.green[700])),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.transparent),
                    child: Text("ACCEPT",
                        style: TextStyle(color: Colors.green[700])),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
