import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/adapter/my_files_adapter.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/model/folder_file.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/my_toast.dart';

class ProgressLinearTop extends StatefulWidget {
  ProgressLinearTop();

  @override
  ProgressLinearTopState createState() => ProgressLinearTopState();
}

class ProgressLinearTopState extends State<ProgressLinearTop> {
  late BuildContext context;
  List<FolderFile> items = [];
  bool finishLoading = false;
  double progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    items.add(FolderFile.section("Today")); // add section
    items.add(FolderFile("Photos", "Jan 9, 2024", Icons.folder_rounded, true));
    items.add(
        FolderFile("London Trip", "Feb 22, 2024", Icons.folder_rounded, true));
    items.add(FolderFile("Work", "May 28, 2024", Icons.folder_rounded, true));
    items.add(FolderFile.section("")); // add section
    delayShowingList();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        iconTheme: IconThemeData(color: MyColors.primary),
        title: Text(
          "To do",
          style: MyText.title(context)!.copyWith(color: MyColors.primary),
        ),
        flexibleSpace: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 3, // Ensure the container has sufficient height
                child: finishLoading
                    ? Container() // Hide when loading is finished
                    : LinearProgressIndicator(
                        value: progressValue,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            MyColors.primaryLight),
                        backgroundColor: Colors.black.withOpacity(0.1),
                      ),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                finishLoading = false;
              });
              delayShowingList();
            },
          ), // overflow menu
          PopupMenuButton<String>(
            onSelected: (String value) {},
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "Settings",
                child: Text("Settings"),
              ),
            ],
          )
        ],
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedOpacity(
          opacity: finishLoading ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: buildList(context),
        ),
      ],
    );
  }

  void onItemClick(int index, FolderFile obj) {
    MyToast.show(obj.name, context, duration: MyToast.LENGTH_SHORT);
  }

  Widget buildList(BuildContext context) {
    return MyFilesAdapter(items, onItemClick).getView();
  }

  void delayShowingList() {
    progressValue = 0.0;
    const oneSec = const Duration(milliseconds: 300);
    Timer.periodic(oneSec, (Timer t) {
      setState(() {
        progressValue += 0.2;
        // we "finish" downloading here
        if (progressValue > 1.0) {
          progressValue = 0.0;
          finishLoading = true;
          t.cancel();
        }
      });
    });
  }
}
