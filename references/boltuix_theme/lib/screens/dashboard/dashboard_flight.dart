import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class DashboardFlight extends StatefulWidget {
  DashboardFlight();

  @override
  DashboardFlightState createState() => new DashboardFlightState();
}

class DashboardFlightState extends State<DashboardFlight> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(color: MyColors.gradient1)),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [MyColors.gradient1, MyColors.gradient2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                width: double.infinity,
                height: 200,
                child: Image.asset(Img.get('world_map.png'), fit: BoxFit.cover),
              )
            ],
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarBrightness: Brightness.dark,
                  ),
                  leading: IconButton(
                    icon: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [MyColors.grey_3, MyColors.grey_3],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Icon(Icons.menu_rounded, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [MyColors.grey_3, MyColors.grey_3],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child:
                            Icon(Icons.more_vert_rounded, color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                Text("Where will you go?",
                    style: MyText.headline(context)!
                        .copyWith(color: Colors.white)),
                Container(height: 20),
                _buildSearchCard("From", Icons.flight_takeoff),
                Container(height: 5),
                _buildSearchCard("To", Icons.flight_land),
                Container(height: 5),
                _buildDetailCard("Departure", "Thu, 10 Mar 2024", Icons.event),
                _buildDetailCard("Passenger", "3 adult, 2 child", Icons.person),
                _buildDetailCard(
                    "Cabin class", "Business class", Icons.event_seat),
                Container(height: 20),
                _buildBookingSummary(),
                Container(height: 20),
                _buildFlightResults(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchCard(String hint, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 5),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        height: 50,
        alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [MyColors.gradient1, MyColors.gradient2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Icon(icon, color: Colors.white),
              ),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration.collapsed(
                  hintText: hint,
                ),
              ),
            ),
            IconButton(
              icon: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [MyColors.gradient1, MyColors.gradient2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Icon(Icons.search_rounded, color: Colors.white),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String detail, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 5),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            child: Text(title,
                style:
                    MyText.body2(context)!.copyWith(color: MyColors.grey_40)),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [MyColors.gradient1, MyColors.gradient2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Icon(icon, color: Colors.white),
                    ),
                    Container(width: 10),
                    Text(detail,
                        style: MyText.body2(context)!
                            .copyWith(color: MyColors.grey_60))
                  ],
                ),
                Container(height: 10),
                // Container(width: double.infinity, height: 1, color: Colors.lightGreen)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSummary() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Booking Summary",
              style: MyText.medium(context).copyWith(
                  color: MyColors.grey_90, fontWeight: FontWeight.bold)),
          Container(height: 10),
          _buildSummaryRow("From", "New York (JFK)"),
          _buildSummaryRow("To", "London (LHR)"),
          _buildSummaryRow("Date", "Thu, 10 Mar 2024"),
          _buildSummaryRow("Passengers", "3 Adults, 2 Children"),
          _buildSummaryRow("Class", "Business"),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: MyText.body2(context)!.copyWith(color: MyColors.grey_60)),
          Text(detail,
              style: MyText.body2(context)!.copyWith(color: MyColors.grey_90)),
        ],
      ),
    );
  }

  Widget _buildFlightResults() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Flight Results",
              style: MyText.medium(context).copyWith(
                  color: MyColors.grey_90, fontWeight: FontWeight.bold)),
          Container(height: 10),
          _buildFlightResultCard(
              "Delta Airlines", "10:00 AM", "6:00 PM", "\$499"),
          _buildFlightResultCard(
              "British Airways", "11:00 AM", "7:00 PM", "\$599"),
          _buildFlightResultCard(
              "American Airlines", "12:00 PM", "8:00 PM", "\$699"),
        ],
      ),
    );
  }

  Widget _buildFlightResultCard(
      String airline, String departure, String arrival, String price) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 5),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(airline,
                    style: MyText.body1(context)!.copyWith(
                        color: MyColors.grey_90, fontWeight: FontWeight.bold)),
                Text("Departure: $departure",
                    style: MyText.body2(context)!
                        .copyWith(color: MyColors.grey_60)),
                Text("Arrival: $arrival",
                    style: MyText.body2(context)!
                        .copyWith(color: MyColors.grey_60)),
              ],
            ),
            Text(price,
                style: MyText.headline(context)!.copyWith(
                    color: Colors.green[500], fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
