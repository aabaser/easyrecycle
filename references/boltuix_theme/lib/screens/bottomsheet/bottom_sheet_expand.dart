import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:get/get.dart';

class BottomSheetExpand extends StatefulWidget {
  BottomSheetExpand();

  @override
  BottomSheetExpandState createState() => new BottomSheetExpandState();
}

class BottomSheetExpandState extends State<BottomSheetExpand> {
  bool showSheet = false;
  var expand = false.obs;
  late double screenHeight;
  double initialSize = 0.4;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyColors.grey_5,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: screenHeight - (screenHeight * initialSize),
            child: Image.asset(
              Img.get('image_001.png'),
              fit: BoxFit.cover,
            ),
          ),
          // Expandable Bottom Sheet
          Obx(() => Column(
                children: [
                  // Expanded Toolbar Section
                  expand.value
                      ? Container(
                          height: kToolbarHeight,
                          color: Colors.white,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.expand_more_rounded,
                                    color: MyColors.grey_80),
                                onPressed: () {},
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Bean There, Brew That!",
                                style: MyText.medium(context)
                                    .copyWith(color: MyColors.grey_80),
                              ),
                              Spacer(),
                            ],
                          ),
                        )
                      : Container(),
                  Divider(color: MyColors.grey_10, thickness: 1, height: 0),
                  Expanded(
                    child:
                        NotificationListener<DraggableScrollableNotification>(
                      onNotification: (DraggableScrollableNotification n) {
                        expand.value = n.extent >= n.maxExtent - 0.04;
                        return true;
                      },
                      child: DraggableScrollableSheet(
                        maxChildSize: 1,
                        minChildSize: initialSize,
                        initialChildSize: initialSize,
                        builder: (BuildContext context, myScrollController) {
                          return Stack(
                            children: [
                              SingleChildScrollView(
                                controller: myScrollController,
                                child: Column(
                                  children: [
                                    // Conditionally Display Header Information
                                    Obx(
                                      () => Container(
                                        height: expand.value ? 0 : 80,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.green[700]!,
                                              Colors.green[400]!
                                            ],
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Bean There, Brew That!",
                                                  style:
                                                      MyText.subhead(context)!
                                                          .copyWith(
                                                              color:
                                                                  Colors.white),
                                                ),
                                                Text(
                                                  "Quirky Coffee Spot",
                                                  style:
                                                      MyText.caption(context)!
                                                          .copyWith(
                                                              color: Colors
                                                                  .white70),
                                                ),
                                              ],
                                            ),
                                            Align(
                                              alignment: Alignment(0.85, 0.3),
                                              child: Text(
                                                "10 min",
                                                style: MyText.caption(context)!
                                                    .copyWith(
                                                        color: Colors.white70),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    _buildActionButtons(),
                                    Divider(
                                        color: MyColors.grey_10,
                                        thickness: 1,
                                        height: 0),
                                    _buildDetailsSection(),
                                    Divider(
                                        color: MyColors.grey_10,
                                        thickness: 1,
                                        height: 0),
                                    _buildPhotoSection(),
                                    Divider(
                                        color: MyColors.grey_10,
                                        thickness: 1,
                                        height: 0),
                                    _buildDescriptionSection(),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  // Action Buttons Section
  Widget _buildActionButtons() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: <Widget>[
          _buildActionButton(Icons.phone_rounded, "CALL"),
          _buildActionButton(Icons.language_rounded, "WEBSITE"),
          _buildActionButton(Icons.bookmark_add_rounded, "SAVE"),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Expanded(
      child: Column(
        children: <Widget>[
          IconButton(
            icon: Icon(icon, color: Colors.green[700], size: 25),
            onPressed: () {},
          ),
          Text(
            label,
            style: MyText.body1(context)!.copyWith(
                color: Colors.green[700], fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Details Section
  Widget _buildDetailsSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildDetailRow(
              Icons.location_on_rounded, "123 Coffee Lane, Brewtown"),
          _buildDetailRow(Icons.phone_rounded, "(123) 456-7890"),
          _buildDetailRow(Icons.access_time_rounded, "Mon-Fri, 7 AM - 8 PM"),
          _buildDetailRow(Icons.menu_book_rounded, "Menus"),
          _buildDetailRow(Icons.label_rounded, "Add Label"),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 25.0, color: Colors.green[700]),
          SizedBox(width: 20),
          Text(text, style: MyText.body1(context)),
        ],
      ),
    );
  }

  // Photos Section
  Widget _buildPhotoSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "PHOTOS",
            style: MyText.subhead(context)!
                .copyWith(color: MyColors.grey_80, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (String image in [
                  'image_001.png',
                  'image_002.png',
                  'image_004.png',
                  'image_005.png',
                  'image_006.png',
                  'image_007.png'
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Image.asset(
                      Img.get(image),
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Description Section
  Widget _buildDescriptionSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "DESCRIPTION",
            style: MyText.subhead(context)!
                .copyWith(color: MyColors.grey_80, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Text(
            "A delightful coffee spot where beans meet creativity. Enjoy quirky brews, cozy vibes, and friendly baristas. Perfect for coffee lovers and pun enthusiasts alike!",
            textAlign: TextAlign.justify,
            style: MyText.subhead(context)!.copyWith(color: MyColors.grey_80),
          ),
        ],
      ),
    );
  }
}
