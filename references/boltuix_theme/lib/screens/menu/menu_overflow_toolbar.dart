import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/adapter/list_people_left_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/model/people.dart';
import 'package:boltuix/widgets/my_toast.dart';

class MenuOverflowToolbar extends StatefulWidget {
  MenuOverflowToolbar();

  @override
  MenuOverflowToolbarState createState() => new MenuOverflowToolbarState();
}

class MenuOverflowToolbarState extends State<MenuOverflowToolbar> {
  final GlobalKey _menuKey = new GlobalKey();
  List<People>? items;
  late BuildContext context;

  void onItemClick(int index, People obj) {
    MyToast.show(obj.name!, context, duration: MyToast.LENGTH_SHORT);
  }

  @override
  void initState() {
    super.initState();

    items = Dummy.getPeopleData();
    items!.addAll(Dummy.getPeopleData());

    Future.delayed(Duration(seconds: 1), () {
      print("SHOW_MENU");
      setState(() {
        dynamic state = _menuKey.currentState;
        state.showButtonMenu();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          title: new Text("Overflow toolbar"),
          backgroundColor: MyColors.primary,
          leading: IconButton(
            icon: Icon(Icons.menu_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search_rounded),
              onPressed: () {},
            ),
            PopupMenuButton<String>(
              key: _menuKey,
              onSelected: (String value) {
                showToastClicked(context, value);
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "Search",
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, color: Colors.black54),
                      SizedBox(width: 10),
                      Text("Search"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "Refresh",
                  child: Row(
                    children: [
                      Icon(Icons.refresh_rounded, color: Colors.black54),
                      SizedBox(width: 10),
                      Text("Refresh"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "Settings",
                  child: Row(
                    children: [
                      Icon(Icons.settings_rounded, color: Colors.black54),
                      SizedBox(width: 10),
                      Text("Settings"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "Send feedback",
                  child: Row(
                    children: [
                      Icon(Icons.feedback_rounded, color: Colors.black54),
                      SizedBox(width: 10),
                      Text("Send feedback"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "Help",
                  child: Row(
                    children: [
                      Icon(Icons.help_outline_rounded, color: Colors.black54),
                      SizedBox(width: 10),
                      Text("Help"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "Signout",
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded, color: Colors.black54),
                      SizedBox(width: 10),
                      Text("Signout"),
                    ],
                  ),
                ),
              ],
            )
          ]),
      body: ListPeopleLeftAdapter(items, onItemClick).getView(),
    );
  }

  static void showToastClicked(BuildContext context, String action) {
    print(action);
    MyToast.show(action + " clicked", context);
  }
}
