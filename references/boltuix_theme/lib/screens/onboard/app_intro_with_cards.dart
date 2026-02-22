import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/model/wizard.dart';
import 'package:boltuix/widgets/my_text.dart';

class AppIntroCardsBackgroundAbstract extends StatefulWidget {
  AppIntroCardsBackgroundAbstract();

  @override
  AppIntroCardsBackgroundAbstractState createState() =>
      new AppIntroCardsBackgroundAbstractState();
}

class AppIntroCardsBackgroundAbstractState
    extends State<AppIntroCardsBackgroundAbstract> {
  List<Wizard> wizardData = Dummy.getWizard();
  PageController pageController = PageController(
    initialPage: 0,
  );
  int page = 0;
  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(color: Colors.grey[100])),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/bg_abstract.svg',
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fitHeight,
            ),
            Container(color: Color(0xffCCFFFFFF).withOpacity(0.8)),
            Column(children: <Widget>[
              Expanded(
                child: PageView(
                  onPageChanged: onPageViewChange,
                  controller: pageController,
                  children: buildPageViewItem(),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 60,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: buildDots(context),
                  ),
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }

  void onPageViewChange(int _page) {
    page = _page;
    isLast = _page == wizardData.length - 1;
    setState(() {});
  }

  List<Widget> buildPageViewItem() {
    List<Widget> widgets = [];
    for (Wizard wz in wizardData) {
      Widget wg = Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Wrap(
          children: <Widget>[
            Container(
                width: 280,
                height: 370,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 2,
                  child: Stack(
                    children: <Widget>[
                      Image.asset(Img.get(wz.background),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover),
                      Container(color: Colors.white),
                      Column(
                        children: <Widget>[
                          Container(height: 35),
                          Text(wz.title,
                              style: MyText.title(context)!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            child: Text(wz.brief,
                                textAlign: TextAlign.center,
                                style: MyText.subhead(context)!
                                    .copyWith(color: Colors.black)),
                          ),
                          Expanded(
                            child: Image.asset(Img.get(wz.image),
                                width: 150, height: 150),
                          ),
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.pink[600],
                                  elevation: 0),
                              child: Text(isLast ? "Get Started" : "Next",
                                  style: MyText.subhead(context)!
                                      .copyWith(color: Colors.pink)),
                              onPressed: () {
                                if (isLast) {
                                  Navigator.pop(context);
                                  return;
                                }
                                pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeOut);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      );
      widgets.add(wg);
    }
    return widgets;
  }

  Widget buildDots(BuildContext context) {
    Widget widget;

    List<Widget> dots = [];
    for (int i = 0; i < wizardData.length; i++) {
      Widget w = Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: 8,
        width: 8,
        child: CircleAvatar(
          backgroundColor: page == i ? Colors.pink[600] : Colors.grey,
        ),
      );
      dots.add(w);
    }
    widget = Row(
      mainAxisSize: MainAxisSize.min,
      children: dots,
    );
    return widget;
  }
}
