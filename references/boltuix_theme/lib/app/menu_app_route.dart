import 'package:boltuix/app/travel/splash.dart';
import 'package:flutter/material.dart';
import 'package:boltuix/app/dinosaur/app_dinosaur.dart';
import 'package:boltuix/app/shop/app_shop.dart';

class CustomListViewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> screens = [
    {
      "title": "SwiperPlus",
      "desc": "A sleek and modern swiper app demo using a color palette.",
      "icon": Icons.swipe,
      "screen": const AnimatingScreen()
    },
    {
      "title": "TravelApp",
      "desc": "Discover new destinations and adventures with this UI design.",
      "icon": Icons.travel_explore,
      "screen": const GetStarted()
    },
    {
      "title": "EShopUI",
      "desc":
          "Explore our e-commerce interface design with a red branding style.",
      "icon": Icons.shopping_bag,
      "screen": const Splash()
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffFA7D82),
                  Color(0xffFF5287),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                "Lite App Demo",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                    ),
              ),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index >= screens.length) {
                  return SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.13,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffFA7D82),
                          Color(0xffFF5287),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          screens[index]["icon"],
                          size: 28,
                          color: Color(0xff000000),
                        ),
                      ),
                      title: Text(
                        screens[index]["title"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        screens[index]["desc"],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => screens[index]["screen"],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              childCount: screens.length,
            ),
          ),
        ],
      ),
    );
  }
}
