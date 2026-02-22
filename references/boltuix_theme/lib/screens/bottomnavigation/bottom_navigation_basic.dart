import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/included/include_releases_content.dart';
import 'package:boltuix/model/bottom_nav.dart';

class BottomNavigationBasic extends StatefulWidget {
  final List<BottomNav> itemsNav = <BottomNav>[
    BottomNav('Home', Icons.store_rounded, null),
    BottomNav('Cart', Icons.shopping_cart_rounded, null),
    BottomNav('Profile', Icons.account_circle_rounded, null)
  ];

  @override
  BottomNavigationBasicState createState() => BottomNavigationBasicState();
}

class BottomNavigationBasicState extends State<BottomNavigationBasic>
    with TickerProviderStateMixin<BottomNavigationBasic> {
  int currentIndex = 0;
  late BuildContext ctx;

  void onBackPress() {
    if (Navigator.of(ctx).canPop()) {
      Navigator.of(ctx).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
            ),
            bottom: PreferredSize(
                child: Card(
                  margin: EdgeInsets.all(10),
                  elevation: 1,
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        splashColor: Colors.grey[600],
                        highlightColor: Colors.grey[600],
                        onTap: onBackPress,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.menu_rounded,
                            size: 23.0,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      Text(
                        "Search",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.mic,
                          size: 23.0,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
                preferredSize: Size.fromHeight(15)),
            backgroundColor: Colors.grey[200],
            automaticallyImplyLeading: false,
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("New Releases",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Container(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: IncludeReleasesContent.newReleases.length,
                    itemBuilder: (BuildContext context, int index) {
                      return IncludeReleasesContent.newReleases[index];
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Top Rated",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: IncludeReleasesContent.topRated.length,
                  itemBuilder: (BuildContext context, int index) {
                    return IncludeReleasesContent.topRated[index];
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightGreen,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[200],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: widget.itemsNav.map((BottomNav d) {
          return BottomNavigationBarItem(
            icon: Icon(d.icon),
            label: d.title,
          );
        }).toList(),
      ),
    );
  }
}
