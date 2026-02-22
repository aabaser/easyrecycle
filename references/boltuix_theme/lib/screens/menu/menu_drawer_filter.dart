import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/adapter/list_news_light_hrzntl_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/model/news.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/my_toast.dart';

class MenuDrawerFilter extends StatefulWidget {
  MenuDrawerFilter();

  @override
  MenuDrawerFilterState createState() => new MenuDrawerFilterState();
}

class MenuDrawerFilterState extends State<MenuDrawerFilter> {
  late BuildContext _scaffoldCtx;
  TextStyle textStyle =
      TextStyle(color: Colors.pink[300], height: 1.4, fontSize: 16);
  TextStyle labelStyle = TextStyle(color: Colors.pink[300]);
  UnderlineInputBorder lineStyle1 = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.pink[300]!, width: 1));
  UnderlineInputBorder lineStyle2 = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.pink[300]!, width: 2));

  double value1 = 0.3;
  bool isSwitched1 = true, isSwitched2 = false;
  void setValue1(double value) => setState(() => value1 = value);

  void onItemClick(int index, News obj) {
    MyToast.show("News " + index.toString() + "clicked", context,
        duration: MyToast.LENGTH_SHORT);
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
    List<News> items = Dummy.getNewsData(10);

    return new Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          titleSpacing: 0,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Search Result",
              style: MyText.title(context)!.copyWith(color: Colors.white)),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.sort_rounded),
                onPressed: () {
                  Scaffold.of(_scaffoldCtx).openEndDrawer();
                }),
          ]),
      body: Builder(builder: (BuildContext context) {
        _scaffoldCtx = context;
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ListNewsLightHrzntlAdapter(items, onItemClick).getWidgetView(),
        );
      }),
      endDrawer: Container(
        width: 250,
        child: Container(
          color: MyColors.grey_5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(height: 35),
              Container(
                color: Colors.white,
                width: double.infinity,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25),
                  title: Text("Filter by",
                      style: MyText.title(context)!.copyWith(
                          color: Colors.green, fontWeight: FontWeight.w500)),
                  trailing:
                      Icon(Icons.close_rounded, size: 20, color: Colors.green),
                  onTap: () {},
                ),
              ),
              Container(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text("Keyword",
                    style: MyText.body1(context)!
                        .copyWith(color: MyColors.grey_80)),
              ),
              Container(
                height: 40,
                color: Colors.white,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 15),
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  maxLines: 1,
                  controller: TextEditingController(text: "Lorem ipsum"),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(-12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text("Variant",
                    style: MyText.body1(context)!
                        .copyWith(color: MyColors.grey_80)),
              ),
              Container(
                  color: Colors.white,
                  height: 40,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text("Select variant",
                          style: MyText.subhead(context)!
                              .copyWith(color: MyColors.grey_40)),
                      Spacer(),
                      Icon(Icons.chevron_right_rounded,
                          size: 20, color: Colors.green)
                    ],
                  )),
              Container(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text("Location, city & area",
                    style: MyText.body1(context)!
                        .copyWith(color: MyColors.grey_80)),
              ),
              Container(
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Container(
                        height: 45,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text("Select location",
                                style: MyText.subhead(context)!
                                    .copyWith(color: MyColors.grey_40)),
                            Spacer(),
                            Icon(Icons.chevron_right_rounded,
                                size: 20, color: Colors.green)
                          ],
                        ),
                      ),
                      Divider(height: 0, color: Colors.lightGreenAccent),
                      Container(
                        height: 45,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text("Select city",
                                style: MyText.subhead(context)!
                                    .copyWith(color: MyColors.grey_20)),
                            Spacer(),
                            Icon(Icons.chevron_right_rounded,
                                size: 20, color: Colors.green)
                          ],
                        ),
                      ),
                      Divider(height: 0, color: Colors.lightGreenAccent),
                      Container(
                        height: 45,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text("Select area",
                                style: MyText.subhead(context)!
                                    .copyWith(color: MyColors.grey_20)),
                            Spacer(),
                            Icon(Icons.chevron_right_rounded,
                                size: 20, color: Colors.green)
                          ],
                        ),
                      ),
                    ],
                  )),
              Container(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text("Event",
                    style: MyText.body1(context)!
                        .copyWith(color: MyColors.grey_80)),
              ),
              Container(
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 45,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text("Promo",
                                style: MyText.subhead(context)!
                                    .copyWith(color: MyColors.grey_40)),
                            Spacer(),
                            Switch(
                              value: isSwitched1,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched1 = value;
                                });
                              },
                              activeColor: Colors.green,
                              inactiveThumbColor: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child:
                            Divider(height: 0, color: Colors.lightGreenAccent),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 45,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text("Agency",
                                style: MyText.subhead(context)!
                                    .copyWith(color: MyColors.grey_40)),
                            Spacer(),
                            Switch(
                              value: isSwitched2,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched2 = value;
                                });
                              },
                              activeColor: Colors.green,
                              inactiveThumbColor: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade700, Colors.greenAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                width: double.infinity,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25),
                  title: Text(
                    "APPLY",
                    textAlign: TextAlign.center,
                    style: MyText.subhead(context)!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
