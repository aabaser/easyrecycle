import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class TabsBasicRoute extends StatefulWidget {
  TabsBasicRoute();

  @override
  TabsBasicRouteState createState() => new TabsBasicRouteState();
}

class TabsBasicRouteState extends State<TabsBasicRoute>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  ScrollController? _scrollController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScroller) {
          return <Widget>[
            SliverAppBar(
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
              title: Text('Basic'),
              pinned: true,
              floating: true,
              backgroundColor: MyColors.primary,
              forceElevated: innerBoxIsScroller,
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
              bottom: TabBar(
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 4,
                labelStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(color: Colors.grey),
                tabs: [
                  Tab(child: Text("ITEM ONE")),
                  Tab(child: Text("ITEM TWO")),
                  Tab(child: Text("ITEM THREE")),
                ],
                labelColor: Colors.white, // Selected tab text color
                unselectedLabelColor: Colors.white, // Unselected tab text color
                controller: _tabController,
              ),
            )
          ];
        },
        body: TabBarView(
          children: [
            Align(child: Text("Section : 1", style: MyText.display1(context))),
            Align(child: Text("Section : 2", style: MyText.display1(context))),
            Align(child: Text("Section : 3", style: MyText.display1(context))),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
