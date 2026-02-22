import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class DashboardWallet extends StatefulWidget {
  DashboardWallet();

  @override
  DashboardWalletState createState() => new DashboardWalletState();
}

class DashboardWalletState extends State<DashboardWallet> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark,
              ),
              leading: IconButton(
                icon: Icon(Icons.menu_rounded, color: MyColors.grey_90),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh, color: MyColors.grey_90),
                  onPressed: () {},
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [MyColors.gradient1, MyColors.gradient2],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Image.asset(Img.get('header.png'),
                              fit: BoxFit.cover, width: double.infinity),
                          Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(width: 10),
                                    IconButton(
                                        icon: Icon(Icons.dashboard_rounded,
                                            color: Colors.white),
                                        onPressed: () {}),
                                  ],
                                ),
                                Container(height: 10),
                                Text("ETH Balance",
                                    style: MyText.subhead(context)!
                                        .copyWith(color: Colors.white)),
                                Text("24.561",
                                    style: MyText.display1(context)!
                                        .copyWith(color: Colors.white)),
                                Text("3734.89 USD",
                                    style: MyText.subhead(context)!
                                        .copyWith(color: Colors.white)),
                                Container(height: 25),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 5),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Colors.white,
                          elevation: 2,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: <Widget>[
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      MyColors.gradient1,
                                      MyColors.gradient2
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds),
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.transparent,
                                    child: Icon(Icons.arrow_upward,
                                        color: Colors.white, size: 15),
                                  ),
                                ),
                                Container(width: 15),
                                Text("Send",
                                    style: MyText.subhead(context)!.copyWith(
                                        color: Colors.green[900],
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(width: 5),
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Colors.white,
                          elevation: 2,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: <Widget>[
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      MyColors.gradient1,
                                      MyColors.gradient2
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds),
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.transparent,
                                    child: Icon(Icons.arrow_downward,
                                        color: Colors.white, size: 15),
                                  ),
                                ),
                                Container(width: 15),
                                Text("Receive",
                                    style: MyText.subhead(context)!.copyWith(
                                        color: Colors.green[900],
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(height: 10),
                  Text("Transactions Today",
                      style: MyText.body2(context)!
                          .copyWith(color: MyColors.grey_40)),
                  Container(height: 5),
                  _buildTransactionCard("Received", "10 Jan 2024 11:20",
                      "1.639 ETH", "4.38 USD", Icons.arrow_downward),
                  _buildTransactionCard("Received", "10 Jan 2024 08:55",
                      "1.947 ETH", "5.204 USD", Icons.arrow_downward),
                  _buildTransactionCard("Sent", "10 Jan 2024 08:55",
                      "2.165 ETH", "8.42 USD", Icons.arrow_upward),
                  _buildTransactionCard("Sent", "10 Jan 2024 07:20",
                      "2.035 ETH", "8.12 USD", Icons.arrow_upward),
                  Container(height: 20),
                  _buildStatisticsSection(),
                  Container(height: 20),
                  _buildLineChart(),
                  Container(height: 20),
                  _buildBarChart(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green[400],
        unselectedItemColor: MyColors.grey_40,
        currentIndex: currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          _buildBottomNavigationBarItem(Icons.equalizer),
          _buildBottomNavigationBarItem(Icons.credit_card),
          _buildBottomNavigationBarItem(Icons.pie_chart_outline),
          _buildBottomNavigationBarItem(Icons.person),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(IconData icon) {
    return BottomNavigationBarItem(
      icon: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [MyColors.gradient1, MyColors.gradient2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: Icon(icon, color: Colors.white),
      ),
      label: '',
    );
  }

  Widget _buildTransactionCard(String type, String date, String ethAmount,
      String usdAmount, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      elevation: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Stack(
        children: [
          Image.asset(Img.get('header.png'),
              fit: BoxFit.cover, width: double.infinity),
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [MyColors.gradient1, MyColors.gradient2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.transparent,
                    child: Icon(icon, color: Colors.white, size: 15),
                  ),
                ),
                Container(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(type,
                        style: MyText.subhead(context)!.copyWith(
                            color: Colors.green[900],
                            fontWeight: FontWeight.w500)),
                    Container(height: 5),
                    Text(date,
                        style: MyText.caption(context)!
                            .copyWith(color: MyColors.grey_40)),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(ethAmount,
                        style: MyText.body1(context)!
                            .copyWith(color: Colors.green[700])),
                    Container(height: 5),
                    Text(usdAmount,
                        style: MyText.caption(context)!
                            .copyWith(color: MyColors.grey_40)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [MyColors.gradient1, MyColors.gradient2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Transaction Statistics",
              style: MyText.subhead(context)!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          Container(height: 10),
          _buildStatisticRow("Total Sent", "45.875 ETH", "89,210 USD"),
          _buildStatisticRow("Total Received", "50.341 ETH", "97,560 USD"),
          _buildStatisticRow("Net Balance", "4.466 ETH", "8,350 USD"),
        ],
      ),
    );
  }

  Widget _buildStatisticRow(String title, String ethAmount, String usdAmount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: MyText.body2(context)!.copyWith(color: Colors.white)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(ethAmount,
                  style: MyText.body2(context)!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text(usdAmount,
                  style:
                      MyText.caption(context)!.copyWith(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      elevation: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Balance Over Time",
                style: MyText.subhead(context)!.copyWith(
                    color: MyColors.grey_60, fontWeight: FontWeight.bold)),
            Container(height: 10),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text('Jan');
                            case 2:
                              return Text('Mar');
                            case 4:
                              return Text('May');
                            case 6:
                              return Text('Jul');
                            case 8:
                              return Text('Sep');
                            case 10:
                              return Text('Nov');
                            default:
                              return Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 1:
                              return Text('\$1000');
                            case 3:
                              return Text('\$3000');
                            case 5:
                              return Text('\$5000');
                            case 7:
                              return Text('\$7000');
                            default:
                              return Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(2, 3),
                        FlSpot(4, 5),
                        FlSpot(6, 4),
                        FlSpot(8, 6),
                        FlSpot(10, 7),
                      ],
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [MyColors.gradient1, MyColors.gradient2],
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

  Widget _buildBarChart() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      elevation: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Monthly Transactions",
                style: MyText.subhead(context)!.copyWith(
                    color: MyColors.grey_60, fontWeight: FontWeight.bold)),
            Container(height: 10),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text('Jan');
                            case 2:
                              return Text('Mar');
                            case 4:
                              return Text('May');
                            case 6:
                              return Text('Jul');
                            case 8:
                              return Text('Sep');
                            case 10:
                              return Text('Nov');
                            default:
                              return Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 2:
                              return Text('\$2000');
                            case 4:
                              return Text('\$4000');
                            case 6:
                              return Text('\$6000');
                            case 8:
                              return Text('\$8000');
                            case 10:
                              return Text('\$10000');
                            default:
                              return Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(
                        toY: 8,
                        gradient: LinearGradient(
                          colors: [MyColors.gradient1, MyColors.gradient2],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: 15,
                      ),
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(
                        toY: 10,
                        gradient: LinearGradient(
                          colors: [MyColors.gradient1, MyColors.gradient2],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: 15,
                      ),
                    ]),
                    BarChartGroupData(x: 4, barRods: [
                      BarChartRodData(
                        toY: 14,
                        gradient: LinearGradient(
                          colors: [MyColors.gradient1, MyColors.gradient2],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: 15,
                      ),
                    ]),
                    BarChartGroupData(x: 6, barRods: [
                      BarChartRodData(
                        toY: 12,
                        gradient: LinearGradient(
                          colors: [MyColors.gradient1, MyColors.gradient2],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: 15,
                      ),
                    ]),
                    BarChartGroupData(x: 8, barRods: [
                      BarChartRodData(
                        toY: 16,
                        gradient: LinearGradient(
                          colors: [MyColors.gradient1, MyColors.gradient2],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: 15,
                      ),
                    ]),
                    BarChartGroupData(x: 10, barRods: [
                      BarChartRodData(
                        toY: 18,
                        gradient: LinearGradient(
                          colors: [MyColors.gradient1, MyColors.gradient2],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: 15,
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
