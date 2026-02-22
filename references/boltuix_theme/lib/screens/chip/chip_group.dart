import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiverseChipGroup extends StatefulWidget {
  @override
  _DiverseChipGroupState createState() => _DiverseChipGroupState();
}

class _DiverseChipGroupState extends State<DiverseChipGroup> {
  // Data for different categories with IDs
  static const List<Map<String, dynamic>> categoriesWithIcons = [
    {"id": 1, "name": "Beaches", "icon": Icons.beach_access},
    {"id": 2, "name": "Mountains", "icon": Icons.terrain},
    {"id": 3, "name": "Cities", "icon": Icons.location_city},
    {"id": 4, "name": "Adventure", "icon": Icons.hiking},
    {"id": 5, "name": "Historical", "icon": Icons.history_edu},
  ];

  static const List<Map<String, dynamic>> plainTextCategories = [
    {"id": 6, "name": "Luxury"},
    {"id": 7, "name": "Budget"},
    {"id": 8, "name": "Family"},
    {"id": 9, "name": "Solo"},
    {"id": 10, "name": "Romantic"},
  ];

  // RxBool for multi-select and single-select states
  RxMap<int, bool> multiSelectFlags = RxMap<int, bool>(); // For multi-select
  RxInt singleSelectId = (-1).obs; // For single-select
  RxMap<int, bool> outlineFlags = RxMap<int, bool>(); // For outlined chips

  @override
  void initState() {
    super.initState();
    // Initialize flags for all IDs
    for (var category in categoriesWithIcons) {
      multiSelectFlags[category['id']] = false;
      outlineFlags[category['id']] = false;
    }
    for (var category in plainTextCategories) {
      multiSelectFlags[category['id']] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Diverse Chip Groups"),
        backgroundColor: Colors.green[800], // Changed branding color to green
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chips with Icons (Multi-Select)
            Text(
              "Chips with Icons (Multi-Select)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categoriesWithIcons.map((category) {
                return Obx(() => ChoiceChip(
                      avatar: Icon(
                        category['icon'],
                        size: 20,
                        color: multiSelectFlags[category['id']]!
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                      selected: multiSelectFlags[category['id']]!,
                      label: Text(category['name']),
                      labelStyle: TextStyle(
                        color: multiSelectFlags[category['id']]!
                            ? Colors.white
                            : Colors.grey[800],
                      ),
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.green[600], // Updated to green
                      onSelected: (bool selected) {
                        multiSelectFlags[category['id']] = selected;
                      },
                    ));
              }).toList(),
            ),
            SizedBox(height: 30),

            // Chips with Icons (Single-Select)
            Text(
              "Chips with Icons (Single-Select)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categoriesWithIcons.map((category) {
                return Obx(() => ChoiceChip(
                      avatar: Icon(
                        category['icon'],
                        size: 20,
                        color: singleSelectId.value == category['id']
                            ? Colors.green
                            : Colors.grey[600],
                      ),
                      selected: singleSelectId.value == category['id'],
                      label: Text(category['name']),
                      labelStyle: TextStyle(
                        color: singleSelectId.value == category['id']
                            ? Colors.white
                            : Colors.grey[800],
                      ),
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.green[600], // Updated to green
                      onSelected: (bool selected) {
                        singleSelectId.value = selected ? category['id'] : -1;
                      },
                    ));
              }).toList(),
            ),
            SizedBox(height: 30),

            // Plain Text Chips (Multi-Select)
            Text(
              "Plain Text Chips (Multi-Select)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: plainTextCategories.map((category) {
                return Obx(() => ChoiceChip(
                      selected: multiSelectFlags[category['id']]!,
                      label: Text(category['name']),
                      labelStyle: TextStyle(
                        color: multiSelectFlags[category['id']]!
                            ? Colors.white
                            : Colors.grey[800],
                      ),
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.green[600], // Updated to green
                      onSelected: (bool selected) {
                        multiSelectFlags[category['id']] = selected;
                      },
                    ));
              }).toList(),
            ),
            SizedBox(height: 30),

            // Outlined Chips
            Text(
              "Outlined Chips",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categoriesWithIcons.map((category) {
                return Obx(() => ChoiceChip(
                      avatar: Icon(
                        category['icon'],
                        size: 20,
                        color: outlineFlags[category['id']]!
                            ? Colors.green[600] // Updated to green
                            : Colors.grey[400],
                      ),
                      selected: outlineFlags[category['id']]!,
                      label: Text(category['name']),
                      labelStyle: TextStyle(
                        color: outlineFlags[category['id']]!
                            ? Colors.green[800]
                            : Colors.grey[800],
                      ),
                      backgroundColor: Colors.transparent,
                      selectedColor: Colors.transparent,
                      side: BorderSide(
                        color: outlineFlags[category['id']]!
                            ? Colors.green
                            : Colors.grey[400]!,
                        width: 1,
                      ),
                      onSelected: (bool selected) {
                        outlineFlags[category['id']] = selected;
                      },
                    ));
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
