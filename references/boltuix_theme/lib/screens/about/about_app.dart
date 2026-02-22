import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class AboutApp extends StatefulWidget {
  AboutApp();

  @override
  AboutAppState createState() => new AboutAppState();
}

class AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: MyColors.grey_10,
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        title: Text("About"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value) {},
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "Settings",
                child: Text("Settings"),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              color: Colors.white,
              elevation: 2,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Image.asset(Img.get('logo_f.png')),
                          width: 50,
                          height: 50,
                        ),
                        Container(width: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("BoltUiX About",
                                style: MyText.medium(context)
                                    .copyWith(color: MyColors.grey_80)),
                            Container(height: 2),
                            Text("@boltuix",
                                style: MyText.caption(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    Container(height: 20),
                    Row(
                      children: <Widget>[
                        GradientIcon(Icons.info_outline_rounded, 35),
                        Container(width: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Version",
                                style: MyText.body1(context)!.copyWith(
                                    color: MyColors.grey_60,
                                    fontWeight: FontWeight.w500)),
                            Container(height: 2),
                            Text("1.0",
                                style: MyText.caption(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    Container(height: 20),
                    Row(
                      children: <Widget>[
                        GradientIcon(Icons.sync_rounded, 35),
                        Container(width: 15),
                        Text("Changelog",
                            style: MyText.body1(context)!
                                .copyWith(color: MyColors.grey_60)),
                        Spacer(),
                      ],
                    ),
                    Container(height: 20),
                    Row(
                      children: <Widget>[
                        GradientIcon(Icons.book_rounded, 35),
                        Container(width: 15),
                        Text("License",
                            style: MyText.body1(context)!
                                .copyWith(color: MyColors.grey_60)),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              color: Colors.white,
              elevation: 2,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(width: 6),
                        Text("Author",
                            style: MyText.body1(context)!.copyWith(
                                color: MyColors.grey_80,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Container(height: 20),
                    Row(
                      children: <Widget>[
                        GradientIcon(Icons.person_rounded, 35),
                        Container(width: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("John Smith",
                                style: MyText.body1(context)!.copyWith(
                                    color: MyColors.grey_60,
                                    fontWeight: FontWeight.w500)),
                            Container(height: 2),
                            Text("United States",
                                style: MyText.caption(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    Container(height: 20),
                    Row(
                      children: <Widget>[
                        GradientIcon(Icons.file_download_rounded, 35),
                        Container(width: 15),
                        Text("Download From Cloud",
                            style: MyText.body1(context)!.copyWith(
                                color: MyColors.grey_60,
                                fontWeight: FontWeight.w500)),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              color: Colors.white,
              elevation: 2,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(width: 6),
                        Text("Company",
                            style: MyText.body1(context)!.copyWith(
                                color: MyColors.grey_80,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Container(height: 20),
                    Row(
                      children: <Widget>[
                        GradientIcon(Icons.business_rounded, 35),
                        Container(width: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("BoltUiX Inc.",
                                style: MyText.body1(context)!.copyWith(
                                    color: MyColors.grey_60,
                                    fontWeight: FontWeight.w500)),
                            Container(height: 2),
                            Text("Tech Innovators",
                                style: MyText.caption(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    Container(height: 20),
                    Row(
                      children: <Widget>[
                        GradientIcon(Icons.location_on_rounded, 35),
                        Container(width: 15),
                        Expanded(
                          child: Text(
                            "221B Bolt Street, London, United Kingdom",
                            style: MyText.body1(context)!.copyWith(
                                color: MyColors.grey_60,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 10),
          ],
        ),
      ),
    );
  }
}

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;

  GradientIcon(this.icon, this.size);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [MyColors.gradient1, MyColors.gradient2],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Icon(
        icon,
        size: size,
        color: Colors.white,
      ),
    );
  }
}
