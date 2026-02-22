import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppAboutScree extends StatefulWidget {
  const AppAboutScree({super.key});

  @override
  State<AppAboutScree> createState() => _AppAboutScreeState();
}

class _AppAboutScreeState extends State<AppAboutScree> {
  bool isSignInDialogShown = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.0,
            bottom: 350,
            left: 100,
            child: ZoomableRotatingImage(
              imageUrl: 'assets/images/3d.png',
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
              child: const SizedBox(),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 240),
            top: isSignInDialogShown ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    Spacer(),
                    SizedBox(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Bolt Ui",
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontFamily: "Jost",
                                    height: 1.2,
                                    letterSpacing: 2,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "X",
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontFamily: "Jost",
                                    height: 1.2,
                                    letterSpacing: 2,
                                    color: Colors.pink,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            "Let us build beautiful product, Start your Flutter journey today!",
                            style: TextStyle(
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Text(
                        "Ver 1.2025.1",
                        style: TextStyle(color: Color(0xFF2A5CFF)),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/images/space2.svg',
            width: double.infinity,
            height: double.infinity,
          ),
          /*   Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () {
                // Define what happens when the close button is pressed
                Navigator.of(context).pop();
              },
              color: Colors.transparent,
            ),
          ),*/
        ],
      ),
    );
  }
}

class AnimatedAlphaGradientImage extends StatefulWidget {
  @override
  _AnimatedAlphaGradientImageState createState() =>
      _AnimatedAlphaGradientImageState();
}

class _AnimatedAlphaGradientImageState extends State<AnimatedAlphaGradientImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black],
                stops: [_animation.value, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: SvgPicture.asset(
              'assets/banner/space2.svg',
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}

class RotatingImageAnimation extends StatefulWidget {
  @override
  _RotatingImageAnimationState createState() => _RotatingImageAnimationState();
}

class _RotatingImageAnimationState extends State<RotatingImageAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: 2 * 3.14159265359 * animationController.value,
            child: SvgPicture.asset(
              'triangle.svg',
              width: 100,
              height: 100,
            ),
          );
        },
      ),
    );
  }
}

class ZoomableRotatingImage extends StatefulWidget {
  final String imageUrl;

  ZoomableRotatingImage({required this.imageUrl});

  @override
  _ZoomableRotatingImageState createState() => _ZoomableRotatingImageState();
}

class _ZoomableRotatingImageState extends State<ZoomableRotatingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    _rotationAnimation = Tween(begin: -0.1, end: 0.1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _scale = 1.2;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Image.asset(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
