import 'package:flutter/material.dart';
import 'package:boltuix/data/my_colors.dart';

class SearchBarWidget extends StatefulWidget {
  final List<String> categories;
  final IconData icon;
  final Function(String) onSearch;

  const SearchBarWidget({
    Key? key,
    required this.categories,
    required this.icon,
    required this.onSearch,
  }) : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController inputController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentCategoryIndex = 0;
  bool isUserTyping = false;
  bool searchAnimationPlayed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _startCategoryAnimation();
  }

  void _startCategoryAnimation() {
    _animationController.forward().then((_) {
      Future.delayed(Duration(seconds: 2), () {
        if (!isUserTyping && !searchAnimationPlayed) {
          _animationController.reverse().then((_) {
            setState(() {
              _currentCategoryIndex =
                  (_currentCategoryIndex + 1) % widget.categories.length;
            });
            _animationController
                .forward(); // Start the animation only once on load
          });
        }
      });
    });
  }

  void _triggerSearchAnimation() {
    if (!searchAnimationPlayed) {
      _animationController.forward(from: 0.0).then((_) {
        setState(() {
          searchAnimationPlayed = true;
        });
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.grey_5, // Light background color for the entire column
      child: Column(
        children: <Widget>[
          AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.menu_rounded, color: Colors.grey[600]),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.more_vert_rounded, color: Colors.grey[600]),
                onPressed: () {},
              ),
            ],
          ),
          Spacer(),
          Container(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12), // Rounded corners for the card
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: EdgeInsets.all(20),
              elevation: 1,
              child: Row(
                children: <Widget>[
                  Container(width: 15, height: 55),
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: TextField(
                        maxLines: 1,
                        controller: inputController,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18), // Typing text color is now black
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              'Search by ${widget.categories[_currentCategoryIndex]}',
                          hintStyle: TextStyle(fontSize: 16.0),
                        ),
                        onChanged: (text) {
                          setState(() {
                            isUserTyping = text.isNotEmpty;
                          });
                        },
                        onSubmitted: widget.onSearch,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: ScaleTransition(
                      scale: _fadeAnimation,
                      child: Icon(Icons.mic, color: Colors.grey[600]),
                    ),
                    onPressed: () {
                      inputController.clear();
                      setState(() {
                        isUserTyping = false;
                      });
                    },
                  ),
                  Container(width: 5),
                ],
              ),
            ),
          ),
          Container(
            width: 55,
            height: 55,
            child: FloatingActionButton(
              heroTag: "fab3",
              backgroundColor:
                  Colors.green, // Primary color for the search button
              elevation: 1,
              child: Icon(
                widget.icon,
                color: Colors.white,
              ),
              onPressed: () {
                _triggerSearchAnimation(); // Trigger the animation when search is tapped
                widget.onSearch(inputController.text);
              },
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
