import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/adapter/grid_album_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/data/my_strings.dart';
import 'package:boltuix/model/image_obj.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/toolbar.dart';

class MotionPageBasicRoute extends StatefulWidget {
  MotionPageBasicRoute();

  @override
  MotionPageBasicRouteState createState() => new MotionPageBasicRouteState();
}

class MotionPageBasicRouteState extends State<MotionPageBasicRoute> {
  late BuildContext _scaffoldCtx;
  bool slow = true;

  void onItemClick(int index, ImageObj obj) {
    Navigator.push(
        _scaffoldCtx,
        PageRouteBuilder(
            transitionDuration: Duration(milliseconds: slow ? 800 : 1000),
            pageBuilder: (_, __, ___) => MotionPageDetails(index, obj)));
    slow = !slow;
  }

  @override
  Widget build(BuildContext context) {
    List<ImageObj> items = Dummy.getImageDate();
    items.addAll(Dummy.getImageDate());

    return new Scaffold(
      backgroundColor: Colors.grey[200],
      appBar:
          CommonAppBar.getPrimarySettingAppbar(context, "Album", light: true)
              as PreferredSizeWidget?,
      body: new Builder(builder: (BuildContext context) {
        _scaffoldCtx = context;
        return GridAlbumAdapter(items, onItemClick).getView();
      }),
    );
  }
}

class MotionPageDetails extends StatelessWidget {
  final int index;
  final ImageObj obj;

  MotionPageDetails(this.index, this.obj);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Hero(
                  tag: index.toString(),
                  child: Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          Img.get(obj.image),
                          fit: BoxFit
                              .cover, // Ensures the image is cropped to fit
                          height: 350,
                          width: double
                              .infinity, // You can specify width as needed
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                          alignment: Alignment.centerLeft,
                          height: 55,
                          color: Colors.black.withOpacity(0.5),
                          child: Text(obj.name,
                              style: MyText.title(context)!
                                  .copyWith(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search_rounded),
                  onPressed: () {},
                ), // overflow menu
                IconButton(
                  icon: Icon(Icons.more_vert_rounded),
                  onPressed: () {},
                ),
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(MyStrings.very_long_lorem_ipsum,
                    textAlign: TextAlign.justify,
                    style: MyText.medium(context).copyWith(
                      color: MyColors.grey_60,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
