import 'package:flutter/material.dart';
import 'package:boltuix/adapter/list_swipe_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/model/people.dart';
import 'package:boltuix/widgets/toolbar.dart';
import 'package:boltuix/widgets/my_toast.dart';

class ListSwipe extends StatefulWidget {
  ListSwipe();

  @override
  ListSwipeState createState() => new ListSwipeState();
}

class ListSwipeState extends State<ListSwipe> {
  late BuildContext context;
  List<People>? items;

  void onItemSwipe(int index, People obj) {
    setState(() {
      items!.removeAt(index);
    });
    MyToast.show(obj.name! + " dismissed", context,
        duration: MyToast.LENGTH_SHORT);
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
      appBar: CommonAppBar.getPrimaryAppbar(context, "Swipe")
          as PreferredSizeWidget?,
      body: ListSwipeAdapter(items, onItemSwipe).getView(),
    );
  }
}
