import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/model/bottom_nav.dart';

class BottomNavigationShifting extends StatefulWidget {
  final List<BottomNav> itemsNav = <BottomNav>[
    BottomNav('Music', Icons.music_note_rounded, Colors.blue[800]),
    BottomNav(
        'Movies & TV', Icons.ondemand_video_rounded, Colors.blueGrey[700]),
    BottomNav('Books', Icons.book_rounded, Colors.grey[700]),
    BottomNav('News', Icons.chrome_reader_mode_rounded, Colors.teal[800])
  ];

  @override
  BottomNavigationShiftingState createState() =>
      BottomNavigationShiftingState();
}

class BottomNavigationShiftingState extends State<BottomNavigationShifting>
    with TickerProviderStateMixin<BottomNavigationShifting> {
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
    BottomNav curItem = widget.itemsNav[currentIndex];
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: buildAppBar(curItem),
      body: buildBody(context),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  AppBar buildAppBar(BottomNav curItem) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.grey[200],
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(15),
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
                "Search: " + curItem.title,
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
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.itemsNav[currentIndex].icon,
            size: 100,
            color: widget.itemsNav[currentIndex].color,
          ),
          SizedBox(height: 20),
          Text(
            widget.itemsNav[currentIndex].title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: widget.itemsNav[currentIndex].color,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      currentIndex: currentIndex,
      onTap: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: widget.itemsNav.map((BottomNav d) {
        return BottomNavigationBarItem(
          backgroundColor: d.color,
          icon: Icon(d.icon),
          label: d.title,
        );
      }).toList(),
    );
  }
}
