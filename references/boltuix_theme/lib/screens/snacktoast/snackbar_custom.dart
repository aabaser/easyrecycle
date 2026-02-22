import 'package:flutter/material.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/toolbar.dart';

class SnackbarCustomRoute extends StatefulWidget {
  SnackbarCustomRoute();

  @override
  SnackbarCustomRouteState createState() => new SnackbarCustomRouteState();
}

class SnackbarCustomRouteState extends State<SnackbarCustomRoute> {
  late BuildContext _scaffoldCtx;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: MyColors.grey_5,
      appBar: CommonAppBar.getPrimarySettingAppbar(context, "Snackbar Custom")
          as PreferredSizeWidget?,
      body: Builder(builder: (BuildContext context) {
        _scaffoldCtx = context;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 50,
                child: InkWell(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Primary Color",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500)),
                  ),
                  onTap: () {
                    onMenuClicked("Primary Color");
                  },
                ),
              ),
              Divider(color: Colors.grey[400], height: 0, thickness: 0.5),
              Container(
                width: double.infinity,
                height: 50,
                child: InkWell(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Card Light",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500)),
                  ),
                  onTap: () {
                    onMenuClicked("Card Light");
                  },
                ),
              ),
              Divider(color: Colors.grey[400], height: 0, thickness: 0.5),
              Container(
                width: double.infinity,
                height: 50,
                child: InkWell(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Card Image",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500)),
                  ),
                  onTap: () {
                    onMenuClicked("Card Image");
                  },
                ),
              ),
              Divider(color: Colors.grey[400], height: 0, thickness: 0.5),
              Container(
                width: double.infinity,
                height: 50,
                child: InkWell(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Icon Error",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500)),
                  ),
                  onTap: () {
                    onMenuClicked("Icon Error");
                  },
                ),
              ),
              Divider(color: Colors.grey[400], height: 0, thickness: 0.5),
              Container(
                width: double.infinity,
                height: 50,
                child: InkWell(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Icon Success",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500)),
                  ),
                  onTap: () {
                    onMenuClicked("Icon Success");
                  },
                ),
              ),
              Divider(color: Colors.grey[400], height: 0, thickness: 0.5),
              Container(
                width: double.infinity,
                height: 50,
                child: InkWell(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Icon Info",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500)),
                  ),
                  onTap: () {
                    onMenuClicked("Icon Info");
                  },
                ),
              ),
              Divider(color: Colors.grey[400], height: 0, thickness: 0.5),
            ],
          ),
        );
      }),
    );
  }

  void onMenuClicked(String menu) {
    if (menu == "Primary Color") {
      ScaffoldMessenger.of(_scaffoldCtx).showSnackBar(
        SnackBar(
          content: Container(
            height: 45, // Increased height
            alignment: Alignment.centerLeft,
            child: Text("Snackbar Primary", style: TextStyle(fontSize: 16)),
          ),
          backgroundColor: MyColors.primary,
          duration: Duration(seconds: 2),
        ),
      );
    } else if (menu == "Card Light") {
      ScaffoldMessenger.of(_scaffoldCtx).showSnackBar(SnackBar(
        elevation: 0,
        content: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Iphone S4O",
                        style: MyText.subhead(context)!
                            .copyWith(color: MyColors.grey_90)),
                    Text("Has Been Removed",
                        style: MyText.caption(context)!
                            .copyWith(color: MyColors.grey_40)),
                  ],
                )),
                Container(
                    color: MyColors.grey_20,
                    height: 35,
                    width: 1,
                    margin: EdgeInsets.symmetric(horizontal: 5)),
                SnackBarAction(
                    label: "UNDO",
                    textColor: MyColors.primary,
                    onPressed: () {}),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        duration: Duration(seconds: 2),
      ));
    } else if (menu == "Card Image") {
      ScaffoldMessenger.of(_scaffoldCtx).showSnackBar(SnackBar(
        elevation: 0,
        content: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Image.asset(
                  Img.get('logo_f.png'),
                  height: 40,
                  width: 40,
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Kids f kit",
                        style: MyText.subhead(context)!
                            .copyWith(color: MyColors.grey_90)),
                    Text("Added to Cart",
                        style: MyText.caption(context)!
                            .copyWith(color: MyColors.grey_40)),
                  ],
                )),
                Container(
                    color: MyColors.grey_20,
                    height: 35,
                    width: 1,
                    margin: EdgeInsets.symmetric(horizontal: 5)),
                SnackBarAction(
                    label: "UNDO",
                    textColor: MyColors.primary,
                    onPressed: () {}),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        duration: Duration(seconds: 2),
      ));
    } else if (menu == "Icon Error") {
      ScaffoldMessenger.of(_scaffoldCtx).showSnackBar(
        SnackBar(
          content: Container(
            height: 45, // Increased height
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.close, color: Colors.white, size: 24),
                SizedBox(width: 15),
                Expanded(
                    child: Text("This is Error Message",
                        style: MyText.body1(context)!
                            .copyWith(color: MyColors.grey_5))),
              ],
            ),
          ),
          backgroundColor: Colors.red[600],
          duration: Duration(seconds: 2),
        ),
      );
    } else if (menu == "Icon Success") {
      ScaffoldMessenger.of(_scaffoldCtx).showSnackBar(
        SnackBar(
          content: Container(
            height: 45, // Increased height
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.done, color: Colors.white, size: 24),
                SizedBox(width: 15),
                Expanded(
                    child: Text("Success!",
                        style: MyText.body1(context)!
                            .copyWith(color: MyColors.grey_5))),
              ],
            ),
          ),
          backgroundColor: Colors.green[500],
          duration: Duration(seconds: 2),
        ),
      );
    } else if (menu == "Icon Info") {
      ScaffoldMessenger.of(_scaffoldCtx).showSnackBar(
        SnackBar(
          content: Container(
            height: 45, // Increased height
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.error_outline, color: Colors.white, size: 24),
                SizedBox(width: 15),
                Expanded(
                    child: Text("Some Info Text Here",
                        style: MyText.body1(context)!
                            .copyWith(color: MyColors.grey_5))),
              ],
            ),
          ),
          backgroundColor: Colors.blue[500],
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
