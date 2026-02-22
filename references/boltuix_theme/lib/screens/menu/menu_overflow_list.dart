import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/adapter/list_people_more_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/model/people.dart';
import 'package:boltuix/widgets/my_toast.dart';

class MenuOverflowList extends StatefulWidget {
  MenuOverflowList();

  @override
  MenuOverflowListState createState() => new MenuOverflowListState();
}

class MenuOverflowListState extends State<MenuOverflowList> {
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
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        title: Text("Drawer White", style: TextStyle(color: MyColors.grey_80)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: MyColors.grey_60),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close_rounded, color: MyColors.grey_60),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListPeopleMoreAdapter(items, onItemClick).getView(),
    );
  }
}
