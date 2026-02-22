import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../data/img.dart';
import '../flutter_pro_uix_app_theme.dart';
import 'meals_list_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 9;

    listViews.add(
      Align(
        alignment: Alignment.center,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Image.asset(Img.get('logo.png'),
                height: 200, width: 200, fit: BoxFit.cover)

            /*ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Color(0xFF6A88E5),
                Color(0xFFFD4685),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds),
            blendMode: BlendMode.srcIn, // Tint the Lottie animation
            child: Lottie.asset(
              'assets/anim/logo.json',
              fit: BoxFit.cover,
              repeat: true,
              height: 180,
            ),
          )*/

            ),
      ),
    );

/* Color(0xFFFD4685),
                Color(0xFFFE5A87),
                Color(0xFFFE7689),
                Color(0xFFFE5A87),
                Color(0xFFFD4685),*/
    listViews.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                /*   FitnessAppTheme.nearlyDarkBlue,
                HexColor('#6A88E5'),*/
                Color(0xFF6A88E5),
                Color(0xFFFD4685),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: Text(
            'Flutter Boltuix App Templates',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: FlutterBoltuixAppTheme.fontName,
              fontWeight: FontWeight.bold,
              fontSize: 35,
              letterSpacing: 0.0,
            ),
          ),
        ),
      ),
    );

    listViews.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Templates Built for Android, iOS, and Web.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: FlutterBoltuixAppTheme.fontName,
          fontWeight: FontWeight.normal,
          fontSize: 16,
          letterSpacing: 0.0,
        ),
      ),
    ));

    listViews.add(
      SizedBox(height: 30.0),
    );
    /* listViews.add(
      TitleView(
        titleTxt: 'Templates',
        subTxt: 'Ver 1.2024.1',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );*/

    listViews.add(
      SizedBox(height: 30.0),
    );
    listViews.add(
      MealsListView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );

/*
    listViews.add(
      RunningView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
*/

    listViews.add(
      SizedBox(height: 30.0),
    );
    /* listViews.add(
      Image.asset(
          Img.get("3d.png"), height: 125, width: 25
      ),
    );*/
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FlutterBoltuixAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: <Widget>[
                  getMainListViewUI(),
                  //getAppBarUI(),
                ],
              ),
            ),
            // Footer with GlassView
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        FlutterBoltuixAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FlutterBoltuixAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Flutter Boltuix - App template',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: FlutterBoltuixAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: FlutterBoltuixAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class GradientLottieLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Color(0xFF6A88E5),
              Color(0xFFFD4685),
              Color(0xFFFE5A87),
              Color(0xFFFE7689),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          blendMode: BlendMode.srcIn, // Ensures the gradient applies as a tint
          child: Lottie.asset(
            'assets/anim/logo.json',
            fit: BoxFit.cover,
            repeat: true,
            height: 200,
          ),
        ),
      ),
    );
  }
}
