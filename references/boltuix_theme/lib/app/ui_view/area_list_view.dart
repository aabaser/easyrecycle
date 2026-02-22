import 'package:flutter/material.dart';

import '../flutter_pro_uix_app_theme.dart';

class AreaListView extends StatefulWidget {
  const AreaListView({
    Key? key,
    this.mainScreenAnimationController,
    this.mainScreenAnimation,
  }) : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _AreaListViewState createState() => _AreaListViewState();
}

class _AreaListViewState extends State<AreaListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<Map<String, String>> areaListData = <Map<String, String>>[
    {
      'image': 'assets/app_template/area1.png',
      'title': 'Cardio Training',
      'description': 'Improve heart health with intensive cardio sessions.',
    },
    {
      'image': 'assets/app_template/area2.png',
      'title': 'Strength Training',
      'description': 'Build muscle and increase overall strength.',
    },
    {
      'image': 'assets/app_template/area3.png',
      'title': 'Yoga Practice',
      'description': 'Enhance flexibility and inner peace.',
    },
    {
      'image': 'assets/app_template/area1.png',
      'title': 'HIIT Workouts',
      'description': 'Boost metabolism with high-intensity training.',
    },
    {
      'image': 'assets/app_template/area1.png',
      'title': 'Cardio Training',
      'description': 'Improve heart health with intensive cardio sessions.',
    },
    {
      'image': 'assets/app_template/area2.png',
      'title': 'Strength Training',
      'description': 'Build muscle and increase overall strength.',
    },
    {
      'image': 'assets/app_template/area3.png',
      'title': 'Yoga Practice',
      'description': 'Enhance flexibility and inner peace.',
    },
    {
      'image': 'assets/app_template/area1.png',
      'title': 'HIIT Workouts',
      'description': 'Boost metabolism with high-intensity training.',
    },
    {
      'image': 'assets/app_template/area1.png',
      'title': 'Cardio Training',
      'description': 'Improve heart health with intensive cardio sessions.',
    },
    {
      'image': 'assets/app_template/area2.png',
      'title': 'Strength Training',
      'description': 'Build muscle and increase overall strength.',
    },
    {
      'image': 'assets/app_template/area3.png',
      'title': 'Yoga Practice',
      'description': 'Enhance flexibility and inner peace.',
    },
    {
      'image': 'assets/app_template/area1.png',
      'title': 'HIIT Workouts',
      'description': 'Boost metabolism with high-intensity training.',
    },
    {
      'image': 'assets/app_template/area1.png',
      'title': 'Cardio Training',
      'description': 'Improve heart health with intensive cardio sessions.',
    },
    {
      'image': 'assets/app_template/area2.png',
      'title': 'Strength Training',
      'description': 'Build muscle and increase overall strength.',
    },
    {
      'image': 'assets/app_template/area3.png',
      'title': 'Yoga Practice',
      'description': 'Enhance flexibility and inner peace.',
    },
    {
      'image': 'assets/app_template/area1.png',
      'title': 'HIIT Workouts',
      'description': 'Boost metabolism with high-intensity training.',
    },
    {
      'image': 'assets/app_template/area1.png',
      'title': 'Cardio Training',
      'description': 'Improve heart health with intensive cardio sessions.',
    },
    {
      'image': 'assets/app_template/area2.png',
      'title': 'Strength Training',
      'description': 'Build muscle and increase overall strength.',
    },
    {
      'image': 'assets/app_template/area3.png',
      'title': 'Yoga Practice',
      'description': 'Enhance flexibility and inner peace.',
    },
    {
      'image': 'assets/app_template/area1.png',
      'title': 'HIIT Workouts',
      'description': 'Boost metabolism with high-intensity training.',
    },
  ];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine number of columns based on screen width
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth < 600
        ? 2 // Mobile View
        : screenWidth < 900
            ? 3 // Tablet View
            : screenWidth < 1200
                ? 4 // Medium Screen
                : 5; // Desktop View

    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: areaListData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                    childAspectRatio:
                        0.75, // Adjusted for title and description
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final int count = areaListData.length;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animationController!,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn),
                      ),
                    );
                    animationController?.forward();
                    return AreaView(
                      imagePath: areaListData[index]['image']!,
                      title: areaListData[index]['title']!,
                      description: areaListData[index]['description']!,
                      animation: animation,
                      animationController: animationController!,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AreaView extends StatelessWidget {
  const AreaView({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final String imagePath;
  final String title;
  final String description;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: FlutterBoltuixAppTheme.white,
                borderRadius:
                    BorderRadius.circular(25.0), // 25 dp corner radius
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: LinearGradient(
                      colors: [
                        FlutterBoltuixAppTheme.nearlyDarkBlue.withOpacity(0.3),
                        FlutterBoltuixAppTheme.grey.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).colors.first,
                    offset: const Offset(3.0, 3.0),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(25.0),
                  splashColor:
                      FlutterBoltuixAppTheme.nearlyDarkBlue.withOpacity(0.2),
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Wrapping Image with Expanded
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Wrapping Title and Description with Flexible
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontFamily: FlutterBoltuixAppTheme.fontName,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: FlutterBoltuixAppTheme.nearlyDarkBlue,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            description,
                            style: TextStyle(
                              fontFamily: FlutterBoltuixAppTheme.fontName,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: FlutterBoltuixAppTheme.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis, // Handle long text
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
