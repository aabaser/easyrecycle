import 'package:flutter/material.dart';
import 'package:boltuix/adapter/grid_sectioned_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/model/section_image.dart';
import 'package:boltuix/widgets/my_toast.dart';
import 'package:boltuix/widgets/toolbar.dart';

class GridSectionedRoute extends StatefulWidget {
  GridSectionedRoute();

  @override
  GridSectionedRouteState createState() => new GridSectionedRouteState();
}

class GridSectionedRouteState extends State<GridSectionedRoute> {
  void onItemClick(int index, String obj) {
    MyToast.show(obj, context, duration: MyToast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    List<String> itemsImg = Dummy.getNatureImages();
    itemsImg.addAll(Dummy.getNatureImages());
    itemsImg.addAll(Dummy.getNatureImages());
    itemsImg.addAll(Dummy.getNatureImages());
    itemsImg.addAll(Dummy.getNatureImages());

    List<SectionImage> items = [];
    for (String i in itemsImg) {
      items.add(SectionImage(i, "IMG_" + i + ".jpg", false));
    }

    int sectCount = 0;
    int sectIdx = 0;
    List<String> months = Dummy.getStringsMonth();
    for (int i = 0; i < items.length / 10; i++) {
      items.insert(sectCount, SectionImage("", months[sectIdx], true));
      sectCount = sectCount + 10;
      sectIdx++;
    }

    return new Scaffold(
      appBar: CommonAppBar.getPrimarySettingAppbar(context, "Sectioned")
          as PreferredSizeWidget?,
      body: GridSectionedAdapter(items, onItemClick).getView(),
    );
  }
}
