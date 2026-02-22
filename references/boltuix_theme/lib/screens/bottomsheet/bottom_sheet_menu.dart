import 'package:flutter/material.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/toolbar.dart';

class BottomSheetMenu extends StatefulWidget {
  BottomSheetMenu();

  @override
  BottomSheetMenuState createState() => new BottomSheetMenuState();
}

class BottomSheetMenuState extends State<BottomSheetMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar.getPrimaryAppbar(context, "Menu")
          as PreferredSizeWidget?,
      body: Center(
        child: Text(
          "Press button \nbelow",
          textAlign: TextAlign.center,
          style: MyText.display1(context)!.copyWith(color: Colors.grey[300]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "fab",
        backgroundColor: Colors.green[500],
        elevation: 3,
        child: Icon(
          Icons.arrow_upward_rounded,
          color: Colors.white,
        ),
        onPressed: () {
          showSheet(context);
        },
      ),
    );
  }
}

void showSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // First Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMenuItem(Icons.search_rounded, "Search", context),
                _buildMenuItem(
                    Icons.notifications_active_rounded, "Alerts", context),
                _buildMenuItem(Icons.download_rounded, "Downloads", context),
                _buildMenuItem(Icons.favorite_rounded, "Favorites", context),
              ],
            ),
            SizedBox(height: 20),
            // Second Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMenuItem(Icons.info_rounded, "Info", context),
                _buildMenuItem(Icons.help_center_rounded, "Help", context),
                _buildMenuItem(Icons.star_rounded, "Rate Us", context),
                _buildMenuItem(Icons.share_rounded, "Share", context),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

// Helper function to create clickable menu items with ripple effect and haptic feedback
Widget _buildMenuItem(IconData icon, String label, BuildContext context) {
  double itemWidth = MediaQuery.of(context).size.width /
      5; // Dynamically calculate equal width
  return InkWell(
    onTap: () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("$label clicked!"), duration: Duration(seconds: 1)),
      );
    },
    borderRadius: BorderRadius.circular(8), // Ripple effect shape
    child: SizedBox(
      width: itemWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: Colors.green,
            size: 30,
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
