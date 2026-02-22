import 'package:flutter/material.dart';
import 'package:boltuix/adapter/list_draggable_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/model/people.dart';
import 'package:boltuix/widgets/toolbar.dart';

class ListDraggable extends StatefulWidget {
  ListDraggable();

  @override
  ListDraggableState createState() => new ListDraggableState();
}

class ListDraggableState extends State<ListDraggable> {
  late BuildContext context;
  List<People>? items;

  void onReorder() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    items = Dummy.getPeopleData();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return new Scaffold(
      appBar: CommonAppBar.getPrimaryAppbar(context, "Draggable")
          as PreferredSizeWidget?,
      body: ListDraggableAdapter(items, onReorder).getView(),
    );
  }
}
