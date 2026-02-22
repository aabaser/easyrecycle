import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/adapter/list_sectioned_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/model/people.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:get/get.dart';
import 'package:boltuix/widgets/my_toast.dart';

class SideSheetBasicRoute extends StatefulWidget {
  SideSheetBasicRoute();

  @override
  SideSheetBasicRouteState createState() => SideSheetBasicRouteState();
}

class SideSheetBasicRouteState extends State<SideSheetBasicRoute> {
  late BuildContext _scaffoldCtx;
  double value1 = 0.3;

  void setValue1(double value) => setState(() => value1 = value);

  void onItemClick(int index, People obj) {
    MyToast.show(obj.name!, context, duration: MyToast.LENGTH_SHORT);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(milliseconds: 500), () {
        Scaffold.of(_scaffoldCtx).openEndDrawer();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<People> items = Dummy.getPeopleData();
    items.addAll(Dummy.getPeopleData());
    items.addAll(Dummy.getPeopleData());

    int sectCount = 0;
    int sectIdx = 0;
    List<RxBool> label = [false.obs, true.obs, true.obs, false.obs];

    var selectedOrder = "Option 1".obs;
    List<String> orderBy = [
      "Sort by Date",
      "Sort by Name",
      "Sort by Size",
      "Sort by Type",
    ];

    List<String> months = Dummy.getStringsMonth();
    for (int i = 0; i < items.length / 6; i++) {
      items.insert(sectCount, People.section(months[sectIdx], true));
      sectCount = sectCount + 5;
      sectIdx++;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        titleSpacing: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Side sheet - Filter",
          style: MyText.title(context)!.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search_rounded), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.filter_alt_rounded),
              onPressed: () {
                Scaffold.of(_scaffoldCtx).openEndDrawer();
              }),
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        _scaffoldCtx = context;
        return ListSectionedAdapter(items, onItemClick).getView();
      }),
      endDrawer: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 5),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Text(
                      "Select Labels",
                      style: MyText.subhead(context)!
                          .copyWith(color: MyColors.grey_60),
                    ),
                  ),
                  _buildLabelSection(label, context),
                  Divider(height: 0, color: Colors.lightGreenAccent),
                  _buildTextInputSection(context),
                  _buildSliderSection(),
                  _buildOrderBySection(orderBy, selectedOrder, context),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildLabelSection(List<RxBool> label, BuildContext context) {
    return Column(
      children: [
        ...["Work", "Personal", "Events", "Reminders"].asMap().entries.map(
          (entry) {
            int index = entry.key;
            String text = entry.value;
            return InkWell(
              child: Row(
                children: <Widget>[
                  Checkbox(
                      value: label[index].value,
                      onChanged: (value) {
                        label[index].value = !label[index].value;
                      }),
                  Text(text),
                ],
              ),
              onTap: () {
                label[index].value = !label[index].value;
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildTextInputSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: TextField(
        style: TextStyle(color: Colors.green[300], height: 1.4, fontSize: 16),
        keyboardType: TextInputType.text,
        cursorColor: Colors.green[300],
        controller: TextEditingController(text: "Enter Format"),
        decoration: InputDecoration(
          labelText: "Format",
          labelStyle: TextStyle(color: Colors.green[600]),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green[300]!, width: 1)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green[300]!, width: 2)),
          suffixIcon: Icon(Icons.arrow_drop_down_rounded),
        ),
      ),
    );
  }

  Widget _buildSliderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            "Adjust Range",
            style: TextStyle(color: MyColors.grey_60, fontSize: 16),
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            thumbColor: Colors.green,
            trackHeight: 2,
            activeTrackColor: Colors.green,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
          ),
          child: Slider(
            value: value1,
            onChanged: setValue1,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderBySection(
      List<String> orderBy, RxString selectedOrder, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            "Sort Options",
            style: TextStyle(color: MyColors.grey_60, fontSize: 16),
          ),
        ),
        Column(
          children: orderBy
              .map((r) => RadioListTile(
                    title: Text(
                      r,
                      style: TextStyle(
                        color: selectedOrder.value == r
                            ? Colors.green[700]
                            : Colors.grey[600],
                      ),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.all(0),
                    groupValue: selectedOrder.value,
                    selected: r == selectedOrder.value,
                    value: r,
                    onChanged: (dynamic val) {
                      selectedOrder.value = val;
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}
