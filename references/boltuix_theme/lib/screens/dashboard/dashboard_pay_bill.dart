import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class DashboardPayBill extends StatefulWidget {
  DashboardPayBill();

  @override
  DashboardPayBillState createState() => new DashboardPayBillState();
}

class DashboardPayBillState extends State<DashboardPayBill> {
  Widget buildServiceCard(String title, IconData icon) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(6), // Adding margin to each card for spacing
        padding: EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: MyColors.grey_5,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [MyColors.gradient1, MyColors.gradient2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Icon(icon, size: 35, color: Colors.white),
              ),
            ),
            Container(height: 18),
            Text(title,
                style:
                    MyText.body1(context)!.copyWith(color: MyColors.grey_90)),
          ],
        ),
      ),
    );
  }

  Widget buildServiceRow(List<Map<String, dynamic>> services) {
    return Row(
      children: services.map((service) {
        return buildServiceCard(service['title'], service['icon']);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        backgroundColor: Colors.white,
        title: Text("Pay Master",
            style: MyText.title(context)!.copyWith(color: Colors.green[700])),
        leading: IconButton(
          icon: Icon(Icons.dashboard, color: Colors.green[700]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_alt, color: Colors.green[700]),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.green[700]),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(height: 20),
            // User Details at the top right
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text("Welcome, Alex",
                          style: MyText.medium(context).copyWith(
                              color: MyColors.grey_90,
                              fontWeight: FontWeight.bold)),
                      Text("alex.jones@example.com",
                          style: MyText.body2(context)
                              ?.copyWith(color: MyColors.grey_80)),
                    ],
                  )
                ],
              ),
            ),
            Container(height: 30),
            Text("Manage Your Payments",
                style: MyText.medium(context).copyWith(
                    color: MyColors.grey_90, fontWeight: FontWeight.bold)),
            Container(height: 10),
            buildServiceRow([
              {'title': 'GAS', 'icon': Icons.local_gas_station},
              {'title': 'MORTGAGE', 'icon': Icons.home_work},
              {'title': 'CREDIT CARD', 'icon': Icons.credit_card},
            ]),
            Container(height: 6),
            buildServiceRow([
              {'title': 'PHONE', 'icon': Icons.phone},
              {'title': 'GROCERIES', 'icon': Icons.shopping_cart},
              {'title': 'SUBSCRIPTIONS', 'icon': Icons.subscriptions},
            ]),
            Container(height: 30),
            Text("Buy Tickets",
                style: MyText.medium(context).copyWith(
                    color: MyColors.grey_90, fontWeight: FontWeight.bold)),
            Container(height: 10),
            buildServiceRow([
              {'title': 'CONCERT', 'icon': Icons.music_note},
              {'title': 'THEATER', 'icon': Icons.theater_comedy},
              {'title': 'TRAVEL', 'icon': Icons.airplanemode_active},
            ]),
            Container(height: 6),
            Text("Additional Services",
                style: MyText.medium(context).copyWith(
                    color: MyColors.grey_90, fontWeight: FontWeight.bold)),
            Container(height: 10),
            buildServiceRow([
              {'title': 'TAXES', 'icon': Icons.receipt_long},
              {'title': 'DONATIONS', 'icon': Icons.volunteer_activism},
              {'title': 'INVESTMENTS', 'icon': Icons.trending_up},
            ]),
            Container(height: 6),
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: MyColors.grey_5,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.purple, Colors.pink],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Icon(Icons.help_outline, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.pink, Colors.pink],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          "Help & Support",
                          style: MyText.medium(context).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("1. Make sure to review your payment history regularly.",
                      style: MyText.body2(context)
                          ?.copyWith(color: MyColors.grey_80)),
                  SizedBox(height: 5),
                  Text("2. Keep your account information secure.",
                      style: MyText.body2(context)
                          ?.copyWith(color: MyColors.grey_80)),
                  SizedBox(height: 5),
                  Text(
                      "3. Contact support if you notice any suspicious activity.",
                      style: MyText.body2(context)
                          ?.copyWith(color: MyColors.grey_80)),
                ],
              ),
            ),
            Container(height: 30),
            Text("Powered by FlutterUiX Pro",
                style:
                    MyText.caption(context)!.copyWith(color: MyColors.grey_40)),
            Container(height: 20),
          ],
        ),
      ),
    );
  }
}
