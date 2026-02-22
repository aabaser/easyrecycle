import 'dart:async';

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class BackdropBasic extends StatefulWidget {
  BackdropBasic();

  @override
  BackdropBasicState createState() => new BackdropBasicState();
}

class BackdropBasicState extends State<BackdropBasic>
    with TickerProviderStateMixin {
  late BuildContext _scaffoldCtx;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(milliseconds: 500), () {
        Backdrop.of(_scaffoldCtx).revealBackLayer();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height + kToolbarHeight;

    return BackdropScaffold(
      backgroundColor: Colors.transparent,
      backLayerBackgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 300), value: 1),
      appBar: BackdropAppBar(
        titleSpacing: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        leading: BackdropToggleButton(
          color: Colors.white,
          icon: AnimatedIcons.menu_close,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      headerHeight: height / 2,
      frontLayerBorderRadius: BorderRadius.only(
          topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      frontLayerBackgroundColor: Colors.transparent,
      backLayer: Builder(
        builder: (BuildContext context) {
          _scaffoldCtx = context;
          return Container(
            padding: EdgeInsets.only(top: height / 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[800]!, Colors.green[400]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Back Layer Content",
                  style: MyText.headline(context)!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "This is where you can add options or settings.",
                  style:
                      MyText.subhead(context)!.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.settings_rounded, color: Colors.green),
                  label: Text("Manage Settings"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      frontLayerScrim: Colors.transparent,
      frontLayer: Container(
        padding: EdgeInsets.only(top: height / 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[100]!, Colors.green[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Front Layer Content",
              style: MyText.headline(context)!.copyWith(
                  color: MyColors.grey_80, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Tap the menu button above to reveal the back layer.",
              style: MyText.subhead(context)!.copyWith(color: MyColors.grey_60),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.info_rounded, color: Colors.white),
              label: Text("Learn More"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
