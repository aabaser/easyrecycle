import 'dart:async';

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/adapter/list_sectioned_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/model/people.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/my_toast.dart';
import 'package:boltuix/widgets/widget_size.dart';

class BackdropNavigationMail extends StatefulWidget {
  BackdropNavigationMail();

  @override
  BackdropNavigationState createState() => new BackdropNavigationState();
}

class BackdropNavigationState extends State<BackdropNavigationMail>
    with TickerProviderStateMixin {
  late BuildContext _scaffoldCtx;
  late List<People> items;
  double menuHeight = 0;

  void onItemClick(int index, People obj) {
    MyToast.show(obj.name!, context, duration: MyToast.LENGTH_SHORT);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(milliseconds: 500), () {
        Backdrop.of(_scaffoldCtx).revealBackLayer();
      });
    });

    items = Dummy.getPeopleData();
    items.addAll(Dummy.getPeopleData());
    items.addAll(Dummy.getPeopleData());

    int sectCount = 0;
    int sectIdx = 0;
    List<String> months = Dummy.getStringsMonth();
    for (int i = 0; i < items.length / 6; i++) {
      items.insert(sectCount, People.section(months[sectIdx], true));
      sectCount = sectCount + 5;
      sectIdx++;
    }
  }

  void closeFrontLayer() {
    Backdrop.of(_scaffoldCtx).concealBackLayer();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      backgroundColor: Colors.green[700],
      backLayerBackgroundColor: Colors.green[700],
      animationCurve: Curves.linear,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 300), value: 1),
      appBar: BackdropAppBar(
        title: Text("Email",
            style: MyText.title(context)!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
        iconTheme: IconThemeData(color: MyColors.grey_80),
        backgroundColor: Colors.green[700],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        leading: BackdropToggleButton(
            color: Colors.white, icon: AnimatedIcons.close_menu),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.more_vert_rounded, color: Colors.white),
              onPressed: () {}),
        ],
      ),
      headerHeight: 430,
      frontLayerBorderRadius: BorderRadius.only(
          topLeft: Radius.circular(6), topRight: Radius.circular(6)),
      backLayer: Builder(builder: (BuildContext context) {
        _scaffoldCtx = context;
        return Container(
          color: Colors.green[700],
          alignment: Alignment.topCenter,
          child: WidgetSize(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      closeFrontLayer();
                    },
                    child: ListTile(
                      leading: Icon(Icons.email, color: Colors.white),
                      title: Text("Unread",
                          style: MyText.subhead(context)!
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      closeFrontLayer();
                    },
                    child: ListTile(
                      leading: Icon(Icons.inbox, color: Colors.white),
                      title: Text("Inbox",
                          style: MyText.subhead(context)!
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      closeFrontLayer();
                    },
                    child: ListTile(
                      leading: Icon(Icons.bookmark, color: Colors.white),
                      title: Text("Bookmark",
                          style: MyText.subhead(context)!
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      closeFrontLayer();
                    },
                    child: ListTile(
                      leading: Icon(Icons.person, color: Colors.white),
                      title: Text("Social",
                          style: MyText.subhead(context)!
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                ),
                // New Menu Items
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      closeFrontLayer();
                    },
                    child: ListTile(
                      leading: Icon(Icons.warning_amber_rounded,
                          color: Colors.white),
                      title: Text("Spam",
                          style: MyText.subhead(context)!
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      closeFrontLayer();
                    },
                    child: ListTile(
                      leading: Icon(Icons.delete_rounded, color: Colors.white),
                      title: Text("Trash",
                          style: MyText.subhead(context)!
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
            onChange: (Size size) {
              setState(() {
                menuHeight = size.height;
              });
            },
          ),
        );
      }),
      frontLayerScrim: Colors.transparent,
      frontLayer: Container(
        color: Colors.white,
        alignment: Alignment.topCenter,
        child: ListSectionedAdapter(items, onItemClick).getView(),
      ),
    );
  }
}
