import 'dart:async';

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:boltuix/adapter/list_sectioned_adapter.dart';
import 'package:boltuix/model/people.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/widgets/my_toast.dart';

class BackdropFilterBy extends StatefulWidget {
  BackdropFilterBy();

  @override
  BackdropFilterState createState() => new BackdropFilterState();
}

class BackdropFilterState extends State<BackdropFilterBy>
    with TickerProviderStateMixin {
  late BuildContext _scaffoldCtx;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(milliseconds: 500), () {
        Backdrop.of(_scaffoldCtx).revealBackLayer();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<People> items = Dummy.getPeopleData();
    items.addAll(Dummy.getPeopleData());
    items.addAll(Dummy.getPeopleData());

    List<RxBool> filterOptions = [
      false.obs,
      true.obs,
      true.obs,
      false.obs,
      false.obs,
      true.obs,
      true.obs,
      false.obs
    ];

    List<String> filterLabels = [
      "Free Delivery",
      "Discounted Items",
      "In Stock",
      "Fast Shipping",
      "New Arrivals",
      "Popular",
      "Best Sellers",
      "Exclusive"
    ];

    var selectedPriceRange = "Below \$50".obs;
    List<String> priceRanges = [
      "Below \$50",
      "\$50 - \$100",
      "\$100 - \$200",
      "Above \$200"
    ];

    var sortOrder = "Featured".obs;
    List<String> sortOptions = [
      "Featured",
      "Price: Low to High",
      "Price: High to Low",
      "Customer Ratings"
    ];

    int sectionCount = 0;
    int sectionIndex = 0;
    List<String> months = Dummy.getStringsMonth();
    for (int i = 0; i < items.length / 6; i++) {
      items.insert(sectionCount, People.section(months[sectionIndex], true));
      sectionCount = sectionCount + 5;
      sectionIndex++;
    }

    void onItemClick(int index, People obj) {
      MyToast.show(obj.name!, context, duration: MyToast.LENGTH_SHORT);
    }

    return BackdropScaffold(
      backgroundColor: Colors.green[700],
      backLayerBackgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 700), value: 1),
      appBar: BackdropAppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Filter Products",
          style: MyText.subhead(context)!
              .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.green,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        actions: <Widget>[
          BackdropToggleButton(
              color: Colors.white, icon: AnimatedIcons.close_menu)
        ],
      ),
      headerHeight: 55,
      frontLayerBorderRadius: BorderRadius.only(
          topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      backLayer: Builder(
        builder: (BuildContext context) {
          _scaffoldCtx = context;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[800]!, Colors.green[400]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Theme(
                        data: Theme.of(context)
                            .copyWith(unselectedWidgetColor: Colors.white),
                        child: Container(
                          child: Column(
                            children: filterLabels.asMap().entries.map((entry) {
                              int index = entry.key;
                              String label = entry.value;
                              return Row(
                                children: <Widget>[
                                  Checkbox(
                                    checkColor: Colors.green,
                                    activeColor: Colors.white,
                                    value: filterOptions[index].value,
                                    onChanged: (value) {
                                      filterOptions[index].value =
                                          !filterOptions[index].value;
                                    },
                                  ),
                                  Container(width: 10),
                                  Text(label,
                                      style: MyText.body1(context)!
                                          .copyWith(color: Colors.white)),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(height: 0, color: Colors.white),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Text(
                          "Price Range",
                          style: MyText.body2(context)!.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Theme(
                        data: Theme.of(context)
                            .copyWith(unselectedWidgetColor: Colors.white),
                        child: Column(
                          children: priceRanges.map((range) {
                            return RadioListTile(
                              title: Text(range,
                                  style: MyText.body1(context)!
                                      .copyWith(color: Colors.white)),
                              dense: true,
                              activeColor: Colors.white,
                              groupValue: selectedPriceRange.value,
                              value: range,
                              onChanged: (dynamic val) {
                                selectedPriceRange.value = val;
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      Divider(height: 0, color: Colors.white),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Text(
                          "Sort By",
                          style: MyText.body2(context)!.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Theme(
                        data: Theme.of(context)
                            .copyWith(unselectedWidgetColor: Colors.white),
                        child: Column(
                          children: sortOptions.map((option) {
                            return RadioListTile(
                              title: Text(option,
                                  style: MyText.body1(context)!
                                      .copyWith(color: Colors.white)),
                              dense: true,
                              activeColor: Colors.white,
                              groupValue: sortOrder.value,
                              value: option,
                              onChanged: (dynamic val) {
                                sortOrder.value = val;
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 80),
                    ],
                  )),
            ),
          );
        },
      ),
      frontLayerScrim: Colors.transparent,
      frontLayer: Container(
        color: Colors.white,
        child: ListSectionedAdapter(items, onItemClick).getView(),
      ),
    );
  }
}
