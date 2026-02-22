import 'package:flutter/material.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/circle_image.dart';
import 'package:boltuix/widgets/my_text.dart';

class SettingProfileLight extends StatefulWidget {
  SettingProfileLight();

  @override
  SettingProfileLightState createState() => new SettingProfileLightState();
}

class SettingProfileLightState extends State<SettingProfileLight> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: Container(),
        preferredSize: Size.fromHeight(0),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height: 20),
            _buildProfileHeader(context),
            _buildSettingItem(
                context, "Promotions & Discounts", Icons.local_offer_rounded),
            _buildDivider(),
            _buildSettingItem(
                context, "Refer a Friend", Icons.group_add_rounded),
            _buildDivider(),
            _buildSettingItem(context, "Manage Payments",
                Icons.account_balance_wallet_rounded),
            _buildDivider(),
            _buildSettingItem(
                context, "Host a Space", Icons.store_mall_directory_rounded),
            _buildDivider(),
            _buildSettingItem(context, "Support", Icons.support_agent_rounded),
            _buildDivider(),
            _buildSettingItem(context, "Feedback", Icons.feedback_rounded),
            _buildDivider(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "John Smith",
                style: MyText.headline(context)!.copyWith(
                    color: MyColors.grey_80, fontWeight: FontWeight.bold),
              ),
              Text(
                "View and edit profile",
                style: MyText.body1(context)!.copyWith(color: MyColors.grey_80),
              ),
            ],
          ),
          Spacer(),
          CircleImage(
            imageProvider: AssetImage(Img.get('image_001.png')),
            size: 90,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, IconData icon) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style:
                  MyText.body1(context)?.copyWith(fontWeight: FontWeight.w300),
            ),
            Spacer(),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [MyColors.gradient1, MyColors.gradient2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Icon(icon, color: Colors.white),
            ),
            Container(width: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: MyColors.primaryLight.withOpacity(0.3));
  }
}
