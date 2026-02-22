import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/star_rating.dart';

class ProductDetailsPage extends StatefulWidget {
  @override
  ProductDetailsPageState createState() => new ProductDetailsPageState();
}

class ProductDetailsPageState extends State<ProductDetailsPage>
    with TickerProviderStateMixin {
  bool expand1 = true, expand2 = false, expand3 = false;
  late AnimationController controller1, controller2, controller3;
  late Animation<double> animation1, animation1View;
  late Animation<double> animation2, animation2View;
  late Animation<double> animation3, animation3View;

  @override
  void initState() {
    super.initState();
    controller1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    controller2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    controller3 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    animation1 = Tween(begin: 0.0, end: 180.0).animate(controller1);
    animation1View = CurvedAnimation(parent: controller1, curve: Curves.linear);

    animation2 = Tween(begin: 0.0, end: 180.0).animate(controller2);
    animation2View = CurvedAnimation(parent: controller2, curve: Curves.linear);

    animation3 = Tween(begin: 0.0, end: 180.0).animate(controller3);
    animation3View = CurvedAnimation(parent: controller3, curve: Curves.linear);

    controller1.addListener(() {
      setState(() {});
    });
    controller2.addListener(() {
      setState(() {});
    });
    controller3.addListener(() {
      setState(() {});
    });

    controller1.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.grey_3,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
              expandedHeight: 350,
              floating: false,
              pinned: true,
              backgroundColor: MyColors.primary,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  var top = constraints.biggest.height;
                  return FlexibleSpaceBar(
                    title: top <= 80
                        ? Text("3D Airplane Toy",
                            style: MyText.subhead(context)!
                                .copyWith(color: Colors.white))
                        : null,
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.asset(Img.get('b_image_4.png'),
                            fit: BoxFit.cover),
                      ],
                    ),
                  );
                },
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Card with content
              Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      // Title and details
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "3D Airplane Toy",
                              style: MyText.headline(context)!
                                  .copyWith(color: Colors.green),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Shop Aircraft Models",
                              style: MyText.body1(context)!
                                  .copyWith(color: MyColors.grey_95),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                StarRating(
                                  starCount: 5,
                                  rating: 4.5,
                                  color: Colors.green,
                                  size: 14,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "3,800 reviews",
                                  style: MyText.caption(context)!
                                      .copyWith(color: MyColors.grey_95),
                                ),
                                Spacer(),
                                Text(
                                  "\$ 65.00",
                                  style: MyText.subhead(context)!.copyWith(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(color: MyColors.grey_10),
                      // Expandable Panels inside the Card
                      buildExpandablePanel(
                        context,
                        icon: Icons.error_outline_rounded,
                        title: "Description",
                        expanded: expand1,
                        onToggle: togglePanel1,
                        animationView: animation1View,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SizedBox(width: 10),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    "This 3D airplane toy model is crafted with precision and attention to detail, making it a perfect collectible for aviation enthusiasts.",
                                    style: MyText.subhead(context),
                                  ),
                                ),
                                SizedBox(width: 20)
                              ],
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                      Divider(
                          color: MyColors.grey_10, height: 0, thickness: 0.8),
                      buildExpandablePanel(
                        context,
                        icon: Icons.chat_rounded,
                        title: "Reviews",
                        expanded: expand2,
                        onToggle: togglePanel2,
                        animationView: animation2View,
                        child: Column(
                          children: <Widget>[
                            buildReviewRow("John Smith", 4.0),
                            buildReviewRow("Emma", 5.0),
                            buildReviewRow("Marry Brown", 5.0),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      Divider(
                          color: MyColors.grey_10, height: 0, thickness: 0.8),
                      buildExpandablePanel(
                        context,
                        icon: Icons.verified_user_rounded,
                        title: "Warranty",
                        expanded: expand3,
                        onToggle: togglePanel3,
                        animationView: animation3View,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SizedBox(width: 10),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    "The 3D airplane toy comes with a 1-year warranty covering manufacturing defects. For more information, please refer to our warranty policy.",
                                    style: MyText.subhead(context),
                                  ),
                                ),
                                SizedBox(width: 20)
                              ],
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildExpandablePanel(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool expanded,
    required Function() onToggle,
    required Animation<double> animationView,
    required Widget child,
  }) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Row(
            children: <Widget>[
              SizedBox(width: 15),
              Icon(icon, size: 25.0, color: MyColors.grey_60),
              SizedBox(width: 20),
              Text(title,
                  style:
                      MyText.medium(context).copyWith(color: MyColors.grey_80)),
              Spacer(),
              Transform.rotate(
                angle: expanded ? math.pi : 0,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.arrow_drop_down_rounded,
                      color: MyColors.grey_60),
                  onPressed: onToggle,
                ),
              ),
            ],
          ),
        ),
        SizeTransition(
          sizeFactor: animationView,
          child: child,
        ),
      ],
    );
  }

  Widget buildReviewRow(String name, double rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(width: 65),
          StarRating(
              starCount: 5, rating: rating, color: Colors.green, size: 14),
          SizedBox(width: 10),
          Text(name),
        ],
      ),
    );
  }

  void togglePanel1() {
    setState(() {
      expand1 = !expand1;
      if (expand1) {
        controller1.forward();
      } else {
        controller1.reverse();
      }
    });
  }

  void togglePanel2() {
    setState(() {
      expand2 = !expand2;
      if (expand2) {
        controller2.forward();
      } else {
        controller2.reverse();
      }
    });
  }

  void togglePanel3() {
    setState(() {
      expand3 = !expand3;
      if (expand3) {
        controller3.forward();
      } else {
        controller3.reverse();
      }
    });
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }
}
