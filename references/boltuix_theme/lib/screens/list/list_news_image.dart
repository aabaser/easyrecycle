import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/adapter/list_news_image_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/model/news.dart';
import 'package:boltuix/widgets/my_toast.dart';

class ListNewsImage extends StatefulWidget {
  ListNewsImage();

  @override
  ListNewsImageState createState() => new ListNewsImageState();
}

class ListNewsImageState extends State<ListNewsImage> {
  late BuildContext context;
  void onItemClick(int index, News obj) {
    MyToast.show("News " + index.toString() + "clicked", context,
        duration: MyToast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    List<News> items = Dummy.getNewsData(10);
    return Scaffold(
      backgroundColor: Colors.green,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
              backgroundColor: Colors.green[900],
              title:
                  Text("News Image", style: TextStyle(color: MyColors.grey_10)),
              leading: IconButton(
                icon: Icon(Icons.menu_rounded, color: MyColors.grey_10),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search_rounded, color: MyColors.grey_10),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.more_vert_rounded, color: MyColors.grey_10),
                  onPressed: () {},
                ), // overflow menu
              ]),
          ListNewsImageAdapter(items, onItemClick).getView()
        ],
      ),
    );
  }
}
