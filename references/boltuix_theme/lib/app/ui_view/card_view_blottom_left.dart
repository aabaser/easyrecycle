import 'package:flutter/material.dart';
import '../bottom_navigation_view/bottom_bar_view.dart';
import '../flutter_pro_uix_app_theme.dart';

class CardViewBottomRight extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const CardViewBottomRight(
      {Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      HexColor("#2727FF"),
                      HexColor("#7E7EFF"),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(68.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: FlutterBoltuixAppTheme.grey.withOpacity(0.6),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0,
                    ),
                    BoxShadow(
                      color:
                          Colors.purple.withOpacity(0.2), // Add purple shadow
                      offset: Offset(4.0, 4.0), // Position of the purple shadow
                      blurRadius: 15.0, // Spread of the purple shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Flutter Boltuix - App template',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: FlutterBoltuixAppTheme.fontName,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 0.0,
                          color: FlutterBoltuixAppTheme.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Let us Create Beautiful products together.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: FlutterBoltuixAppTheme.fontName,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            letterSpacing: 0.0,
                            color: FlutterBoltuixAppTheme.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Are you ready to build the next innovation generation project with us?',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: FlutterBoltuixAppTheme.fontName,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 0.0,
                            color: FlutterBoltuixAppTheme.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
