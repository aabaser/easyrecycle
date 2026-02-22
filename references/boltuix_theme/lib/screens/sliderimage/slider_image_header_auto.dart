import 'dart:async';
import 'package:flutter/material.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/model/model_image.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/toolbar.dart';

class SliderImageHeaderAuto extends StatefulWidget {
  SliderImageHeaderAuto();

  @override
  SliderImageHeaderAutoState createState() => new SliderImageHeaderAutoState();
}

class SliderImageHeaderAutoState extends State<SliderImageHeaderAuto> {
  static const int MAX = 5;
  List<ModelImage> items = Dummy.getModelImage();
  int page = 0;
  Timer? timer;
  late ModelImage curObj;

  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    curObj = items[0];
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      page = page + 1;
      if (page >= MAX) page = 0;
      pageController.animateToPage(page,
          duration: Duration(milliseconds: 200), curve: Curves.linear);
      setState(() {
        curObj = items[page];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null && timer!.isActive) timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar.getPrimarySettingAppbar(
          context, "Auto header slider image") as PreferredSizeWidget?,
      body: Stack(
        children: <Widget>[
          PageView(
            controller: pageController,
            children: getImagesHeader(),
            onPageChanged: onPageViewChange,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.7)
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(curObj.name,
                      style:
                          MyText.medium(context).copyWith(color: Colors.white)),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on, size: 10, color: Colors.white),
                      SizedBox(width: 5),
                      Text(curObj.brief, style: TextStyle(color: Colors.white)),
                      Spacer(),
                      PageIndicator(
                        pageCount: MAX,
                        currentPage: page,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onPageViewChange(int _page) {
    page = _page;
    setState(() {});
  }

  List<Widget> getImagesHeader() {
    return items
        .map((mi) => Image.asset(Img.get(mi.image), fit: BoxFit.cover))
        .toList();
  }
}

class PageIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPage;

  PageIndicator({required this.pageCount, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children:
          List.generate(pageCount, (index) => _buildDot(index == currentPage)),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        color: isActive ? Colors.greenAccent : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.green, width: 1.5),
      ),
    );
  }
}
