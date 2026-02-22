import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/adapter/list_multi_selection_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:get/get.dart';
import 'package:boltuix/model/inbox.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/my_toast.dart';

class ListMultiSelection extends StatefulWidget {
  ListMultiSelection();

  @override
  ListMultiSelectionState createState() => new ListMultiSelectionState();
}

class ListMultiSelectionState extends State<ListMultiSelection> {
  late BuildContext context;
  List<Inbox> items = [];
  var modeSelection = false.obs;
  var refreshList = false.obs;
  var selectionCount = 0.obs;

  void onItemClick(int index, Inbox obj) {
    MyToast.show(obj.name!, context, duration: MyToast.LENGTH_SHORT);
  }

  @override
  void initState() {
    items = Dummy.getInboxData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    var adapter = ListMultiSelectionAdapter(context, items, onItemClick);
    adapter.setOnSelectedMode((bool flag, int count) {
      print(
          "setOnSelectedMode : " + flag.toString() + " | " + count.toString());
      modeSelection.value = flag;
      selectionCount.value = count;
    });

    return new Obx(() => Scaffold(
          appBar: AppBar(
              backgroundColor:
                  modeSelection.value ? Colors.green[600] : Colors.green[600],
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
              titleSpacing: 0,
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                  modeSelection.value
                      ? selectionCount.value.toString()
                      : "Inbox",
                  style: MyText.title(context)!.copyWith(color: Colors.white)),
              leading: IconButton(
                icon: Icon(modeSelection.value
                    ? Icons.arrow_back_rounded
                    : Icons.menu_rounded),
                onPressed: () {
                  modeSelection.value
                      ? adapter.clearSelection()
                      : Navigator.pop(context);
                },
              ),
              actions: modeSelection.value
                  ? <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            items.removeWhere((e) => e.selected.value == true);
                            adapter.clearSelection();
                            refreshList.value = !refreshList.value;
                          });
                        },
                      )
                    ]
                  : <Widget>[
                      IconButton(
                        icon: Icon(Icons.search_rounded),
                        onPressed: () {},
                      ),
                      PopupMenuButton<String>(
                        onSelected: (String value) {},
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: "Settings", child: Text("Settings")),
                        ],
                      )
                    ]),
          body: adapter.getView(),
        ));
  }
}
