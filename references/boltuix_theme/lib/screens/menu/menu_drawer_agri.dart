import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/included/include_drawer_content.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/my_toast.dart';

class MenuDrawerGoGreen extends StatefulWidget {
  MenuDrawerGoGreen();

  @override
  MenuDrawerGoGreenState createState() => new MenuDrawerGoGreenState();
}

class MenuDrawerGoGreenState extends State<MenuDrawerGoGreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late BuildContext context;

  void onDrawerItemClicked(String name) {
    Navigator.pop(context);
    MyToast.show(name + " Selected", context);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      scaffoldKey.currentState!.openDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    Widget widget = Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: new AppBar(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          backgroundColor: Colors.green,
          title: new Text("Drawer Go Green")),
      drawer: Drawer(
        child: Stack(
          children: [
            Image.asset(
              Img.get('bg_green.webp'),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(color: Colors.black.withOpacity(0.5)),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(height: 40),
                Row(
                  children: [
                    Container(width: 10),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Spacer()
                  ],
                ),
                Container(height: 30),
                Image.asset(Img.get('logo_f.png'),
                    width: 90, height: 90, fit: BoxFit.cover),
                Container(height: 5),
                Text("Go green",
                    style: MyText.headline(context)!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Container(height: 40),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25),
                  leading:
                      Icon(Icons.spa_rounded, size: 20, color: Colors.white),
                  minLeadingWidth: 0,
                  title: Text("PLANTS",
                      style: MyText.subhead(context)!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                  onTap: () {
                    onDrawerItemClicked("PLANTS");
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25),
                  leading:
                      Icon(Icons.grass_rounded, size: 20, color: Colors.white),
                  minLeadingWidth: 0,
                  title: Text("PRODUCT",
                      style: MyText.subhead(context)!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                  onTap: () {
                    onDrawerItemClicked("PRODUCT");
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25),
                  leading: Icon(Icons.local_florist_rounded,
                      size: 20, color: Colors.white),
                  minLeadingWidth: 0,
                  title: Text("FLOWERS",
                      style: MyText.subhead(context)!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                  onTap: () {
                    onDrawerItemClicked("FLOWERS");
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25),
                  leading: Icon(Icons.cottage_rounded,
                      size: 20, color: Colors.white),
                  minLeadingWidth: 0,
                  title: Text("PROCESS",
                      style: MyText.subhead(context)!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                  onTap: () {
                    onDrawerItemClicked("PROCESS");
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25),
                  leading:
                      Icon(Icons.eco_rounded, size: 20, color: Colors.white),
                  minLeadingWidth: 0,
                  title: Text("SUSTAINABILITY",
                      style: MyText.subhead(context)!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                  onTap: () {
                    onDrawerItemClicked("SUSTAINABILITY");
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25),
                  leading: Icon(Icons.nature_people_rounded,
                      size: 20, color: Colors.white),
                  minLeadingWidth: 0,
                  title: Text("COMMUNITY",
                      style: MyText.subhead(context)!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                  onTap: () {
                    onDrawerItemClicked("COMMUNITY");
                  },
                ),
                Spacer(),
                Container(
                    height: 0.5,
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 20)),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25),
                  title: Text("EXPLORE",
                      style: MyText.subhead(context)!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                  trailing: Icon(Icons.chevron_right_rounded,
                      size: 20, color: Colors.white),
                  onTap: () {
                    onDrawerItemClicked("EXPLORE");
                  },
                ),
              ],
            )
          ],
        ),
      ),
      body: IncludeDrawerContent.get(context),
    );
    return widget;
  }
}
