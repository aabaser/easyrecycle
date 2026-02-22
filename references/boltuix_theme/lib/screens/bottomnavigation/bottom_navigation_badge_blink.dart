import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:boltuix/model/bottom_nav.dart';
import 'package:boltuix/widgets/my_text.dart';

class BottomNavigationBadgeBlink extends StatefulWidget {
  @override
  BottomNavigationBadgeBlinkState createState() =>
      BottomNavigationBadgeBlinkState();
}

class BottomNavigationBadgeBlinkState extends State<BottomNavigationBadgeBlink>
    with TickerProviderStateMixin<BottomNavigationBadgeBlink> {
  var currentIndex = 1.obs;
  var blink = true.obs;
  late BuildContext ctx;

  final List<BottomNav> itemsNav = <BottomNav>[
    BottomNav.count('Favorites', Icons.favorite_rounded, null, true, ""),
    BottomNav('Music', Icons.music_note_rounded, null),
    BottomNav.count('Book', Icons.chrome_reader_mode_rounded, null, true, "9+"),
    BottomNav('News', Icons.receipt_long_rounded, null)
  ];

  void onBackPress() {
    if (Navigator.of(ctx).canPop()) {
      Navigator.of(ctx).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateBlink();
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: buildAppBar(),
      body: buildBody(context),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(15),
        child: Card(
          margin: EdgeInsets.all(10),
          elevation: 2,
          child: Row(
            children: <Widget>[
              InkWell(
                splashColor: Colors.grey[600],
                highlightColor: Colors.grey[600],
                onTap: onBackPress,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.menu_rounded,
                      size: 23.0, color: Colors.grey[700]),
                ),
              ),
              Text("Search", style: TextStyle(color: Colors.grey[500])),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.mic, size: 23.0, color: Colors.grey[800]),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      automaticallyImplyLeading: false,
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              width: 220,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Bottom Navigation Badge",
                    style: MyText.medium(context)
                        .copyWith(color: Colors.lightGreenAccent[600]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBottomNavigationBar() {
    return Obx(() {
      return BottomNavigationBar(
        elevation: 15,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.green[700],
        currentIndex: currentIndex.value,
        onTap: (int index) {
          currentIndex.value = index;
        },
        items: itemsNav.map((BottomNav d) {
          return BottomNavigationBarItem(
            icon: !d.badge ? buildGradientIcon(d.icon) : buildBadgeIcon(d),
            label: d.title,
          );
        }).toList(),
      );
    });
  }

  Widget buildGradientIcon(IconData icon) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Colors.greenAccent[700]!,
          Colors.blue
        ], // Updated to green gradient
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget buildBadgeIcon(BottomNav d) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        buildGradientIcon(d.icon),
        Positioned(
          right: -18,
          top: -8,
          child: Container(
            alignment: Alignment.bottomLeft,
            width: 25,
            height: 15,
            child: Wrap(
              children: [
                d.title == "Book"
                    ? (blink.value ? Container() : buildBadge(d))
                    : buildBadge(d),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBadge(BottomNav d) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.redAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
      child: d.badgeText == ""
          ? Container(width: 0, height: 0)
          : Text(
              d.badgeText,
              style: MyText.overline(context)!.copyWith(color: Colors.white),
            ),
    );
  }

  void updateBlink() {
    Timer.periodic(Duration(milliseconds: 600), (Timer t) {
      blink.value = !blink.value;
    });
  }
}
