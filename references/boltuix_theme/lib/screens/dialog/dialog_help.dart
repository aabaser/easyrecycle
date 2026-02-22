import 'package:flutter/material.dart';

import '../../data/img.dart';
import '../../data/my_colors.dart';
import '../../widgets/my_text.dart';

class DialogHelp extends StatefulWidget {
  @override
  DialogHelpState createState() => new DialogHelpState();
}

class DialogHelpState extends State<DialogHelp> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 650,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(5),
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.blue[900]),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Divider(height: 0, color: MyColors.grey_20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(height: 10),
                            Text(
                              "How to Use BOLT AI?",
                              textAlign: TextAlign.left,
                              style: MyText.headline(context)!.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Hi, please note that there is a maximum 7 second limit for your voice input query.",
                              textAlign: TextAlign.start,
                              style: MyText.body1(context)!.copyWith(
                                color: MyColors.grey_40,
                              ),
                            ),
                            Container(height: 35),
                            Text(
                              "Try Saying...",
                              textAlign: TextAlign.start,
                              style: MyText.subhead(context)!.copyWith(
                                color: MyColors.grey_40,
                              ),
                            ),
                            Container(height: 35),
                            Text(
                              "General Queries",
                              textAlign: TextAlign.start,
                              style: MyText.headline(context)!.copyWith(
                                color: MyColors.grey_40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(height: 10),
                            // General Queries
                            commonQuery("Locate the nearest store",
                                "Find out where the closest store is."),
                            customDivider(),
                            commonQuery("How do I purchase a ticket?",
                                "Steps to buy a ticket."),
                            customDivider(),
                            commonQuery("What is the cost of a single ride?",
                                "Check the cost of a single ride."),
                            customDivider(),
                            commonQuery("How do I cancel a booking?",
                                "Steps to cancel a scheduled booking."),
                            customDivider(),
                            commonQuery("How do I apply for special services?",
                                "Instructions for applying for special services."),
                            customDivider(),
                            commonQuery("How do I contact support?",
                                "Ways to reach out to customer support."),
                            customDivider(),
                            commonQuery(
                                "What is the cost of a monthly subscription?",
                                "Find out the cost of a monthly subscription."),
                            customDivider(),
                            commonQuery("Are there discounts for children?",
                                "Learn about discounted fares for children."),
                            customDivider(),
                            commonQuery("Can I track my service in real-time?",
                                "Find out how to track your service in real-time."),
                            customDivider(),
                            commonQuery("How do I report a safety concern?",
                                "Report a safety issue."),
                            customDivider(),
                            commonQuery("Can I bring a stroller?",
                                "Find out the rules for strollers."),
                            customDivider(),
                            tripQuery("Plan a trip from City A to City B",
                                "Get the best screens for your trip."),
                            Container(height: 35),
                          ],
                        ),
                      ),
                      Container(height: 35),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        color: Colors.green,
                        child: Column(
                          children: [
                            Text(
                              "Powered by BOLT AI",
                              textAlign: TextAlign.start,
                              style: MyText.body1(context)!
                                  .copyWith(color: MyColors.grey_20),
                            ),
                            Container(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.asset(
                                  Img.get("ic_social_twitter.png"),
                                  height: 25,
                                  width: 25,
                                ),
                                Container(width: 25),
                                Image.asset(
                                  Img.get("ic_social_facebook.png"),
                                  height: 25,
                                  width: 25,
                                ),
                                Container(width: 25),
                                Image.asset(
                                  Img.get("ic_social_instagram.png"),
                                  height: 25,
                                  width: 25,
                                ),
                              ],
                            ),
                            Container(height: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to create a general query with title and short explanation
  Widget commonQuery(String title, String explanation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: MyText.headline(context)!.copyWith(
            color: MyColors.grey_80,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(height: 5),
        Text(
          explanation,
          style: MyText.body1(context)!.copyWith(
            color: MyColors.grey_60,
          ),
        ),
      ],
    );
  }

  // Function to create a trip query with title and short explanation
  Widget tripQuery(String title, String explanation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: MyText.headline(context)!.copyWith(
            color: MyColors.grey_80,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(height: 5),
        Text(
          explanation,
          style: MyText.body1(context)!.copyWith(
            color: MyColors.grey_60,
          ),
        ),
      ],
    );
  }

  // Custom Divider with extra padding
  Widget customDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Divider(
        height: 1,
        color: MyColors.grey_40,
      ),
    );
  }
}
