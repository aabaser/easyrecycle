import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/adapter/list_news_card_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/model/news.dart';
import 'package:boltuix/widgets/my_toast.dart';

class TabsSimpleBlueRoute extends StatefulWidget {
  TabsSimpleBlueRoute();

  @override
  TabsSimpleBlueRouteState createState() => new TabsSimpleBlueRouteState();
}

class TabsSimpleBlueRouteState extends State<TabsSimpleBlueRoute>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  ScrollController? _scrollController;
  late List<News> items;

  void onItemClick(int index, News obj) {
    MyToast.show("News " + index.toString() + "clicked", context,
        duration: MyToast.LENGTH_SHORT);
  }

  @override
  void initState() {
    items = Dummy.getNewsData(15);
    _tabController = TabController(length: 4, vsync: this);
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
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScroller) {
          return <Widget>[
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness: Brightness.light,
              ),
              pinned: true,
              floating: true,
              backgroundColor: Colors.white,
              forceElevated: innerBoxIsScroller,
              iconTheme: IconThemeData(color: MyColors.grey_80),
              leading: IconButton(
                icon: Icon(Icons.notes),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.shopping_cart_outlined),
                  onPressed: () {},
                ),
              ],
              title: Text(
                'Your Title', // Set the title here
                style: TextStyle(
                  color: MyColors.grey_80, // Set the title color here
                  fontWeight: FontWeight.bold, // Optional: Makes the title bold
                ),
              ),
              bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                isScrollable: true,
                indicatorPadding: EdgeInsets.symmetric(vertical: 6),
                labelColor: Colors.white,
                unselectedLabelColor: MyColors.grey_60,
                indicator: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                tabs: [
                  Container(width: 70, child: Tab(text: "All")),
                  Container(width: 70, child: Tab(text: "Trending")),
                  Container(width: 70, child: Tab(text: "New")),
                  Container(width: 70, child: Tab(text: "Featured")),
                ],
                controller: _tabController,
              ),
            )
          ];
        },
        body: ListNewsCardAdapter(items, onItemClick).getWidgetView(),
      ),
    );
  }
}
