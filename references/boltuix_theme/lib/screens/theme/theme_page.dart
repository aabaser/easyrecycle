import 'package:flutter/material.dart';

import '../../widgets/toolbar.dart';
import 'components/animated_toggle_button.dart';
import 'model/theme_color.dart';

class ThemePage extends StatefulWidget {
  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isDarkMode = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ThemeColor lightMode = ThemeColor(
    gradient: [
      const Color(0xDDFF0080),
      const Color(0xDDFF8C00),
    ],
    backgroundColor: const Color(0xFFFFFFFF),
    textColor: const Color(0xFF000000),
    toggleButtonColor: const Color(0xFFFFFFFF),
    toggleBackgroundColor: const Color(0xFFe7e7e8),
    shadow: const [
      BoxShadow(
        color: const Color(0xFFd8d7da),
        spreadRadius: 5,
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  );

  ThemeColor darkMode = ThemeColor(
    gradient: [
      const Color(0xFF8983F7),
      const Color(0xFFA3DAFB),
    ],
    backgroundColor: const Color(0xFF26242e),
    textColor: const Color(0xFFFFFFFF),
    toggleButtonColor: const Color(0xFf34323d),
    toggleBackgroundColor: const Color(0xFF222029),
    shadow: const <BoxShadow>[
      BoxShadow(
        color: const Color(0x66000000),
        spreadRadius: 5,
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  );

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    super.initState();
  }

  changeThemeMode() {
    if (isDarkMode) {
      _animationController.forward(from: 0.0);
    } else {
      _animationController.reverse(from: 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar.getPrimarySettingAppbar(context, "Dark/Light Theme")
          as PreferredSizeWidget?,
      key: _scaffoldKey,
      backgroundColor:
          isDarkMode ? darkMode.backgroundColor : lightMode.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Use constraints to adjust UI based on screen size
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;

            // Check if it's a web view
            bool isWebView = width > 600;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWebView ? width * 0.2 : 20,
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: height * 0.1),
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          width: isWebView ? width * 0.2 : width * 0.35,
                          height: isWebView ? width * 0.2 : width * 0.35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: isDarkMode
                                  ? darkMode.gradient
                                  : lightMode.gradient,
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(40, 0),
                          child: ScaleTransition(
                            scale: _animationController.drive(
                              Tween<double>(begin: 0.0, end: 1.0).chain(
                                CurveTween(curve: Curves.decelerate),
                              ),
                            ),
                            alignment: Alignment.topRight,
                            child: Container(
                              width: isWebView ? width * 0.15 : width * 0.26,
                              height: isWebView ? width * 0.15 : width * 0.26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDarkMode
                                    ? darkMode.backgroundColor
                                    : lightMode.backgroundColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.1),
                    Text(
                      'Choose a style',
                      style: TextStyle(
                        color: isDarkMode
                            ? darkMode.textColor
                            : lightMode.textColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.7,
                      child: Text(
                        'Pop or subtle. Day or night. Customize your interface',
                        style: TextStyle(
                          color: isDarkMode
                              ? darkMode.textColor
                              : lightMode.textColor,
                          fontSize: 14.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    AnimatedToggle(
                      values: const ['Light', 'Dark'],
                      textColor:
                          isDarkMode ? darkMode.textColor : lightMode.textColor,
                      backgroundColor: isDarkMode
                          ? darkMode.toggleBackgroundColor
                          : lightMode.toggleBackgroundColor,
                      buttonColor: isDarkMode
                          ? darkMode.toggleButtonColor
                          : lightMode.toggleButtonColor,
                      shadows: isDarkMode ? darkMode.shadow : lightMode.shadow,
                      onToggleCallback: (index) {
                        isDarkMode = !isDarkMode;
                        setState(() {});
                        changeThemeMode();
                      },
                    ),
                    SizedBox(height: height * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildDot(
                          width: width * 0.02,
                          height: width * 0.02,
                          color: const Color(0xFFd9d9d9),
                        ),
                        buildDot(
                          width: width * 0.05,
                          height: width * 0.02,
                          color: !isDarkMode
                              ? darkMode.backgroundColor
                              : lightMode.backgroundColor,
                        ),
                        buildDot(
                          width: width * 0.02,
                          height: width * 0.02,
                          color: const Color(0xFFd9d9d9),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Container buildDot({double? width, double? height, Color? color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: width,
      height: height,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: color,
      ),
    );
  }
}
