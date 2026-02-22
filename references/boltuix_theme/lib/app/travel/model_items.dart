import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'data.dart';

class ModelItems extends StatelessWidget {
  final int index; // 🏷️ Index of the item in the data list
  final double imageWidth; // 📏 Width of the image
  final double imageOffset; // 🔄 Offset for parallax effect
  final double indexFactor; // 📐 Factor for offset adjustment
  final String hero; // 🎭 Hero tag for animations

  const ModelItems({
    Key? key,
    required this.index,
    required this.imageWidth,
    required this.imageOffset,
    required this.indexFactor,
    required this.hero,
  }) : super(key: key);

  // 🖼️ Widget to display the image with Hero animation and parallax effect
  Widget image() {
    return Hero(
      tag: hero, // 🎭 Hero tag for animation
      child: Image.asset(
        data[index]["image"], // 🏙️ Image from the data
        fit: BoxFit.cover, // 📏 Ensure image covers its container
        alignment: Alignment(
            -imageOffset + indexFactor * index, 0), // 🔄 Parallax alignment
      ),
    );
  }

  // ⭐ Widget to display the rating with a blurred background
  Widget rating() {
    return Align(
      alignment: Alignment.topLeft, // 📍 Align to top left
      child: Padding(
        padding: const EdgeInsets.all(12), // 📏 Padding for spacing
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32), // 🎨 Rounded corners
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // 🌫️ Blur effect
            child: Container(
              height: 48, // 📏 Fixed height
              color: kSecondaryColor
                  .withOpacity(0.4), // 🎨 Semi-transparent background
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 12, right: 16), // 📏 Inner padding
                child: Row(
                  mainAxisSize: MainAxisSize.min, // 📐 Minimum size for row
                  children: [
                    const Icon(
                      FontAwesomeIcons.solidStar, // ⭐ Star icon
                      color: Color(0xFFFFD600), // 🎨 Star color
                      size: 20, // 📏 Icon size
                    ),
                    const SizedBox(width: 8), // ➡️ Spacing
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 2), // ⬆️ Slight adjustment
                      child: Text(
                        data[index]["rating"], // 🔢 Rating value
                        style: const TextStyle(
                          color: kPrimaryColor, // 🎨 Text color
                          fontSize: 16, // 📏 Font size
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ❤️ Widget to display a favorite icon
  Widget favoriteIcon() {
    return Align(
      alignment: Alignment.topRight, // 📍 Align to top right
      child: Padding(
        padding: const EdgeInsets.all(12), // 📏 Padding for spacing
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32), // 🎨 Rounded corners
          child: Container(
            width: 48, // 📏 Fixed size
            height: 48,
            color: Colors.white, // 🎨 Background color
            child: const Icon(
              FontAwesomeIcons.heart, // ❤️ Heart icon
              color: Colors.black87, // 🎨 Icon color
            ),
          ),
        ),
      ),
    );
  }

  // 📍 Widget to display city and country text with blurred background
  Widget bottomText() {
    return Align(
      alignment: Alignment.bottomCenter, // 📍 Align to bottom center
      child: Padding(
        padding: const EdgeInsets.all(12), // 📏 Padding for spacing
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24), // 🎨 Rounded corners
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // 🌫️ Blur effect
            child: Container(
              height: 48, // 📏 Fixed height
              color: kSecondaryColor
                  .withOpacity(0.4), // 🎨 Semi-transparent background
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12), // 📏 Inner padding
                child: Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.locationDot, // 📍 Location icon
                      color: kPrimaryColor, // 🎨 Icon color
                    ),
                    const SizedBox(width: 4), // ➡️ Spacing
                    Text(
                      data[index]["city"], // 🏙️ City name
                      style: const TextStyle(
                        color: kPrimaryColor, // 🎨 Text color
                        fontSize: 16, // 📏 Font size
                        fontWeight: FontWeight.bold, // 🔡 Bold text
                      ),
                    ),
                    Text(
                      ', ${data[index]["country"]}', // 🌍 Country name
                      style: TextStyle(
                        color: kPrimaryColor
                            .withOpacity(0.8), // 🎨 Lighter text color
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: imageWidth, // 📏 Width from parent
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15), // 🎨 Rounded corners
        child: Stack(
          fit: StackFit.expand, // 📐 Fill available space
          children: [
            image(), // 🖼️ Display image
            // Uncomment the following lines to include more widgets
            // rating(),
            favoriteIcon(), // ❤️ Display favorite icon
            // bottomText(),
          ],
        ),
      ),
    );
  }
}
