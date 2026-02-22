import 'dart:core';
import 'package:flutter/material.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class DashboardGridFab extends StatefulWidget {
  DashboardGridFab();

  @override
  DashboardGridFabState createState() => new DashboardGridFabState();
}

class DashboardGridFabState extends State<DashboardGridFab> {
  final List<List<Color>> _gradients = [
    [Colors.red, Colors.orange],
    [Colors.blue, Colors.lightBlue],
    [Colors.green, Colors.teal],
    [Colors.purple, Colors.pink],
    [Colors.cyan, Colors.blueAccent],
    [Colors.yellow, Colors.orangeAccent],
    [Colors.indigo, Colors.lightBlueAccent],
    [Colors.deepPurple, Colors.purpleAccent],
    [Colors.lightGreen, Colors.greenAccent],
    [Colors.orange, Colors.deepOrangeAccent],
    [Colors.blueGrey, Colors.grey],
    [Colors.teal, Colors.cyan],
    [MyColors.gradient1, MyColors.gradient2],
  ];

  Widget buildHeader() {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [MyColors.gradient1, MyColors.gradient2],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Image.asset(Img.get('header.png'), fit: BoxFit.cover),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: 20),
                Text("Hi, John Smith",
                    style:
                        MyText.subhead(context)!.copyWith(color: Colors.white)),
                Container(height: 10),
                Text("Welcome to London",
                    style: MyText.caption(context)!
                        .copyWith(color: Colors.grey[200])),
              ],
            ),
            Spacer(),
            IconButton(
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget buildProfileCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green, // Add background color for initial
              child: Text('J',
                  style: MyText.title(context)!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold)), // Initial letter
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("John Smith",
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Text("Traveler & Explorer",
                    style: MyText.caption(context)!
                        .copyWith(color: Colors.grey[600])),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(" 4.8 Rating ",
                        style: MyText.caption(context)!
                            .copyWith(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
            Spacer(),
            IconButton(
              icon: const Icon(Icons.edit, color: MyColors.primary),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFeatureCard(
      String title, IconData icon, List<Color> gradient, String imageAsset) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 3,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imageAsset),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.darken),
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: Colors.white, size: 30),
            SizedBox(width: 15),
            Text(title,
                style: MyText.title(context)!.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget buildFabCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 5),
        child: Column(
          children: <Widget>[
            buildFabRow([
              {
                'icon': Icons.travel_explore_rounded,
                'label': 'TRIPS',
                'gradient': _gradients[0]
              },
              {
                'icon': Icons.event_note_rounded,
                'label': 'ITINERARIES',
                'gradient': _gradients[1]
              },
              {
                'icon': Icons.place_rounded,
                'label': 'PLACES',
                'gradient': _gradients[2]
              },
              {
                'icon': Icons.event_rounded,
                'label': 'EVENTS',
                'gradient': _gradients[3]
              },
            ]),
            Container(height: 15),
            buildFabRow([
              {
                'icon': Icons.photo_album_rounded,
                'label': 'PHOTOS',
                'gradient': _gradients[4]
              },
              {
                'icon': Icons.favorite_rounded,
                'label': 'FAVORITES',
                'gradient': _gradients[5]
              },
              {
                'icon': Icons.info_rounded,
                'label': 'TIPS',
                'gradient': _gradients[6]
              },
              {
                'icon': Icons.rate_review_rounded,
                'label': 'REVIEWS',
                'gradient': _gradients[7]
              },
            ]),
            Container(height: 15),
            buildFabRow([
              {
                'icon': Icons.directions_run_rounded,
                'label': 'ACTIVITIES',
                'gradient': _gradients[8]
              },
              {
                'icon': Icons.payment_rounded,
                'label': 'BILLS',
                'gradient': _gradients[9]
              },
              {
                'icon': Icons.favorite_rounded,
                'label': 'FAVORITES',
                'gradient': _gradients[10]
              },
              {
                'icon': Icons.drafts_rounded,
                'label': 'DRAFT',
                'gradient': _gradients[11]
              },
            ]),
          ],
        ),
      ),
    );
  }

  Widget buildFabRow(List<Map<String, dynamic>> fabData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: fabData.map((data) {
        List<Color> gradientColors =
            data['gradient']; // Use fixed gradient colors

        return Column(
          children: <Widget>[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(15), // Rounded rectangular shape
              ),
              child: Center(
                child: FloatingActionButton(
                  heroTag: UniqueKey(),
                  elevation: 0,
                  mini: true,
                  backgroundColor: Colors.transparent,
                  child: Icon(data['icon'], color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ),
            Container(height: 5),
            Text(
              data['label'],
              style: MyText.caption(context)!.copyWith(color: MyColors.grey_40),
              textAlign: TextAlign.center,
            )
          ],
        );
      }).toList(),
    );
  }

  Widget buildBalanceCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      elevation: 3,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        height: 70,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Balance",
                  style: MyText.subhead(context)!
                      .copyWith(color: MyColors.grey_60),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "\$ 730",
                  style: MyText.medium(context).copyWith(
                      color: Colors.green[400], fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.redAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                "View History",
                style: MyText.body2(context)!.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primary,
      appBar:
          PreferredSize(preferredSize: Size.fromHeight(0), child: Container()),
      body: Container(
        color: Colors.grey[100],
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              buildHeader(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                transform: Matrix4.translationValues(0.0, -35.0, 0.0),
                child: Column(
                  children: <Widget>[
                    buildProfileCard(),
                    buildBalanceCard(), // Move balance card to the top below profile card
                    SizedBox(height: 15),
                    buildFabCard(),
                    SizedBox(height: 15),
                    buildFeatureCard("Travel Guides", Icons.book_rounded,
                        _gradients[12], Img.get('header.png')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
