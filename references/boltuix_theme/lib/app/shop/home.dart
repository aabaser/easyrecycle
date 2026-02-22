import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // 🌟 Main scaffold with gradient background
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffffffff), Color(0xffffe7e3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // 🛍️ Header with logo
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 5),
                  height: 100,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/app_shop/logo-kusmi-b.png"),
                          fit: BoxFit.fitHeight)),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: const Icon(Icons.local_mall_outlined),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🏆 Best-seller section
                      const Text("Our best-seller"),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            ...List.generate(
                              10,
                              (i) => SizedBox(
                                height: 320,
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      width: 230,
                                      height: 265,
                                      margin: const EdgeInsets.only(
                                          top: 10,
                                          right: 20,
                                          bottom: 10,
                                          left: 10),
                                      child: Material(
                                        elevation: 10,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(35)),
                                        child: Container(
                                          height: 265,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 5),
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(35))),
                                          child: Column(children: [
                                            // 📦 Tea Item Details
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                alignment: Alignment.topLeft,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // 🏷️ Tea Name
                                                    Text(
                                                      [
                                                        "Green Delight",
                                                        "Mint Harmony",
                                                        "Berry Bliss",
                                                        "Citrus Glow",
                                                        "Choco Charm",
                                                        "Golden Elixir",
                                                        "Spice Twist",
                                                        "Velvet Vanilla",
                                                        "Tropical Zest",
                                                        "Morning T"
                                                      ][i], // Dynamic names
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xff333d47),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 24,
                                                        letterSpacing: 1.4,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 15),
                                                    const Text(
                                                      "Green tea yerba\nmaté",
                                                      style: TextStyle(
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        letterSpacing: 1.2,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    const Text(
                                                      "\$42.70",
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        letterSpacing: 1.2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 20),
                                                child: Row(
                                                  children: [
                                                    // 🛒 Add to Cart Button
                                                    Material(
                                                      elevation: 8,
                                                      shadowColor:
                                                          Colors.redAccent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Container(
                                                        height: 40,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 15),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                            colors: [
                                                              Color(0xfff45269),
                                                              Color(0xffd32f2f),
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: const Text(
                                                          "Add to cart",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    // ❤️ Favorite Button
                                                    Material(
                                                      elevation: 8,
                                                      shadowColor:
                                                          Colors.redAccent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Container(
                                                        height: 40,
                                                        width: 40,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.red
                                                                  .withOpacity(
                                                                      0.3),
                                                              blurRadius: 8,
                                                              offset:
                                                                  const Offset(
                                                                      0, 4),
                                                            ),
                                                          ],
                                                        ),
                                                        child: const Icon(
                                                          Icons
                                                              .favorite_outlined,
                                                          size: 18,
                                                          color: Colors.black38,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text("Choose your tea type"),
                      Column(
                        children: [
                          ...List.generate(
                            10,
                            (i) => Container(
                              width: double.infinity,
                              height: 130,
                              margin: const EdgeInsets.only(
                                  top: 10, right: 10, bottom: 10, left: 10),
                              child: Material(
                                elevation: 10,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                child: Container(
                                  height: 280,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(children: [
                                    Container(
                                      width: 100,
                                      height: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 10),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: const AssetImage(
                                                  "assets/app_shop/cafe.png"),
                                              fit: BoxFit.contain)),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Stack(
                                        alignment: Alignment.centerRight,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  [
                                                    "Green Delight",
                                                    "Mint Harmony",
                                                    "Berry Bliss",
                                                    "Citrus Glow",
                                                    "Choco Charm",
                                                    "Golden Elixir",
                                                    "Spice Twist",
                                                    "Velvet Vanilla",
                                                    "Tropical Zest",
                                                    "Morning"
                                                  ][i], // Dynamic names
                                                  style: const TextStyle(
                                                    color: Color(0xff333d47),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    letterSpacing: 1.4,
                                                  ),
                                                ),
                                                const Text(
                                                  "Green tea yerba\nmaté",
                                                  style: TextStyle(
                                                    color: Colors.black45,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    letterSpacing: 1.2,
                                                  ),
                                                ),
                                                const Spacer(),
                                                const Text(
                                                  "\$42.70",
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    letterSpacing: 1.2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 12,
                                            right: 15,
                                            child: Material(
                                              elevation: 8,
                                              shadowColor: Colors.redAccent,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Container(
                                                height: 40,
                                                width: 70,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color(0xfff45269),
                                                      Color(0xffd32f2f),
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Text(
                                                  "Buy",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
