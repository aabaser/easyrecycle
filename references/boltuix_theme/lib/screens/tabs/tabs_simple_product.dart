import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/model/news.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/my_toast.dart';

class TabsSimpleProductRoute extends StatefulWidget {
  TabsSimpleProductRoute();

  @override
  TabsSimpleProductRouteState createState() =>
      new TabsSimpleProductRouteState();
}

class TabsSimpleProductRouteState extends State<TabsSimpleProductRoute>
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
    _tabController = TabController(length: 5, vsync: this);
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
              elevation: 0,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: MyColors.grey_80),
              leading: IconButton(
                  icon: Icon(Icons.notes),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.shopping_cart_rounded),
                  onPressed: () {},
                ), // overflow menu
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text("Most Popular\nProduct",
                  style: MyText.title(context)!.copyWith(
                      color: MyColors.grey_60, fontWeight: FontWeight.bold)),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: PreferredSize(
                  preferredSize: Size.fromHeight(40),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    isScrollable: true,
                    indicatorPadding: EdgeInsets.symmetric(vertical: 8),
                    labelColor:
                        Colors.green, // Set selected tab text color to pink
                    unselectedLabelColor:
                        MyColors.grey_40, // Unselected tab text color
                    indicator: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tabs: [
                      Container(width: 70, child: Tab(text: "All")),
                      Container(width: 70, child: Tab(text: "Toys")),
                      Container(width: 70, child: Tab(text: "Dress")),
                      Container(width: 70, child: Tab(text: "GIFT")),
                    ],
                    controller: _tabController,
                    splashFactory:
                        NoSplash.splashFactory, // Remove the ripple effect
                  ),
                )),
            Container(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(width: 15),
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      Img.get('image_001.png'),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(width: 10),
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      Img.get('image_002.png'),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(width: 15),
              ],
            ),
            Container(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(width: 15),
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      Img.get('image_003.png'),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(width: 10),
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      Img.get('image_004.png'),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(width: 15),
              ],
            ),
            Container(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(width: 15),
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      Img.get('image_005.png'),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(width: 10),
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      Img.get('image_006.png'),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(width: 15),
              ],
            ),
            Container(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(width: 15),
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      Img.get('image_007.png'),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(width: 10),
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      Img.get('image_008.png'),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(width: 15),
              ],
            ),
            Container(height: 200, width: 0)
          ],
        ),
      ),
    );
  }
}
