import 'package:flutter/material.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/widgets/my_text.dart';

class IncludeReleasesContent {
  static Widget get(BuildContext context) {
    bool isWeb = MediaQuery.of(context).size.width > 600;
    Widget widget;
    widget = SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionHeader(context, "New Releases"),
            Container(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: newReleases.length,
                itemBuilder: (BuildContext context, int index) {
                  return newReleases[index];
                },
              ),
            ),
            _buildSectionHeader(context, "Top Rated"),
            isWeb ? _buildGridView() : _buildListView(),
          ],
        ),
      ),
    );
    return widget;
  }

  static Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: <Widget>[
        Container(width: 5),
        Text(
          title,
          style: MyText.medium(context).copyWith(
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(child: Container()),
        ButtonTheme(
          minWidth: 10,
          child: TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.transparent),
            child: Text(
              "MORE",
              style: MyText.body2(context)!.copyWith(
                color: Colors.green[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  static final List<Widget> newReleases = <Widget>[
    _buildCard(
        image: 'image_001.png',
        title: "Happy Puppy",
        subtitle: "Loyal and Playful"),
    _buildCard(
        image: 'image_002.png',
        title: "Lovely Unicorn",
        subtitle: "Magical and Sparkly"),
    _buildCard(
        image: 'image_003.png',
        title: "Cute Dinosaur",
        subtitle: "Roar-some Fun"),
  ];

  static final List<Widget> topRated = <Widget>[
    _buildListCard(
        image: 'image_006.png',
        title: "Lovely Unicorn",
        subtitle: "Magical and Sparkly"),
    _buildListCard(
        image: 'image_007.png',
        title: "Cute Dinosaur",
        subtitle: "Roar-some Fun"),
  ];

  static Widget _buildCard(
      {required String image,
      required String title,
      required String subtitle}) {
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Image.asset(
                Img.get(image),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[900]),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            Container(height: 15),
          ],
        ),
      ),
    );
  }

  static Widget _buildListCard(
      {required String image,
      required String title,
      required String subtitle}) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              Img.get(image),
              height: 350,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[900]),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            Container(height: 15),
          ],
        ),
      ),
    );
  }

  static Widget _buildListView() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: topRated.length,
      itemBuilder: (BuildContext context, int index) {
        return topRated[index];
      },
    );
  }

  static Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 3 / 4,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: topRated.length,
      itemBuilder: (BuildContext context, int index) {
        return topRated[index];
      },
    );
  }
}
