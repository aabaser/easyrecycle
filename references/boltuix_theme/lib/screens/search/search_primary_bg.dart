import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:lottie/lottie.dart';

class SearchPrimaryBackground extends StatefulWidget {
  SearchPrimaryBackground();

  @override
  SearchPrimaryBackgroundState createState() =>
      new SearchPrimaryBackgroundState();
}

class SearchPrimaryBackgroundState extends State<SearchPrimaryBackground> {
  bool finishLoading = true;
  final TextEditingController inputController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        // This container holds the background gradient and the main content of the screen
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.green.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          // Column to organize the widgets vertically
          children: <Widget>[
            // AppBar with transparent background and menu icon
            AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark,
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.menu_rounded, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Spacer(), // Spacer to push the content below towards the center
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                // Column to hold the Lottie animation and welcome text
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Lottie animation displaying a burger
                  Container(
                    child: Lottie.asset('assets/images/burger.json'),
                    width: 250,
                    height: 250,
                  ),
                  // Welcome text with a bold style
                  Text(
                    "Welcome to Burger Bliss!",
                    textAlign: TextAlign.center,
                    style: MyText.headline(context)!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(height: 5), // Spacer between the two text widgets
                  // Subtitle text welcoming the user by name
                  Text(
                    "Hello John, ready to discover delicious burgers?",
                    textAlign: TextAlign.center,
                    style: MyText.subhead(context)!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: 30), // Spacer to give some space before the search bar
            Container(
              // Container wrapping the search bar card
              child: Card(
                // Card that holds the search bar and microphone icon
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.symmetric(horizontal: 40),
                elevation: 1,
                child: Row(
                  // Row to place microphone icon and search field horizontally
                  children: <Widget>[
                    Container(width: 5), // Spacer before the microphone icon
                    IconButton(
                      icon: Icon(Icons.mic, color: Colors.grey[600]),
                      onPressed: () {
                        inputController.clear();
                        setState(() {});
                      },
                    ),
                    Container(
                        width: 5, height: 50), // Spacer before the text field
                    Expanded(
                      child: TextField(
                        // The text field where users can type their search query
                        maxLines: 1,
                        controller: inputController,
                        style: TextStyle(color: Colors.grey[600], fontSize: 18),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              'Search for burger recipes or type a topping...',
                          hintStyle: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30), // Spacer before the search button
            Container(
              // Container wrapping the search button or loading indicator
              width: 55,
              height: 55,
              child: finishLoading
                  ? FloatingActionButton(
                      // Button to trigger the search
                      heroTag: "fab3",
                      backgroundColor: Colors.white,
                      elevation: 1,
                      child: Icon(
                        Icons.search_rounded,
                        color: MyColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          finishLoading = false;
                        });
                        delayShowingContent();
                      },
                    )
                  : CircularProgressIndicator(
                      // Loading indicator that shows while searching
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
            ),
            Spacer(), // Spacer to push the content above towards the center
          ],
        ),
      ),
    );
  }

  // Simulates a delay to show a loading state
  void delayShowingContent() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        finishLoading = true;
      });
    });
  }
}
