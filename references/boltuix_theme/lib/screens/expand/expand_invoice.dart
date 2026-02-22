import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:boltuix/data/my_strings.dart';

class ExpandInvoice extends StatefulWidget {
  @override
  ExpandInvoiceState createState() => ExpandInvoiceState();
}

class ExpandInvoiceState extends State<ExpandInvoice>
    with TickerProviderStateMixin {
  bool expand1 = false, expand2 = false, expand3 = false;
  late AnimationController controller1, controller2, controller3;
  late Animation<double> animation1, animation1View;
  late Animation<double> animation2, animation2View;
  late Animation<double> animation3, animation3View;

  @override
  void initState() {
    super.initState();
    controller1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    controller2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    controller3 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    animation1 = Tween(begin: 0.0, end: 180.0).animate(controller1);
    animation1View =
        CurvedAnimation(parent: controller1, curve: Curves.easeInOut);

    animation2 = Tween(begin: 0.0, end: 180.0).animate(controller2);
    animation2View =
        CurvedAnimation(parent: controller2, curve: Curves.easeInOut);

    animation3 = Tween(begin: 0.0, end: 180.0).animate(controller3);
    animation3View =
        CurvedAnimation(parent: controller3, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // AppBar and Header Section
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green, Colors.green],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon:
                            Icon(Icons.arrow_back_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(height: 10),
                      Text("\$2026.24",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text("TOTAL PRICE",
                          style:
                              TextStyle(fontSize: 16, color: Colors.white70)),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("INV-ZT45C",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              Text("Purchase Code",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white70)),
                            ],
                          ),
                          Spacer(),
                          FloatingActionButton(
                            elevation: 4,
                            backgroundColor: Colors.white,
                            mini: true,
                            onPressed: () {},
                            child: Icon(Icons.description_rounded,
                                color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Invoice Date Section
            buildInvoiceSection(
              icon: Icons.event_rounded,
              title: "Invoice Date",
              subtitle: "2:30 PM, 22 March 2024",
            ),
            buildDivider(),
            // Items Section
            buildExpandablePanel(
              title: "Items",
              icon: Icons.shopping_bag_rounded,
              animation: animation1,
              animationView: animation1View,
              togglePanel: togglePanel1,
              children: [
                buildItemRow("Web Design", "\$455.62"),
                buildItemRow("E-Book Design", "\$278.12"),
                buildItemRow("Hosting Plan", "\$719.00"),
                buildItemRow("Brochure Design", "\$573.50"),
                SizedBox(height: 10),
                buildItemRow("Total", "\$2026.24", isBold: true),
              ],
            ),
            buildDivider(),
            // Description Section
            buildExpandablePanel(
              title: "Description",
              icon: Icons.description_rounded,
              animation: animation2,
              animationView: animation2View,
              togglePanel: togglePanel2,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    MyStrings.lorem_ipsum,
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
            buildDivider(),
            // Address Section
            buildExpandablePanel(
              title: "Address",
              icon: Icons.location_on_rounded,
              animation: animation3,
              animationView: animation3View,
              togglePanel: togglePanel3,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    MyStrings.invoice_address,
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInvoiceSection(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: Colors.green),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              SizedBox(height: 10),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildItemRow(String title, String price, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Spacer(),
          Text(price,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
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
    required List<Widget> children,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, size: 30, color: Colors.green),
          title: Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          trailing: Transform.rotate(
            angle: animation.value * math.pi / 180,
            child: IconButton(
              icon: Icon(Icons.expand_more_rounded, color: Colors.black),
              onPressed: togglePanel,
            ),
          ),
          onTap: togglePanel,
        ),
        SizeTransition(
          sizeFactor: animationView,
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget buildDivider() {
    return Divider(color: Colors.green, height: 1, thickness: 1);
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

  void togglePanel3() {
    if (!expand3) {
      controller3.forward();
    } else {
      controller3.reverse();
    }
    expand3 = !expand3;
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }
}
