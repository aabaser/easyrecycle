import 'package:flutter/material.dart';
import 'package:boltuix/adapter/list_expand_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/model/people.dart';
import 'package:boltuix/widgets/toolbar.dart';

class ListExpand extends StatefulWidget {
  ListExpand();

  @override
  ListExpandState createState() => new ListExpandState();
}

class ListExpandState extends State<ListExpand> {
  late BuildContext context;
  List<People>? items;

  @override
  void initState() {
    super.initState();
    items = Dummy.getPeopleData();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return new Scaffold(
      appBar: CommonAppBar.getPrimaryAppbar(context, "Expand")
          as PreferredSizeWidget?,
      body: ListExpandAdapter(items).getView(),
    );
  }
}
