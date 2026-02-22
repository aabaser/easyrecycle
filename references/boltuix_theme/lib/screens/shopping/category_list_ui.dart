import 'package:flutter/material.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/model/shop_category.dart';
import 'package:boltuix/widgets/my_text.dart';

class CategoryListUI extends StatefulWidget {
  CategoryListUI();

  @override
  CategoryListUIState createState() => new CategoryListUIState();
}

class CategoryListUIState extends State<CategoryListUI> {
  @override
  Widget build(BuildContext context) {
    List<Widget> listCategory = [];
    for (ShopCategory s in Dummy.getShoppingCategory()) {
      listCategory.add(getItemViewList(s));
    }

    return new Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        title: new Text("Categories"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart_rounded),
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
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(width: 20, height: 90),
                  _buildGradientFAB(
                      icon: Icons.accessibility_rounded, heroTag: "fab1"),
                  Container(width: 20, height: 0),
                  _buildGradientFAB(icon: Icons.face_rounded, heroTag: "fab2"),
                  Container(width: 20, height: 0),
                  _buildGradientFAB(
                      icon: Icons.child_friendly_rounded, heroTag: "fab3"),
                  Container(width: 20, height: 0),
                  _buildGradientFAB(
                      icon: Icons.weekend_rounded, heroTag: "fab4"),
                  Container(width: 20, height: 0),
                  _buildGradientFAB(
                      icon: Icons.devices_rounded, heroTag: "fab5"),
                  Container(width: 20, height: 0),
                  _buildGradientFAB(icon: Icons.pool_rounded, heroTag: "fab6"),
                  Container(width: 20, height: 0),
                  _buildGradientFAB(
                      icon: Icons.restaurant_rounded, heroTag: "fab7"),
                  Container(width: 20, height: 0),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Text("All Categories",
                  style: MyText.medium(context).copyWith(
                      color: Colors.grey[900], fontWeight: FontWeight.bold)),
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: listCategory,
              ),
            )
          ],
        ),
      ),
    );
  }

  // Function to build FloatingActionButton with gradient
  Widget _buildGradientFAB({required IconData icon, required String heroTag}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.green[400]!, Colors.green[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: FloatingActionButton(
        heroTag: heroTag,
        backgroundColor: Colors.transparent, // Transparent to show gradient
        elevation: 0,
        child: Icon(icon, color: Colors.white),
        onPressed: () {
          print('Clicked');
        },
      ),
    );
  }

  // Function to build a category item
  Widget getItemViewList(ShopCategory s) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(25),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [Colors.green[300]!, Colors.green[700]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Icon(
                    s.icon,
                    size: 25,
                    color: Colors
                        .white, // Use a base color, this will be overridden by the gradient
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(s.title,
                      style: MyText.medium(context)
                          .copyWith(color: Colors.green[900])),
                  Container(height: 5),
                  Text(s.brief,
                      style: MyText.subhead(context)!.copyWith(
                        color: Colors.grey[500],
                      )),
                ],
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(20),
                child: Icon(Icons.chevron_right_rounded,
                    size: 25, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Container(width: 75),
            Expanded(
              child: Container(height: 1, color: Colors.grey[300]),
            )
          ],
        )
      ],
    );
  }
}
