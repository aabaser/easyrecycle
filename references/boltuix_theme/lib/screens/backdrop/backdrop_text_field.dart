import 'dart:async';

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/adapter/list_news_light_hrzntl_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/model/news.dart';
import 'package:boltuix/widgets/my_toast.dart';

class BackdropTextField extends StatefulWidget {
  BackdropTextField();

  @override
  BackdropTextFieldState createState() => new BackdropTextFieldState();
}

class BackdropTextFieldState extends State<BackdropTextField>
    with TickerProviderStateMixin {
  late BuildContext _scaffoldCtx;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(milliseconds: 500), () {
        Backdrop.of(_scaffoldCtx).revealBackLayer();
      });
    });
  }

  void onItemClick(int index, News obj) {
    MyToast.show("News $index clicked", context,
        duration: MyToast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    List<News> items = Dummy.getNewsData(10);
    return BackdropScaffold(
      backgroundColor: Colors.green[700],
      backLayerBackgroundColor: Colors.green[700],
      animationCurve: Curves.linear,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 300), value: 1),
      appBar: BackdropAppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[700],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        titleSpacing: 0,
        title: Column(
          children: [
            Container(
              width: double.maxFinite,
              alignment: Alignment.center,
              child: TabBar(
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 2,
                isScrollable: true,
                labelColor: Colors.white, // Selected tab text color
                unselectedLabelColor:
                    Colors.white70, // Unselected tab text color
                tabs: [
                  Tab(icon: Text("BOOK")),
                  Tab(icon: Text("CHAT")),
                  Tab(icon: Text("SOCIAL")),
                ],
                controller: TabController(length: 3, vsync: this),
                onTap: (index) {
                  if (index == 0) {
                    Backdrop.of(_scaffoldCtx).revealBackLayer();
                  } else {
                    Backdrop.of(_scaffoldCtx).concealBackLayer();
                  }
                },
              ),
            ),
            Container(
              width: double.maxFinite,
              height: 1,
              color: Colors.white.withOpacity(0.25),
            ),
          ],
        ),
      ),
      headerHeight: 550,
      frontLayerBorderRadius: BorderRadius.only(
        topLeft: Radius.circular(6),
        topRight: Radius.circular(6),
      ),
      backLayer: Builder(
        builder: (BuildContext context) {
          _scaffoldCtx = context;
          return Container(
            color: Colors.green[700],
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                _buildRoundedTextField(Icons.location_on, "Royal Hotel"),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                        child: _buildRoundedTextField(Icons.people, "2 guest",
                            dropdown: true)),
                    SizedBox(width: 15),
                    Expanded(
                        child: _buildRoundedTextField(
                            Icons.meeting_room, "1 room",
                            dropdown: true)),
                  ],
                ),
                SizedBox(height: 15),
                _buildRoundedTextField(Icons.event, "Today, 10/07/18"),
              ],
            ),
          );
        },
      ),
      frontLayerScrim: Colors.transparent,
      frontLayer: Container(
        color: Colors.white,
        height: double.maxFinite,
        padding: EdgeInsets.symmetric(vertical: 15),
        child: ListNewsLightHrzntlAdapter(items, onItemClick).getWidgetView(),
      ),
    );
  }

  Widget _buildRoundedTextField(IconData icon, String text,
      {bool dropdown = false}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Fully rounded corners
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Colors.white.withOpacity(0.25),
      margin: EdgeInsets.all(0),
      elevation: 0,
      child: Container(
        height: 50,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: <Widget>[
            SizedBox(width: 10),
            Icon(icon, color: Colors.white),
            SizedBox(width: 15),
            Expanded(
              child: TextField(
                maxLines: 1,
                style: TextStyle(color: Colors.white),
                controller: TextEditingController(text: text),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(-12),
                  border: InputBorder.none,
                ),
              ),
            ),
            if (dropdown) Icon(Icons.arrow_drop_down, color: Colors.white),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
