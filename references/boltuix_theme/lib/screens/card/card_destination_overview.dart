import 'dart:core';
import 'package:flutter/material.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

import '../../widgets/toolbar.dart';

class DestinationOverview extends StatefulWidget {
  DestinationOverview();

  @override
  DestinationOverviewState createState() => new DestinationOverviewState();
}

class DestinationOverviewState extends State<DestinationOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.grey_10,
      appBar:
          CommonAppBar.getPrimarySettingAppbar(context, "Destination Overview")
              as PreferredSizeWidget?,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Stack(
              children: [
                Image.asset(
                  Img.get('image_001.png'), // Hero Image
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    "Paradise Beach",
                    style: MyText.headline(context)!.copyWith(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Feature Cards
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Features Card
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Features",
                            style: MyText.title(context)!.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: MyColors.grey_80,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _featureIcon(Icons.wifi, "Free Wi-Fi"),
                              _featureIcon(Icons.pool, "Swimming Pool"),
                              _featureIcon(Icons.local_parking, "Parking"),
                              _featureIcon(Icons.spa, "Spa"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Reviews Card
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Reviews",
                            style: MyText.title(context)!.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: MyColors.grey_80,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "\"A beautiful destination with amazing views and top-notch facilities!\"",
                            style: MyText.subhead(context)!
                                .copyWith(color: MyColors.grey_60),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow, size: 20),
                              Icon(Icons.star, color: Colors.yellow, size: 20),
                              Icon(Icons.star, color: Colors.yellow, size: 20),
                              Icon(Icons.star, color: Colors.yellow, size: 20),
                              Icon(Icons.star_half,
                                  color: Colors.yellow, size: 20),
                              SizedBox(width: 10),
                              Text("4.5 / 5",
                                  style: MyText.body1(context)!
                                      .copyWith(color: MyColors.grey_80)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Description Card
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description",
                            style: MyText.title(context)!.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: MyColors.grey_80,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Paradise Beach is the perfect getaway destination offering pristine waters, "
                            "sandy shores, and luxurious amenities. Enjoy activities like snorkeling, "
                            "sunbathing, and exquisite dining experiences.",
                            style: MyText.subhead(context)!
                                .copyWith(color: MyColors.grey_60),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Call-to-Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary,
                        foregroundColor:
                            Colors.white, // Set the text color to white
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text("Book Now"),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        side: BorderSide(color: MyColors.primary),
                      ),
                      child: Text("Learn More",
                          style: TextStyle(color: MyColors.primary)),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _featureIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: MyColors.primary, size: 30),
        SizedBox(height: 5),
        Text(label,
            style: MyText.body2(context)!.copyWith(color: MyColors.grey_60)),
      ],
    );
  }
}
