import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/adapter/grid_music_card_album.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/data/my_strings.dart';
import 'package:boltuix/model/music_album.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/toolbar.dart';

class MotionCardRoute extends StatefulWidget {
  MotionCardRoute();

  @override
  MotionCardRouteState createState() => new MotionCardRouteState();
}

class MotionCardRouteState extends State<MotionCardRoute> {
  late BuildContext _scaffoldCtx;
  bool slow = true;

  void onItemClick(int index, MusicAlbum obj) {
    Navigator.push(
        _scaffoldCtx,
        PageRouteBuilder(
            transitionDuration: Duration(milliseconds: slow ? 500 : 1000),
            pageBuilder: (_, __, ___) => MotionCardDetails(index, obj)));
    slow = !slow;
  }

  @override
  Widget build(BuildContext context) {
    List<MusicAlbum> items = Dummy.getMusicAlbum();

    return new Scaffold(
      backgroundColor: Colors.grey[200],
      appBar:
          CommonAppBar.getPrimarySettingAppbar(context, "Album", light: true)
              as PreferredSizeWidget?,
      body: new Builder(builder: (BuildContext context) {
        _scaffoldCtx = context;
        return GridMusicCardAlbum(items, onItemClick).getView();
      }),
    );
  }
}

class MotionCardDetails extends StatelessWidget {
  final int index;
  final MusicAlbum obj;

  MotionCardDetails(this.index, this.obj);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: index.toString(),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.green[800],
                expandedHeight: 400.0,
                systemOverlayStyle:
                    SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Stack(
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
                          height: 130,
                          color: Colors.green[800],
                          child: Stack(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(obj.name,
                                      style: MyText.display1(context)!
                                          .copyWith(color: Colors.white)),
                                  Container(height: 5),
                                  Text(obj.brief,
                                      style: MyText.subhead(context)!
                                          .copyWith(color: Colors.white)),
                                ],
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                transform:
                                    Matrix4.translationValues(0.0, -25.0, 0.0),
                                child: FloatingActionButton(
                                  heroTag: null,
                                  backgroundColor: Colors.amber[700],
                                  elevation: 1,
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
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
      ),
    );
  }
}
