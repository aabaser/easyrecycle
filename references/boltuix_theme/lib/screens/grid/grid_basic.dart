import 'package:flutter/material.dart';
import 'package:boltuix/adapter/grid_basic_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/widgets/my_toast.dart';
import 'package:boltuix/widgets/toolbar.dart';

class GridBasicRoute extends StatefulWidget {
  GridBasicRoute();

  @override
  GridBasicRouteState createState() => new GridBasicRouteState();
}

class GridBasicRouteState extends State<GridBasicRoute> {
  void onItemClick(int index, String obj) {
    MyToast.show(obj, context, duration: MyToast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    List<String> items = Dummy.getNatureImages();
    items.addAll(Dummy.getNatureImages());
    items.addAll(Dummy.getNatureImages());
    items.addAll(Dummy.getNatureImages());

    return new Scaffold(
      appBar: CommonAppBar.getPrimarySettingAppbar(context, "Basic")
          as PreferredSizeWidget?,
      body: GridBasicAdapter(items, onItemClick).getView(),
    );
  }
}
