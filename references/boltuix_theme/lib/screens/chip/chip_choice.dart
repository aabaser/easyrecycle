import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class ChipChoice extends StatefulWidget {
  ChipChoice();

  @override
  ChipChoiceState createState() => new ChipChoiceState();
}

class ChipChoiceState extends State<ChipChoice> {
  List<String> categoryText = ["Extra Soft", "Soft", "Medium", "Hard"];
  List<int> categoryIndex = List.generate(4, (index) => index);
  List<RxBool> categoryFlag = List.generate(4, (index) => false.obs);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        title: Text("Product"),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 25, left: 25, right: 25),
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Updated image asset
                  Image.asset(
                    Img.get('image_002.png'),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(height: 5),
                        Row(
                          children: <Widget>[
                            // Updated product title and price
                            Text(
                              "Cute Toy",
                              style: MyText.headline(context)!
                                  .copyWith(color: MyColors.grey_80),
                            ),
                            Spacer(),
                            Text(
                              "\$ 15.0",
                              style: MyText.headline(context)!
                                  .copyWith(color: MyColors.grey_80),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Text(
                            "This cute toy is perfect for kids of all ages, providing fun and entertainment.",
                            style: MyText.subhead(context)!
                                .copyWith(color: MyColors.grey_40),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Divider(height: 0, color: Colors.lightGreenAccent),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Select Type",
                          style: MyText.subtitle(context)!
                              .copyWith(color: MyColors.grey_80),
                        ),
                        Container(height: 10),
                        Wrap(
                          spacing: 10,
                          children: categoryIndex
                              .map(
                                (int index) => Obx(
                                  () => ChoiceChip(
                                    selected: categoryFlag[index].value,
                                    label: Text(categoryText[index]),
                                    labelPadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    labelStyle: TextStyle(
                                        color: MyColors.grey_60,
                                        fontWeight: FontWeight.w500),
                                    backgroundColor: MyColors.grey_5,
                                    pressElevation: 1,
                                    selectedColor: MyColors.grey_10,
                                    padding: EdgeInsets.all(8),
                                    onSelected: (bool selected) {
                                      for (RxBool b in categoryFlag) {
                                        if (b.isTrue) b.value = false;
                                      }
                                      categoryFlag[index].value = true;
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary,
                      ),
                      child: Text(
                        "ADD TO CART",
                        style: MyText.body2(context)!
                            .copyWith(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Container(height: 20)
                ],
              ),
            ),
            Container(height: 10),
          ],
        ),
      ),
    );
  }
}
