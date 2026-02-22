import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/included/include_drawer_content.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/my_toast.dart';

class MenuDrawerApp extends StatefulWidget {
  MenuDrawerApp();

  @override
  MenuDrawerAppState createState() => new MenuDrawerAppState();
}

class MenuDrawerAppState extends State<MenuDrawerApp> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late BuildContext context;
  bool isNotificationEnabled = true;

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
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        title: Text("App Menu"),
        backgroundColor: Colors.blue,
      ),
      drawer: Container(
        width: 260,
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(height: 30),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(Img.get("image_001.png")),
                    ),
                    SizedBox(width: 20),
                    Text("User Name",
                        style: MyText.body2(context)!.copyWith(
                            color: Colors.blueGrey[800],
                            fontWeight: FontWeight.w500)),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.logout, size: 20, color: Colors.blue),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Divider(height: 0),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text("Main",
                    style: MyText.body2(context)!
                        .copyWith(color: MyColors.grey_90)),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                leading: Icon(Icons.dashboard, size: 20, color: Colors.blue),
                minLeadingWidth: 0,
                dense: true,
                title: Text("Dashboard",
                    style: MyText.subhead(context)!
                        .copyWith(color: MyColors.grey_40)),
                onTap: () {
                  onDrawerItemClicked("Dashboard");
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                leading:
                    Icon(Icons.notifications, size: 20, color: Colors.blue),
                minLeadingWidth: 0,
                dense: true,
                title: Text("Notifications",
                    style: MyText.subhead(context)!
                        .copyWith(color: MyColors.grey_40)),
                trailing: Switch(
                  value: isNotificationEnabled,
                  onChanged: (value) {
                    setState(() {
                      isNotificationEnabled = value;
                    });
                  },
                  activeColor: Colors.blue,
                  inactiveThumbColor: Colors.grey,
                ),
                onTap: () {
                  onDrawerItemClicked("Notifications");
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                leading: Icon(Icons.chat, size: 20, color: Colors.blue),
                minLeadingWidth: 0,
                dense: true,
                title: Text("Messages",
                    style: MyText.subhead(context)!
                        .copyWith(color: MyColors.grey_40)),
                onTap: () {
                  onDrawerItemClicked("Messages");
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                leading:
                    Icon(Icons.shopping_cart, size: 20, color: Colors.blue),
                minLeadingWidth: 0,
                dense: true,
                title: Text("Products",
                    style: MyText.subhead(context)!
                        .copyWith(color: MyColors.grey_40)),
                onTap: () {
                  onDrawerItemClicked("Products");
                },
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text("Data",
                    style: MyText.body2(context)!
                        .copyWith(color: MyColors.grey_90)),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                leading: Icon(Icons.attach_money, size: 20, color: Colors.blue),
                minLeadingWidth: 0,
                dense: true,
                title: Text("Earnings",
                    style: MyText.subhead(context)!
                        .copyWith(color: MyColors.grey_40)),
                onTap: () {
                  onDrawerItemClicked("Earnings");
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                leading: Icon(Icons.bar_chart, size: 20, color: Colors.blue),
                minLeadingWidth: 0,
                dense: true,
                title: Text("Reports",
                    style: MyText.subhead(context)!
                        .copyWith(color: MyColors.grey_40)),
                trailing: Icon(Icons.chevron_right, color: Colors.blue),
                onTap: () {
                  onDrawerItemClicked("Reports");
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                leading: Icon(Icons.people, size: 20, color: Colors.blue),
                minLeadingWidth: 0,
                dense: true,
                title: Text("Users",
                    style: MyText.subhead(context)!
                        .copyWith(color: MyColors.grey_40)),
                onTap: () {
                  onDrawerItemClicked("Users");
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                leading: Icon(Icons.analytics, size: 20, color: Colors.blue),
                minLeadingWidth: 0,
                dense: true,
                title: Text("Analytics",
                    style: MyText.subhead(context)!
                        .copyWith(color: MyColors.grey_40)),
                onTap: () {
                  onDrawerItemClicked("Analytics");
                },
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text("Others",
                    style: MyText.body2(context)!
                        .copyWith(color: MyColors.grey_90)),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                leading: Icon(Icons.security, size: 20, color: Colors.blue),
                minLeadingWidth: 0,
                dense: true,
                title: Text("Security",
                    style: MyText.subhead(context)!
                        .copyWith(color: MyColors.grey_40)),
                onTap: () {
                  onDrawerItemClicked("Security");
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                leading:
                    Icon(Icons.account_circle, size: 20, color: Colors.blue),
                minLeadingWidth: 0,
                dense: true,
                title: Text("Profile",
                    style: MyText.subhead(context)!
                        .copyWith(color: MyColors.grey_40)),
                onTap: () {
                  onDrawerItemClicked("Profile");
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
