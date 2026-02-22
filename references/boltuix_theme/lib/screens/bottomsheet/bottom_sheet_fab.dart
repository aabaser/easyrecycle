import 'package:flutter/material.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class BottomSheetFabAppSetting extends StatefulWidget {
  BottomSheetFabAppSetting();

  @override
  BottomSheetFabAppSettingState createState() =>
      new BottomSheetFabAppSettingState();
}

class BottomSheetFabAppSettingState extends State<BottomSheetFabAppSetting> {
  late PersistentBottomSheetController sheetController;
  late BuildContext _scaffoldCtx;
  bool showSheet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.grey_5,
      appBar: AppBar(
        title: Text("App Settings", style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Builder(builder: (BuildContext ctx) {
        _scaffoldCtx = ctx;
        return Center(
          child: Text("Press button below to open settings",
              textAlign: TextAlign.center,
              style:
                  MyText.display1(context)!.copyWith(color: Colors.grey[500])),
        );
      }),
      floatingActionButton: FloatingActionButton(
          heroTag: "fab",
          backgroundColor: Colors.blue[500],
          elevation: 3,
          child: Icon(
            showSheet
                ? Icons.arrow_downward_rounded
                : Icons.arrow_upward_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              showSheet = !showSheet;
              if (showSheet) {
                _showSheet();
              } else {
                Navigator.pop(_scaffoldCtx);
              }
            });
          }),
    );
  }

  void _showSheet() {
    sheetController = showBottomSheet(
        context: _scaffoldCtx,
        builder: (BuildContext bc) {
          return Card(
            elevation: 10,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                          width: 30,
                          height: 5,
                          decoration: BoxDecoration(
                            color: MyColors.grey_10,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          )),
                    ),
                    Container(height: 10),
                    Row(
                      children: <Widget>[
                        Container(width: 50),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("App Settings",
                                  style: MyText.headline(context)!
                                      .copyWith(color: Colors.grey[800])),
                              Container(height: 20),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.settings,
                                      color: Colors.blue, size: 18),
                                  Container(width: 5),
                                  Text("Configure your preferences",
                                      style: MyText.medium(context)),
                                ],
                              ),
                              Container(height: 5),
                              Divider(height: 0, color: Colors.black12),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text("Adjust app settings",
                                    style: MyText.medium(context)
                                        .copyWith(color: Colors.grey)),
                              ),
                              Divider(height: 0, color: Colors.black12),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Container(width: 10),
                          Icon(Icons.notifications_rounded, color: Colors.blue),
                          Container(width: 20),
                          Text("Manage notifications",
                              style: MyText.medium(context)
                                  .copyWith(color: MyColors.grey_90)),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Container(width: 10),
                          Icon(Icons.privacy_tip_rounded, color: Colors.blue),
                          Container(width: 20),
                          Text("Privacy settings",
                              style: MyText.medium(context)
                                  .copyWith(color: MyColors.grey_90)),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Container(width: 10),
                          Icon(Icons.update_rounded, color: Colors.blue),
                          Container(width: 20),
                          Text("Check for updates",
                              style: MyText.medium(context)
                                  .copyWith(color: MyColors.grey_90)),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        });
    sheetController.closed.then((value) {
      setState(() {
        showSheet = false;
      });
    });
  }
}
