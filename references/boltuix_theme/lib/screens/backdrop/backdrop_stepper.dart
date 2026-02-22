import 'dart:async';

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class BackdropStepper extends StatefulWidget {
  BackdropStepper();

  @override
  BackdropStepperState createState() => new BackdropStepperState();
}

class BackdropStepperState extends State<BackdropStepper>
    with TickerProviderStateMixin {
  late BuildContext _scaffoldCtx;
  double menuHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(milliseconds: 500), () {
        Backdrop.of(_scaffoldCtx).revealBackLayer();
      });
    });
  }

  void closeFrontLayer() {
    Backdrop.of(_scaffoldCtx).concealBackLayer();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      backgroundColor: Colors.green[700],
      backLayerBackgroundColor: Colors.green[700],
      animationCurve: Curves.linear,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 300), value: 1),
      appBar: BackdropAppBar(
        title: Row(
          children: [
            Icon(Icons.shopping_cart_rounded, color: Colors.white),
            SizedBox(width: 20),
            Text("Place Your Order",
                style: MyText.subhead(context)!.copyWith(color: Colors.white)),
            Spacer(),
            BackdropToggleButton(
                color: Colors.white, icon: AnimatedIcons.close_menu),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[700],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
      ),
      headerHeight: 550,
      frontLayerBorderRadius: BorderRadius.only(
          topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      backLayer: Builder(
        builder: (BuildContext context) {
          _scaffoldCtx = context;
          return Container(
            color: Colors.green[700],
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      SizedBox(width: 15),
                      Icon(Icons.shopping_cart_checkout_rounded,
                          color: Colors.white),
                      SizedBox(width: 20),
                      Text("Add Items to Cart",
                          style: MyText.subhead(context)!
                              .copyWith(color: Colors.white)),
                    ],
                  ),
                ),
                Divider(color: Colors.white),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      SizedBox(width: 15),
                      Icon(Icons.location_on_rounded, color: Colors.white),
                      SizedBox(width: 20),
                      Text("Set Delivery Address",
                          style: MyText.subhead(context)!
                              .copyWith(color: Colors.white)),
                    ],
                  ),
                ),
                Divider(color: Colors.white),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      SizedBox(width: 15),
                      Icon(Icons.credit_card_rounded, color: Colors.white),
                      SizedBox(width: 20),
                      Text("Select Payment Method",
                          style: MyText.subhead(context)!
                              .copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      frontLayerScrim: Colors.transparent,
      frontLayer: Container(
        color: Colors.white,
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField("First Name", "John"),
              SizedBox(height: 15),
              _buildTextField("Last Name", "Smith"),
              SizedBox(height: 15),
              _buildTextField("Email", "john.smith@mail.com",
                  keyboardType: TextInputType.emailAddress),
              SizedBox(height: 15),
              _buildTextField("Phone Number", "083 2374 2342",
                  keyboardType: TextInputType.phone),
              SizedBox(height: 15),
              _buildTextField("Delivery Address", "123 Main St, Springfield"),
              SizedBox(height: 15),
              _buildDropdownField("State", "California"),
              SizedBox(height: 15),
              _buildTextField("ZIP Code", "6625",
                  keyboardType: TextInputType.number),
              SizedBox(height: 15),
              _buildDropdownField("Country", "United States"),
              SizedBox(height: 15),
              _buildDropdownField("Payment Method", "Credit Card"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: TextStyle(fontSize: 11, color: MyColors.grey_60)),
        SizedBox(height: 5),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: MyColors.grey_5,
          margin: EdgeInsets.all(0),
          elevation: 0,
          child: Container(
            height: 45,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              maxLines: 1,
              keyboardType: keyboardType,
              controller: TextEditingController(text: placeholder),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(-12),
                  border: InputBorder.none),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: TextStyle(fontSize: 11, color: MyColors.grey_60)),
        SizedBox(height: 5),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: MyColors.grey_5,
          margin: EdgeInsets.all(0),
          elevation: 0,
          child: Container(
            height: 45,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: TextStyle(color: MyColors.grey_80)),
                Icon(Icons.expand_more, color: MyColors.grey_40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
