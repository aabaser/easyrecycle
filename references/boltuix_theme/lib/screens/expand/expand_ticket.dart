import 'dart:math' as math;
import 'package:flutter/material.dart';

class ExpandTicket extends StatefulWidget {
  @override
  ExpandTicketState createState() => ExpandTicketState();
}

class ExpandTicketState extends State<ExpandTicket>
    with TickerProviderStateMixin {
  bool expand1 = false;
  bool expand2 = false;
  late AnimationController controller1, controller2;
  late Animation<double> animation1, animation1View;
  late Animation<double> animation2, animation2View;

  @override
  void initState() {
    super.initState();
    controller1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    controller2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    animation1 = Tween(begin: 0.0, end: 180.0).animate(controller1);
    animation1View =
        CurvedAnimation(parent: controller1, curve: Curves.easeInOut);

    animation2 = Tween(begin: 0.0, end: 180.0).animate(controller2);
    animation2View =
        CurvedAnimation(parent: controller2, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Flight Ticket", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Booking Code
            buildBookingCodeCard(),

            // Flight Info
            buildFlightInfoCard(),

            // Pre-Flight Info
            buildExpandablePanel(
              title: "Pre-Flight Info",
              icon: Icons.info_rounded,
              animation: animation1,
              animationView: animation1View,
              togglePanel: togglePanel1,
              content: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Here is some detailed pre-flight information.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
            ),

            // Passenger Info
            buildExpandablePanel(
              title: "Passenger(s)",
              icon: Icons.person_rounded,
              animation: animation2,
              animationView: animation2View,
              togglePanel: togglePanel2,
              content: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildPassengerInfo("1", "Mr. ANDERSON THOMAS", "Adult"),
                    buildPassengerInfo("2", "Mrs. GARCIA LEWIS", "Adult"),
                    buildPassengerInfo("3", "SOPHIA TURNER", "Infant"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildBookingCodeCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Text(
              "Booking Code:",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            Spacer(),
            Text(
              "CXDT2887A",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            IconButton(
              icon: Icon(Icons.content_copy_rounded, color: Colors.green),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFlightInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.flight_rounded, color: Colors.green, size: 30),
            title: Text(
              "Lion JT-539",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800]),
            ),
            subtitle: Text(
              "Promo (Subclass T)",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                buildFlightTimeInfo("17:40", "28 Sep"),
                buildFlightPath(),
                buildFlightDestinationInfo(
                    "Jakarta (CGK)", "Soekarno Hatta Intl Airport"),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Duration: 1 hour 15 minutes",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFlightTimeInfo(String time, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(time,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800])),
        Text(date, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget buildFlightPath() {
    return Expanded(
      child: Column(
        children: [
          Icon(Icons.flight_takeoff_rounded, color: Colors.green),
          Container(
            width: 2,
            height: 50,
            color: Colors.green,
          ),
          Icon(Icons.flight_land_rounded, color: Colors.green),
        ],
      ),
    );
  }

  Widget buildFlightDestinationInfo(String destination, String airport) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(destination,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800])),
        Text(airport, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget buildPassengerInfo(String number, String name, String type) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text("$number.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          SizedBox(width: 10),
          Expanded(
              child: Text(name,
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(type,
                style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ),
        ],
      ),
    );
  }

  Widget buildExpandablePanel({
    required String title,
    required IconData icon,
    required Animation<double> animation,
    required Animation<double> animationView,
    required VoidCallback togglePanel,
    required Widget content,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: Colors.green, size: 30),
            title: Text(title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800])),
            trailing: Transform.rotate(
              angle: animation.value * math.pi / 180,
              child: IconButton(
                icon: Icon(Icons.expand_more_rounded, color: Colors.grey[700]),
                onPressed: togglePanel,
              ),
            ),
            onTap: togglePanel,
          ),
          SizeTransition(
            sizeFactor: animationView,
            child: content,
          ),
        ],
      ),
    );
  }

  void togglePanel1() {
    if (!expand1) {
      controller1.forward();
    } else {
      controller1.reverse();
    }
    expand1 = !expand1;
  }

  void togglePanel2() {
    if (!expand2) {
      controller2.forward();
    } else {
      controller2.reverse();
    }
    expand2 = !expand2;
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }
}
