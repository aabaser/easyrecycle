import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/included/include_releases_content.dart';

class TabsRoundRoute extends StatefulWidget {
  TabsRoundRoute();

  @override
  TabsRoundRouteState createState() => new TabsRoundRouteState();
}

class TabsRoundRouteState extends State<TabsRoundRoute> {
  var finishLoading = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Tabs Round'),
        titleSpacing: 0,
        backgroundColor: MyColors.primary,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        leading: IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ), // overflow menu
          PopupMenuButton<String>(
            onSelected: (String value) {},
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "Settings",
                child: Text("Settings"),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: MyColors.primary,
                        elevation: 1),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("TAB 1",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                    onPressed: () {
                      delayShowingContent();
                    },
                  ),
                  Container(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: MyColors.primary,
                        elevation: 1),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("TAB 2",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                    onPressed: () {
                      delayShowingContent();
                    },
                  ),
                  Container(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: MyColors.primary,
                        elevation: 1),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("TAB 3",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                    onPressed: () {
                      delayShowingContent();
                    },
                  ),
                  Container(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: MyColors.primary,
                        elevation: 1),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("TAB 4",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                    onPressed: () {
                      delayShowingContent();
                    },
                  ),
                  Container(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: MyColors.primary,
                        elevation: 1),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("TAB 5",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                    onPressed: () {
                      delayShowingContent();
                    },
                  ),
                  Container(width: 10),
                ],
              ),
            ),
            Obx(() => AnimatedOpacity(
                  opacity: finishLoading.value ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 200),
                  child: IncludeReleasesContent.get(context),
                  onEnd: () {
                    finishLoading.value = false;
                  },
                ))
          ],
        ),
      ),
    );
  }

  void delayShowingContent() {
    finishLoading.value = true;
  }
}
