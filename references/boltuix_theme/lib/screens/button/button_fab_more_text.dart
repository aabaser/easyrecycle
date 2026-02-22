import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:boltuix/adapter/list_basic_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/model/people.dart';
import 'package:boltuix/widgets/toolbar.dart';
import 'package:boltuix/widgets/my_toast.dart';

class ButtonFabMoreText extends StatefulWidget {
  ButtonFabMoreText();

  @override
  ButtonFabMoreTextState createState() => new ButtonFabMoreTextState();
}

class ButtonFabMoreTextState extends State<ButtonFabMoreText> {
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

    return Scaffold(
      backgroundColor: MyColors.grey_5,
      appBar:
          CommonAppBar.getPrimaryAppbar(context, "FAB") as PreferredSizeWidget?,
      body: ListBasicAdapter(items, onItemClick).getView(),
      floatingActionButton: buildSpeedDial(
        children: [
          SpeedDialChild(
            elevation: 2,
            label: "Share",
            child: Icon(Icons.share, color: MyColors.grey_80),
            backgroundColor: Colors.white,
            onTap: () {},
          ),
          SpeedDialChild(
            elevation: 2,
            label: "Send Feedback",
            child: Icon(Icons.feedback, color: MyColors.grey_80),
            backgroundColor: Colors.white,
            onTap: () {},
          ),
          SpeedDialChild(
            elevation: 2,
            label: "Support",
            child: Icon(Icons.support, color: MyColors.grey_80),
            backgroundColor: Colors.white,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget buildSpeedDial({required List<SpeedDialChild> children}) {
    return SpeedDial(
      elevation: 2,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(color: Colors.white),
      curve: Curves.linear,
      overlayColor: Colors.black,
      overlayOpacity: 0.2,
      backgroundColor: MyColors.primary,
      children: children,
    );
  }
}
