import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class ToolbarBottomBasic extends StatefulWidget {
  ToolbarBottomBasic();

  @override
  ToolbarBottomBasicState createState() => new ToolbarBottomBasicState();
}

class ToolbarBottomBasicState extends State<ToolbarBottomBasic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text("Bottom toolbar basic",
            textAlign: TextAlign.center,
            style: MyText.title(context)!.copyWith(
              color: MyColors.grey_40,
            )),
      ),
      bottomNavigationBar: BottomAppBar(
        color: MyColors.primary,
        child: Container(
          height: kToolbarHeight,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.search_rounded, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.more_vert_rounded, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
