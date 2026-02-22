import 'package:flutter/material.dart';
import '../../data/my_colors.dart';
import '../../widgets/my_text.dart';

class DialogAboutProject extends StatefulWidget {
  @override
  DialogAboutProjectState createState() => new DialogAboutProjectState();
}

class DialogAboutProjectState extends State<DialogAboutProject> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 310,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.green),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Spacer(),
                  ],
                ),
                Container(height: 80),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Get in touch if you\nneed help with a\nproject",
                        textAlign: TextAlign.left,
                        style: MyText.headline(context)!.copyWith(
                            color: MyColors.grey_80,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(height: 50),
                      Text(
                        "London, Paris\n1234 Example Street\nDummy Address",
                        textAlign: TextAlign.start,
                        style: MyText.body1(context)!
                            .copyWith(color: MyColors.grey_40, height: 1.5),
                      ),
                      Container(height: 35),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "boltuix@gmail.com\n0818-725-8539",
                              textAlign: TextAlign.start,
                              style: MyText.body1(context)!.copyWith(
                                  color: MyColors.grey_40, height: 1.5),
                            ),
                          ),
                          FloatingActionButton(
                            heroTag: null,
                            backgroundColor: Colors.green,
                            mini: true,
                            elevation: 0,
                            child: Icon(Icons.email, color: Colors.white),
                            onPressed: () {
                              print('Email clicked');
                            },
                          ),
                          FloatingActionButton(
                            heroTag: null,
                            backgroundColor: Colors.green,
                            mini: true,
                            elevation: 0,
                            child: Icon(Icons.phone, color: Colors.white),
                            onPressed: () {
                              print('Phone clicked');
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
