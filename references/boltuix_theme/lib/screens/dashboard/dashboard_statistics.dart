import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class DashboardStatistics extends StatefulWidget {
  DashboardStatistics();

  @override
  DashboardStatisticsState createState() => new DashboardStatisticsState();
}

class DashboardStatisticsState extends State<DashboardStatistics>
    with TickerProviderStateMixin {
  final List<Color> _greenGradient = [Colors.green, Colors.teal];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildStatisticCard(String title, String value,
      AnimatedIconData iconData, List<Color> gradientColors) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        elevation: 2,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                child: AnimatedIcon(
                  icon: iconData,
                  progress: _controller,
                  color: Colors.white,
                ),
              ),
              Container(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    value,
                    style: MyText.subhead(context)!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Container(height: 5),
                  Text(
                    title,
                    style:
                        MyText.caption(context)!.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRecentActivity(String activity, String date) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: <Widget>[
          Text(
            activity,
            style: MyText.body2(context)!.copyWith(color: MyColors.grey_60),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          Text(
            date,
            style: MyText.body2(context)!.copyWith(color: MyColors.grey_40),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildLineChart() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Revenue Trends",
                style: MyText.subhead(context)!.copyWith(
                    color: MyColors.grey_60, fontWeight: FontWeight.bold)),
            Container(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(1, 2),
                        FlSpot(2, 1.5),
                        FlSpot(3, 2.8),
                        FlSpot(4, 3.5),
                        FlSpot(5, 2.2),
                        FlSpot(6, 3.9),
                      ],
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: _greenGradient,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPieChart() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("User Engagement",
                style: MyText.subhead(context)!.copyWith(
                    color: MyColors.grey_60, fontWeight: FontWeight.bold)),
            Container(height: 10),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.green,
                      value: 30,
                      title: '30%',
                      radius: 50,
                      titleStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      color: Colors.teal,
                      value: 30,
                      title: '30%',
                      radius: 50,
                      titleStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      color: Colors.lightGreen,
                      value: 20,
                      title: '20%',
                      radius: 50,
                      titleStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      color: Colors.lime,
                      value: 20,
                      title: '20%',
                      radius: 50,
                      titleStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          backgroundColor: Colors.white,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          iconTheme: IconThemeData(color: MyColors.grey_60),
          title: Text("Dashboard",
              style: MyText.title(context)!.copyWith(color: MyColors.grey_60)),
          leading: IconButton(
              icon: Icon(Icons.menu_rounded),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search_rounded),
                onPressed: () {}), // overflow menu
            PopupMenuButton<String>(
              onSelected: (String value) {},
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "Settings",
                  child: Text("Settings"),
                ),
              ],
            )
          ]),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                buildStatisticCard("Active Users", "50,000",
                    AnimatedIcons.ellipsis_search, _greenGradient),
                Container(width: 5),
                buildStatisticCard("Sales", "75,000", AnimatedIcons.play_pause,
                    _greenGradient),
              ],
            ),
            Container(height: 5),
            Row(
              children: <Widget>[
                buildStatisticCard("New Signups", "20,000",
                    AnimatedIcons.add_event, _greenGradient),
                Container(width: 5),
                buildStatisticCard("Feedback", "15,000",
                    AnimatedIcons.list_view, _greenGradient),
              ],
            ),
            Container(height: 5),
            buildLineChart(),
            Container(height: 5),
            buildPieChart(),
            Container(height: 5),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.white,
              elevation: 2,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Recent Activity",
                            style: MyText.subhead(context)!.copyWith(
                                color: MyColors.grey_60,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                          Icon(Icons.add, color: MyColors.primary)
                        ],
                      ),
                    ),
                    Divider(height: 0, color: Colors.lightGreenAccent),
                    Container(height: 15),
                    buildRecentActivity("Added New Product", "5 Mar 2024"),
                    buildRecentActivity("Updated Terms", "18 Feb 2024"),
                    buildRecentActivity("User Feedback Review", "25 Jan 2024"),
                    buildRecentActivity("Monthly Report", "12 Jan 2024"),
                    Container(height: 15),
                    Divider(height: 0, color: Colors.lightGreenAccent),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.transparent),
                        child: Text("See More",
                            style: TextStyle(color: MyColors.primary)),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(height: 5),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.white,
              elevation: 2,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Image.asset(Img.get('img_social_twitter.png')),
                      width: 40,
                      height: 40,
                    ),
                    Container(width: 10),
                    Container(
                      child: Image.asset(Img.get('img_social_youtube.png')),
                      width: 40,
                      height: 40,
                    ),
                    Container(width: 10),
                    Container(
                      child: Image.asset(Img.get('img_social_facebook.png')),
                      width: 40,
                      height: 40,
                    ),
                    Container(width: 10),
                    Container(
                      child: Image.asset(Img.get('img_social_instagram.png')),
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
