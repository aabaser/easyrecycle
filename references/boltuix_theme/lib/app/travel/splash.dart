import 'package:flutter/material.dart';

import 'app_travel.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      body: Stack(
        children: [
          // Background with image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.webp', // Replace with your image
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'travel_logo_hero_tag',
                      child: SizedBox(
                        width: 250,
                        height: 250,
                        child: Image.asset(
                            "assets/images/user_1.png"), // Travel logo
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [
                              Color(0xFF010917), // Dark text color
                              Color(0xFF010917), // Dark text color
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcIn,
                        child: Text(
                          'Discover Your Next Adventure',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 45,
                            fontFamily: 'Montserrat',
                            color: const Color(0xFF010917), // Dark text color
                            letterSpacing: 0.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Embark on unforgettable journeys and explore breathtaking destinations with ease.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            thickness: 1.0,
                            color: Color(0x86dee1e8),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF010917), // Secondary color
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TravelHome()));
                            },
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            label: Text(
                              "Explore Now",
                              style: textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            thickness: 1.0,
                            color: Color(0x86dee1e8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 42),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
