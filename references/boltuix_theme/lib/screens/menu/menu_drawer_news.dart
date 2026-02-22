import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/included/include_drawer_content.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/my_toast.dart';

class MenuDrawerNews extends StatefulWidget {
  MenuDrawerNews();

  @override
  MenuDrawerNewsState createState() => new MenuDrawerNewsState();
}

class MenuDrawerNewsState extends State<MenuDrawerNews> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late BuildContext context;

  void onDrawerItemClicked(String name) {
    Navigator.pop(context);
    MyToast.show("$name Selected", context);
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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        title: Text("Drawer News"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 250,
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      Img.get('image_001.png'),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 14),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.grey[100],
                        child: CircleAvatar(
                          radius: 33,
                          backgroundImage: AssetImage(Img.get("image_002.png")),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "John Smith",
                              style: MyText.body2(context)!.copyWith(
                                color: Colors.grey[100],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(height: 5),
                            Text(
                              "johnsmith@mail.com",
                              style: MyText.body2(context)!.copyWith(
                                color: Colors.grey[100],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  "Home",
                  style: MyText.subhead(context)!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading:
                    Icon(Icons.home_outlined, size: 25.0, color: Colors.grey),
                onTap: () {
                  onDrawerItemClicked("Home");
                },
              ),
              ListTile(
                title: Text(
                  "Trending",
                  style: MyText.subhead(context)!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: Icon(Icons.trending_up_rounded,
                    size: 25.0, color: Colors.grey),
                onTap: () {
                  onDrawerItemClicked("Trending");
                },
              ),
              ListTile(
                title: Text(
                  "Latest",
                  style: MyText.subhead(context)!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: Icon(Icons.access_time_rounded,
                    size: 25.0, color: Colors.grey),
                onTap: () {
                  onDrawerItemClicked("Latest");
                },
              ),
              ListTile(
                title: Text(
                  "Highlight",
                  style: MyText.subhead(context)!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: Icon(Icons.highlight_alt_rounded,
                    size: 25.0, color: Colors.grey),
                onTap: () {
                  onDrawerItemClicked("Highlight");
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Settings",
                  style: MyText.subhead(context)!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: Icon(Icons.settings_suggest_rounded,
                    size: 25.0, color: Colors.grey),
                onTap: () {
                  onDrawerItemClicked("Settings");
                },
              ),
              ListTile(
                title: Text(
                  "Help",
                  style: MyText.subhead(context)!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: Icon(Icons.help_center_rounded,
                    size: 25.0, color: Colors.grey),
                onTap: () {
                  onDrawerItemClicked("Help");
                },
              ),
            ],
          ),
        ),
      ),
      body: IncludeDrawerContent.get(context),
    );
  }
}
