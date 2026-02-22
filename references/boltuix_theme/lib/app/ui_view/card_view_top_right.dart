import 'package:flutter/material.dart';
import '../flutter_pro_uix_app_theme.dart';

class WorkoutView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const WorkoutView({Key? key, this.animationController, this.animation})
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
                      Color(0xFFFD4685),
                      Color(0xFF6A88E5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(68.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0xFFFD4685)
                          .withOpacity(0.3), // Shadow matching gradient start
                      offset: Offset(2.0, 2.0),
                      blurRadius: 10.0,
                    ),
                    BoxShadow(
                      color: Color(0xFF6A88E5)
                          .withOpacity(0.2), // Shadow matching gradient end
                      offset: Offset(-2.0, -2.0),
                      blurRadius: 15.0,
                    ),
                    BoxShadow(
                      color: Colors.purple.withOpacity(
                          0.1), // Additional purple shadow for depth
                      offset: Offset(4.0, 4.0),
                      blurRadius: 15.0,
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
                          'Download instruction',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: FlutterBoltuixAppTheme.fontName,
                            fontWeight:
                                FontWeight.bold, // Emphasize the heading
                            fontSize: 16,
                            letterSpacing: 0.0,
                            color: FlutterBoltuixAppTheme.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          '• Purchase Version 1 to receive all updates in the Version 1 series at no additional cost.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: FlutterBoltuixAppTheme.fontName,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            letterSpacing: 0.0,
                            color: FlutterBoltuixAppTheme.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Please share your invoice ID to get the download template link via mail. You will receive the full source code.',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: FlutterBoltuixAppTheme.fontName,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  color: FlutterBoltuixAppTheme.white,
                                ),
                              ),
                            ),
                          ],
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
