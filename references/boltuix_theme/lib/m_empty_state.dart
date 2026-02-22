import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'widgets/m_navigation_utils.dart';
import 'widgets/m_typography.dart';

class EmptyStateScreen extends StatelessWidget {
  const EmptyStateScreen(
      {super.key}); // Pass the key to the superclass constructor

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Stack(
      children: [
        Opacity(
          opacity: 0.1, // Set opacity value between 0.0 and 1.0
          child: Lottie.asset(
            'assets/anim/7.json',
            fit: BoxFit.scaleDown,
          ),
        ),
        Positioned(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Spacer(),
                Lottie.asset(
                  'assets/anim/404.json',
                  height: 90,
                  fit: BoxFit.scaleDown,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextStyleExample(
                      name: "Something 's missing!",
                      align: TextAlign.center,
                      style: textTheme.bodyLarge!),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton.small(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    // Callback function when the button is pressed
                    onPressed: () {
                      NavigationUtil().finish(context);
                    },
                    // Icon to display inside the button
                    child: const Icon(Icons.arrow_back_rounded),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
