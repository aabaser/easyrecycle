import 'package:flutter/material.dart';

class Menu {
  int id = 0;
  late String title;
  String description = "View More";
  IconData? icon;
  String type = "PARENT";
  bool expand = false;
  List subs = <Menu>[];
  StatefulWidget? route;
  bool newPage = false;

  Menu(int id, IconData icon, String title,
      [String description = "", bool newPage = false]) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.icon = icon;
    this.type = "PARENT";
    this.newPage = newPage;
  }

  Menu.sub(int id, String title, StatefulWidget route,
      [String description = "", bool newPage = false]) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.icon = null;
    this.type = "CHILD";
    this.route = route;
    this.newPage = newPage;
  }

  Menu.divider() {
    this.type = "DIVIDER";
  }

  Menu.spacer() {
    this.type = "SPACER";
  }
}
