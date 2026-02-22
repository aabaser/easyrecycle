import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/included/include_drawer_content.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/my_toast.dart';

class MenuDrawerAbstract extends StatefulWidget {
  MenuDrawerAbstract();

  @override
  MenuDrawerAbstractState createState() => MenuDrawerAbstractState();
}

class MenuDrawerAbstractState extends State<MenuDrawerAbstract> {
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
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        title: Text("Drawer White", style: TextStyle(color: MyColors.grey_80)),
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
        ],
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            // SVG Background with Alpha
            Opacity(
              opacity: 0.1, // Set opacity to 10%
              child: SvgPicture.asset(
                'assets/images/bg_abstract.svg', // Path to your SVG file
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover, // Cover the entire drawer
              ),
            ),
            // Drawer Content
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(height: 50),
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: MyColors.grey_20,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage(Img.get("image_001.png")),
                          ),
                        ),
                        Container(height: 7),
                        Text(
                          "John Smith",
                          style: MyText.body2(context)!.copyWith(
                            color: Colors.blueGrey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(height: 2),
                        Text(
                          "johnsmith@mail.com",
                          style: MyText.caption(context)!.copyWith(
                            color: MyColors.grey_20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 8),
                  drawerItem("Home", Icons.domain_rounded),
                  drawerItem("Reports", Icons.data_usage_rounded),
                  drawerItem("Bookings", Icons.class_rounded),
                  drawerItem("Settings", Icons.menu_rounded),
                  drawerItem("Logout", Icons.power_settings_new_rounded),
                ],
              ),
            ),
          ],
        ),
      ),
      body: IncludeDrawerContent.get(context),
    );
  }

  Widget drawerItem(String title, IconData icon) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            Icon(icon, color: MyColors.grey_20, size: 20),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: MyText.body2(context)!.copyWith(color: MyColors.grey_80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
