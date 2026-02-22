import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class ProfileImageAppbar extends StatefulWidget {
  ProfileImageAppbar();

  @override
  ProfileImageAppbarState createState() => new ProfileImageAppbarState();
}

class ProfileImageAppbarState extends State<ProfileImageAppbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark,
              ),
              title: Text("Profile"),
              backgroundColor: Colors.pink.shade50,
              expandedHeight: 260,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background:
                    Image.asset(Img.get('bg_image1.png'), fit: BoxFit.cover),
              ),
              leading: IconButton(
                icon: Icon(Icons.menu_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search_rounded),
                  onPressed: () {},
                ),
                PopupMenuButton<String>(
                  onSelected: (String value) {},
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "Settings",
                      child: Text("Settings"),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: 15),
                Row(
                  children: <Widget>[
                    Container(width: 150),
                    Text("John Smith",
                        style: MyText.headline(context)!
                            .copyWith(color: MyColors.grey_90)),
                  ],
                ),
                Container(height: 15),
                ElevatedButton(
                  onPressed: () {
                    // Handle edit profile
                  },
                  child: Text("Edit Profile"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                Container(height: 15),
                _buildSection(
                  icon: Icons.person_rounded,
                  title: "About Me",
                  content:
                      "John Smith is a passionate software engineer with a knack for problem-solving and creating efficient solutions. He has worked on various projects ranging from mobile apps to large-scale web applications. John is also an avid open-source contributor and enjoys sharing his knowledge with the developer community.",
                ),
                Container(height: 15),
                Divider(color: Colors.pink.withOpacity(0.1), indent: 50),
                Container(height: 15),
                _buildSection(
                  icon: Icons.directions_bike_rounded,
                  title: "Hobbies",
                  content:
                      "Swimming, playing tennis, cooking are my favorite hobbies.",
                ),
                Container(height: 15),
                Divider(color: Colors.pink.withOpacity(0.1), indent: 50),
                Container(height: 15),
                _buildSection(
                  icon: Icons.photo_camera_rounded,
                  title: "Photos",
                  content: "",
                  isPhotos: true,
                ),
                Container(height: 15),
                Divider(color: Colors.pink.withOpacity(0.1), indent: 50),
                Container(height: 15),
                _buildSection(
                  icon: Icons.contact_phone_rounded,
                  title: "Contact Information",
                  content:
                      "Email: john.smith@example.com\nPhone: +1 234 567 890",
                ),
                Container(height: 15),
                Divider(color: Colors.pink.withOpacity(0.1), indent: 50),
                Container(height: 15),
                _buildSection(
                  icon: Icons.lightbulb_outline_rounded,
                  title: "Skills",
                  content: "Flutter, Dart, JavaScript, React, Node.js",
                ),
                Container(height: 15),
                Divider(color: Colors.pink.withOpacity(0.1), indent: 50),
                Container(height: 15),
                _buildSection(
                  icon: Icons.format_quote_rounded,
                  title: "Favorite Quotes",
                  content:
                      "\"The only way to do great work is to love what you do.\" - Steve Jobs",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      {required IconData icon,
      required String title,
      required String content,
      bool isPhotos = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.pink, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Icon(icon, size: 25, color: Colors.white),
        ),
        Container(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(height: 2),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.pink, Colors.pinkAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(title,
                    style: MyText.medium(context).copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              Container(height: 5),
              isPhotos
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          _buildPhotoCard('b_image_1.png'),
                          _buildPhotoCard('b_image_2.png'),
                          _buildPhotoCard('b_image_3.png'),
                          _buildPhotoCard('b_image_4.png'),
                          _buildPhotoCard('b_image_5.png'),
                        ],
                      ),
                    )
                  : Text(
                      content,
                      style: MyText.body1(context)!
                          .copyWith(color: MyColors.grey_60, height: 1.4),
                    ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPhotoCard(String imageName) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Stack(
        children: [
          Image.asset(Img.get(imageName),
              width: 100, height: 100, fit: BoxFit.cover),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.pink.withOpacity(0.2),
                  Colors.white.withOpacity(0.3)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
