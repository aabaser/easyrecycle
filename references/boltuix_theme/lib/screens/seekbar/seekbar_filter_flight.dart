import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}

class CartFilterDemo extends StatefulWidget {
  @override
  _CartFilterDemoState createState() => _CartFilterDemoState();
}

class _CartFilterDemoState extends State<CartFilterDemo> {
  List<Product> allProducts = [
    Product(name: "Product A", price: 10.0),
    Product(name: "Product B", price: 20.0),
    Product(name: "Product C", price: 30.0),
    Product(name: "Product D", price: 40.0),
    Product(name: "Product E", price: 50.0),
  ];

  double minPrice = 0;
  double maxPrice = 50;

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = allProducts
        .where(
            (product) => product.price >= minPrice && product.price <= maxPrice)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Real-Time Cart Filter"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Slider for price range
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Filter by Price",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${minPrice.toStringAsFixed(0)}",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    Text(
                      "\$${maxPrice.toStringAsFixed(0)}",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
                RangeSlider(
                  values: RangeValues(minPrice, maxPrice),
                  min: 0,
                  max: 50,
                  divisions: 10,
                  activeColor: Colors.green,
                  inactiveColor: Colors.green[100],
                  labels: RangeLabels(
                    "\$${minPrice.toStringAsFixed(0)}",
                    "\$${maxPrice.toStringAsFixed(0)}",
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      minPrice = values.start;
                      maxPrice = values.end;
                    });
                  },
                ),
              ],
            ),
          ),
          Divider(thickness: 1, color: Colors.green[100]),
          // Display the filtered products
          Expanded(
            child: filteredProducts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Text(
                              product.name[0],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            product.name,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            "\$${product.price.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 14, color: Colors.green[800]),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search_off_rounded, size: 80, color: Colors.green[300]),
        SizedBox(height: 20),
        Text(
          "No products found!",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        Text(
          "Try adjusting the price range.",
          style: TextStyle(fontSize: 14, color: Colors.black45),
        ),
      ],
    );
  }
}

void main() => runApp(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      home: CartFilterDemo(),
    ));
