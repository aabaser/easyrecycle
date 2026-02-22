import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:math';

import 'home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10), // Slow rotation
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffffffff), Color(0xffffe7e3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/app_shop/framboises.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(23),
                        bottomRight: Radius.circular(23),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xffffffff), Color(0xfff5f5f5)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            SizedBox(
              child: Column(children: [
                const Spacer(),
                Container(
                  width: double.infinity,
                  height: 100,
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/app_shop/logo-kusmi.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  height: 60,
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  child: const Text(
                    "Discover our must-haves to enjoy\nat any time of the day!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.4,
                      height: 1.35,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                const Spacer(),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 42,
                      ),
                      child: Material(
                        elevation: 10,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(35)),
                        child: Container(
                          width: double.infinity,
                          height: 235,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(35)),
                          ),
                          child: Column(children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 20,
                                ),
                                child: const Text(
                                  "Discover\nnew\nflavors",
                                  style: TextStyle(
                                    color: Color(0xff333d47),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    letterSpacing: 1.4,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 20,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child: const Home(),
                                      ),
                                    );
                                  },
                                  child: Material(
                                    elevation: 10,
                                    shadowColor: const Color(0xfff45269),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xfff45269),
                                            Color(0xffd32f2f),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      child: const Text(
                                        "Take a look",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -48,
                      top: 15,
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _controller.value * 2 * pi,
                            child: child,
                          );
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          margin: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 50,
                          ),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/app_shop/cafe.png"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
