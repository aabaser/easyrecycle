import 'package:flutter/material.dart';

class BottomSheetFilter extends StatefulWidget {
  @override
  BottomSheetFilterState createState() => BottomSheetFilterState();
}

class BottomSheetFilterState extends State<BottomSheetFilter> {
  // State variables
  String selectedCategory = "Electronics";
  double minPrice = 0;
  double maxPrice = 1000;
  double minRating = 3;
  bool onSaleOnly = false;

  // Data lists
  final List<String> categories = [
    "Electronics",
    "Clothing",
    "Home Appliances",
    "Books",
    "Sports"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Filter"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          "Press button \nbelow",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.grey[400]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "fab",
        backgroundColor: Colors.green,
        elevation: 3,
        child: Icon(
          Icons.filter_list,
          color: Colors.white,
        ),
        onPressed: () {
          showFilterSheet(context);
        },
      ),
    );
  }

  // Show Bottom Sheet for Filters
  void showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Wrap(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildCategoryChips(setModalState),
                        SizedBox(height: 20),
                        _buildPriceSlider(setModalState),
                        SizedBox(height: 20),
                        _buildRatingSlider(setModalState),
                        SizedBox(height: 20),
                        _buildOnSaleSwitch(setModalState),
                        SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              applyFilter();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "APPLY FILTER",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Build Category Chips
  Widget _buildCategoryChips(StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Category",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: categories.map((category) {
            return ChoiceChip(
              label: Text(category),
              selected: selectedCategory == category,
              selectedColor: Colors.green,
              onSelected: (bool selected) {
                setModalState(() {
                  selectedCategory = category;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // Build Price Slider
  Widget _buildPriceSlider(StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Price Range (\$)",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        SizedBox(height: 10),
        RangeSlider(
          values: RangeValues(minPrice, maxPrice),
          min: 0,
          max: 2000,
          divisions: 20,
          labels: RangeLabels("\$${minPrice.toInt()}", "\$${maxPrice.toInt()}"),
          activeColor: Colors.green,
          onChanged: (RangeValues values) {
            setModalState(() {
              minPrice = values.start;
              maxPrice = values.end;
            });
          },
        ),
      ],
    );
  }

  // Build Rating Slider
  Widget _buildRatingSlider(StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Minimum Rating",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        SizedBox(height: 10),
        Slider(
          value: minRating,
          min: 1,
          max: 5,
          divisions: 4,
          activeColor: Colors.green,
          label: "${minRating.toStringAsFixed(1)} Stars",
          onChanged: (double value) {
            setModalState(() {
              minRating = value;
            });
          },
        ),
      ],
    );
  }

  // Build On Sale Toggle Switch
  Widget _buildOnSaleSwitch(StateSetter setModalState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "On Sale Only",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        Switch(
          value: onSaleOnly,
          activeColor: Colors.green,
          onChanged: (bool value) {
            setModalState(() {
              onSaleOnly = value;
            });
          },
        ),
      ],
    );
  }

  // Apply Filter Action
  void applyFilter() {
    Navigator.pop(context); // Close the bottom sheet
    // Logic to apply filters can be added here.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Filters Applied: \nCategory: $selectedCategory, Price: \$${minPrice.toInt()}-\$${maxPrice.toInt()}, Rating: $minRating+, On Sale: $onSaleOnly"),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
