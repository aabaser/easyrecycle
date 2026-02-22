import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/included/include_drawer_content.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/my_toast.dart';

class MenuDrawerMail extends StatefulWidget {
  MenuDrawerMail();

  @override
  MenuDrawerMailState createState() => new MenuDrawerMailState();
}

class MenuDrawerMailState extends State<MenuDrawerMail> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late BuildContext context;

  void onDrawerItemClicked(String name) {
    Navigator.pop(context);
    MyToast.show(name + " Selected", context);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      scaffoldKey.currentState!.openDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    Widget widget = Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: new AppBar(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          title: new Text("Drawer Mail"),
          backgroundColor: Colors.green[600],
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ]),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 190,
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      Img.get('bg_001.png'),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 14),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.grey[100],
                        child: CircleAvatar(
                          radius: 33,
                          backgroundImage: AssetImage(Img.get("image_001.png")),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("John Smith",
                                        style: MyText.body2(context)!.copyWith(
                                            color: Colors.grey[100],
                                            fontWeight: FontWeight.bold)),
                                    Container(height: 5),
                                    Text("johnsmith@mail.com",
                                        style: MyText.body2(context)!
                                            .copyWith(color: Colors.grey[100]))
                                  ],
                                ),
                              ),
                              InkWell(
                                child: Icon(Icons.arrow_drop_down,
                                    size: 24.0, color: Colors.white),
                                onTap: () {},
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
              Container(height: 8),
              ListTile(
                title: Text("All inboxes",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.grey[800], fontWeight: FontWeight.bold)),
                leading: Icon(Icons.move_to_inbox,
                    size: 25.0, color: Colors.grey[600]),
                trailing: Text("75",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.grey[700], fontWeight: FontWeight.w500)),
                onTap: () {
                  onDrawerItemClicked("All inboxes");
                },
              ),
              Divider(height: 0, color: Colors.lightGreenAccent),
              ListTile(
                title: Text("Inbox",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.grey[800], fontWeight: FontWeight.bold)),
                leading: Icon(Icons.inbox, size: 25.0, color: Colors.grey[600]),
                trailing: Text("68",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.grey[700], fontWeight: FontWeight.w500)),
                onTap: () {
                  onDrawerItemClicked("Inbox");
                },
              ),
              ListTile(
                title: Text("Priority inbox",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.grey[800], fontWeight: FontWeight.bold)),
                leading: Icon(Icons.label, size: 25.0, color: Colors.grey[600]),
                trailing: Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  color: Colors.green,
                  child: Text("3 new", style: TextStyle(color: Colors.white)),
                ),
                onTap: () {
                  onDrawerItemClicked("Priority inbox");
                },
              ),
              ListTile(
                title: Text("Social",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.grey[800], fontWeight: FontWeight.bold)),
                leading:
                    Icon(Icons.people, size: 25.0, color: Colors.grey[600]),
                trailing: Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  color: Colors.green,
                  child: Text("51 new", style: TextStyle(color: Colors.white)),
                ),
                onTap: () {
                  onDrawerItemClicked("Social");
                },
              ),
              Divider(height: 0, color: Colors.lightGreenAccent),
              ListTile(
                title: Text("Starred",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.grey[800], fontWeight: FontWeight.bold)),
                leading: Icon(Icons.star, size: 25.0, color: Colors.grey[600]),
                onTap: () {
                  onDrawerItemClicked("Starred");
                },
              ),
              ListTile(
                title: Text("Sent",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.grey[800], fontWeight: FontWeight.bold)),
                leading: Icon(Icons.send, size: 25.0, color: Colors.grey[600]),
                onTap: () {
                  onDrawerItemClicked("Sent");
                },
              ),
              ListTile(
                title: Text("Spam",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.grey[800], fontWeight: FontWeight.bold)),
                leading:
                    Icon(Icons.report, size: 25.0, color: Colors.grey[600]),
                trailing: Text("13",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.grey[700], fontWeight: FontWeight.w500)),
                onTap: () {
                  onDrawerItemClicked("Spam");
                },
              ),
              ListTile(
                title: Text("Trash",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.grey[800], fontWeight: FontWeight.bold)),
                leading:
                    Icon(Icons.delete, size: 25.0, color: Colors.grey[600]),
                onTap: () {
                  onDrawerItemClicked("Trash");
                },
              ),
              Divider(height: 0, color: Colors.lightGreenAccent),
              ListTile(
                title: Text("Settings",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.grey[800], fontWeight: FontWeight.bold)),
                leading:
                    Icon(Icons.settings, size: 25.0, color: Colors.grey[600]),
                onTap: () {
                  onDrawerItemClicked("Settings");
                },
              ),
              ListTile(
                title: Text("Help & Feedback",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.grey[800], fontWeight: FontWeight.bold)),
                leading: Icon(Icons.help_outline,
                    size: 25.0, color: Colors.grey[600]),
                onTap: () {
                  onDrawerItemClicked("Help & Feedback");
                },
              ),
            ],
          ),
        ),
      ),
      body: IncludeDrawerContent.get(context),
    );
    return widget;
  }
}
