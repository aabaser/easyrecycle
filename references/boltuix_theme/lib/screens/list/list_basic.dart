import 'package:flutter/material.dart';
import 'package:boltuix/adapter/list_basic_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/model/people.dart';
import 'package:boltuix/widgets/toolbar.dart';
import 'package:boltuix/widgets/my_toast.dart';

class ListBasic extends StatefulWidget {
  ListBasic();

  @override
  ListBasicState createState() => new ListBasicState();
}

class ListBasicState extends State<ListBasic> {
  late BuildContext context;
  void onItemClick(int index, People obj) {
    MyToast.show(obj.name!, context, duration: MyToast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    List<People> items = Dummy.getPeopleData();
    items.addAll(Dummy.getPeopleData());
    items.addAll(Dummy.getPeopleData());

    return new Scaffold(
      appBar: CommonAppBar.getPrimarySettingAppbar(context, "Basic")
          as PreferredSizeWidget?,
      body: ListBasicAdapter(items, onItemClick).getView(),
    );
  }
}
