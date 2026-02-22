import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/included/include_drawer_content.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/my_toast.dart';

class MenuDrawerWhite extends StatefulWidget {
  MenuDrawerWhite();

  @override
  MenuDrawerWhiteState createState() => new MenuDrawerWhiteState();
}

class MenuDrawerWhiteState extends State<MenuDrawerWhite> {
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
      appBar: AppBar(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          title:
              Text("Drawer White", style: TextStyle(color: MyColors.grey_80)),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.menu_rounded, color: MyColors.grey_60),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.close_rounded, color: MyColors.grey_60),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ]),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(height: 30),
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: MyColors.grey_20,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(Img.get("image_001.png")),
                      ),
                    ),
                    Container(height: 7),
                    Text("John Smith",
                        style: MyText.body2(context)!.copyWith(
                            color: Colors.blueGrey[800],
                            fontWeight: FontWeight.w500)),
                    Container(height: 2),
                    Text("john.smith@mail.com",
                        style: MyText.caption(context)!.copyWith(
                            color: MyColors.grey_20,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Container(height: 8),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.domain_rounded, color: Colors.blue, size: 20),
                      Container(width: 20),
                      Expanded(
                          child: Text("Home",
                              style: MyText.body2(context)!
                                  .copyWith(color: MyColors.grey_80))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.data_usage_rounded,
                          color: Colors.blue, size: 20),
                      Container(width: 20),
                      Expanded(
                          child: Text("Reports",
                              style: MyText.body2(context)!
                                  .copyWith(color: MyColors.grey_80))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.class_rounded, color: Colors.blue, size: 20),
                      Container(width: 20),
                      Expanded(
                          child: Text("Bookings",
                              style: MyText.body2(context)!
                                  .copyWith(color: MyColors.grey_80))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.menu_rounded, color: Colors.blue, size: 20),
                      Container(width: 20),
                      Expanded(
                          child: Text("Settings",
                              style: MyText.body2(context)!
                                  .copyWith(color: MyColors.grey_80))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.power_settings_new_rounded,
                          color: Colors.blue, size: 20),
                      Container(width: 20),
                      Expanded(
                          child: Text("Logout",
                              style: MyText.body2(context)!
                                  .copyWith(color: MyColors.grey_80))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: IncludeDrawerContent.get(context),
    );
    return widget;
  }
}
