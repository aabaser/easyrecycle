import 'package:flutter/material.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/my_toast.dart';
import 'package:boltuix/widgets/toolbar.dart';

class ToastCustomRoute extends StatefulWidget {
  ToastCustomRoute();

  @override
  ToastCustomRouteState createState() => new ToastCustomRouteState();
}

class ToastCustomRouteState extends State<ToastCustomRoute> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: MyColors.grey_5,
      appBar: CommonAppBar.getPrimarySettingAppbar(context, "Toast Custom")
          as PreferredSizeWidget?,
      body: SingleChildScrollView(
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
                  child: Text("Card Light",
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500)),
                ),
                onTap: () {
                  toastCardLight();
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
                  child: Text("Card Dark",
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500)),
                ),
                onTap: () {
                  toastCardDark();
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
                  toastCardImage();
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
                  toastIconError();
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
                  toastIconSuccess();
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
                  toastIconInfo();
                },
              ),
            ),
            Divider(color: Colors.grey[400], height: 0, thickness: 0.5),
          ],
        ),
      ),
    );
  }

  void toastCardLight() {
    MyToast.showCustom(
        context,
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Card Light",
                    style: MyText.subhead(context)!
                        .copyWith(color: MyColors.grey_90)),
                Text("This is a card light toast.",
                    style: MyText.caption(context)!
                        .copyWith(color: MyColors.grey_40)),
              ],
            ),
          ),
        ));
  }

  void toastCardDark() {
    MyToast.showCustom(
        context,
        Card(
          color: MyColors.grey_90,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Card Dark",
                    style: MyText.subhead(context)!
                        .copyWith(color: MyColors.grey_5)),
                Text("This is a card dark toast.",
                    style: MyText.caption(context)!
                        .copyWith(color: MyColors.grey_40)),
              ],
            ),
          ),
        ));
  }

  void toastCardImage() {
    MyToast.showCustom(
        context,
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Img.get('logo_f.png'),
                  height: 40,
                  width: 40,
                ),
                Container(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Image Toast",
                        style: MyText.subhead(context)!
                            .copyWith(color: MyColors.grey_90)),
                    Text("This toast has an image.",
                        style: MyText.caption(context)!
                            .copyWith(color: MyColors.grey_40)),
                  ],
                )
              ],
            ),
          ),
        ),
        duration: Duration(seconds: 3));
  }

  void toastIconError() {
    MyToast.showCustom(
        context,
        Container(
          decoration: BoxDecoration(
            color: Colors.red[600],
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.close, color: Colors.white, size: 20),
              Container(width: 10),
              Text("Error: Something went wrong.",
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_5)),
              Container(width: 8),
            ],
          ),
        ));
  }

  void toastIconSuccess() {
    MyToast.showCustom(
        context,
        Container(
          decoration: BoxDecoration(
            color: Colors.green[500],
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.done, color: Colors.white, size: 20),
              Container(width: 10),
              Text("Success! Operation completed.",
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_5)),
              Container(width: 8),
            ],
          ),
        ));
  }

  void toastIconInfo() {
    MyToast.showCustom(
        context,
        Container(
          decoration: BoxDecoration(
            color: Colors.blue[500],
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              Container(width: 10),
              Text("Info: Additional details here.",
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_5)),
              Container(width: 8),
            ],
          ),
        ));
  }
}
