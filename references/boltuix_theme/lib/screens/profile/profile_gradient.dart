import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class ProfileGradient extends StatefulWidget {
  ProfileGradient();

  @override
  ProfileGradientState createState() => new ProfileGradientState();
}

class ProfileGradientState extends State<ProfileGradient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [MyColors.gradient1, MyColors.gradient2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(Img.get('bg_image1.jpg'), fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.greenAccent.withOpacity(0.3),
                              Colors.green.withOpacity(0.3),
                              Colors.greenAccent.withOpacity(0.3)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search_rounded),
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
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(100),
                child: Container(
                  transform: Matrix4.translationValues(0, 50, 0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: AssetImage(Img.get("bg_image1.jpg")),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                Container(height: 70),
                Text(
                  "John Smith",
                  style: MyText.headline(context)!.copyWith(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                Container(height: 15),
                Text(
                  "Digital Artist & Photographer",
                  textAlign: TextAlign.center,
                  style: MyText.subhead(context)!
                      .copyWith(color: Colors.grey[900], fontSize: 16),
                ),
                Container(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    shadowColor: Colors.transparent,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [MyColors.gradient1, MyColors.gradient2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: Text("FOLLOW",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ),
                  onPressed: () {},
                ),
                Container(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildStatisticCard("8825", "Followers", Icons.people),
                    _buildStatisticCard("1766", "Following", Icons.person_add),
                    _buildStatisticCard("8.5", "Social Score", Icons.star),
                  ],
                ),
                Container(height: 20),
                Divider(height: 2, thickness: 1, color: MyColors.primaryLight),
                Container(height: 20),
                Text(
                  "John Smith is a renowned digital artist and photographer known for his vibrant and captivating works. "
                  "He has been featured in numerous exhibitions worldwide and has a significant following on social media. "
                  "John continues to inspire with his creative vision and artistic expression. He graduated from the "
                  "prestigious Art Institute and has won several awards for his innovative approach to digital art. "
                  "John is passionate about exploring new techniques and pushing the boundaries of traditional art forms. "
                  "In his free time, he enjoys teaching photography workshops and mentoring young artists.",
                  textAlign: TextAlign.justify,
                  style: MyText.body1(context)!
                      .copyWith(color: Colors.grey[900], fontSize: 14),
                ),
                Container(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticCard(String value, String label, IconData icon) {
    return Expanded(
      child: Column(
        children: <Widget>[
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [MyColors.gradient1, MyColors.gradient2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Icon(icon, color: Colors.white, size: 25),
          ),
          Container(height: 5),
          Text(
            value,
            style: MyText.title(context)!.copyWith(
                color: Colors.grey[900],
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          Container(height: 5),
          Text(
            label,
            style: MyText.subhead(context)!
                .copyWith(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
